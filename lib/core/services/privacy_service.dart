import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import 'secure_storage_service.dart';

/// Production-grade privacy service for data collection consent and privacy compliance
/// Implements GDPR, CCPA, and other privacy regulations compliance
@singleton
class PrivacyService {

  PrivacyService(this._prefs, this._secureStorage);
  final SharedPreferences _prefs;
  final SecureStorageService _secureStorage;

  static const String _consentKey = 'privacy_consent';
  static const String _dataCollectionKey = 'data_collection_settings';
  static const String _deletionRequestKey = 'deletion_request_pending';
  static const String _privacyPolicyVersionKey = 'privacy_policy_version';

  /// Initialize privacy service
  Future<void> initialize() async {
    // Check if we need to request consent for updated privacy policy
    await _checkPrivacyPolicyUpdates();

    // Ensure analytics consent is properly configured
    await _validateAnalyticsConsent();

    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('🔐 Privacy service initialized');
    }
  }

  /// Request user consent for data collection
  Future<void> requestDataCollectionConsent({
    required bool analytics,
    required bool crashReporting,
    required bool performanceMonitoring,
    required bool personalizedContent,
    String? privacyPolicyVersion,
  }) async {
    final consent = PrivacyConsent(
      analytics: analytics,
      crashReporting: crashReporting,
      performanceMonitoring: performanceMonitoring,
      personalizedContent: personalizedContent,
      consentDate: DateTime.now(),
      privacyPolicyVersion:
          privacyPolicyVersion ?? _getCurrentPrivacyPolicyVersion(),
    );

    await _storeConsent(consent);

    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('✅ Privacy consent updated: ${consent.toJson()}');
    }
  }

  /// Get current privacy consent status
  Future<PrivacyConsent?> getPrivacyConsent() async {
    final consentJson = _prefs.getString(_consentKey);
    if (consentJson == null) return null;

    try {
      final consentMap = jsonDecode(consentJson) as Map<String, dynamic>;
      return PrivacyConsent.fromJson(consentMap);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to parse privacy consent: $e');
      }
      return null;
    }
  }

  /// Check if user has given consent for analytics
  Future<bool> hasAnalyticsConsent() async {
    final consent = await getPrivacyConsent();
    return consent?.analytics ?? false;
  }

  /// Check if user has given consent for crash reporting
  Future<bool> hasCrashReportingConsent() async {
    final consent = await getPrivacyConsent();
    return consent?.crashReporting ?? false;
  }

  /// Check if user has given consent for performance monitoring
  Future<bool> hasPerformanceMonitoringConsent() async {
    final consent = await getPrivacyConsent();
    return consent?.performanceMonitoring ?? false;
  }

  /// Check if user has given consent for personalized content
  Future<bool> hasPersonalizedContentConsent() async {
    final consent = await getPrivacyConsent();
    return consent?.personalizedContent ?? false;
  }

  /// Check if consent is required (no consent given or policy updated)
  Future<bool> isConsentRequired() async {
    final consent = await getPrivacyConsent();
    if (consent == null) return true;

    // Check if privacy policy has been updated since last consent
    final currentVersion = _getCurrentPrivacyPolicyVersion();
    return consent.privacyPolicyVersion != currentVersion;
  }

  /// Configure data collection settings
  Future<void> configureDataCollection({
    required bool collectUsageStatistics,
    required bool collectCrashReports,
    required bool collectPerformanceMetrics,
    required bool shareAnonymizedData,
    required bool enableTelemetry,
  }) async {
    final settings = DataCollectionSettings(
      collectUsageStatistics: collectUsageStatistics,
      collectCrashReports: collectCrashReports,
      collectPerformanceMetrics: collectPerformanceMetrics,
      shareAnonymizedData: shareAnonymizedData,
      enableTelemetry: enableTelemetry,
      lastUpdated: DateTime.now(),
    );

    await _storeDataCollectionSettings(settings);

    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('✅ Data collection settings updated');
    }
  }

  /// Get current data collection settings
  Future<DataCollectionSettings?> getDataCollectionSettings() async {
    final settingsJson = _prefs.getString(_dataCollectionKey);
    if (settingsJson == null) return null;

    try {
      final settingsMap = jsonDecode(settingsJson) as Map<String, dynamic>;
      return DataCollectionSettings.fromJson(settingsMap);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to parse data collection settings: $e');
      }
      return null;
    }
  }

  /// Request user data deletion (GDPR Article 17 - Right to be forgotten)
  Future<void> requestDataDeletion({
    required String reason,
    required bool deleteUserProfile,
    required bool deleteActivityHistory,
    required bool deleteStoredMessages,
    required bool deleteAnalyticsData,
    String? additionalNotes,
  }) async {
    final request = DataDeletionRequest(
      reason: reason,
      deleteUserProfile: deleteUserProfile,
      deleteActivityHistory: deleteActivityHistory,
      deleteStoredMessages: deleteStoredMessages,
      deleteAnalyticsData: deleteAnalyticsData,
      additionalNotes: additionalNotes,
      requestDate: DateTime.now(),
      status: DataDeletionStatus.pending,
    );

    // Store deletion request locally
    await _storeDeletionRequest(request);

    // Mark as pending for backend processing
    await _prefs.setBool(_deletionRequestKey, true);

    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('✅ Data deletion request submitted');
    }
  }

  /// Check if there's a pending data deletion request
  Future<bool> hasPendingDeletionRequest() async => _prefs.getBool(_deletionRequestKey) ?? false;

  /// Get pending data deletion request
  Future<DataDeletionRequest?> getPendingDeletionRequest() async {
    final requestJson = await _secureStorage.getSecure('deletion_request');
    if (requestJson == null) return null;

    try {
      final requestMap = jsonDecode(requestJson) as Map<String, dynamic>;
      return DataDeletionRequest.fromJson(requestMap);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to parse deletion request: $e');
      }
      return null;
    }
  }

  /// Execute local data deletion (immediate cleanup)
  Future<void> executeLocalDataDeletion() async {
    try {
      // Clear all local caches and preferences
      await _prefs.clear();

      // Clear all secure storage
      await _secureStorage.clearAll();

      if (kDebugMode && AppConfig.enableDebugLogs) {
        debugPrint('✅ Local data deletion completed');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to delete local data: $e');
      }
      throw PrivacyException('Failed to delete local data: $e');
    }
  }

  /// Export user data (GDPR Article 20 - Right to data portability)
  Future<Map<String, dynamic>> exportUserData() async {
    final exportData = <String, dynamic>{
      'export_date': DateTime.now().toIso8601String(),
      'privacy_consent': await getPrivacyConsent(),
      'data_collection_settings': await getDataCollectionSettings(),
      'user_preferences': await _exportUserPreferences(),
      'cached_data': await _exportCachedData(),
    };

    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('✅ User data exported');
    }

    return exportData;
  }

  /// Revoke all privacy consents
  Future<void> revokeAllConsents() async {
    await requestDataCollectionConsent(
      analytics: false,
      crashReporting: false,
      performanceMonitoring: false,
      personalizedContent: false,
    );

    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('✅ All privacy consents revoked');
    }
  }

  /// Get privacy-compliant analytics settings
  Future<Map<String, bool>> getAnalyticsSettings() async {
    final consent = await getPrivacyConsent();
    final settings = await getDataCollectionSettings();

    return {
      'enabled': (consent?.analytics ?? false) && AppConfig.enableAnalytics,
      'collect_usage': settings?.collectUsageStatistics ?? false,
      'collect_crashes': settings?.collectCrashReports ?? false,
      'collect_performance': settings?.collectPerformanceMetrics ?? false,
      'share_anonymized': settings?.shareAnonymizedData ?? false,
      'enable_telemetry': settings?.enableTelemetry ?? false,
    };
  }

  // Private methods

  Future<void> _storeConsent(PrivacyConsent consent) async {
    final consentJson = jsonEncode(consent.toJson());
    await _prefs.setString(_consentKey, consentJson);
  }

  Future<void> _storeDataCollectionSettings(
    DataCollectionSettings settings,
  ) async {
    final settingsJson = jsonEncode(settings.toJson());
    await _prefs.setString(_dataCollectionKey, settingsJson);
  }

  Future<void> _storeDeletionRequest(DataDeletionRequest request) async {
    final requestJson = jsonEncode(request.toJson());
    await _secureStorage.storeSecure('deletion_request', requestJson);
  }

  Future<void> _checkPrivacyPolicyUpdates() async {
    final currentVersion = _getCurrentPrivacyPolicyVersion();
    final storedVersion = _prefs.getString(_privacyPolicyVersionKey);

    if (storedVersion != currentVersion) {
      await _prefs.setString(_privacyPolicyVersionKey, currentVersion);
    }
  }

  Future<void> _validateAnalyticsConsent() async {
    final consent = await getPrivacyConsent();
    if (consent == null && AppConfig.enableAnalytics) {
      // Analytics is enabled but no consent given - this needs to be handled
      if (kDebugMode) {
        debugPrint('⚠️ Analytics enabled but no privacy consent given');
      }
    }
  }

  String _getCurrentPrivacyPolicyVersion() {
    // This should be updated whenever privacy policy changes
    return '1.0.0';
  }

  Future<Map<String, dynamic>> _exportUserPreferences() async {
    final keys = _prefs.getKeys();
    final prefs = <String, dynamic>{};

    for (final key in keys) {
      if (!key.startsWith('_') && !key.contains('token')) {
        final value = _prefs.get(key);
        if (value != null) {
          prefs[key] = value;
        }
      }
    }

    return prefs;
  }

  Future<Map<String, dynamic>> _exportCachedData() async {
    final keys = _prefs.getKeys();
    final cachedData = <String, dynamic>{};

    for (final key in keys) {
      if (key.startsWith('cached_') || key.contains('_cache_')) {
        final value = _prefs.get(key);
        if (value != null) {
          cachedData[key] = value;
        }
      }
    }

    return cachedData;
  }
}

