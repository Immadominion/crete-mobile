import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../constants/storage_keys.dart';
import '../error/exceptions.dart';

/// Production-grade secure storage service for sensitive data
/// Uses platform-specific secure storage (Keychain on iOS, Keystore on Android)
@singleton
class SecureStorageService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      sharedPreferencesName: 'crete_secure_prefs',
      preferencesKeyPrefix: 'crete_',
    ),
    iOptions: IOSOptions(
      groupId: 'group.com.crete.secure',
      accountName: 'crete_account',
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    mOptions: MacOsOptions(
      groupId: 'group.com.crete.secure',
      accountName: 'crete_account',
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    webOptions: WebOptions(
      dbName: 'crete_secure_db',
      publicKey: 'crete_public_key',
    ),
  );

  /// Store sensitive string data
  Future<void> storeSecure(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);

      if (kDebugMode) {
        debugPrint('🔐 Stored secure data for key: $key');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to store secure data for key $key: $e');
      }
      throw StorageException('Failed to store secure data: $e');
    }
  }

  /// Retrieve sensitive string data
  Future<String?> getSecure(String key) async {
    try {
      final value = await _secureStorage.read(key: key);

      if (kDebugMode && value != null) {
        debugPrint('🔐 Retrieved secure data for key: $key');
      }

      return value;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to retrieve secure data for key $key: $e');
      }
      throw StorageException('Failed to retrieve secure data: $e');
    }
  }

  /// Store JSON object securely
  Future<void> storeSecureJson(String key, Map<String, dynamic> data) async {
    try {
      final jsonString = jsonEncode(data);
      await storeSecure(key, jsonString);
    } catch (e) {
      throw StorageException('Failed to store secure JSON data: $e');
    }
  }

  /// Retrieve JSON object securely
  Future<Map<String, dynamic>?> getSecureJson(String key) async {
    try {
      final jsonString = await getSecure(key);
      if (jsonString == null) return null;

      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw StorageException('Failed to retrieve secure JSON data: $e');
    }
  }

  /// Store authentication tokens securely
  Future<void> storeAuthTokens({
    required String accessToken,
    required String refreshToken,
    String? userId,
  }) async {
    await Future.wait([
      storeSecure(StorageKeys.accessToken, accessToken),
      storeSecure(StorageKeys.refreshToken, refreshToken),
      if (userId != null) storeSecure(StorageKeys.userId, userId),
    ]);
  }

  /// Get authentication tokens
  Future<Map<String, String?>> getAuthTokens() async {
    final results = await Future.wait([
      getSecure(StorageKeys.accessToken),
      getSecure(StorageKeys.refreshToken),
      getSecure(StorageKeys.userId),
    ]);

    return {
      'accessToken': results[0],
      'refreshToken': results[1],
      'userId': results[2],
    };
  }

  /// Store wallet credentials securely
  Future<void> storeWalletCredentials({
    required String walletAddress,
    required String walletType,
    String? privateKey,
    String? mnemonic,
  }) async {
    await Future.wait([
      storeSecure(StorageKeys.walletAddress, walletAddress),
      storeSecure(StorageKeys.walletType, walletType),
      if (privateKey != null)
        storeSecure('${StorageKeys.walletAddress}_private_key', privateKey),
      if (mnemonic != null)
        storeSecure('${StorageKeys.walletAddress}_mnemonic', mnemonic),
    ]);
  }

  /// Get wallet credentials
  Future<Map<String, String?>> getWalletCredentials() async {
    final walletAddress = await getSecure(StorageKeys.walletAddress);
    if (walletAddress == null) return {};

    final results = await Future.wait([
      getSecure(StorageKeys.walletType),
      getSecure('${walletAddress}_private_key'),
      getSecure('${walletAddress}_mnemonic'),
    ]);

    return {
      'walletAddress': walletAddress,
      'walletType': results[0],
      'privateKey': results[1],
      'mnemonic': results[2],
    };
  }

  /// Check if specific key exists
  Future<bool> containsKey(String key) async {
    try {
      return await _secureStorage.containsKey(key: key);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to check key existence for $key: $e');
      }
      return false;
    }
  }

  /// Delete specific key
  Future<void> delete(String key) async {
    try {
      await _secureStorage.delete(key: key);

      if (kDebugMode) {
        debugPrint('🗑️ Deleted secure data for key: $key');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to delete secure data for key $key: $e');
      }
      throw StorageException('Failed to delete secure data: $e');
    }
  }

  /// Clear all authentication data
  Future<void> clearAuthData() async {
    await Future.wait([
      delete(StorageKeys.accessToken),
      delete(StorageKeys.refreshToken),
      delete(StorageKeys.userId),
    ]);
  }

  /// Clear all wallet data
  Future<void> clearWalletData() async {
    final walletAddress = await getSecure(StorageKeys.walletAddress);

    await Future.wait([
      delete(StorageKeys.walletAddress),
      delete(StorageKeys.walletType),
      if (walletAddress != null) ...[
        delete('${walletAddress}_private_key'),
        delete('${walletAddress}_mnemonic'),
      ],
    ]);
  }

  /// Clear all secure storage
  Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();

      if (kDebugMode) {
        debugPrint('🗑️ Cleared all secure storage');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to clear all secure storage: $e');
      }
      throw StorageException('Failed to clear secure storage: $e');
    }
  }

  /// Get all stored keys (for debugging/migration purposes)
  Future<Map<String, String>> getAllSecureData() async {
    try {
      if (kDebugMode) {
        return await _secureStorage.readAll();
      }
      return {};
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to read all secure data: $e');
      }
      return {};
    }
  }

  /// Migrate data from SharedPreferences to SecureStorage
  Future<void> migrateFromSharedPreferences(
    Map<String, String> sensitiveData,
  ) async {
    try {
      for (final entry in sensitiveData.entries) {
        await storeSecure(entry.key, entry.value);
      }

      if (kDebugMode) {
        debugPrint(
          '✅ Migrated ${sensitiveData.length} items to secure storage',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to migrate data to secure storage: $e');
      }
      throw StorageException('Failed to migrate data: $e');
    }
  }
}
