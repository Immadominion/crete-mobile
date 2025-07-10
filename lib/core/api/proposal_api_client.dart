import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/api/proposal_models.dart';

part 'proposal_api_client.g.dart';

/// Proposal API client
@RestApi()
abstract class ProposalApiClient {
  factory ProposalApiClient(Dio dio, {String baseUrl}) = _ProposalApiClient;

  /// Get proposals for a DAO
  @GET('/proposals')
  Future<List<Proposal>> getProposals(
    @Query('daoId') String daoId,
    @Query('page') int page,
    @Query('limit') int limit,
    @Query('status') String? status,
  );

  /// Get proposal details
  @GET('/proposals/{id}')
  Future<Proposal> getProposalDetails(@Path('id') String proposalId);

  /// Create a new proposal
  @POST('/proposals/create')
  Future<Proposal> createProposal(@Body() Map<String, dynamic> proposalData);

  /// Vote on a proposal
  @POST('/proposals/{id}/vote')
  Future<Vote> voteOnProposal(
    @Path('id') String proposalId,
    @Body() Map<String, dynamic> voteData,
  );

  /// Get proposal results
  @GET('/proposals/{id}/results')
  Future<ProposalResults> getProposalResults(
    @Path('id') String proposalId,
  );

  /// Get user's vote for a proposal
  @GET('/proposals/{id}/my-vote')
  Future<Vote?> getUserVote(@Path('id') String proposalId);

  /// Get all votes for a proposal
  @GET('/proposals/{id}/votes')
  Future<List<Vote>> getProposalVotes(
    @Path('id') String proposalId,
    @Query('page') int page,
    @Query('limit') int limit,
  );
}
