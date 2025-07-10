import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing API response cache with automatic invalidation
@lazySingleton
class CacheService {

  CacheService(this._prefs);
  static const String _cachePrefix = 'cache_';
  static const String _cacheExpiryPrefix = 'cache_expiry_';
  static const String _cacheVersionPrefix = 'cache_version_';
  static const int _defaultCacheDurationMinutes = 30;
  static const int _currentCacheVersion = 1;

  final SharedPreferences _prefs;
  Directory? _cacheDirectory;

  /// Initialize cache service and setup cache directory
  Future<void> initialize() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      _cacheDirectory = Directory('${appDir.path}/cache');

      if (!await _cacheDirectory!.exists()) {
        await _cacheDirectory!.create(recursive: true);
      }

      // Clean up expired cache entries on initialization
      await _cleanupExpiredCache();

      // Handle cache version migration
      await _handleCacheVersionMigration();
    } catch (e) {
      debugPrint('Failed to initialize cache service: $e');
    }
  }

  /// Cache data with automatic expiration
  Future<void> cacheData<T>({
    required String key,
    required T data,
    Duration? duration,
    bool useFileStorage = false,
  }) async {
    try {
      final cacheKey = _cachePrefix + key;
      final expiryKey = _cacheExpiryPrefix + key;
      final cacheDuration =
          duration ?? const Duration(minutes: _defaultCacheDurationMinutes);
      final expiryTime = DateTime.now()
          .add(cacheDuration)
          .millisecondsSinceEpoch;

      if (useFileStorage && _cacheDirectory != null) {
        await _cacheToFile(key, data, expiryTime);
      } else {
        final jsonData = jsonEncode(data);
        await _prefs.setString(cacheKey, jsonData);
        await _prefs.setInt(expiryKey, expiryTime);
      }
    } catch (e) {
      debugPrint('Failed to cache data for key $key: $e');
    }
  }

  /// Retrieve cached data if not expired
  Future<T?> getCachedData<T>({
    required String key,
    required T Function(Map<String, dynamic>) fromJson,
    bool useFileStorage = false,
  }) async {
    try {
      if (useFileStorage && _cacheDirectory != null) {
        return await _getCachedFromFile<T>(key, fromJson);
      } else {
        return await _getCachedFromPrefs<T>(key, fromJson);
      }
    } catch (e) {
      debugPrint('Failed to get cached data for key $key: $e');
      return null;
    }
  }

  /// Check if cached data exists and is not expired
  Future<bool> isCached(String key, {bool useFileStorage = false}) async {
    try {
      if (useFileStorage && _cacheDirectory != null) {
        return await _isFileCached(key);
      } else {
        return await _isPrefsCached(key);
      }
    } catch (e) {
      debugPrint('Failed to check cache for key $key: $e');
      return false;
    }
  }

  /// Clear specific cached data
  Future<void> clearCache(String key, {bool useFileStorage = false}) async {
    try {
      if (useFileStorage && _cacheDirectory != null) {
        await _clearFileCache(key);
      } else {
        await _clearPrefsCache(key);
      }
    } catch (e) {
      debugPrint('Failed to clear cache for key $key: $e');
    }
  }

  /// Clear all cached data
  Future<void> clearAllCache() async {
    try {
      // Clear SharedPreferences cache
      final keys = _prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith(_cachePrefix) ||
            key.startsWith(_cacheExpiryPrefix) ||
            key.startsWith(_cacheVersionPrefix)) {
          await _prefs.remove(key);
        }
      }

      // Clear file cache
      if (_cacheDirectory != null && await _cacheDirectory!.exists()) {
        await _cacheDirectory!.delete(recursive: true);
        await _cacheDirectory!.create(recursive: true);
      }
    } catch (e) {
      debugPrint('Failed to clear all cache: $e');
    }
  }

  /// Get cache size information
  Future<Map<String, dynamic>> getCacheInfo() async {
    int prefsCount = 0;
    int fileCount = 0;
    int totalSize = 0;

    try {
      // Count SharedPreferences cache entries
      final keys = _prefs.getKeys();
      prefsCount = keys.where((key) => key.startsWith(_cachePrefix)).length;

      // Count file cache entries and calculate size
      if (_cacheDirectory != null && await _cacheDirectory!.exists()) {
        final files = await _cacheDirectory!.list().toList();
        fileCount = files.length;

        for (final file in files) {
          if (file is File) {
            totalSize += await file.length();
          }
        }
      }
    } catch (e) {
      debugPrint('Failed to get cache info: $e');
    }

    return {
      'prefsCount': prefsCount,
      'fileCount': fileCount,
      'totalSizeBytes': totalSize,
      'totalSizeMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
    };
  }

  /// Invalidate cache based on patterns
  Future<void> invalidateCache(String pattern) async {
    try {
      final keys = _prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith(_cachePrefix) && key.contains(pattern)) {
          final cacheKey = key.substring(_cachePrefix.length);
          await clearCache(cacheKey);
        }
      }

      // Invalidate file cache
      if (_cacheDirectory != null && await _cacheDirectory!.exists()) {
        final files = await _cacheDirectory!.list().toList();
        for (final file in files) {
          if (file.path.contains(pattern)) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      debugPrint('Failed to invalidate cache with pattern $pattern: $e');
    }
  }

  // Private methods

  Future<void> _cacheToFile<T>(String key, T data, int expiryTime) async {
    final file = File('${_cacheDirectory!.path}/$key.json');
    final cacheData = {
      'data': data,
      'expiry': expiryTime,
      'version': _currentCacheVersion,
    };
    await file.writeAsString(jsonEncode(cacheData));
  }

  Future<T?> _getCachedFromFile<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final file = File('${_cacheDirectory!.path}/$key.json');

    if (!await file.exists()) {
      return null;
    }

    final content = await file.readAsString();
    final cacheData = jsonDecode(content) as Map<String, dynamic>;

    final expiryTime = cacheData['expiry'] as int;
    final version = cacheData['version'] as int? ?? 0;

    if (DateTime.now().millisecondsSinceEpoch > expiryTime ||
        version != _currentCacheVersion) {
      await file.delete();
      return null;
    }

    return fromJson(cacheData['data'] as Map<String, dynamic>);
  }

  Future<T?> _getCachedFromPrefs<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final cacheKey = _cachePrefix + key;
    final expiryKey = _cacheExpiryPrefix + key;

    final cachedData = _prefs.getString(cacheKey);
    final expiryTime = _prefs.getInt(expiryKey);

    if (cachedData == null || expiryTime == null) {
      return null;
    }

    if (DateTime.now().millisecondsSinceEpoch > expiryTime) {
      await _clearPrefsCache(key);
      return null;
    }

    final jsonData = jsonDecode(cachedData) as Map<String, dynamic>;
    return fromJson(jsonData);
  }

  Future<bool> _isFileCached(String key) async {
    final file = File('${_cacheDirectory!.path}/$key.json');

    if (!await file.exists()) {
      return false;
    }

    try {
      final content = await file.readAsString();
      final cacheData = jsonDecode(content) as Map<String, dynamic>;
      final expiryTime = cacheData['expiry'] as int;
      final version = cacheData['version'] as int? ?? 0;

      if (DateTime.now().millisecondsSinceEpoch > expiryTime ||
          version != _currentCacheVersion) {
        await file.delete();
        return false;
      }

      return true;
    } catch (e) {
      await file.delete();
      return false;
    }
  }

  Future<bool> _isPrefsCached(String key) async {
    final cacheKey = _cachePrefix + key;
    final expiryKey = _cacheExpiryPrefix + key;

    final cachedData = _prefs.getString(cacheKey);
    final expiryTime = _prefs.getInt(expiryKey);

    if (cachedData == null || expiryTime == null) {
      return false;
    }

    if (DateTime.now().millisecondsSinceEpoch > expiryTime) {
      await _clearPrefsCache(key);
      return false;
    }

    return true;
  }

  Future<void> _clearFileCache(String key) async {
    final file = File('${_cacheDirectory!.path}/$key.json');
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> _clearPrefsCache(String key) async {
    final cacheKey = _cachePrefix + key;
    final expiryKey = _cacheExpiryPrefix + key;

    await _prefs.remove(cacheKey);
    await _prefs.remove(expiryKey);
  }

  Future<void> _cleanupExpiredCache() async {
    // Clean up expired SharedPreferences cache
    final keys = _prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_cachePrefix)) {
        final cacheKey = key.substring(_cachePrefix.length);
        if (!await _isPrefsCached(cacheKey)) {
          // This will remove expired entries
        }
      }
    }

    // Clean up expired file cache
    if (_cacheDirectory != null && await _cacheDirectory!.exists()) {
      final files = await _cacheDirectory!.list().toList();
      for (final file in files) {
        if (file is File && file.path.endsWith('.json')) {
          try {
            final content = await file.readAsString();
            final cacheData = jsonDecode(content) as Map<String, dynamic>;
            final expiryTime = cacheData['expiry'] as int;
            final version = cacheData['version'] as int? ?? 0;

            if (DateTime.now().millisecondsSinceEpoch > expiryTime ||
                version != _currentCacheVersion) {
              await file.delete();
            }
          } catch (e) {
            // Invalid cache file, delete it
            await file.delete();
          }
        }
      }
    }
  }

  Future<void> _handleCacheVersionMigration() async {
    const versionKey = '${_cacheVersionPrefix}current';
    final currentVersion = _prefs.getInt(versionKey) ?? 0;

    if (currentVersion < _currentCacheVersion) {
      // Clear all cache on version upgrade
      await clearAllCache();
      await _prefs.setInt(versionKey, _currentCacheVersion);
    }
  }
}
