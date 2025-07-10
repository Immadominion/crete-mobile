import '../../core/models/api/proposal_models.dart';
import '../../domain/repositories/proposal_repository.dart';
import '../data_sources/local_data_source.dart';
import '../data_sources/remote_data_source.dart';

/// Concrete implementation of ProposalRepository
class ProposalRepository implements IProposalRepository {

  ProposalRepository(this._remoteDataSource, this._localDataSource);
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  @override
  Future<List<Proposal>> getProposalsByDao(
    String daoId, {
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    try {
      // For first page, try cache first
      if (page == 1 && status == null) {
        final isCacheValid = await _localDataSource.isProposalsCacheValid(
          daoId,
        );
        if (isCacheValid) {
          final cachedProposals = await _localDataSource.getCachedProposals(
            daoId,
          );
          if (cachedProposals.isNotEmpty) {
            return cachedProposals;
          }
        }
      }

      // Fetch from remote
      final proposals = await _remoteDataSource.getProposalsByDao(
        daoId,
        page: page,
        limit: limit,
        status: status,
      );

      // Cache first page results
      if (page == 1 && status == null) {
        await _localDataSource.cacheProposals(daoId, proposals);
      }

      return proposals;
    } catch (e) {
      // Return cached results if remote fails
      if (page == 1 && status == null) {
        return _localDataSource.getCachedProposals(daoId);
      }
      rethrow;
    }
  }

  @override
  Future<Proposal> getProposalById(String proposalId) async => _remoteDataSource.getProposalById(proposalId);

  @override
  Future<Proposal> createProposal({
    required String daoId,
    required String title,
    required String description,
    required String type,
    required DateTime deadline,
    Map<String, dynamic>? metadata,
  }) async {
    final proposal = await _remoteDataSource.createProposal(
      daoId: daoId,
      title: title,
      description: description,
      type: type,
      deadline: deadline,
      metadata: metadata,
    );

    // Clear cache to force refresh
    await _localDataSource.clearAllCaches();

    return proposal;
  }

  @override
  Future<Vote> voteOnProposal({
    required String proposalId,
    required String voteType,
    required String reason,
  }) async {
    final vote = await _remoteDataSource.voteOnProposal(
      proposalId: proposalId,
      voteType: voteType,
      reason: reason,
    );

    // Clear cache to force refresh
    await _localDataSource.clearAllCaches();

    return vote;
  }

  @override
  Future<Vote?> getUserVote(String proposalId) async {
    final votes = await getProposalVotes(proposalId);
    final userId = await _localDataSource.getUserId();

    if (userId != null) {
      try {
        return votes.firstWhere((vote) => vote.voterAddress == userId);
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  @override
  Future<List<Vote>> getProposalVotes(String proposalId) async => _remoteDataSource.getProposalVotes(proposalId);

  @override
  Future<List<Proposal>> getProposalsUserVotedOn() async {
    // This would need to be implemented in the API
    // For now, return empty list
    return [];
  }

  @override
  Future<List<Proposal>> getActiveProposals() async {
    // This would need to be implemented as a separate endpoint
    // For now, we could aggregate from multiple DAOs
    return [];
  }

  @override
  Future<List<Proposal>> getCachedProposals(String daoId) async => _localDataSource.getCachedProposals(daoId);

  @override
  Future<void> cacheProposals(String daoId, List<Proposal> proposals) async {
    await _localDataSource.cacheProposals(daoId, proposals);
  }

  @override
  Future<void> clearProposalCache(String daoId) async {
    await _localDataSource.clearAllCaches();
  }
}
