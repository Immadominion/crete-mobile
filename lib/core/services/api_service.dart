import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../api/auth_api_client.dart';
import '../api/dao_api_client.dart';
import '../api/proposal_api_client.dart';
import './http_client_service.dart';

/// Unified API service that provides access to all API clients
@singleton
class ApiService {

  ApiService(this._httpClientService) {
    _initializeClients();
  }
  final HttpClientService _httpClientService;

  late final AuthApiClient _authClient;
  late final DaoApiClient _daoClient;
  late final ProposalApiClient _proposalClient;

  void _initializeClients() {
    final dio = _httpClientService.client;

    _authClient = AuthApiClient(dio);
    _daoClient = DaoApiClient(dio);
    _proposalClient = ProposalApiClient(dio);
  }

  // Getters for API clients
  AuthApiClient get auth => _authClient;
  DaoApiClient get dao => _daoClient;
  ProposalApiClient get proposal => _proposalClient;

  /// Get the underlying HTTP client for custom requests
  Dio get httpClient => _httpClientService.client;

  /// Handle API errors with proper exception mapping
  Future<T> handleApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on DioException catch (e) {
      throw _httpClientService.handleDioError(e);
    }
  }

  /// Handle async API calls with proper exception mapping
  Future<T> handleAsyncApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on DioException catch (e) {
      throw _httpClientService.handleDioError(e);
    }
  }

  /// Update authentication token for all clients
  Future<void> setAuthToken(String token, String refreshToken) async {
    await _httpClientService.setAuthToken(token, refreshToken);
    // Reinitialize clients to pick up new auth token
    _initializeClients();
  }

  /// Clear authentication for all clients
  Future<void> clearAuth() async {
    await _httpClientService.clearAuth();
    // Reinitialize clients to clear auth token
    _initializeClients();
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _httpClientService.isAuthenticated;

  /// Update base URL for environment switching
  void updateBaseUrl(String newBaseUrl) {
    _httpClientService.updateBaseUrl(newBaseUrl);
    _initializeClients();
  }
}
