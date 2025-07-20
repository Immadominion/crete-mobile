import '../../../domain/models/chat/chat_message.dart';

/// Demo data for chat messages
class ChatDemoData {
  // Private constructor to prevent instantiation
  ChatDemoData._();

  /// Get demo chat messages
  static List<ChatMessage> getMessages() {
    return [
      ChatMessage(
        id: '1',
        userId: 'user1',
        username: 'Sarah Chen',
        avatar: 'https://i.pravatar.cc/150?img=1',
        content: 'Hey everyone! Just joined this amazing community 🎉',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        reactions: ['🔥', '👋', '🎉'],
      ),
      ChatMessage(
        id: '2',
        userId: 'user2',
        username: 'Alex Rodriguez',
        avatar: 'https://i.pravatar.cc/150?img=2',
        content:
            'Welcome Sarah! Great to have you here. Make sure to check out the governance channel for the latest proposals.',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 45),
        ),
        reactions: ['👍', '❤️'],
      ),
      ChatMessage(
        id: '3',
        userId: 'user3',
        username: 'Maria Santos',
        avatar: 'https://i.pravatar.cc/150?img=3',
        content: 'Anyone else excited about the upcoming token launch? 🚀',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 30),
        ),
        reactions: ['🚀', '💎', '🔥'],
      ),
      ChatMessage(
        id: '4',
        userId: 'user4',
        username: 'Jordan Kim',
        avatar: 'https://i.pravatar.cc/150?img=4',
        content:
            'Just dropped some new artwork in the showcase channel. Would love your feedback!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        attachments: ['artwork.jpg'],
        reactions: ['🎨', '😍', '👏'],
      ),
      ChatMessage(
        id: '5',
        userId: 'user5',
        username: 'Chris Wilson',
        avatar: 'https://i.pravatar.cc/150?img=5',
        content: 'GM everyone! Ready for another productive day in the DAO 💪',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        reactions: ['☀️', '💪', '🚀'],
      ),
      // Asset message examples
      ChatMessage(
        id: '6',
        userId: 'user3',
        username: 'Maria Santos',
        avatar: 'https://i.pravatar.cc/150?img=3',
        content: "Here's a little bonus for your help last week!",
        timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
        reactions: ['🙏', '🎉'],
        type: MessageType.token,
        sentAsset: const SentAsset(
          id: 'token-123',
          type: AssetType.token,
          name: 'BONK',
          value: 1000,
          imageUrl: 'https://cryptologos.cc/logos/bonk-bonk-logo.png',
          tokenAddress: '7GeR1qvqZaH9LXs4BbevDzSUA2wuHP3V4mR8n2XrZ9by',
        ),
        isClaimable: true,
        claimableUntil: DateTime.now().add(const Duration(days: 7)),
      ),
      ChatMessage(
        id: '7',
        userId: 'user2',
        username: 'Alex Rodriguez',
        avatar: 'https://i.pravatar.cc/150?img=2',
        content: 'Congrats on becoming a Community Contributor!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        reactions: ['🏆', '👏'],
        type: MessageType.role,
        sentAsset: const SentAsset(
          id: 'role-456',
          type: AssetType.role,
          name: 'Community Contributor',
          value: 1,
          imageUrl: 'https://i.imgur.com/XqQLHX6.png',
        ),
        mentionedUsers: ['user1'],
      ),
      ChatMessage(
        id: '8',
        userId: 'user4',
        username: 'Jordan Kim',
        avatar: 'https://i.pravatar.cc/150?img=4',
        content: 'Dropping this rare NFT to one lucky community member!',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        reactions: ['😮', '🎁', '👀'],
        type: MessageType.nft,
        sentAsset: const SentAsset(
          id: 'nft-789',
          type: AssetType.nft,
          name: 'Cosmic Explorer #42',
          value: 1,
          imageUrl: 'https://i.imgur.com/pLOQTGa.jpeg',
          metadata: {
            'collection': 'Cosmic Explorers',
            'rarity': 'Legendary',
            'creator': 'ArtistX',
          },
        ),
        isClaimable: true,
        claimableUntil: DateTime.now().add(const Duration(hours: 24)),
      ),
    ];
  }

  /// Get typing users demo data
  static List<String> getTypingUsers() {
    return ['Sarah Chen', 'Alex Rodriguez'];
  }
}
