import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import 'privacy_service.dart';

/// Privacy-focused analytics service
/// Collects anonymized usage data with explicit user consent
/// Implements privacy-by-design principles
@singleton
class PrivacyAnalyticsService {

  PrivacyAnalyticsService(this._prefs, this._privacyService);
  final SharedPreferences _prefs;
  final PrivacyService _privacyService;

  static const String _userIdKey = 'analytics_user_id';
  static const String _eventQueueKey = 'analytics_event_queue';
  static const String _lastFlushKey = 'analytics_last_flush';

  // Privacy-safe event queue (local storage until consent and flush)
  final List<AnalyticsEvent> _eventQueue = [];
  String? _anonymousUserId;
  String? _sessionId;
  bool _isInitialized = false;

  /// Initialize analytics service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Generate anonymous user ID (persistent but not linked to real identity)
    _anonymousUserId = await _getOrCreateAnonymousUserId();

    // Generate session ID (changes each app session)
    _sessionId = _generateSessionId();

    // Load queued events from storage
    await _loadEventQueue();

    _isInitialized = true;

    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('📊 Privacy Analytics initialized');
    }
  }

  /// Track user action with privacy-first approach
  Future<void> trackEvent(
    String eventName, {
    Map<String, dynamic>? properties,
    bool requiresConsent = true,
  }) async {
    if (!_isInitialized) await initialize();

    // Check if analytics is enabled and user consented
    if (requiresConsent && !await _hasAnalyticsConsent()) {
      if (kDebugMode) {
        debugPrint('📊 Analytics event skipped (no consent): $eventName');
      }
      return;
    }

    if (!AppConfig.enableAnalytics) {
      if (kDebugMode) {
        debugPrint('📊 Analytics disabled: $eventName');
      }
      return;
    }

    // Create privacy-safe event
    final event = AnalyticsEvent(
      name: eventName,
      properties: _sanitizeProperties(properties ?? {}),
      timestamp: DateTime.now(),
      sessionId: _sessionId!,
      userId: _anonymousUserId!,
      platform: _getPlatformInfo(),
      appVersion: AppConfig.appVersion,
    );

    // Add to local queue
    _eventQueue.add(event);

    // Persist event queue
    await _saveEventQueue();

    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('📊 Analytics event queued: $eventName');
    }

    // Auto-flush if queue is large
    if (_eventQueue.length >= 10) {
      await flushEvents();
    }
  }

  /// Track screen view
  Future<void> trackScreenView(
    String screenName, {
    Map<String, dynamic>? properties,
  }) async {
    await trackEvent(
      'screen_view',
      properties: {'screen_name': screenName, ...?properties},
    );
  }

  /// Track user interaction
  Future<void> trackInteraction(
    String interactionType, {
    String? target,
    Map<String, dynamic>? properties,
  }) async {
    await trackEvent(
      'user_interaction',
      properties: {
        'interaction_type': interactionType,
        if (target != null) 'target': target,
        ...?properties,
      },
    );
  }

  /// Track error (without sensitive data)
  Future<void> trackError(
    String errorType, {
    String? errorMessage,
    Map<String, dynamic>? properties,
  }) async {
    await trackEvent(
      'error_occurred',
      properties: {
        'error_type': errorType,
        if (errorMessage != null)
          'error_message': _sanitizeErrorMessage(errorMessage),
        ...?properties,
      },
    );
  }

  /// Track performance metric
  Future<void> trackPerformance(
    String metricName, {
    required double value,
    String? unit,
    Map<String, dynamic>? properties,
  }) async {
    await trackEvent(
      'performance_metric',
      properties: {
        'metric_name': metricName,
        'value': value,
        if (unit != null) 'unit': unit,
        ...?properties,
      },
    );
  }

  /// Track feature usage
  Future<void> trackFeatureUsage(
    String featureName, {
    String? action,
    Map<String, dynamic>? properties,
  }) async {
    await trackEvent(
      'feature_usage',
      properties: {
        'feature_name': featureName,
        if (action != null) 'action': action,
        ...?properties,
      },
    );
  }

  /// Flush events to analytics backend (only if consent given)
  Future<void> flushEvents() async {
    if (!await _hasAnalyticsConsent()) {
      if (kDebugMode) {
        debugPrint('📊 Analytics flush skipped (no consent)');
      }
      return;
    }

    if (_eventQueue.isEmpty) return;

    try {
      // In a real implementation, this would send to your analytics backend
      // For now, we'll just log and clear the queue
      if (kDebugMode) {
        debugPrint('📊 Flushing ${_eventQueue.length} analytics events');
        for (final event in _eventQueue) {
          debugPrint('  - ${event.name}: ${event.properties}');
        }
      }

      // Clear local queue after successful flush
      _eventQueue.clear();
      await _saveEventQueue();

      // Update last flush time
      await _prefs.setInt(_lastFlushKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Analytics flush failed: $e');
      }
    }
  }

  /// Clear all analytics data (for privacy compliance)
  Future<void> clearAnalyticsData() async {
    _eventQueue.clear();
    await _prefs.remove(_eventQueueKey);
    await _prefs.remove(_lastFlushKey);

    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('🗑️ Analytics data cleared');
    }
  }

  /// Reset anonymous user ID (for privacy)
  Future<void> resetAnonymousUserId() async {
    _anonymousUserId = _generateAnonymousUserId();
    await _prefs.setString(_userIdKey, _anonymousUserId!);

    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('🔄 Anonymous user ID reset');
    }
  }

  /// Get analytics statistics (for user transparency)
  Future<Map<String, dynamic>> getAnalyticsStats() async {
    final lastFlush = _prefs.getInt(_lastFlushKey);
    final settings = await _privacyService.getAnalyticsSettings();

    return {
      'events_queued': _eventQueue.length,
      'last_flush': lastFlush != null
          ? DateTime.fromMillisecondsSinceEpoch(lastFlush).toIso8601String()
          : null,
      'anonymous_user_id': _anonymousUserId,
      'session_id': _sessionId,
      'settings': settings,
      'initialized': _isInitialized,
    };
  }

  /// Export analytics data for user review
  Future<Map<String, dynamic>> exportAnalyticsData() async => {
      'events': _eventQueue.map((e) => e.toJson()).toList(),
      'settings': await _privacyService.getAnalyticsSettings(),
      'stats': await getAnalyticsStats(),
    };

  // Private methods

  Future<bool> _hasAnalyticsConsent() async => _privacyService.hasAnalyticsConsent();

  Future<String> _getOrCreateAnonymousUserId() async {
    final storedId = _prefs.getString(_userIdKey);
    if (storedId != null) return storedId;

    final newId = _generateAnonymousUserId();
    await _prefs.setString(_userIdKey, newId);
    return newId;
  }

  String _generateAnonymousUserId() {
    // Generate a random anonymous ID (not linked to real identity)
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomNum = random.nextInt(999999);
    return 'anon_${timestamp}_$randomNum';
  }

  String _generateSessionId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomNum = random.nextInt(999999);
    return 'session_${timestamp}_$randomNum';
  }

  Map<String, dynamic> _sanitizeProperties(Map<String, dynamic> properties) {
    final sanitized = <String, dynamic>{};

    for (final entry in properties.entries) {
      final key = entry.key;
      final value = entry.value;

      // Skip potentially sensitive keys
      if (_isSensitiveKey(key)) continue;

      // Sanitize values
      if (value is String) {
        sanitized[key] = _sanitizeStringValue(value);
      } else if (value is num || value is bool) {
        sanitized[key] = value;
      } else if (value is List || value is Map) {
        // Skip complex objects for privacy
        continue;
      } else {
        sanitized[key] = value?.toString();
      }
    }

    return sanitized;
  }

  bool _isSensitiveKey(String key) {
    final sensitiveKeys = [
      'password',
      'token',
      'secret',
      'key',
      'auth',
      'credential',
      'wallet',
      'address',
      'private',
      'mnemonic',
      'seed',
      'email',
      'phone',
      'name',
      'id',
      'user_id',
      'discord_id',
      'username',
    ];

    final lowerKey = key.toLowerCase();
    return sensitiveKeys.any((sensitive) => lowerKey.contains(sensitive));
  }

  String _sanitizeStringValue(String value) {
    // Remove potentially sensitive information
    if (value.contains('@')) return '[email]';
    if (value.length > 100) return '[long_text]';
    if (RegExp('[0-9A-Za-z]{20,}').hasMatch(value)) return '[token_like]';

    return value;
  }

  String _sanitizeErrorMessage(String message) {
    // Remove sensitive information from error messages
    return message
        .replaceAll(RegExp('[0-9A-Za-z]{20,}'), '[redacted]')
        .replaceAll(
          RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'),
          '[email]',
        );
  }

  String _getPlatformInfo() {
    if (kDebugMode) {
      return 'debug';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.linux:
        return 'linux';
      case TargetPlatform.fuchsia:
        return 'fuchsia';
    }
  }

  Future<void> _saveEventQueue() async {
    final eventsJson = jsonEncode(_eventQueue.map((e) => e.toJson()).toList());
    await _prefs.setString(_eventQueueKey, eventsJson);
  }

  Future<void> _loadEventQueue() async {
    final eventsJson = _prefs.getString(_eventQueueKey);
    if (eventsJson == null) return;

    try {
      final eventsList = jsonDecode(eventsJson) as List;
      _eventQueue.clear();
      _eventQueue.addAll(
        eventsList.map(
          (json) => AnalyticsEvent.fromJson(json as Map<String, dynamic>),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to load analytics event queue: $e');
      }
      // Clear corrupted data
      await _prefs.remove(_eventQueueKey);
    }
  }
}

/// Privacy-safe analytics event model
class AnalyticsEvent {

  const AnalyticsEvent({
    required this.name,
    required this.properties,
    required this.timestamp,
    required this.sessionId,
    required this.userId,
    required this.platform,
    required this.appVersion,
  });

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) => AnalyticsEvent(
    name: json['name'] as String,
    properties: json['properties'] as Map<String, dynamic>,
    timestamp: DateTime.parse(json['timestamp'] as String),
    sessionId: json['sessionId'] as String,
    userId: json['userId'] as String,
    platform: json['platform'] as String,
    appVersion: json['appVersion'] as String,
  );
  final String name;
  final Map<String, dynamic> properties;
  final DateTime timestamp;
  final String sessionId;
  final String userId;
  final String platform;
  final String appVersion;

  Map<String, dynamic> toJson() => {
    'name': name,
    'properties': properties,
    'timestamp': timestamp.toIso8601String(),
    'sessionId': sessionId,
    'userId': userId,
    'platform': platform,
    'appVersion': appVersion,
  };
}
