import 'package:json_annotation/json_annotation.dart';

part 'proposal_models.g.dart';

/// Proposal model
@JsonSerializable()
class Proposal {

  const Proposal({
    required this.id,
    required this.daoId,
    required this.title,
    required this.description,
    required this.proposerAddress,
    required this.status,
    required this.type,
    required this.startTime,
    required this.endTime,
    required this.yesVotes,
    required this.noVotes,
    required this.quorum,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  factory Proposal.fromJson(Map<String, dynamic> json) =>
      _$ProposalFromJson(json);
  final String id;
  final String daoId;
  final String title;
  final String description;
  final String proposerAddress;
  final String status;
  final String type;
  final DateTime startTime;
  final DateTime endTime;
  final int yesVotes;
  final int noVotes;
  final int quorum;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => _$ProposalToJson(this);
}

/// Proposal results model
@JsonSerializable()
class ProposalResults {

  const ProposalResults({
    required this.results,
  });

  factory ProposalResults.fromJson(Map<String, dynamic> json) =>
      _$ProposalResultsFromJson(json);
  final Map<String, dynamic> results;

  Map<String, dynamic> toJson() => _$ProposalResultsToJson(this);
}

/// Vote model
@JsonSerializable()
class Vote {

  const Vote({
    required this.id,
    required this.proposalId,
    required this.voterAddress,
    required this.choice,
    required this.weight,
    required this.createdAt,
    this.transactionId,
  });

  factory Vote.fromJson(Map<String, dynamic> json) => _$VoteFromJson(json);
  final String id;
  final String proposalId;
  final String voterAddress;
  final String choice;
  final int weight;
  final DateTime createdAt;
  final String? transactionId;

  Map<String, dynamic> toJson() => _$VoteToJson(this);
}
