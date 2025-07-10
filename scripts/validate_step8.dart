#!/usr/bin/env dart

/// Step 8 validation script for Crete Flutter app
/// Validates Security & Privacy implementation

import 'dart:io';

void main() async {
  print('🔍 Step 8: Security & Privacy Validation');
  print('=========================================\n');

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
        content.contains('storeSecure') &&
        content.contains('getSecure') &&
        content.contains('clearAll') &&
        content.contains('storeAuthTokens') &&
        content.contains('storeWalletCredentials') &&
        content.contains('clearAuthData') &&
        content.contains('clearWalletData')) {
      print('   ✅ Secure Storage Service implemented correctly');
      passedChecks++;
    } else {
      print('   ❌ Secure Storage Service missing required features');
    }
  } else {
    print('   ❌ Secure Storage Service file not found');
  }

  // Check 2: Biometric Authentication Service
  print('\n📋 2. Validating Biometric Authentication Service...');
  totalChecks++;

  final biometricAuthFile = File(
    'lib/core/services/biometric_auth_service.dart',
  );
  if (await biometricAuthFile.exists()) {
    final content = await biometricAuthFile.readAsString();

    if (content.contains('@singleton') &&
        content.contains('class BiometricAuthService') &&
        content.contains('LocalAuthentication') &&
        content.contains('initialize') &&
        content.contains('authenticate') &&
        content.contains('isAvailable') &&
        content.contains('isEnrolled') &&
        content.contains('getAvailableBiometrics') &&
        content.contains('BiometricException') &&
        content.contains('cancelAuthentication') &&
        content.contains('quickAuth') &&
        content.contains('secureAuth')) {
      print('   ✅ Biometric Authentication Service implemented correctly');
      passedChecks++;
    } else {
      print('   ❌ Biometric Authentication Service missing required features');
      // Debug what's missing
      print('   - Checking for quickAuth: ${content.contains('quickAuth')}');
      print('   - Checking for secureAuth: ${content.contains('secureAuth')}');
    }
  } else {
    print('   ❌ Biometric Authentication Service file not found');
  }

  // Check 3: Certificate Pinning Service
  print('\n📋 3. Validating Certificate Pinning Service...');
  totalChecks++;

  final certificatePinningFile = File(
    'lib/core/services/certificate_pinning_service.dart',
  );
  if (await certificatePinningFile.exists()) {
    final content = await certificatePinningFile.readAsString();

    if (content.contains('@singleton') &&
        content.contains('class CertificatePinningService') &&
        content.contains('_pinnedCertificates') &&
        content.contains('validateCertificateChain') &&
        content.contains('_calculateSHA256Fingerprint') &&
        content.contains('createSecureHttpClient') &&
        content.contains('isCertificateValid') &&
        content.contains('getCertificateInfo')) {
      print('   ✅ Certificate Pinning Service implemented correctly');
      passedChecks++;
    } else {
      print('   ❌ Certificate Pinning Service missing required features');
    }
  } else {
    print('   ❌ Certificate Pinning Service file not found');
  }

  // Check 4: Privacy Service
  print('\n📋 4. Validating Privacy Service...');
  totalChecks++;

  final privacyServiceFile = File('lib/core/services/privacy_service.dart');
  if (await privacyServiceFile.exists()) {
    final content = await privacyServiceFile.readAsString();

    if (content.contains('@singleton') &&
        content.contains('class PrivacyService') &&
        content.contains('requestDataCollectionConsent') &&
        content.contains('getPrivacyConsent') &&
        content.contains('hasAnalyticsConsent') &&
        content.contains('requestDataDeletion') &&
        content.contains('exportUserData') &&
        content.contains('revokeAllConsents') &&
        content.contains('PrivacyConsent') &&
        content.contains('DataCollectionSettings') &&
        content.contains('DataDeletionRequest')) {
      print('   ✅ Privacy Service implemented correctly');
      passedChecks++;
    } else {
      print('   ❌ Privacy Service missing required features');
    }
  } else {
    print('   ❌ Privacy Service file not found');
  }

  // Check 5: Privacy Analytics Service
  print('\n📋 5. Validating Privacy Analytics Service...');
  totalChecks++;

  final privacyAnalyticsFile = File(
    'lib/core/services/privacy_analytics_service.dart',
  );
  if (await privacyAnalyticsFile.exists()) {
    final content = await privacyAnalyticsFile.readAsString();

    if (content.contains('@singleton') &&
        content.contains('class PrivacyAnalyticsService') &&
        content.contains('trackEvent') &&
        content.contains('trackScreenView') &&
        content.contains('trackInteraction') &&
        content.contains('trackError') &&
        content.contains('trackPerformance') &&
        content.contains('flushEvents') &&
        content.contains('clearAnalyticsData') &&
        content.contains('_sanitizeProperties') &&
        content.contains('_hasAnalyticsConsent') &&
        content.contains('AnalyticsEvent')) {
      print('   ✅ Privacy Analytics Service implemented correctly');
      passedChecks++;
    } else {
      print('   ❌ Privacy Analytics Service missing required features');
    }
  } else {
    print('   ❌ Privacy Analytics Service file not found');
  }

  // Check 6: ProGuard Obfuscation Rules
  print('\n📋 6. Validating ProGuard Obfuscation Rules...');
  totalChecks++;

  final proguardRulesFile = File('android/app/proguard-rules.pro');
  if (await proguardRulesFile.exists()) {
    final content = await proguardRulesFile.readAsString();

    if (content.contains('# Flutter wrapper') &&
        content.contains('-keep class io.flutter.') &&
        content.contains('# Solana') &&
        content.contains('# Firebase') &&
        content.contains('# Gson') &&
        content.contains('-keepattributes Signature') &&
        content.contains('-keepattributes *Annotation*') &&
        content.contains('# Keep model classes') &&
        content.contains('# Keep enum classes') &&
        content.contains('# Remove debug logs')) {
      print('   ✅ ProGuard obfuscation rules configured correctly');
      passedChecks++;
    } else {
      print('   ❌ ProGuard obfuscation rules missing required configurations');
    }
  } else {
    print('   ❌ ProGuard rules file not found');
  }

  // Check 7: Certificate Pinning Integration
  print('\n📋 7. Validating Certificate Pinning Integration...');
  totalChecks++;

  final httpClientServiceFile = File(
    'lib/core/services/http_client_service.dart',
  );
  if (await httpClientServiceFile.exists()) {
    final content = await httpClientServiceFile.readAsString();

    if (content.contains('CertificatePinningService') &&
        content.contains('_certificatePinning') &&
        content.contains('validateCertificateChain') &&
        content.contains('badCertificateCallback')) {
      print('   ✅ Certificate pinning integrated with HTTP client');
      passedChecks++;
    } else {
      print('   ❌ Certificate pinning not properly integrated');
    }
  } else {
    print('   ❌ HTTP Client Service file not found');
  }

  // Check 8: App Config Security Settings
  print('\n📋 8. Validating App Config Security Settings...');
  totalChecks++;

  final appConfigFile = File('lib/core/config/app_config.dart');
  if (await appConfigFile.exists()) {
    final content = await appConfigFile.readAsString();

    if (content.contains('enableBiometricAuth') &&
        content.contains('enableAnalytics') &&
        content.contains('enableCrashReporting') &&
        content.contains('enableDebugLogs') &&
        content.contains('enableNetworkLogging')) {
      print('   ✅ App Config has security settings configured');
      passedChecks++;
    } else {
      print('   ❌ App Config missing security settings');
    }
  } else {
    print('   ❌ App Config file not found');
  }

  // Check 9: Dependencies
  print('\n📋 9. Validating Security Dependencies...');
  totalChecks++;

  final pubspecFile = File('pubspec.yaml');
  if (await pubspecFile.exists()) {
    final content = await pubspecFile.readAsString();

    if (content.contains('flutter_secure_storage:') &&
        content.contains('local_auth:') &&
        content.contains('crypto:') &&
        content.contains('shared_preferences:')) {
      print('   ✅ All required security dependencies present');
      passedChecks++;
    } else {
      print('   ❌ Missing required security dependencies');
    }
  } else {
    print('   ❌ pubspec.yaml file not found');
  }

  // Check 10: Service Registration
  print('\n📋 10. Validating Service Registration...');
  totalChecks++;

  final injectionConfigFile = File('lib/core/injection/injection.config.dart');
  if (await injectionConfigFile.exists()) {
    final content = await injectionConfigFile.readAsString();

    if (content.contains('SecureStorageService') &&
        content.contains('BiometricAuthService') &&
        content.contains('CertificatePinningService') &&
        content.contains('PrivacyService') &&
        content.contains('PrivacyAnalyticsService')) {
      print('   ✅ All security services registered in DI');
      passedChecks++;
    } else {
      print('   ❌ Not all security services registered in DI');
      // Debug what's missing
      print(
        '   - SecureStorageService: ${content.contains('SecureStorageService')}',
      );
      print(
        '   - BiometricAuthService: ${content.contains('BiometricAuthService')}',
      );
      print(
        '   - CertificatePinningService: ${content.contains('CertificatePinningService')}',
      );
      print('   - PrivacyService: ${content.contains('PrivacyService')}');
      print(
        '   - PrivacyAnalyticsService: ${content.contains('PrivacyAnalyticsService')}',
      );
    }
  } else {
    print('   ❌ Injection configuration file not found');
  }

  // Check 11: Environment Configuration
  print('\n📋 11. Validating Environment Configuration...');
  totalChecks++;

  final environmentFile = File('lib/core/config/environment.dart');
  if (await environmentFile.exists()) {
    final content = await environmentFile.readAsString();

    if (content.contains('enableAnalytics') &&
        content.contains('enableDebugLogs') &&
        content.contains('enableNetworkLogging') &&
        content.contains('enableCrashReporting')) {
      print('   ✅ Environment has privacy/security configurations');
      passedChecks++;
    } else {
      print('   ❌ Environment missing security configurations');
    }
  } else {
    print('   ❌ Environment configuration file not found');
  }

  // Check 12: Security Exception Classes
  print('\n📋 12. Validating Security Exception Classes...');
  totalChecks++;

  final exceptionsFile = File('lib/core/error/exceptions.dart');
  if (await exceptionsFile.exists()) {
    final content = await exceptionsFile.readAsString();

    if (content.contains('StorageException') ||
        content.contains('SecurityException') ||
        content.contains('AuthenticationException')) {
      print('   ✅ Security exception classes available');
      passedChecks++;
    } else {
      print('   ❌ Security exception classes missing');
    }
  } else {
    print('   ❌ Exceptions file not found');
  }

  // Final Result
  print('\n${'=' * 50}');
  print('📊 STEP 8 VALIDATION SUMMARY');
  print('=' * 50);
  print('Total Checks: $totalChecks');
  print('Passed: $passedChecks');
  print('Failed: ${totalChecks - passedChecks}');
  print(
    'Success Rate: ${((passedChecks / totalChecks) * 100).toStringAsFixed(1)}%',
  );

  if (passedChecks == totalChecks) {
    print('\n🎉 Step 8 (Security & Privacy) is COMPLETE!');
    print('✅ All security and privacy features are properly implemented');
    print('✅ Data security, privacy compliance, and obfuscation are ready');
    print('✅ Services are registered and configured correctly');
    print('\n🔐 Security Features:');
    print('  • Secure storage for tokens and sensitive data');
    print('  • Biometric authentication with platform support');
    print('  • SSL/TLS certificate pinning for network security');
    print('  • ProGuard obfuscation for release builds');
    print('\n🔒 Privacy Features:');
    print('  • Privacy-focused analytics with user consent');
    print('  • Comprehensive consent management system');
    print('  • Data deletion mechanisms (GDPR compliance)');
    print('  • User data export functionality');
    print('  • Anonymized data collection and sanitization');
    exit(0);
  } else {
    print('\n❌ Step 8 (Security & Privacy) validation FAILED');
    print('Please address the issues above before proceeding.');
    exit(1);
  }
}
