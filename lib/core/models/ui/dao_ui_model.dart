import 'package:equatable/equatable.dart';

/// DAO UI model for display purposes
class DaoUiModel extends Equatable {
  const DaoUiModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.bannerImageUrl,
    required this.memberCount,
    required this.treasuryAmount,
    required this.category,
    required this.isMyDao,
    required this.keywords,
    this.longDescription,
    this.stats,
    this.members,
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String? bannerImageUrl;
  final int memberCount;
  final String treasuryAmount;
  final String category;
  final bool isMyDao;
  final List<String> keywords;
  final String? longDescription;
  final DaoStats? stats;
  final List<DaoMemberUi>? members;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    bannerImageUrl,
    memberCount,
    treasuryAmount,
    category,
    isMyDao,
    keywords,
    longDescription,
    stats,
    members,
  ];
}

/// DAO member UI model
class DaoMemberUi extends Equatable {
  const DaoMemberUi({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.isVerified,
  });

  final String id;
  final String name;
  final String avatarUrl;
  final bool isVerified;

  @override
  List<Object?> get props => [id, name, avatarUrl, isVerified];
}

/// Proposal UI model
class ProposalUi extends Equatable {
  const ProposalUi({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.statusColor,
    required this.timeframe,
    required this.voteCount,
    required this.participationRate,
  });

  final String id;
  final String title;
  final String description;
  final String status;
  final String statusColor; // 'inprogress', 'completed', 'failed'
  final String timeframe;
  final String voteCount;
  final String participationRate;

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    status,
    statusColor,
    timeframe,
    voteCount,
    participationRate,
  ];
}

/// Chat message UI model
class ChatMessageUi extends Equatable {
  const ChatMessageUi({
    required this.id,
    required this.senderName,
    required this.senderAvatar,
    required this.isVerified,
    required this.content,
    required this.reactions,
  });

  final String id;
  final String senderName;
  final String senderAvatar;
  final bool isVerified;
  final String content;
  final List<ReactionUi> reactions;

  @override
  List<Object?> get props => [
    id,
    senderName,
    senderAvatar,
    isVerified,
    content,
    reactions,
  ];
}

/// Reaction UI model
class ReactionUi extends Equatable {
  const ReactionUi({required this.type, required this.count});

  final String type; // 'heart', 'chat', 'smiley'
  final String count;

  @override
  List<Object?> get props => [type, count];
}

/// DAO statistics model
class DaoStats extends Equatable {
  const DaoStats({
    required this.proposalCount,
    required this.memberCount,
    required this.treasuryValue,
  });

  final int proposalCount;
  final int memberCount;
  final String treasuryValue;

  @override
  List<Object?> get props => [proposalCount, memberCount, treasuryValue];
}
