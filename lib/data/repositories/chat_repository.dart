import '../../domain/repositories/chat_repository.dart';
import '../data_sources/local_data_source.dart';
import '../data_sources/remote_data_source.dart';

/// Concrete implementation of ChatRepository
class ChatRepository implements IChatRepository {

  ChatRepository(this._remoteDataSource, this._localDataSource);
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  @override
  Future<List<ChatRoom>> getDaoChatRooms(String daoId) async {
    // This would need to be implemented in the API
    // For now, return mock data
    return [
      ChatRoom(
        id: 'general_$daoId',
        name: 'General',
        daoId: daoId,
        type: 'public',
        isPrivate: false,
        createdAt: DateTime.now(),
      ),
      ChatRoom(
        id: 'announcements_$daoId',
        name: 'Announcements',
        daoId: daoId,
        type: 'announcement',
        isPrivate: false,
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<List<ChatMessage>> getChatMessages(
    String roomId, {
    int page = 1,
    int limit = 50,
    DateTime? before,
  }) async {
    try {
      // Try cache first for first page
      if (page == 1 && before == null) {
        final cachedMessages = await _localDataSource.getCachedMessages(roomId);
        if (cachedMessages.isNotEmpty) {
          return cachedMessages
              .map(
                (json) => ChatMessage(
                  id: json['id'] as String,
                  content: json['content'] as String,
                  userId: json['userId'] as String,
                  username: json['username'] as String,
                  avatarUrl: json['avatarUrl'] as String?,
                  timestamp: DateTime.parse(json['timestamp'] as String),
                  type: json['type'] as String,
                  metadata: json['metadata'] as Map<String, dynamic>?,
                ),
              )
              .toList();
        }
      }

      // Fetch from remote (would need API implementation)
      // For now, return empty list
      return [];
    } catch (e) {
      // Return cached messages if remote fails
      if (page == 1 && before == null) {
        final cachedMessages = await _localDataSource.getCachedMessages(roomId);
        return cachedMessages
            .map(
              (json) => ChatMessage(
                id: json['id'] as String,
                content: json['content'] as String,
                userId: json['userId'] as String,
                username: json['username'] as String,
                avatarUrl: json['avatarUrl'] as String?,
                timestamp: DateTime.parse(json['timestamp'] as String),
                type: json['type'] as String,
                metadata: json['metadata'] as Map<String, dynamic>?,
              ),
            )
            .toList();
      }
      rethrow;
    }
  }

  @override
  Future<ChatMessage> sendMessage({
    required String roomId,
    required String content,
    required String type,
    Map<String, dynamic>? metadata,
  }) async {
    // This would need to be implemented in the API
    // For now, return mock message
    return ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      userId: 'current_user',
      username: 'Current User',
      timestamp: DateTime.now(),
      type: type,
      metadata: metadata,
    );
  }

  @override
  Future<List<ChatMessage>> getCachedMessages(String roomId) async {
    final cachedMessages = await _localDataSource.getCachedMessages(roomId);
    return cachedMessages
        .map(
          (json) => ChatMessage(
            id: json['id'] as String,
            content: json['content'] as String,
            userId: json['userId'] as String,
            username: json['username'] as String,
            avatarUrl: json['avatarUrl'] as String?,
            timestamp: DateTime.parse(json['timestamp'] as String),
            type: json['type'] as String,
            metadata: json['metadata'] as Map<String, dynamic>?,
          ),
        )
        .toList();
  }

  @override
  Future<void> cacheMessages(String roomId, List<ChatMessage> messages) async {
    final messagesJson = messages
        .map(
          (msg) => {
            'id': msg.id,
            'content': msg.content,
            'userId': msg.userId,
            'username': msg.username,
            'avatarUrl': msg.avatarUrl,
            'timestamp': msg.timestamp.toIso8601String(),
            'type': msg.type,
            'metadata': msg.metadata,
          },
        )
        .toList();

    await _localDataSource.cacheMessages(roomId, messagesJson);
  }

  @override
  Future<void> clearMessageCache(String roomId) async {
    await _localDataSource.clearAllCaches();
  }

  @override
  Future<void> markMessagesAsRead(
    String roomId,
    List<String> messageIds,
  ) async {
    // This would need to be implemented in the API
  }

  @override
  Future<int> getUnreadMessageCount(String roomId) async {
    // This would need to be implemented in the API
    return 0;
  }

  @override
  Stream<ChatMessage> subscribeToMessages(String roomId) {
    // This would need WebSocket implementation
    // For now, return empty stream
    return const Stream.empty();
  }

  @override
  Stream<Map<String, bool>> subscribeToTypingIndicators(String roomId) {
    // This would need WebSocket implementation
    // For now, return empty stream
    return const Stream.empty();
  }

  @override
  Future<void> sendTypingIndicator(String roomId, bool isTyping) async {
    // This would need WebSocket implementation
  }
}
