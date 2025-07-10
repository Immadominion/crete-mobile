import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../config/app_config.dart';
import '../utils/deep_link_utils.dart';
import 'navigation_service.dart';
import 'privacy_analytics_service.dart';

/// Production-ready deep link service
/// Handles universal links, custom URL schemes, and link validation
@singleton
class DeepLinkService {

  DeepLinkService(
    this._navigationService,
    this._analyticsService,
  );
  final NavigationService _navigationService;
  final PrivacyAnalyticsService _analyticsService;
  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? _linkSubscription;
  bool _isInitialized = false;

  /// Initialize deep link service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Listen for incoming links when app is already running
      _linkSubscription = _appLinks.uriLinkStream.listen(
        _handleIncomingLink,
        onError: _handleLinkError,
      );

      // Handle the initial link if app was opened from a deep link
      await _handleInitialLink();

      _isInitialized = true;

      if (kDebugMode && AppConfig.enableDebugLogs) {
        debugPrint('🔗 Deep Link Service initialized');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Deep Link Service initialization failed: $e');
      }
      throw DeepLinkException('Failed to initialize deep link service: $e');
    }
  }

  /// Handle initial link when app is opened from deep link
  Future<void> _handleInitialLink() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        if (kDebugMode && AppConfig.enableDebugLogs) {
          debugPrint('🔗 Initial deep link: $initialUri');
        }
        await _handleIncomingLink(initialUri);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to handle initial link: $e');
      }
    }
  }

  /// Handle incoming deep link
  Future<void> _handleIncomingLink(Uri uri) async {
    try {
      if (kDebugMode && AppConfig.enableDebugLogs) {
        debugPrint('🔗 Incoming deep link: $uri');
      }

      // Validate the link
      if (!_validateLink(uri)) {
        if (kDebugMode) {
          debugPrint('❌ Invalid deep link: $uri');
        }
        _trackLinkEvent('invalid_link', uri.toString());
        return;
      }

      // Parse the deep link
      final deepLinkData = DeepLinkUtils.parseDeepLink(uri.toString());
      if (deepLinkData == null) {
        if (kDebugMode) {
          debugPrint('❌ Failed to parse deep link: $uri');
        }
        _trackLinkEvent('parse_failed', uri.toString());
        return;
      }

      // Track successful link parsing
      _trackLinkEvent('link_handled', uri.toString(), data: {
        'type': deepLinkData.type.toString(),
        'dao_id': deepLinkData.daoId ?? '',
        'proposal_id': deepLinkData.proposalId ?? '',
        'room_id': deepLinkData.roomId ?? '',
        'user_id': deepLinkData.userId ?? '',
        'invite_code': deepLinkData.inviteCode ?? '',
      });

      // Navigate based on deep link type
      await _navigateFromDeepLink(deepLinkData);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error handling deep link: $e');
      }
      _trackLinkEvent('handling_error', uri.toString(), error: e.toString());
    }
  }

  /// Validate incoming deep link
  bool _validateLink(Uri uri) {
    // Check if it's a valid Crete deep link
    if (!DeepLinkUtils.isValidDeepLink(uri.toString())) {
      return false;
    }

    // Additional security checks
    if (!_checkLinkSecurity(uri)) {
      return false;
    }

    // Check for malicious parameters
    if (!_validateParameters(uri.queryParameters)) {
      return false;
    }

    return true;
  }

  /// Check link security
  bool _checkLinkSecurity(Uri uri) {
    // Check for suspicious patterns
    final suspiciousPatterns = [
      'javascript:',
      'data:',
      'vbscript:',
      'onload=',
      'onclick=',
      '<script',
      'eval(',
    ];

    final fullUrl = uri.toString().toLowerCase();
    
    for (final pattern in suspiciousPatterns) {
      if (fullUrl.contains(pattern)) {
        if (kDebugMode) {
          debugPrint('🚨 Suspicious pattern detected in deep link: $pattern');
        }
        return false;
      }
    }

    // Check URL length (prevent DoS attacks)
    if (fullUrl.length > 2048) {
      if (kDebugMode) {
        debugPrint('🚨 Deep link too long: ${fullUrl.length} characters');
      }
      return false;
    }

    return true;
  }

  /// Validate URL parameters
  bool _validateParameters(Map<String, String> params) {
    // Check parameter values for suspicious content
    for (final entry in params.entries) {
      final key = entry.key.toLowerCase();
      final value = entry.value.toLowerCase();

      // Check for XSS attempts
      if (value.contains('<script') || 
          value.contains('javascript:') ||
          value.contains('data:') ||
          value.contains('vbscript:')) {
        if (kDebugMode) {
          debugPrint('🚨 Suspicious parameter detected: $key=$value');
        }
        return false;
      }

      // Check parameter length
      if (key.length > 100 || value.length > 1000) {
        if (kDebugMode) {
          debugPrint('🚨 Parameter too long: $key (${value.length} chars)');
        }
        return false;
      }
    }

    return true;
  }

  /// Navigate based on deep link data
  Future<void> _navigateFromDeepLink(DeepLinkData data) async {
    switch (data.type) {
      case DeepLinkType.home:
        _navigationService.goHome();
        break;

      case DeepLinkType.daoList:
        _navigationService.goToDaos();
        break;

      case DeepLinkType.daoDetail:
        if (data.daoId != null) {
          _navigationService.goToDao(data.daoId!);
        }
        break;

      case DeepLinkType.daoJoin:
        if (data.daoId != null) {
          _navigationService.goToDaoJoin(data.daoId!);
        }
        break;

      case DeepLinkType.daoMembers:
        if (data.daoId != null) {
          _navigationService.goToNamed(
            'dao-members',
            pathParameters: {'daoId': data.daoId!},
          );
        }
        break;

      case DeepLinkType.daoSettings:
        if (data.daoId != null) {
          _navigationService.goToNamed(
            'dao-settings',
            pathParameters: {'daoId': data.daoId!},
          );
        }
        break;

      case DeepLinkType.proposal:
        if (data.daoId != null && data.proposalId != null) {
          _navigationService.goToProposal(data.daoId!, data.proposalId!);
        }
        break;

      case DeepLinkType.chatRoom:
        if (data.daoId != null && data.roomId != null) {
          _navigationService.goToChatRoom(data.daoId!, data.roomId!);
        }
        break;

      case DeepLinkType.profile:
        _navigationService.goToProfile();
        break;

      case DeepLinkType.userProfile:
        if (data.userId != null) {
          _navigationService.goToProfile(data.userId);
        }
        break;

      case DeepLinkType.wallet:
        _navigationService.goToWallet();
        break;

      case DeepLinkType.walletConnect:
        _navigationService.goToWalletConnect();
        break;

      case DeepLinkType.invite:
        if (data.inviteCode != null) {
          _navigationService.goToInvite(data.inviteCode!);
        }
        break;

      case DeepLinkType.unknown:
      default:
        if (kDebugMode) {
          debugPrint('❌ Unknown deep link type: ${data.type}');
        }
        _navigationService.goHome();
        break;
    }
  }

  /// Handle link errors
  void _handleLinkError(Object error) {
    if (kDebugMode) {
      debugPrint('❌ Deep link error: $error');
    }
    
    _trackLinkEvent('link_error', '', error: error.toString());
  }

  /// Generate a shareable deep link
  String generateShareableLink(DeepLinkType type, {
    String? daoId,
    String? proposalId,
    String? roomId,
    String? userId,
    String? inviteCode,
    Map<String, String>? queryParams,
  }) {
    String link;

    switch (type) {
      case DeepLinkType.daoJoin:
        link = DeepLinkUtils.generateDaoJoinLink(daoId!);
        break;
      case DeepLinkType.proposal:
        link = DeepLinkUtils.generateProposalLink(daoId!, proposalId!);
        break;
      case DeepLinkType.chatRoom:
        link = DeepLinkUtils.generateChatRoomLink(daoId!, roomId!);
        break;
      case DeepLinkType.userProfile:
        link = DeepLinkUtils.generateProfileLink(userId!);
        break;
      case DeepLinkType.walletConnect:
        link = DeepLinkUtils.generateWalletConnectLink();
        break;
      default:
        link = DeepLinkUtils.generateUniversalLink('');
        break;
    }

    // Add query parameters if provided
    if (queryParams != null && queryParams.isNotEmpty) {
      link = DeepLinkUtils.buildUrlWithParams(link, queryParams);
    }

    return link;
  }

  /// Generate universal link for sharing
  String generateUniversalLink(String path, {Map<String, String>? queryParams}) {
    String link = DeepLinkUtils.generateUniversalLink(path);
    
    if (queryParams != null && queryParams.isNotEmpty) {
      link = DeepLinkUtils.buildUrlWithParams(link, queryParams);
    }
    
    return link;
  }

  /// Check if a URL can be handled by the app
  bool canHandleUrl(String url) => DeepLinkUtils.isValidDeepLink(url);

  /// Track deep link events for analytics
  void _trackLinkEvent(
    String event,
    String url, {
    Map<String, String>? data,
    String? error,
  }) {
    try {
      final eventData = <String, dynamic>{
        'url': url,
        'timestamp': DateTime.now().toIso8601String(),
        if (data != null) ...data,
        if (error != null) 'error': error,
      };

      _analyticsService.trackEvent('deep_link_$event', properties: eventData);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to track deep link event: $e');
      }
    }
  }

  /// Public method to log deep link events
  void logDeepLinkEvent(
    String event,
    String url, {
    Map<String, dynamic>? metadata,
    String? error,
  }) {
    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('🔗 Deep Link Event: $event - $url');
      if (metadata != null && metadata.isNotEmpty) {
        debugPrint('🔗 Metadata: $metadata');
      }
      if (error != null) {
        debugPrint('🔗 Error: $error');
      }
    }

    try {
      final eventData = <String, dynamic>{
        'url': url,
        'timestamp': DateTime.now().toIso8601String(),
        if (metadata != null) ...metadata,
        if (error != null) 'error': error,
      };

      _analyticsService.trackEvent('deep_link_$event', properties: eventData);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to log deep link event: $e');
      }
    }
  }

  /// Dispose resources
  void dispose() {
    _linkSubscription?.cancel();
    _isInitialized = false;
    
    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('🔗 Deep Link Service disposed');
    }
  }
}

/// Custom exception for deep link errors
class DeepLinkException implements Exception {

  const DeepLinkException(this.message, {this.code, this.details});
  final String message;
  final String? code;
  final dynamic details;

  @override
  String toString() => 'DeepLinkException: $message';
}
