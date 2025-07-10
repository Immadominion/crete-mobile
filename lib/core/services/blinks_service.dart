import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../config/app_config.dart';

/// Blink action type
enum BlinkActionType { transfer, vote, stake, swap, custom }

/// Blink metadata
class BlinkMetadata {

  const BlinkMetadata({
    required this.title,
    required this.description,
    this.icon,
    this.image,
    this.additionalData,
  });

  factory BlinkMetadata.fromJson(Map<String, dynamic> json) => BlinkMetadata(
    title: json['title'] as String,
    description: json['description'] as String,
    icon: json['icon'] as String?,
    image: json['image'] as String?,
    additionalData: json['additionalData'] as Map<String, dynamic>?,
  );
  final String title;
  final String description;
  final String? icon;
  final String? image;
  final Map<String, dynamic>? additionalData;

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    if (icon != null) 'icon': icon,
    if (image != null) 'image': image,
    if (additionalData != null) 'additionalData': additionalData,
  };
}

/// Blink action parameters
class BlinkActionParams {

  const BlinkActionParams({
    required this.type,
    required this.actionUrl,
    required this.parameters,
    required this.metadata,
  });

  factory BlinkActionParams.fromJson(Map<String, dynamic> json) =>
      BlinkActionParams(
        type: BlinkActionType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => BlinkActionType.custom,
        ),
        actionUrl: json['actionUrl'] as String,
        parameters: json['parameters'] as Map<String, dynamic>,
        metadata: BlinkMetadata.fromJson(
          json['metadata'] as Map<String, dynamic>,
        ),
      );
  final BlinkActionType type;
  final String actionUrl;
  final Map<String, dynamic> parameters;
  final BlinkMetadata metadata;

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'actionUrl': actionUrl,
    'parameters': parameters,
    'metadata': metadata.toJson(),
  };
}

/// Blink execution result
class BlinkResult {

  const BlinkResult({
    required this.success,
    this.transactionSignature,
    this.errorMessage,
    this.additionalData,
  });

  factory BlinkResult.success({
    required String transactionSignature,
    Map<String, dynamic>? additionalData,
  }) => BlinkResult(
    success: true,
    transactionSignature: transactionSignature,
    additionalData: additionalData,
  );

  factory BlinkResult.error({
    required String errorMessage,
    Map<String, dynamic>? additionalData,
  }) => BlinkResult(
    success: false,
    errorMessage: errorMessage,
    additionalData: additionalData,
  );
  final bool success;
  final String? transactionSignature;
  final String? errorMessage;
  final Map<String, dynamic>? additionalData;
}

/// Service for handling Solana Blinks (blockchain links) integration
@singleton
class BlinksService {
  late http.Client _httpClient;
  late String _blinksApiUrl;

  bool _isInitialized = false;

  /// Initialize the Blinks service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _httpClient = http.Client();
      _blinksApiUrl = AppConfig.blinksApiUrl;

      _isInitialized = true;

