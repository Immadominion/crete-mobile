
/// Chat message model
class ChatMessage {

  const ChatMessage({
    required this.id,
    required this.content,
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.timestamp,
    required this.type,
    this.metadata,
  });
  final String id;
  final String content;
  final String userId;
  final String username;
  final String? avatarUrl;
  final DateTime timestamp;
  final String type;
  final Map<String, dynamic>? metadata;
}

/// Chat room model
class ChatRoom {

  const ChatRoom({
    required this.id,
    required this.name,
    required this.daoId,
    required this.type,
    required this.isPrivate,
    required this.createdAt,
    this.metadata,
  });
  final String id;
  final String name;
  final String daoId;
  final String type;
  final bool isPrivate;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;
}

/// Repository interface for chat operations
abstract class IChatRepository {
  /// Get chat rooms for a DAO
  Future<List<ChatRoom>> getDaoChatRooms(String daoId);

  /// Get messages for a chat room
  Future<List<ChatMessage>> getChatMessages(
    String roomId, {
    int page = 1,
    int limit = 50,
    DateTime? before,
  });

  /// Send a message to a chat room
  Future<ChatMessage> sendMessage({
    required String roomId,
    required String content,
    required String type,
    Map<String, dynamic>? metadata,
  });

  /// Get cached messages
  Future<List<ChatMessage>> getCachedMessages(String roomId);

  /// Cache messages
  Future<void> cacheMessages(String roomId, List<ChatMessage> messages);

  /// Clear message cache
  Future<void> clearMessageCache(String roomId);

  /// Mark messages as read
  Future<void> markMessagesAsRead(String roomId, List<String> messageIds);

  /// Get unread message count
  Future<int> getUnreadMessageCount(String roomId);

  /// Subscribe to real-time messages
  Stream<ChatMessage> subscribeToMessages(String roomId);

  /// Subscribe to typing indicators
  Stream<Map<String, bool>> subscribeToTypingIndicators(String roomId);

  /// Send typing indicator
  Future<void> sendTypingIndicator(String roomId, bool isTyping);
}
