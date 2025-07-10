import '../../core/models/api/proposal_models.dart';

/// Repository interface for proposal operations
abstract class IProposalRepository {
  /// Get proposals for a DAO
  Future<List<Proposal>> getProposalsByDao(
    String daoId, {
    int page = 1,
    int limit = 20,
    String? status,
  });

  /// Get proposal by ID
  Future<Proposal> getProposalById(String proposalId);

  /// Create a new proposal
  Future<Proposal> createProposal({
    required String daoId,
    required String title,
    required String description,
    required String type,
    required DateTime deadline,
    Map<String, dynamic>? metadata,
  });

  /// Vote on a proposal
  Future<Vote> voteOnProposal({
    required String proposalId,
    required String voteType,
    required String reason,
  });

  /// Get user's vote for a proposal
  Future<Vote?> getUserVote(String proposalId);

  /// Get all votes for a proposal
  Future<List<Vote>> getProposalVotes(String proposalId);

  /// Get proposals user has voted on
  Future<List<Proposal>> getProposalsUserVotedOn();

  /// Get active proposals
  Future<List<Proposal>> getActiveProposals();

  /// Get cached proposals
  Future<List<Proposal>> getCachedProposals(String daoId);

  /// Cache proposals
  Future<void> cacheProposals(String daoId, List<Proposal> proposals);

  /// Clear proposal cache
  Future<void> clearProposalCache(String daoId);
}
