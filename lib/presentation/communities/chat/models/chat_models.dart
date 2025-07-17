/// Enhanced message model for production-level chat
class ChatMessage {
  final String id;
  final String userId;
  final String username;
  final String displayName;
  final String avatar;
  final String content;
  final DateTime timestamp;
  final List<MessageAttachment> attachments;
  final List<MessageReaction> reactions;
  final bool isBot;
  final bool isEdited;
  final bool isDeleted;
  final bool isPinned;
  final String? replyTo;
  final MessageType type;
  final MessageStatus status;
  final Map<String, dynamic>? metadata;

  const ChatMessage({
    required this.id,
    required this.userId,
    required this.username,
    required this.displayName,
    required this.avatar,
    required this.content,
    required this.timestamp,
    this.attachments = const [],
    this.reactions = const [],
    this.isBot = false,
    this.isEdited = false,
    this.isDeleted = false,
    this.isPinned = false,
    this.replyTo,
    this.type = MessageType.text,
    this.status = MessageStatus.sent,
    this.metadata,
  });

  ChatMessage copyWith({
    String? id,
    String? userId,
    String? username,
    String? displayName,
    String? avatar,
    String? content,
    DateTime? timestamp,
    List<MessageAttachment>? attachments,
    List<MessageReaction>? reactions,
    bool? isBot,
    bool? isEdited,
    bool? isDeleted,
    bool? isPinned,
    String? replyTo,
    MessageType? type,
    MessageStatus? status,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatar: avatar ?? this.avatar,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      attachments: attachments ?? this.attachments,
      reactions: reactions ?? this.reactions,
      isBot: isBot ?? this.isBot,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      isPinned: isPinned ?? this.isPinned,
      replyTo: replyTo ?? this.replyTo,
      type: type ?? this.type,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }
}

enum MessageType {
  text,
  image,
  video,
  audio,
  file,
  sticker,
  gif,
  system,
  poll,
  location,
  voice_note,
  code_block,
  link_preview,
  crypto_transaction,
  nft_share,
}

enum MessageStatus { sending, sent, delivered, read, failed }

/// Message attachment model
class MessageAttachment {
  final String id;
  final String url;
  final String fileName;
  final String mimeType;
  final int size;
  final int? width;
  final int? height;
  final String? thumbnail;
  final AttachmentType type;

  const MessageAttachment({
    required this.id,
    required this.url,
    required this.fileName,
    required this.mimeType,
    required this.size,
    this.width,
    this.height,
    this.thumbnail,
    required this.type,
  });
}

enum AttachmentType { image, video, audio, document, archive, location }

/// Message reaction model
class MessageReaction {
  final String emoji;
  final List<String> userIds;
  final int count;

  const MessageReaction({
    required this.emoji,
    required this.userIds,
    required this.count,
  });
}

/// Chat participant model
class ChatParticipant {
  final String id;
  final String username;
  final String displayName;
  final String avatar;
  final UserRole role;
  final UserStatus status;
  final DateTime lastSeen;
  final bool isTyping;
  final String? customStatus;

  const ChatParticipant({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatar,
    required this.role,
    required this.status,
    required this.lastSeen,
    this.isTyping = false,
    this.customStatus,
  });
}

enum UserRole { owner, admin, moderator, member, guest }

enum UserStatus { online, idle, busy, offline }

/// Typing indicator model
class TypingIndicator {
  final String userId;
  final String username;
  final DateTime timestamp;

  const TypingIndicator({
    required this.userId,
    required this.username,
    required this.timestamp,
  });
}

/// Channel model for chat
class Channel {
  final String id;
  final String name;
  final String? description;
  final ChannelType type;
  final bool isPrivate;
  final List<String> memberIds;
  final DateTime createdAt;
  final DateTime? lastActivity;
  final int unreadCount;
  final String? lastMessage;

  const Channel({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    this.isPrivate = false,
    this.memberIds = const [],
    required this.createdAt,
    this.lastActivity,
    this.unreadCount = 0,
    this.lastMessage,
  });
}

enum ChannelType { text, voice, video, announcement, thread, dm, group_dm }

/// Voice channel state
class VoiceChannelState {
  final String channelId;
  final List<String> participantIds;
  final bool isActive;
  final DateTime? startTime;
  final Duration? duration;

  const VoiceChannelState({
    required this.channelId,
    this.participantIds = const [],
    this.isActive = false,
    this.startTime,
    this.duration,
  });
}

/// Media message model
class MediaMessage {
  final String id;
  final String url;
  final String fileName;
  final String mimeType;
  final int size;
  final int? width;
  final int? height;
  final String? thumbnail;
  final Duration? duration;
  final MediaType type;

  const MediaMessage({
    required this.id,
    required this.url,
    required this.fileName,
    required this.mimeType,
    required this.size,
    this.width,
    this.height,
    this.thumbnail,
    this.duration,
    required this.type,
  });
}

enum MediaType { image, video, audio, gif, sticker }

/// Chat permissions model
class ChatPermissions {
  final bool canSendMessages;
  final bool canSendMedia;
  final bool canReact;
  final bool canMention;
  final bool canPin;
  final bool canDelete;
  final bool canEdit;
  final bool canModerate;
  final bool canManageChannel;

  const ChatPermissions({
    this.canSendMessages = true,
    this.canSendMedia = true,
    this.canReact = true,
    this.canMention = true,
    this.canPin = false,
    this.canDelete = false,
    this.canEdit = false,
    this.canModerate = false,
    this.canManageChannel = false,
  });
}

/// Thread model for message threads
class MessageThread {
  final String id;
  final String parentMessageId;
  final String channelId;
  final String title;
  final List<ChatMessage> messages;
  final int participantCount;
  final DateTime createdAt;
  final DateTime lastActivity;
  final bool isArchived;

  const MessageThread({
    required this.id,
    required this.parentMessageId,
    required this.channelId,
    required this.title,
    this.messages = const [],
    this.participantCount = 0,
    required this.createdAt,
    required this.lastActivity,
    this.isArchived = false,
  });
}
