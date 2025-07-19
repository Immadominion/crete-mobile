// No imports needed for this model file

/// Model for chat messages
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.userId,
    required this.username,
    required this.avatar,
    required this.content,
    required this.timestamp,
    this.attachments = const [],
    this.reactions = const [],
    this.isBot = false,
    this.replyTo,
    this.type = MessageType.text,
    this.sentAsset,
    this.isClaimable = false,
    this.isClaimed = false,
    this.claimableUntil,
    this.mentionedUsers = const [],
    this.taggedRoles = const [],
  });
  final String id;
  final String userId;
  final String username;
  final String avatar;
  final String content;
  final DateTime timestamp;
  final List<String> attachments;
  final List<String> reactions;
  final bool isBot;
  final String? replyTo;
  final MessageType type;

  // New fields for enhanced functionality
  final SentAsset? sentAsset;
  final bool isClaimable;
  final bool isClaimed;
  final DateTime? claimableUntil;
  final List<String> mentionedUsers;
  final List<String> taggedRoles;
}

/// Types of messages that can be sent in a chat
enum MessageType {
  text,
  image,
  video,
  audio,
  file,
  sticker,
  system,
  tag,
  role,
  nft,
  token,
}

/// Model for assets sent in chat
class SentAsset {
  const SentAsset({
    required this.id,
    required this.type,
    required this.name,
    required this.value,
    this.imageUrl,
    this.metadata,
    this.tokenAddress,
  });

  final String id;
  final AssetType type;
  final String name;
  final double value; // Amount/value of tokens or 1 for NFT
  final String? imageUrl;
  final Map<String, dynamic>? metadata;
  final String? tokenAddress;
}

/// Types of assets that can be sent in chat
enum AssetType { tag, role, nft, token }
