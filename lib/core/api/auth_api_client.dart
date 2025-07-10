import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/api/auth_models.dart';
import '../models/api/user_models.dart';

part 'auth_api_client.g.dart';

/// Authentication API client
@RestApi()
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

  /// Connect wallet for authentication
  @POST('/auth/wallet/connect')
  Future<AuthResponse> connectWallet(@Body() WalletConnectRequest request);

  /// Discord OAuth authentication
  @POST('/auth/discord')
  Future<AuthResponse> authenticateWithDiscord(
    @Body() DiscordAuthRequest request,
  );

  /// Create guest session
  @POST('/auth/guest')
  Future<AuthResponse> createGuestSession(@Body() GuestSessionRequest request);

  /// Refresh authentication token
  @POST('/auth/refresh')
  Future<AuthResponse> refreshToken(@Body() RefreshTokenRequest request);

  /// Logout user
  @POST('/auth/logout')
  Future<void> logout();

  /// Get current user profile
  @GET('/auth/profile')
  Future<UserProfile> getCurrentUser();

  /// Update user profile
  @PUT('/auth/profile')
  Future<UserProfile> updateProfile(@Body() UpdateProfileRequest request);

  /// Verify wallet ownership
  @POST('/auth/wallet/verify')
  Future<WalletVerificationResponse> verifyWallet(
    @Body() WalletVerificationRequest request,
  );
}
