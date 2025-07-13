import 'package:equatable/equatable.dart';

/// Model for DAO governance proposals
class DaoGovernanceProposalModel extends Equatable {
  const DaoGovernanceProposalModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.proposalType,
    required this.timeframe,
    required this.proposer,
    required this.passThreshold,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final ProposalStatus status;
  final String proposalType;
  final String timeframe;
  final String proposer;
  final String passThreshold;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    status,
    proposalType,
    timeframe,
    proposer,
    passThreshold,
    createdAt,
  ];
}

/// Status of governance proposals
enum ProposalStatus { inProgress, completed, failed }

/// Model for DAO member info
class DaoMemberModel extends Equatable {
  const DaoMemberModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.isVerified,
    required this.joinedAt,
  });

  final String id;
  final String name;
  final String avatarUrl;
  final bool isVerified;
  final DateTime joinedAt;

  @override
  List<Object?> get props => [id, name, avatarUrl, isVerified, joinedAt];
}
