import '../../core/models/api/user_models.dart';
import '../../domain/repositories/user_repository.dart';
import '../data_sources/local_data_source.dart';
import '../data_sources/remote_data_source.dart';

/// Concrete implementation of UserRepository
class UserRepository implements IUserRepository {

  UserRepository(this._remoteDataSource, this._localDataSource);
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  @override
  Future<UserProfile> getUserProfile(String userId) async {
    try {
      // Try cache first
      final cachedProfile = await _localDataSource.getCachedUserProfile(userId);
      if (cachedProfile != null) return cachedProfile;

      // Fetch from remote
      final profile = await _remoteDataSource.getUserProfile();

      // Cache the result
      await _localDataSource.cacheUserProfile(profile);

      return profile;
    } catch (e) {
      // Return cached profile if remote fails
      final cachedProfile = await _localDataSource.getCachedUserProfile(userId);
      if (cachedProfile != null) return cachedProfile;
      rethrow;
    }
  }

  @override
  Future<UserProfile> updateUserProfile({
    String? username,
    String? email,
    String? avatarUrl,
    Map<String, dynamic>? metadata,
  }) async {
    final profile = await _remoteDataSource.updateUserProfile(
      username: username,
      email: email,
      avatarUrl: avatarUrl,
      metadata: metadata,
    );

    // Update cache
    await _localDataSource.cacheUserProfile(profile);

    return profile;
  }

  @override
  Future<UserProfile?> getCurrentUserProfile() async {
    final userId = await _localDataSource.getUserId();
    if (userId == null) return null;

    return getUserProfile(userId);
  }

  @override
  Future<List<String>> getUserDaoMemberships(String userId) async {
    // This would need to be implemented in the API
    // For now, return empty list
    return [];
  }

  @override
  Future<List<String>> getUserVotingHistory(String userId) async {
    // This would need to be implemented in the API
    // For now, return empty list
    return [];
  }

  @override
  Future<List<UserProfile>> searchUsers(String query) async {
    // This would need to be implemented in the API
    // For now, return empty list
    return [];
  }

  @override
  Future<UserProfile?> getCachedUserProfile(String userId) async => _localDataSource.getCachedUserProfile(userId);

  @override
  Future<void> cacheUserProfile(UserProfile profile) async {
    await _localDataSource.cacheUserProfile(profile);
  }

  @override
  Future<void> clearUserCache() async {
    await _localDataSource.clearAllCaches();
  }

  @override
  Future<UserProfile> updateUserAvatar(String avatarUrl) async => updateUserProfile(avatarUrl: avatarUrl);

  @override
  Future<void> deleteUserAccount() async {
    // This would need to be implemented in the API
    // For now, just clear local data
    await _localDataSource.clearAuthData();
    await _localDataSource.clearAllCaches();
  }
}
