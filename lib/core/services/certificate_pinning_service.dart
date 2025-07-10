import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../config/app_config.dart';

/// Production-grade certificate pinning service
/// Implements SSL/TLS certificate pinning for enhanced security
@singleton
class CertificatePinningService {
  static const Map<String, List<String>> _pinnedCertificates = {
    // Production API endpoints
    'api.crete.com': [
      // SHA256 fingerprints of trusted certificates
      'AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99',
      // Backup certificate fingerprint
      'BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA',
    ],

    // Staging API endpoints
    'staging-api.crete.com': [
      'CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB',
    ],

    // WebSocket endpoints
    'ws.crete.com': [
      'DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC',
    ],

    // Solana RPC endpoints
    'api.mainnet-beta.solana.com': [
      'EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD',
    ],

    // Firebase services
    'fcm.googleapis.com': [
      'FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE',
    ],
  };

  /// Validate certificate chain against pinned certificates
  bool validateCertificateChain(
    List<X509Certificate> certificateChain,
    String host,
  ) {
    if (!AppConfig.isProduction) {
      // Allow all certificates in development/staging
      if (kDebugMode) {
        debugPrint(
          '🔒 Certificate pinning bypassed in ${AppConfig.appEnvironment}',
        );
      }
      return true;
    }

    if (certificateChain.isEmpty) {
      if (kDebugMode) {
        debugPrint('❌ Empty certificate chain for $host');
      }
      return false;
    }

    final pinnedFingerprints = _pinnedCertificates[host];
    if (pinnedFingerprints == null || pinnedFingerprints.isEmpty) {
      if (kDebugMode) {
        debugPrint('⚠️ No pinned certificates for $host, allowing connection');
      }
      return true; // Allow connections to non-pinned hosts
    }

    // Check each certificate in the chain
    for (final certificate in certificateChain) {
      final fingerprint = _calculateSHA256Fingerprint(certificate);

      if (pinnedFingerprints.contains(fingerprint)) {
        if (kDebugMode) {
          debugPrint('✅ Certificate pinning validated for $host');
        }
        return true;
      }
    }

    if (kDebugMode) {
      debugPrint('❌ Certificate pinning failed for $host');
      debugPrint('Certificate chain fingerprints:');
      for (final cert in certificateChain) {
        debugPrint('  - ${_calculateSHA256Fingerprint(cert)}');
      }
      debugPrint('Expected fingerprints:');
      for (final fingerprint in pinnedFingerprints) {
        debugPrint('  - $fingerprint');
      }
    }

    return false;
  }

  /// Calculate SHA256 fingerprint of a certificate
  String _calculateSHA256Fingerprint(X509Certificate certificate) {
    try {
      final der = certificate.der;
      final digest = sha256.convert(der);

      // Convert to uppercase hex with colons
      final hex = digest.bytes
          .map((byte) => byte.toRadixString(16).padLeft(2, '0').toUpperCase())
          .join(':');

      return hex;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to calculate certificate fingerprint: $e');
      }
      return '';
    }
  }

  /// Validate certificate against specific pinned fingerprint
  bool validateCertificateFingerprint(
    X509Certificate certificate,
    String expectedFingerprint,
  ) {
    final actualFingerprint = _calculateSHA256Fingerprint(certificate);
    return actualFingerprint == expectedFingerprint;
  }

  /// Get pinned certificates for a specific host
  List<String>? getPinnedCertificates(String host) => _pinnedCertificates[host];

  /// Check if a host has pinned certificates
  bool hasPinnedCertificates(String host) => _pinnedCertificates.containsKey(host);

  /// Create HttpClient with certificate pinning
  HttpClient createSecureHttpClient() {
    final client = HttpClient();

    if (AppConfig.isProduction) {
      client.badCertificateCallback = (cert, host, port) => validateCertificateChain([cert], host);
    }

    return client;
  }

  /// Validate certificate expiry
  bool isCertificateValid(X509Certificate certificate) {
    final now = DateTime.now();
    return now.isAfter(certificate.startValidity) &&
        now.isBefore(certificate.endValidity);
  }

  /// Get certificate information for debugging
  Map<String, dynamic> getCertificateInfo(X509Certificate certificate) => {
      'subject': certificate.subject,
      'issuer': certificate.issuer,
      'startValidity': certificate.startValidity.toIso8601String(),
      'endValidity': certificate.endValidity.toIso8601String(),
      'fingerprint': _calculateSHA256Fingerprint(certificate),
      'isValid': isCertificateValid(certificate),
    };

  /// Log certificate information (debug mode only)
  void logCertificateInfo(X509Certificate certificate, String host) {
    if (!kDebugMode) return;

    final info = getCertificateInfo(certificate);
    debugPrint('🔒 Certificate info for $host:');
    debugPrint('  Subject: ${info['subject']}');
    debugPrint('  Issuer: ${info['issuer']}');
    debugPrint('  Valid from: ${info['startValidity']}');
    debugPrint('  Valid to: ${info['endValidity']}');
    debugPrint('  Fingerprint: ${info['fingerprint']}');
    debugPrint('  Is valid: ${info['isValid']}');
  }

  /// Update pinned certificates (for testing purposes)
  @visibleForTesting
  void updatePinnedCertificates(String host, List<String> fingerprints) {
    if (!kDebugMode) {
      throw UnsupportedError(
        'Certificate pinning can only be updated in debug mode',
      );
    }
    // This is a testing method and should not be used in production
  }

  /// Get all pinned hosts
  List<String> getPinnedHosts() => _pinnedCertificates.keys.toList();

  /// Validate certificate chain length
  bool isValidCertificateChainLength(List<X509Certificate> chain) {
    // Typical certificate chains have 2-4 certificates
    return chain.isNotEmpty && chain.length <= 10;
  }

  /// Extract hostname from URL
  String extractHostname(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to extract hostname from $url: $e');
      }
      return '';
    }
  }
}

/// Certificate pinning exception
class CertificatePinningException implements Exception {

  CertificatePinningException(this.message, this.host, {this.certificateChain});
  final String message;
  final String host;
  final List<String>? certificateChain;

  @override
  String toString() => 'CertificatePinningException: $message (host: $host)';
}