/// Privacy consent model
class PrivacyConsent {

  const PrivacyConsent({
    required this.analytics,
    required this.crashReporting,
    required this.performanceMonitoring,
    required this.personalizedContent,
    required this.consentDate,
    required this.privacyPolicyVersion,
  });

  factory PrivacyConsent.fromJson(Map<String, dynamic> json) => PrivacyConsent(
    analytics: json['analytics'] as bool,
    crashReporting: json['crashReporting'] as bool,
    performanceMonitoring: json['performanceMonitoring'] as bool,
    personalizedContent: json['personalizedContent'] as bool,
    consentDate: DateTime.parse(json['consentDate'] as String),
    privacyPolicyVersion: json['privacyPolicyVersion'] as String,
  );
  final bool analytics;
  final bool crashReporting;
  final bool performanceMonitoring;
  final bool personalizedContent;
  final DateTime consentDate;
  final String privacyPolicyVersion;

  Map<String, dynamic> toJson() => {
    'analytics': analytics,
    'crashReporting': crashReporting,
    'performanceMonitoring': performanceMonitoring,
    'personalizedContent': personalizedContent,
    'consentDate': consentDate.toIso8601String(),
    'privacyPolicyVersion': privacyPolicyVersion,
  };
}

/// Data collection settings model
class DataCollectionSettings {

