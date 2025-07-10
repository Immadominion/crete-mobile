import '../../core/models/api/auth_models.dart';
import '../../core/models/api/dao_models.dart';
import '../../core/models/api/proposal_models.dart';
import '../../core/models/api/user_models.dart';
import '../../core/services/api_service.dart';

/// Remote data source for API operations
class RemoteDataSource {

  RemoteDataSource(this._apiService);
  final ApiService _apiService;

  /// Authentication operations
  Future<AuthResponse> authenticateWithWallet({
    required String walletAddress,
    required String signature,
    required String message,
    required String walletType,
  }) async => _apiService.handleApiCall(() async {
      final request = WalletConnectRequest(
        walletAddress: walletAddress,
        signature: signature,
        message: message,
        walletType: walletType,
      );
      return _apiService.auth.connectWallet(request);
    });

  Future<AuthResponse> authenticateWithDiscord({
    required String code,
    required String redirectUri,
  }) async => _apiService.handleApiCall(() async {
      final request = DiscordAuthRequest(code: code, redirectUri: redirectUri);
      return _apiService.auth.authenticateWithDiscord(request);
    });

  Future<AuthResponse> createGuestSession({
    required String deviceId,
    Map<String, dynamic>? metadata,
  }) async => _apiService.handleApiCall(() async {
      final request = GuestSessionRequest(
        deviceId: deviceId,
        metadata: metadata,
      );
      return _apiService.auth.createGuestSession(request);
    });

  Future<AuthResponse> refreshToken({required String refreshToken}) async => _apiService.handleApiCall(() async {
      final request = RefreshTokenRequest(refreshToken: refreshToken);
      return _apiService.auth.refreshToken(request);
    });

  Future<WalletVerificationResponse> verifyWallet({
    required String walletAddress,
    required String signature,
    required String message,
    required String challenge,
  }) async => _apiService.handleApiCall(() async {
      final request = WalletVerificationRequest(
        walletAddress: walletAddress,
        signature: signature,
        message: message,
        challenge: challenge,
      );
      return _apiService.auth.verifyWallet(request);
    });

  /// User operations
  Future<UserProfile> getUserProfile() async => _apiService.handleApiCall(() async => _apiService.auth.getCurrentUser());

  Future<UserProfile> updateUserProfile({
    String? username,
    String? email,
    String? avatarUrl,
    Map<String, dynamic>? metadata,
  }) async => _apiService.handleApiCall(() async {
      final request = UpdateProfileRequest(
        username: username,
        email: email,
        avatarUrl: avatarUrl,
        metadata: metadata,
      );
      return _apiService.auth.updateProfile(request);
    });

  /// DAO operations
  Future<List<DaoInfo>> getMyDaos() async => _apiService.handleApiCall(() async => _apiService.dao.getUserDaos());

  Future<List<DaoInfo>> getPublicDaos({
    int page = 1,
    int limit = 20,
    String? search,
  }) async => _apiService.handleApiCall(() async => _apiService.dao.getPublicDaos(page, limit, search));

  Future<DaoInfo> getDaoById(String daoId) async => _apiService.handleApiCall(() async => _apiService.dao.getDaoDetails(daoId));

  Future<void> joinDao(String daoId) async => _apiService.handleApiCall(() async => _apiService.dao.joinDao(daoId));

  Future<void> leaveDao(String daoId) async => _apiService.handleApiCall(() async => _apiService.dao.leaveDao(daoId));

  Future<List<DaoMember>> getDaoMembers(String daoId, {int page = 1, int limit = 20}) async => _apiService.handleApiCall(() async => _apiService.dao.getDaoMembers(daoId, page, limit));

  /// Proposal operations
  Future<List<Proposal>> getProposalsByDao(
    String daoId, {
    int page = 1,
    int limit = 20,
    String? status,
  }) async => _apiService.handleApiCall(() async => _apiService.proposal.getProposals(
        daoId,
        page,
        limit,
        status,
      ));

  Future<Proposal> getProposalById(String proposalId) async => _apiService.handleApiCall(() async => _apiService.proposal.getProposalDetails(proposalId));

  Future<Proposal> createProposal({
    required String daoId,
    required String title,
    required String description,
    required String type,
    required DateTime deadline,
    Map<String, dynamic>? metadata,
  }) async => _apiService.handleApiCall(() async => _apiService.proposal.createProposal({
        'daoId': daoId,
        'title': title,
        'description': description,
        'type': type,
        'deadline': deadline.toIso8601String(),
        if (metadata != null) ...metadata,
      }));

  Future<Vote> voteOnProposal({
    required String proposalId,
    required String voteType,
    required String reason,
  }) async => _apiService.handleApiCall(() async => _apiService.proposal.voteOnProposal(
        proposalId,
        {
          'voteType': voteType,
          'reason': reason,
        },
      ));

  Future<List<Vote>> getProposalVotes(String proposalId, {int page = 1, int limit = 20}) async => _apiService.handleApiCall(() async => _apiService.proposal.getProposalVotes(proposalId, page, limit));
}
