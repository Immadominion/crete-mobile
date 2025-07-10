#!/usr/bin/env dart

/// Firebase Integration Validation Script for Step 3
///
/// This script validates that all Firebase integration components are properly
/// configured for the Crete Flutter app.

import 'dart:io';

void main() async {
  print('🔥 Validating Firebase Integration (Step 3)...\n');

  final validations = [
    _validateFirebaseConfigFiles(),
    _validatePubspecDependencies(),
    _validateFirebaseOptionsFile(),
    _validateMainDartInitialization(),
    _validateAndroidConfiguration(),
    _validateIosConfiguration(),
    _validateNotificationService(),
    _validateDependencyInjection(),
  ];

  int passed = 0;
  final int total = validations.length;

  for (final validation in validations) {
    final result = await validation;
    if (result) passed++;
  }

  print('\n📊 Validation Summary:');
  print('✅ Passed: $passed/$total');

  if (passed == total) {
    print('🎉 All Firebase integration checks passed!');
    print('Step 3 is complete and ready for testing.');
  } else {
    print('❌ Some validations failed. Please review the issues above.');
    exit(1);
  }
}

Future<bool> _validateFirebaseConfigFiles() async {
  print('🔍 Checking Firebase configuration files...');

  final files = [
    'android/app/google-services.json',
    'ios/Runner/GoogleService-Info.plist',
    'macos/Runner/GoogleService-Info.plist',
  ];

  bool allExist = true;
  for (final file in files) {
    if (await File(file).exists()) {
      print('  ✅ $file');
    } else {
      print('  ❌ $file (missing)');
      allExist = false;
    }
  }

  return allExist;
}

Future<bool> _validatePubspecDependencies() async {
  print('\n🔍 Checking pubspec.yaml dependencies...');

  final pubspecFile = File('pubspec.yaml');
  if (!await pubspecFile.exists()) {
    print('  ❌ pubspec.yaml not found');
    return false;
  }

  final content = await pubspecFile.readAsString();
  final requiredDeps = [
    'firebase_core:',
    'firebase_messaging:',
    'flutter_local_notifications:',
  ];

  bool allFound = true;
  for (final dep in requiredDeps) {
    if (content.contains(dep)) {
      print('  ✅ $dep');
    } else {
      print('  ❌ $dep (missing)');
      allFound = false;
    }
  }

  return allFound;
}

Future<bool> _validateFirebaseOptionsFile() async {
  print('\n🔍 Checking firebase_options.dart...');

  final file = File('lib/firebase_options.dart');
  if (!await file.exists()) {
    print('  ❌ lib/firebase_options.dart not found');
    return false;
  }

  final content = await file.readAsString();
  if (content.contains('DefaultFirebaseOptions')) {
    print('  ✅ DefaultFirebaseOptions class found');
    return true;
  } else {
    print('  ❌ DefaultFirebaseOptions class not found');
    return false;
  }
}

Future<bool> _validateMainDartInitialization() async {
  print('\n🔍 Checking main.dart Firebase initialization...');

  final file = File('lib/main.dart');
  if (!await file.exists()) {
    print('  ❌ lib/main.dart not found');
    return false;
  }

  final content = await file.readAsString();
  final checks = [
    ('Firebase.initializeApp', 'Firebase initialization'),
    ('DefaultFirebaseOptions.currentPlatform', 'Firebase options'),
    ('FirebaseNotificationService', 'Notification service'),
    ('notificationService.initialize()', 'Notification service initialization'),
  ];

  bool allFound = true;
  for (final (pattern, description) in checks) {
    if (content.contains(pattern)) {
      print('  ✅ $description');
    } else {
      print('  ❌ $description (missing)');
      allFound = false;
    }
  }

  return allFound;
}

Future<bool> _validateAndroidConfiguration() async {
  print('\n🔍 Checking Android configuration...');

  final buildFile = File('android/app/build.gradle.kts');
  if (!await buildFile.exists()) {
    print('  ❌ android/app/build.gradle.kts not found');
    return false;
  }

  final content = await buildFile.readAsString();
  if (content.contains('com.google.gms.google-services')) {
    print('  ✅ Google Services plugin configured');
    return true;
  } else {
    print('  ❌ Google Services plugin not found');
    return false;
  }
}

Future<bool> _validateIosConfiguration() async {
  print('\n🔍 Checking iOS configuration...');

  final podfile = File('ios/Podfile');
  if (!await podfile.exists()) {
    print('  ❌ ios/Podfile not found');
    return false;
  }

  // For iOS, we mainly check that the GoogleService-Info.plist exists
  // which was already validated in _validateFirebaseConfigFiles
  print('  ✅ iOS configuration appears valid');
  return true;
}

Future<bool> _validateNotificationService() async {
  print('\n🔍 Checking Firebase Notification Service...');

  final file = File('lib/core/services/firebase_notification_service.dart');
  if (!await file.exists()) {
    print('  ❌ FirebaseNotificationService not found');
    return false;
  }

  final content = await file.readAsString();
  final features = [
    'class FirebaseNotificationService',
    'getToken()',
    '_requestPermissions()',
    '_configureFirebaseMessaging()',
    'createNotificationChannel(',
  ];

  bool allFound = true;
  for (final feature in features) {
    if (content.contains(feature)) {
      print('  ✅ $feature');
    } else {
      print('  ❌ $feature (missing)');
      allFound = false;
    }
  }

  return allFound;
}

Future<bool> _validateDependencyInjection() async {
  print('\n🔍 Checking dependency injection setup...');

  final serviceModule = File('lib/core/injection/service_module.dart');
  if (!await serviceModule.exists()) {
    print('  ❌ service_module.dart not found');
    return false;
  }

  final content = await serviceModule.readAsString();
  if (content.contains('FirebaseNotificationService')) {
    print('  ✅ FirebaseNotificationService registered in DI');
    return true;
  } else {
    print('  ❌ FirebaseNotificationService not registered in DI');
    return false;
  }
}