  const DataCollectionSettings({
    required this.collectUsageStatistics,
    required this.collectCrashReports,
    required this.collectPerformanceMetrics,
    required this.shareAnonymizedData,
    required this.enableTelemetry,
    required this.lastUpdated,
  });

  factory DataCollectionSettings.fromJson(Map<String, dynamic> json) =>
      DataCollectionSettings(
        collectUsageStatistics: json['collectUsageStatistics'] as bool,
        collectCrashReports: json['collectCrashReports'] as bool,
        collectPerformanceMetrics: json['collectPerformanceMetrics'] as bool,
        shareAnonymizedData: json['shareAnonymizedData'] as bool,
        enableTelemetry: json['enableTelemetry'] as bool,
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      );
  final bool collectUsageStatistics;
  final bool collectCrashReports;
  final bool collectPerformanceMetrics;
  final bool shareAnonymizedData;
  final bool enableTelemetry;
  final DateTime lastUpdated;

  Map<String, dynamic> toJson() => {
    'collectUsageStatistics': collectUsageStatistics,
    'collectCrashReports': collectCrashReports,
    'collectPerformanceMetrics': collectPerformanceMetrics,
    'shareAnonymizedData': shareAnonymizedData,
    'enableTelemetry': enableTelemetry,
    'lastUpdated': lastUpdated.toIso8601String(),
  };
}

/// Data deletion request model
class DataDeletionRequest {

  const DataDeletionRequest({
    required this.reason,
    required this.deleteUserProfile,
    required this.deleteActivityHistory,
    required this.deleteStoredMessages,
    required this.deleteAnalyticsData,
    this.additionalNotes,
    required this.requestDate,
    required this.status,
  });

  factory DataDeletionRequest.fromJson(Map<String, dynamic> json) =>
      DataDeletionRequest(
        reason: json['reason'] as String,
        deleteUserProfile: json['deleteUserProfile'] as bool,
        deleteActivityHistory: json['deleteActivityHistory'] as bool,
        deleteStoredMessages: json['deleteStoredMessages'] as bool,
        deleteAnalyticsData: json['deleteAnalyticsData'] as bool,
        additionalNotes: json['additionalNotes'] as String?,
        requestDate: DateTime.parse(json['requestDate'] as String),
        status: DataDeletionStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => DataDeletionStatus.pending,
        ),
      );
  final String reason;
  final bool deleteUserProfile;
  final bool deleteActivityHistory;
  final bool deleteStoredMessages;
  final bool deleteAnalyticsData;
  final String? additionalNotes;
  final DateTime requestDate;
  final DataDeletionStatus status;

  Map<String, dynamic> toJson() => {
    'reason': reason,
    'deleteUserProfile': deleteUserProfile,
    'deleteActivityHistory': deleteActivityHistory,
    'deleteStoredMessages': deleteStoredMessages,
    'deleteAnalyticsData': deleteAnalyticsData,
    'additionalNotes': additionalNotes,
    'requestDate': requestDate.toIso8601String(),
    'status': status.name,
  };
}

/// Data deletion status
enum DataDeletionStatus { pending, processing, completed, failed }

/// Custom exception for privacy-related errors
class PrivacyException implements Exception {
  PrivacyException(this.message);
  final String message;

  @override
  String toString() => 'PrivacyException: $message';
}
