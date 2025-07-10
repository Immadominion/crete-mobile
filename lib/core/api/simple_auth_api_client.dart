import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/api/simple_auth_models.dart';

part 'simple_auth_api_client.g.dart';

@RestApi()
abstract class SimpleAuthApiClient {
  factory SimpleAuthApiClient(Dio dio, {String baseUrl}) = _SimpleAuthApiClient;

  @POST('/auth/login')
  Future<AuthResponse> login(@Body() LoginRequest request);

  @POST('/auth/refresh')
  Future<AuthResponse> refreshToken(@Body() RefreshTokenRequest request);

  @POST('/auth/logout')
  Future<void> logout();
}
