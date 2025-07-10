import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../constants/storage_keys.dart';
import '../error/exceptions.dart';
import 'certificate_pinning_service.dart';

/// Production-grade HTTP client service with comprehensive features
@singleton
class HttpClientService {

  HttpClientService(this._prefs, this._certificatePinning) {
    _initializeClient();
  }
  static const String _baseUrl = 'base_url';
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 2);

  late Dio _dio;
  final SharedPreferences _prefs;
  final CertificatePinningService _certificatePinning;
  Timer? _tokenRefreshTimer;

  Dio get client => _dio;

  void _initializeClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent':
              'Crete/${AppConfig.appVersion} (${Platform.operatingSystem})',
        },
      ),
    );

    // Configure certificate pinning
    _setupCertificatePinning();

    _setupInterceptors();
  }

  void _setupCertificatePinning() {
    // Set up certificate pinning for production
    if (AppConfig.isProduction) {
      (_dio.httpClientAdapter as IOHttpClientAdapter)
          .onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => _certificatePinning.validateCertificateChain([cert], host);
        return client;
      };
    }
  }

  void _setupInterceptors() {
    // Request interceptor - Add authentication and common headers
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add authentication token
          final token = _prefs.getString(StorageKeys.accessToken);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Add device/app info headers
          options.headers['X-App-Version'] = AppConfig.appVersion;
          options.headers['X-App-Environment'] = AppConfig.appEnvironment;
          options.headers['X-Platform'] = Platform.operatingSystem;

          // Add request ID for tracing
          options.headers['X-Request-ID'] = _generateRequestId();

          if (kDebugMode && AppConfig.enableNetworkLogging) {
            debugPrint('🌐 [REQUEST] ${options.method} ${options.uri}');
            debugPrint('Headers: ${options.headers}');
            if (options.data != null) {
              debugPrint('Body: ${options.data}');
            }
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode && AppConfig.enableNetworkLogging) {
            debugPrint(
              '✅ [RESPONSE] ${response.statusCode} ${response.requestOptions.uri}',
            );
            debugPrint('Data: ${response.data}');
          }
          handler.next(response);
        },
        onError: (error, handler) async {
          if (kDebugMode) {
            debugPrint(
              '❌ [ERROR] ${error.requestOptions.method} ${error.requestOptions.uri}',
            );
            debugPrint('Status: ${error.response?.statusCode}');
            debugPrint('Message: ${error.message}');
          }

          // Handle token refresh for 401 errors
          if (error.response?.statusCode == 401) {
            final refreshed = await _handleTokenRefresh(error.requestOptions);
            if (refreshed) {
              handler.resolve(await _dio.fetch(error.requestOptions));
              return;
            }
          }

          handler.next(error);
        },
      ),
    );

    // Retry interceptor for network failures
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (_shouldRetry(error)) {
            final retryCount =
                (error.requestOptions.extra['retryCount'] as int?) ?? 0;
            if (retryCount < _maxRetries) {
              error.requestOptions.extra['retryCount'] = retryCount + 1;

              await Future<void>.delayed(_retryDelay * (retryCount + 1));

              if (kDebugMode) {
                debugPrint(
                  '🔄 Retrying request (${retryCount + 1}/$_maxRetries)',
                );
              }

              try {
                final response = await _dio.fetch<dynamic>(
                  error.requestOptions,
                );
                handler.resolve(response);
                return;
              } catch (e) {
                // If retry fails, continue with original error
              }
            }
          }

          handler.next(error);
        },
      ),
    );

    // Certificate pinning for production
    if (AppConfig.isProduction) {
      _dio.interceptors.add(_createCertificatePinningInterceptor());
    }

    // Rate limiting interceptor
    _dio.interceptors.add(_createRateLimitInterceptor());
  }

  /// Handle automatic token refresh
  Future<bool> _handleTokenRefresh(RequestOptions originalRequest) async {
    try {
      final refreshToken = _prefs.getString(StorageKeys.refreshToken);
      if (refreshToken == null) {
        _clearAuthData();
        return false;
      }

      // Create a separate Dio instance for token refresh to avoid infinite loops
      final refreshDio = Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));

      final response = await refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        final newToken = response.data!['accessToken'] as String;
        final newRefreshToken = response.data!['refreshToken'] as String;

        await _prefs.setString(StorageKeys.accessToken, newToken);
        await _prefs.setString(StorageKeys.refreshToken, newRefreshToken);

        // Update the original request with new token
        originalRequest.headers['Authorization'] = 'Bearer $newToken';

        if (kDebugMode) {
          debugPrint('🔑 Token refreshed successfully');
        }

        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Token refresh failed: $e');
      }
    }

    _clearAuthData();
    return false;
  }

  /// Clear authentication data on failure
  void _clearAuthData() {
    _prefs.remove(StorageKeys.accessToken);
    _prefs.remove(StorageKeys.refreshToken);
    _tokenRefreshTimer?.cancel();
  }

  /// Check if request should be retried
  bool _shouldRetry(DioException error) {
    // Retry on network errors, timeouts, and 5xx server errors
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError ||
        (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500);
  }

  /// Generate unique request ID for tracing
  String _generateRequestId() => DateTime.now().millisecondsSinceEpoch.toString() +
        (DateTime.now().microsecond % 1000).toString().padLeft(3, '0');

  /// Certificate pinning interceptor for production security
  Interceptor _createCertificatePinningInterceptor() => InterceptorsWrapper(
      onRequest: (options, handler) {
        // TODO: Implement certificate pinning
        // This would verify the server certificate against known good certificates
        handler.next(options);
      },
    );

  /// Rate limiting interceptor to prevent API abuse
  Interceptor _createRateLimitInterceptor() {
    final requestTimes = <int>[];
    const maxRequestsPerMinute = 60;

    return InterceptorsWrapper(
      onRequest: (options, handler) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final oneMinuteAgo = now - 60000;

        // Remove old requests
        requestTimes.removeWhere((time) => time < oneMinuteAgo);

        // Check rate limit
        if (requestTimes.length >= maxRequestsPerMinute) {
          handler.reject(
            DioException(
              requestOptions: options,
              error: 'Rate limit exceeded',
            ),
          );
          return;
        }

        requestTimes.add(now);
        handler.next(options);
      },
    );
  }

  /// Set authentication token
  Future<void> setAuthToken(String token, String refreshToken) async {
    await _prefs.setString(StorageKeys.accessToken, token);
    await _prefs.setString(StorageKeys.refreshToken, refreshToken);

    // Setup automatic token refresh timer
    _setupTokenRefreshTimer();
  }

  /// Setup automatic token refresh
  void _setupTokenRefreshTimer() {
    _tokenRefreshTimer?.cancel();

    // Refresh token every 45 minutes (assuming 1-hour token expiry)
    _tokenRefreshTimer = Timer.periodic(
      const Duration(minutes: 45),
      (_) => _handleTokenRefresh(RequestOptions()),
    );
  }

  /// Clear authentication
  Future<void> clearAuth() async {
    _clearAuthData();
  }

  /// Update base URL (useful for environment switching)
  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
    _prefs.setString(_baseUrl, newBaseUrl);
  }

  /// Get current authentication status
  bool get isAuthenticated => _prefs.getString(StorageKeys.accessToken) != null;

  /// Handle different types of API errors
  Exception handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException('Request timeout');

      case DioExceptionType.connectionError:
        return const NetworkException('Network connection failed');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message =
            error.response?.data?['message'] as String? ?? 'Server error';

        switch (statusCode) {
          case 400:
            return ValidationException(message);
          case 401:
            return const UnauthorizedException();
          case 403:
            return ForbiddenException(message);
          case 404:
            return NotFoundException(message);
          case 409:
            return ConflictException(message);
          case 500:
          case 502:
          case 503:
            return ServerException(message, statusCode: statusCode);
          default:
            return ApiException(message, statusCode: statusCode);
        }

      default:
        return NetworkException(error.message ?? 'Unknown network error');
    }
  }

  /// Dispose resources
  void dispose() {
    _tokenRefreshTimer?.cancel();
    _dio.close();
  }
}
