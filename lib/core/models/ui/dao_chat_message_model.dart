import 'package:equatable/equatable.dart';

/// Model for DAO chat messages
class DaoChatMessageModel extends Equatable {
  const DaoChatMessageModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatarUrl,
    required this.message,
    required this.timestamp,
    required this.isVerified,
    required this.reactions,
  });

  final String id;
  final String userId;
  final String userName;
  final String userAvatarUrl;
  final String message;
  final DateTime timestamp;
  final bool isVerified;
  final List<MessageReaction> reactions;

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    userAvatarUrl,
    message,
    timestamp,
    isVerified,
    reactions,
  ];
}

/// Model for message reactions
class MessageReaction extends Equatable {
  const MessageReaction({required this.type, required this.count});

  final ReactionType type;
  final int count;

  @override
  List<Object?> get props => [type, count];
}

/// Types of reactions
enum ReactionType { heart, chat, smile }
