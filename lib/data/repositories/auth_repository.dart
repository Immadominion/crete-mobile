import '../../core/models/api/auth_models.dart';
import '../../core/models/api/user_models.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/local_data_source.dart';
import '../data_sources/remote_data_source.dart';

/// Concrete implementation of AuthRepository
class AuthRepository implements IAuthRepository {

  AuthRepository(this._remoteDataSource, this._localDataSource);
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  @override
  Future<AuthResponse> authenticateWithWallet({
    required String walletAddress,
    required String signature,
    required String message,
    required String walletType,
  }) async {
    final response = await _remoteDataSource.authenticateWithWallet(
      walletAddress: walletAddress,
      signature: signature,
      message: message,
      walletType: walletType,
    );

    // Store tokens locally
    await _localDataSource.storeAuthData(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      userId: response.userId,
    );

    return response;
  }

  @override
  Future<AuthResponse> authenticateWithDiscord({
    required String code,
    required String redirectUri,
  }) async {
    final response = await _remoteDataSource.authenticateWithDiscord(
      code: code,
      redirectUri: redirectUri,
    );

    // Store tokens locally
    await _localDataSource.storeAuthData(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      userId: response.userId,
    );

    return response;
  }

  @override
  Future<AuthResponse> createGuestSession({
    required String deviceId,
    Map<String, dynamic>? metadata,
  }) async {
    final response = await _remoteDataSource.createGuestSession(
      deviceId: deviceId,
      metadata: metadata,
    );

    // Store tokens locally
    await _localDataSource.storeAuthData(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      userId: response.userId,
    );

    return response;
  }

  @override
  Future<AuthResponse> refreshToken({required String refreshToken}) async {
    final response = await _remoteDataSource.refreshToken(
      refreshToken: refreshToken,
    );

    // Update stored tokens
    await _localDataSource.storeAuthData(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      userId: response.userId,
    );

    return response;
  }

  @override
  Future<WalletVerificationResponse> verifyWallet({
    required String walletAddress,
    required String signature,
    required String message,
    required String challenge,
  }) async => _remoteDataSource.verifyWallet(
      walletAddress: walletAddress,
      signature: signature,
      message: message,
      challenge: challenge,
    );

  @override
  Future<UserProfile?> getCurrentUser() async {
    final userId = await _localDataSource.getUserId();
    if (userId == null) return null;

    try {
      // Try to get from cache first
      final cachedProfile = await _localDataSource.getCachedUserProfile(userId);
      if (cachedProfile != null) return cachedProfile;

      // Fetch from remote
      final profile = await _remoteDataSource.getUserProfile();

      // Cache the result
      await _localDataSource.cacheUserProfile(profile);

      return profile;
    } catch (e) {
      // Return cached profile if remote fails
      return _localDataSource.getCachedUserProfile(userId);
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _localDataSource.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> signOut() async {
    await _localDataSource.clearAuthData();
  }

  @override
  Future<String?> getAccessToken() async => _localDataSource.getAccessToken();

  @override
  Future<String?> getRefreshToken() async => _localDataSource.getRefreshToken();
}
