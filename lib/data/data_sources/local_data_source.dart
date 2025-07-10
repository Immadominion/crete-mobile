import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/storage_keys.dart';
import '../../core/models/api/dao_models.dart';
import '../../core/models/api/proposal_models.dart';
import '../../core/models/api/user_models.dart';

/// Local data source for caching and offline support
class LocalDataSource {

  LocalDataSource(this._prefs);
  final SharedPreferences _prefs;

  /// Authentication data
  Future<void> storeAuthData({
    required String accessToken,
    required String refreshToken,
    required String userId,
  }) async {
    await Future.wait([
      _prefs.setString(StorageKeys.accessToken, accessToken),
      _prefs.setString(StorageKeys.refreshToken, refreshToken),
      _prefs.setString(StorageKeys.userId, userId),
    ]);
  }

  Future<String?> getAccessToken() async => _prefs.getString(StorageKeys.accessToken);

  Future<String?> getRefreshToken() async => _prefs.getString(StorageKeys.refreshToken);

  Future<String?> getUserId() async => _prefs.getString(StorageKeys.userId);

  Future<void> clearAuthData() async {
    await Future.wait([
      _prefs.remove(StorageKeys.accessToken),
      _prefs.remove(StorageKeys.refreshToken),
      _prefs.remove(StorageKeys.userId),
    ]);
  }

  /// User profile caching
  Future<void> cacheUserProfile(UserProfile profile) async {
    final json = jsonEncode(profile.toJson());
    await _prefs.setString('${StorageKeys.userProfile}_${profile.id}', json);
  }

  Future<UserProfile?> getCachedUserProfile(String userId) async {
    final json = _prefs.getString('${StorageKeys.userProfile}_$userId');
    if (json != null) {
      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        return UserProfile.fromJson(map);
      } catch (e) {
        // Remove corrupted cache
        await _prefs.remove('${StorageKeys.userProfile}_$userId');
        return null;
      }
    }
    return null;
  }

  /// DAO caching
  Future<void> cacheDaos(List<DaoInfo> daos) async {
    final json = jsonEncode(daos.map((dao) => dao.toJson()).toList());
    await _prefs.setString(StorageKeys.cachedDaos, json);
    await _prefs.setInt(
      StorageKeys.daosCacheTime,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<List<DaoInfo>> getCachedDaos() async {
    final json = _prefs.getString(StorageKeys.cachedDaos);
    if (json != null) {
      try {
        final List<dynamic> list = jsonDecode(json) as List<dynamic>;
        return list
            .map((item) => DaoInfo.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (e) {
        // Remove corrupted cache
        await _prefs.remove(StorageKeys.cachedDaos);
        return [];
      }
    }
    return [];
  }

  Future<bool> isDaosCacheValid() async {
    final cacheTime = _prefs.getInt(StorageKeys.daosCacheTime);
    if (cacheTime == null) return false;

    final now = DateTime.now().millisecondsSinceEpoch;
    const cacheValidityDuration = Duration(hours: 1);

    return (now - cacheTime) < cacheValidityDuration.inMilliseconds;
  }

  /// Proposal caching
  Future<void> cacheProposals(String daoId, List<Proposal> proposals) async {
    final json = jsonEncode(
      proposals.map((proposal) => proposal.toJson()).toList(),
    );
    await _prefs.setString('${StorageKeys.cachedProposals}_$daoId', json);
    await _prefs.setInt(
      '${StorageKeys.proposalsCacheTime}_$daoId',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<List<Proposal>> getCachedProposals(String daoId) async {
    final json = _prefs.getString('${StorageKeys.cachedProposals}_$daoId');
    if (json != null) {
      try {
        final List<dynamic> list = jsonDecode(json) as List<dynamic>;
        return list
            .map((item) => Proposal.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (e) {
        // Remove corrupted cache
        await _prefs.remove('${StorageKeys.cachedProposals}_$daoId');
        return [];
      }
    }
    return [];
  }

  Future<bool> isProposalsCacheValid(String daoId) async {
    final cacheTime = _prefs.getInt('${StorageKeys.proposalsCacheTime}_$daoId');
    if (cacheTime == null) return false;

    final now = DateTime.now().millisecondsSinceEpoch;
    const cacheValidityDuration = Duration(minutes: 30);

    return (now - cacheTime) < cacheValidityDuration.inMilliseconds;
  }

  /// Chat messages caching
  Future<void> cacheMessages(
    String roomId,
    List<Map<String, dynamic>> messages,
  ) async {
    final json = jsonEncode(messages);
    await _prefs.setString('${StorageKeys.cachedMessages}_$roomId', json);
  }

  Future<List<Map<String, dynamic>>> getCachedMessages(String roomId) async {
    final json = _prefs.getString('${StorageKeys.cachedMessages}_$roomId');
    if (json != null) {
      try {
        final List<dynamic> list = jsonDecode(json) as List<dynamic>;
        return list.cast<Map<String, dynamic>>();
      } catch (e) {
        // Remove corrupted cache
        await _prefs.remove('${StorageKeys.cachedMessages}_$roomId');
        return [];
      }
    }
    return [];
  }

  /// App settings
  Future<void> setAppTheme(String theme) async {
    await _prefs.setString(StorageKeys.appTheme, theme);
  }

  Future<String?> getAppTheme() async => _prefs.getString(StorageKeys.appTheme);

  Future<void> setNotificationSettings(Map<String, bool> settings) async {
    final json = jsonEncode(settings);
    await _prefs.setString(StorageKeys.notificationSettings, json);
  }

  Future<Map<String, bool>> getNotificationSettings() async {
    final json = _prefs.getString(StorageKeys.notificationSettings);
    if (json != null) {
      try {
        final Map<String, dynamic> map =
            jsonDecode(json) as Map<String, dynamic>;
        return map.cast<String, bool>();
      } catch (e) {
        return {};
      }
    }
    return {};
  }

  /// Clear all caches
  Future<void> clearAllCaches() async {
    final keys = _prefs.getKeys();
    final cacheKeys = keys.where(
      (key) =>
          key.startsWith('${StorageKeys.cachedDaos}_') ||
          key.startsWith('${StorageKeys.cachedProposals}_') ||
          key.startsWith('${StorageKeys.cachedMessages}_') ||
          key.startsWith('${StorageKeys.userProfile}_'),
    );

    await Future.wait(cacheKeys.map((key) => _prefs.remove(key)));
  }
}
