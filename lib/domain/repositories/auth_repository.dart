import '../../core/models/api/auth_models.dart';
import '../../core/models/api/user_models.dart';

/// Repository interface for authentication operations
abstract class IAuthRepository {
  /// Authenticate user with wallet
  Future<AuthResponse> authenticateWithWallet({
    required String walletAddress,
    required String signature,
    required String message,
    required String walletType,
  });

  /// Authenticate user with Discord
  Future<AuthResponse> authenticateWithDiscord({
    required String code,
    required String redirectUri,
  });

  /// Create guest session
  Future<AuthResponse> createGuestSession({
    required String deviceId,
    Map<String, dynamic>? metadata,
  });

  /// Refresh access token
  Future<AuthResponse> refreshToken({required String refreshToken});

  /// Verify wallet signature
  Future<WalletVerificationResponse> verifyWallet({
    required String walletAddress,
    required String signature,
    required String message,
    required String challenge,
  });

  /// Get current user profile
  Future<UserProfile?> getCurrentUser();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Sign out user
  Future<void> signOut();

  /// Get stored access token
  Future<String?> getAccessToken();

  /// Get stored refresh token
  Future<String?> getRefreshToken();
}