      if (kDebugMode && AppConfig.enableDebugLogs) {
        debugPrint('🔗 Blinks Service initialized');
        debugPrint('API URL: $_blinksApiUrl');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to initialize Blinks Service: $e');
      }
      rethrow;
    }
  }

  /// Parse a Blink URL and extract action parameters
  Future<BlinkActionParams?> parseBlink(String blinkUrl) async {
    _ensureInitialized();

    try {
      // Validate URL format
      final uri = Uri.tryParse(blinkUrl);
      if (uri == null) {
        if (kDebugMode) {
          debugPrint('❌ Invalid Blink URL: $blinkUrl');
        }
        return null;
      }

      // Check if it's a valid Blink URL (should start with known protocols)
      if (!_isValidBlinkUrl(uri)) {
        if (kDebugMode) {
          debugPrint('❌ Not a valid Blink URL: $blinkUrl');
        }
        return null;
      }

      // Fetch Blink metadata from the URL
      final response = await _httpClient
          .get(
            Uri.parse('$_blinksApiUrl/parse'),
            headers: {
              'Content-Type': 'application/json',
              'X-App-Version': AppConfig.appVersion,
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        if (kDebugMode) {
          debugPrint('❌ Failed to parse Blink: ${response.statusCode}');
        }
        return null;
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      return BlinkActionParams.fromJson(data);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error parsing Blink URL: $e');
      }
      return null;
    }
  }

  /// Validate if URL is a proper Blink URL
  bool _isValidBlinkUrl(Uri uri) {
    // Check for known Blink patterns
    return uri.scheme == 'https' &&
        (uri.host.contains('dial.to') ||
            uri.host.contains('blinks.') ||
            uri.path.contains('/blink/') ||
            uri.queryParameters.containsKey('action'));
  }

  /// Execute a Blink action
  Future<BlinkResult> executeBlink({
    required BlinkActionParams params,
    required String walletPublicKey,
    Map<String, dynamic>? userInputs,
  }) async {
    _ensureInitialized();

    try {
      // Prepare execution request
      final requestBody = {
        'actionUrl': params.actionUrl,
        'actionType': params.type.name,
        'parameters': {
          ...params.parameters,
          if (userInputs != null) ...userInputs,
        },
        'walletPublicKey': walletPublicKey,
        'metadata': params.metadata.toJson(),
      };

      // Execute the Blink action
      final response = await _httpClient
          .post(
            Uri.parse('$_blinksApiUrl/execute'),
            headers: {
              'Content-Type': 'application/json',
              'X-App-Version': AppConfig.appVersion,
              'X-Wallet-PublicKey': walletPublicKey,
            },
            body: json.encode(requestBody),
          )
          .timeout(const Duration(seconds: 30));

      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        // Success response
        return BlinkResult.success(
          transactionSignature: responseData['transactionSignature'] as String,
          additionalData:
              responseData['additionalData'] as Map<String, dynamic>?,
        );
      } else {
        // Error response
        return BlinkResult.error(
          errorMessage:
              responseData['error'] as String? ?? 'Unknown error occurred',
          additionalData:
              responseData['additionalData'] as Map<String, dynamic>?,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error executing Blink: $e');
      }

      return BlinkResult.error(errorMessage: 'Failed to execute Blink: $e');
    }
  }

  /// Preview a Blink action (get transaction details without executing)
  Future<Map<String, dynamic>?> previewBlink({
    required BlinkActionParams params,
    required String walletPublicKey,
    Map<String, dynamic>? userInputs,
  }) async {
    _ensureInitialized();

    try {
      final requestBody = {
        'actionUrl': params.actionUrl,
        'actionType': params.type.name,
        'parameters': {
          ...params.parameters,
          if (userInputs != null) ...userInputs,
        },
        'walletPublicKey': walletPublicKey,
        'preview': true,
      };

      final response = await _httpClient
          .post(
            Uri.parse('$_blinksApiUrl/preview'),
            headers: {
              'Content-Type': 'application/json',
              'X-App-Version': AppConfig.appVersion,
              'X-Wallet-PublicKey': walletPublicKey,
            },
            body: json.encode(requestBody),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        if (kDebugMode) {
          debugPrint('❌ Failed to preview Blink: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error previewing Blink: $e');
      }
      return null;
    }
  }

  /// Get popular/trending Blinks
  Future<List<BlinkActionParams>> getTrendingBlinks({
    int limit = 10,
    String? category,
  }) async {
    _ensureInitialized();

    try {
      final queryParams = {
        'limit': limit.toString(),
        if (category != null) 'category': category,
      };

      final uri = Uri.parse(
        '$_blinksApiUrl/trending',
      ).replace(queryParameters: queryParams);

      final response = await _httpClient
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'X-App-Version': AppConfig.appVersion,
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final blinks = data['blinks'] as List<dynamic>;

        return blinks
            .map(
              (blink) =>
                  BlinkActionParams.fromJson(blink as Map<String, dynamic>),
            )
            .toList();
      } else {
        if (kDebugMode) {
          debugPrint('❌ Failed to get trending Blinks: ${response.statusCode}');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting trending Blinks: $e');
      }
      return [];
    }
  }

  /// Validate Blink action parameters
  bool validateBlinkParams(BlinkActionParams params) {
    try {
      // Basic validation
      if (params.actionUrl.isEmpty) return false;
      if (params.metadata.title.isEmpty) return false;
      if (params.metadata.description.isEmpty) return false;

      // URL validation
      final uri = Uri.tryParse(params.actionUrl);
      if (uri == null || !uri.hasScheme) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if service is initialized
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError('BlinksService must be initialized before use');
    }
  }

  // Getters
  bool get isInitialized => _isInitialized;
  String get blinksApiUrl => _blinksApiUrl;

  /// Dispose resources
  void dispose() {
    _httpClient.close();
    _isInitialized = false;
  }
}
