import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';

import '../config/app_config.dart';

/// Production-grade biometric authentication service
/// Handles fingerprint, face ID, and other biometric authentication methods
@singleton
class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _isInitialized = false;
  bool _isAvailable = false;
  List<BiometricType> _availableBiometrics = [];

  /// Initialize biometric authentication
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Check if biometric auth is available on device
      _isAvailable = await _localAuth.isDeviceSupported();

      if (_isAvailable) {
        // Get available biometric types
        _availableBiometrics = await _localAuth.getAvailableBiometrics();

        if (kDebugMode && AppConfig.enableDebugLogs) {
          debugPrint('🔒 Biometric auth available: $_isAvailable');
          debugPrint('🔒 Available biometrics: $_availableBiometrics');
        }
      }

      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Biometric auth initialization failed: $e');
      }
      throw BiometricException('Failed to initialize biometric auth: $e');
    }
  }

  /// Check if biometric authentication is available
  bool get isAvailable => _isAvailable && _availableBiometrics.isNotEmpty;

  /// Check if specific biometric type is available
  bool isBiometricTypeAvailable(BiometricType type) => _availableBiometrics.contains(type);

  /// Get available biometric types
  List<BiometricType> get availableBiometrics => _availableBiometrics;

  /// Check if biometric authentication is enrolled
  Future<bool> isBiometricEnrolled() async {
    if (!_isInitialized) await initialize();

    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to check biometric enrollment: $e');
      }
      return false;
    }
  }

  /// Alias for isBiometricEnrolled for consistency
  Future<bool> isEnrolled() async => isBiometricEnrolled();

  /// Authenticate using biometrics
  Future<bool> authenticate({
    required String reason,
    bool useErrorDialogs = true,
    bool stickyAuth = false,
    bool sensitiveTransaction = false,
    bool biometricOnly = false,
  }) async {
    if (!AppConfig.enableBiometricAuth) {
      throw BiometricException('Biometric authentication is disabled');
    }

    if (!_isInitialized) await initialize();

    if (!isAvailable) {
      throw BiometricException('Biometric authentication not available');
    }

    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          sensitiveTransaction: sensitiveTransaction,
          biometricOnly: biometricOnly,
        ),
      );

      if (kDebugMode && AppConfig.enableDebugLogs) {
        debugPrint('🔒 Biometric authentication result: $isAuthenticated');
      }

      return isAuthenticated;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Biometric authentication error: $e');
      }
      throw BiometricException(_handlePlatformException(e));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Biometric authentication failed: $e');
      }
      throw BiometricException('Authentication failed: $e');
    }
  }

  /// Cancel ongoing authentication
  Future<void> cancelAuthentication() async {
    try {
      await _localAuth.stopAuthentication();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to cancel authentication: $e');
      }
    }
  }

  /// Get user-friendly biometric type name
  String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return Platform.isIOS ? 'Face ID' : 'Face Recognition';
      case BiometricType.fingerprint:
        return Platform.isIOS ? 'Touch ID' : 'Fingerprint';
      case BiometricType.iris:
        return 'Iris Recognition';
      case BiometricType.strong:
        return 'Strong Biometric';
      case BiometricType.weak:
        return 'Weak Biometric';
    }
  }

  /// Handle platform-specific exceptions
  String _handlePlatformException(PlatformException e) {
    switch (e.code) {
      case 'NotAvailable':
        return 'Biometric authentication is not available on this device';
      case 'NotEnrolled':
        return 'No biometric credentials are enrolled on this device';
      case 'PasscodeNotSet':
        return 'Device passcode/PIN is not set';
      case 'BiometricOnlyNotSupported':
        return 'Biometric-only authentication is not supported';
      case 'DeviceNotSupported':
        return 'This device does not support biometric authentication';
      case 'UserCancel':
        return 'Authentication was cancelled by user';
      case 'UserFallback':
        return 'User selected fallback authentication method';
      case 'SystemCancel':
        return 'Authentication was cancelled by system';
      case 'InvalidContext':
        return 'Authentication context is invalid';
      case 'NotInteractive':
        return 'Authentication requires user interaction';
      case 'LockedOut':
        return 'Too many failed attempts. Biometric authentication is locked out';
      case 'PermanentlyLockedOut':
        return 'Biometric authentication is permanently locked out';
      default:
        return 'Biometric authentication failed: ${e.message}';
    }
  }

  /// Get primary biometric type available
  BiometricType? get primaryBiometricType {
    if (_availableBiometrics.isEmpty) return null;

    // Prioritize face recognition on iOS, fingerprint on Android
    if (Platform.isIOS) {
      if (_availableBiometrics.contains(BiometricType.face)) {
        return BiometricType.face;
      }
      if (_availableBiometrics.contains(BiometricType.fingerprint)) {
        return BiometricType.fingerprint;
      }
    } else {
      if (_availableBiometrics.contains(BiometricType.fingerprint)) {
        return BiometricType.fingerprint;
      }
      if (_availableBiometrics.contains(BiometricType.face)) {
        return BiometricType.face;
      }
    }

    return _availableBiometrics.first;
  }

  /// Get authentication prompt for primary biometric
  String get primaryBiometricPrompt {
    final primaryType = primaryBiometricType;
    if (primaryType == null) return 'Authenticate using biometrics';

    switch (primaryType) {
      case BiometricType.face:
        return Platform.isIOS
            ? 'Authenticate using Face ID'
            : 'Authenticate using face recognition';
      case BiometricType.fingerprint:
        return Platform.isIOS
            ? 'Authenticate using Touch ID'
            : 'Authenticate using fingerprint';
      case BiometricType.iris:
        return 'Authenticate using iris recognition';
      default:
        return 'Authenticate using biometrics';
    }
  }

  /// Quick authentication for sensitive operations
  Future<bool> quickAuth({String? customReason}) async => authenticate(
      reason: customReason ?? 'Please authenticate to continue',
      stickyAuth: true,
      sensitiveTransaction: true,
    );

  /// Secure authentication for high-value operations
  Future<bool> secureAuth({String? customReason}) async => authenticate(
      reason: customReason ?? 'Please authenticate for secure operation',
      stickyAuth: true,
      sensitiveTransaction: true,
      biometricOnly: true,
    );

  /// Dispose resources
  void dispose() {
    _isInitialized = false;
    _isAvailable = false;
    _availableBiometrics.clear();
  }
}

/// Custom exception for biometric authentication errors
class BiometricException implements Exception {
  BiometricException(this.message);
  final String message;

  @override
  String toString() => 'BiometricException: $message';
}
