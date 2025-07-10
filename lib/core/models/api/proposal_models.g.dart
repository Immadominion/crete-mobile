// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proposal_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Proposal _$ProposalFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Proposal',
      json,
      ($checkedConvert) {
        final val = Proposal(
          id: $checkedConvert('id', (v) => v as String),
          daoId: $checkedConvert('daoId', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String),
          proposerAddress:
              $checkedConvert('proposerAddress', (v) => v as String),
          status: $checkedConvert('status', (v) => v as String),
          type: $checkedConvert('type', (v) => v as String),
          startTime:
              $checkedConvert('startTime', (v) => DateTime.parse(v as String)),
          endTime:
              $checkedConvert('endTime', (v) => DateTime.parse(v as String)),
          yesVotes: $checkedConvert('yesVotes', (v) => (v as num).toInt()),
          noVotes: $checkedConvert('noVotes', (v) => (v as num).toInt()),
          quorum: $checkedConvert('quorum', (v) => (v as num).toInt()),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          updatedAt:
              $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
          metadata:
              $checkedConvert('metadata', (v) => v as Map<String, dynamic>?),
        );
        return val;
      },
    );

Map<String, dynamic> _$ProposalToJson(Proposal instance) => <String, dynamic>{
      'id': instance.id,
      'daoId': instance.daoId,
      'title': instance.title,
      'description': instance.description,
      'proposerAddress': instance.proposerAddress,
      'status': instance.status,
      'type': instance.type,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'yesVotes': instance.yesVotes,
      'noVotes': instance.noVotes,
      'quorum': instance.quorum,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'metadata': instance.metadata,
    };

ProposalResults _$ProposalResultsFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'ProposalResults',
      json,
      ($checkedConvert) {
        final val = ProposalResults(
          results: $checkedConvert('results', (v) => v as Map<String, dynamic>),
        );
        return val;
      },
    );

Map<String, dynamic> _$ProposalResultsToJson(ProposalResults instance) =>
    <String, dynamic>{
      'results': instance.results,
    };

Vote _$VoteFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Vote',
      json,
      ($checkedConvert) {
        final val = Vote(
          id: $checkedConvert('id', (v) => v as String),
          proposalId: $checkedConvert('proposalId', (v) => v as String),
          voterAddress: $checkedConvert('voterAddress', (v) => v as String),
          choice: $checkedConvert('choice', (v) => v as String),
          weight: $checkedConvert('weight', (v) => (v as num).toInt()),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          transactionId: $checkedConvert('transactionId', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$VoteToJson(Vote instance) => <String, dynamic>{
      'id': instance.id,
      'proposalId': instance.proposalId,
      'voterAddress': instance.voterAddress,
      'choice': instance.choice,
      'weight': instance.weight,
      'createdAt': instance.createdAt.toIso8601String(),
      'transactionId': instance.transactionId,
    };
