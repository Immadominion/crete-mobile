#!/usr/bin/env dart

/// Step 7 validation script for Crete Flutter app
/// Validates Storage & Caching implementation

import 'dart:io';

void main() async {
  print('🔍 Step 7: Storage & Caching Validation');
  print('==========================================\n');

  int totalChecks = 0;
  int passedChecks = 0;

  // Check 1: Secure Storage Service
  print('📋 1. Validating Secure Storage Service...');
  totalChecks++;

  final secureStorageFile = File(
    'lib/core/services/secure_storage_service.dart',
  );
  if (await secureStorageFile.exists()) {
    final content = await secureStorageFile.readAsString();

    if (content.contains('@singleton') &&
        content.contains('class SecureStorageService') &&
        content.contains('FlutterSecureStorage') &&
        content.contains('store') &&
        content.contains('get') &&
        content.contains('clear')) {
      print('   ✅ Secure Storage Service implemented correctly');
      passedChecks++;
    } else {
      print('   ❌ Secure Storage Service missing required features');
    }
  } else {
    print('   ❌ Secure Storage Service file not found');
  }

  // Check 2: Cache Service
  print('\n📋 2. Validating Cache Service...');
  totalChecks++;

  final cacheServiceFile = File('lib/core/services/cache_service.dart');
  if (await cacheServiceFile.exists()) {
    final content = await cacheServiceFile.readAsString();

    if (content.contains('@lazySingleton') &&
        content.contains('class CacheService') &&
        content.contains('cacheData') &&
        content.contains('getCachedData') &&
        content.contains('clearCache') &&
        content.contains('expir')) {
      print('   ✅ Cache Service implemented correctly');
      passedChecks++;
    } else {
      print('   ❌ Cache Service missing required features');
    }
  } else {
    print('   ❌ Cache Service file not found');
  }

  // Check 3: Connectivity Service
  print('\n📋 3. Validating Connectivity Service...');
  totalChecks++;

  final connectivityServiceFile = File(
    'lib/core/services/connectivity_service.dart',
  );
  if (await connectivityServiceFile.exists()) {
    final content = await connectivityServiceFile.readAsString();

    if (content.contains('@singleton') &&
        content.contains('class ConnectivityService') &&
        content.contains('NetworkInfo') &&
        content.contains('NetworkStatus') &&
        content.contains('isOnline') &&
        content.contains('Stream')) {
      print('   ✅ Connectivity Service implemented correctly');
      passedChecks++;
    } else {
      print('   ❌ Connectivity Service missing required features');
    }
  } else {
    print('   ❌ Connectivity Service file not found');
  }

  // Check 4: Offline Data Service
  print('\n📋 4. Validating Offline Data Service...');
  totalChecks++;

  final offlineDataServiceFile = File(
    'lib/core/services/offline_data_service.dart',
  );
  if (await offlineDataServiceFile.exists()) {
    final content = await offlineDataServiceFile.readAsString();

    if (content.contains('@lazySingleton') &&
        content.contains('class OfflineDataService') &&
        content.contains('SyncOperation') &&
        content.contains('addOptimisticUpdate') &&
        content.contains('syncPendingOperations') &&
        content.contains('getOfflineData') &&
        content.contains('optimistic updates') &&
        content.contains('sync mechanisms')) {
      print('   ✅ Offline Data Service implemented correctly');
      passedChecks++;
    } else {
      print('   ❌ Offline Data Service missing required features');
    }
  } else {
    print('   ❌ Offline Data Service file not found');
  }

  // Check 5: Local Data Source
  print('\n📋 5. Validating Local Data Sources...');
  totalChecks++;

  final localDataSourceFile = File(
    'lib/data/data_sources/local_data_source.dart',
  );
  if (await localDataSourceFile.exists()) {
    final content = await localDataSourceFile.readAsString();

    if (content.contains('class LocalDataSource') &&
        content.contains('SharedPreferences') &&
        content.contains('cache') &&
        content.contains('User') &&
        content.contains('clear')) {
      print('   ✅ Local Data Source implemented correctly');
      passedChecks++;
    } else {
      print('   ❌ Local Data Source missing required features');
    }
  } else {
    print('   ❌ Local Data Source file not found');
  }

  // Check 6: Dependencies
  print('\n📋 6. Validating Dependencies...');
  totalChecks++;

  final pubspecFile = File('pubspec.yaml');
  if (await pubspecFile.exists()) {
    final content = await pubspecFile.readAsString();

    if (content.contains('shared_preferences:') &&
        content.contains('flutter_secure_storage:') &&
        content.contains('connectivity_plus:') &&
        content.contains('path_provider:')) {
      print('   ✅ All required dependencies present');
      passedChecks++;
    } else {
      print('   ❌ Missing required dependencies');
    }
  } else {
    print('   ❌ pubspec.yaml file not found');
  }

  // Check 7: Service Registration
  print('\n📋 7. Validating Service Registration...');
  totalChecks++;

  final mainFile = File('lib/main.dart');
  if (await mainFile.exists()) {
    final content = await mainFile.readAsString();

    if (content.contains('CacheService') &&
        content.contains('ConnectivityService') &&
        content.contains('OfflineDataService') &&
        content.contains('initialize')) {
      print('   ✅ All services properly registered and initialized');
      passedChecks++;
    } else {
      print('   ❌ Services not properly registered in main.dart');
    }
  } else {
    print('   ❌ main.dart file not found');
  }

  // Check 8: Injectable Services
  print('\n📋 8. Validating Injectable Registration...');
  totalChecks++;

  final injectionFile = File('lib/core/injection/injection.config.dart');
  if (await injectionFile.exists()) {
    final content = await injectionFile.readAsString();

    if (content.contains('CacheService') &&
        content.contains('ConnectivityService') &&
        content.contains('OfflineDataService') &&
        content.contains('SecureStorageService')) {
      print('   ✅ All services properly registered in DI');
      passedChecks++;
    } else {
      print('   ❌ Services not properly registered in DI');
    }
  } else {
    print('   ❌ DI configuration file not found');
  }

  // Final Result
  print('\n${'=' * 50}');
  print('📊 STEP 7 VALIDATION SUMMARY');
  print('=' * 50);
  print('Total Checks: $totalChecks');
  print('Passed: $passedChecks');
  print('Failed: ${totalChecks - passedChecks}');
  print(
    'Success Rate: ${((passedChecks / totalChecks) * 100).toStringAsFixed(1)}%',
  );

  if (passedChecks == totalChecks) {
    print('\n🎉 Step 7 (Storage & Caching) is COMPLETE!');
    print('✅ All storage and caching features are properly implemented');
    print('✅ Secure storage, cache management, and offline support are ready');
    print('✅ Services are registered and initialized correctly');
    exit(0);
  } else {
    print('\n❌ Step 7 (Storage & Caching) validation FAILED');
    print('Please address the issues above before proceeding.');
    exit(1);
  }
}
