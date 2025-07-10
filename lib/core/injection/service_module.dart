import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/auth_api_client.dart';
import '../api/dao_api_client.dart';
import '../api/proposal_api_client.dart';
import '../config/app_config.dart';
import '../services/http_client_service.dart';

@module
abstract class ServiceModule {
  /// SharedPreferences instance
  @preResolve
  @singleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  /// HTTP client with base configuration
  /// Note: HttpClientService is now used as @singleton and provides the Dio client
  /// This basic Dio instance is kept for backward compatibility but should be replaced
  @singleton
  Dio get dio {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    if (AppConfig.enableNetworkLogging) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          logPrint: (o) => print('[HTTP] $o'),
        ),
      );
    }

    return dio;
  }

  /// Connectivity checker
  @singleton
  Connectivity get connectivity => Connectivity();

  /// API clients
  @singleton
  AuthApiClient authApiClient(HttpClientService httpClientService) =>
      AuthApiClient(httpClientService.client, baseUrl: AppConfig.apiBaseUrl);

  @singleton
  DaoApiClient daoApiClient(HttpClientService httpClientService) =>
      DaoApiClient(httpClientService.client, baseUrl: AppConfig.apiBaseUrl);

  @singleton
  ProposalApiClient proposalApiClient(HttpClientService httpClientService) =>
      ProposalApiClient(
        httpClientService.client,
        baseUrl: AppConfig.apiBaseUrl,
      );
}
