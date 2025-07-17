import '../../domain/entities/community.dart';

class CommunityDemoData {
  static List<Community> getMyCommunities() {
    return [
      Community(
        id: '1',
        name: 'Solana Builders',
        description: 'A community for Solana developers and builders',
        memberCount: 1247,
        onlineCount: 89,
        isJoined: true,
        unreadCount: 12,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 5)),
        tags: ['development', 'solana', 'builders'],
      ),
      Community(
        id: '2',
        name: 'DeFi Governance',
        description: 'Decentralized finance governance discussions',
        memberCount: 3456,
        onlineCount: 156,
        isJoined: true,
        unreadCount: 3,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 23)),
        tags: ['defi', 'governance', 'finance'],
      ),
      Community(
        id: '3',
        name: 'NFT Creators',
        description: 'Community for NFT artists and collectors',
        memberCount: 2103,
        onlineCount: 78,
        isJoined: true,
        lastActivity: DateTime.now().subtract(const Duration(hours: 2)),
        tags: ['nft', 'art', 'collectors'],
      ),
      Community(
        id: '4',
        name: 'Web3 Gaming',
        description: 'Gaming on the blockchain',
        memberCount: 567,
        onlineCount: 34,
        isJoined: true,
        unreadCount: 7,
        lastActivity: DateTime.now().subtract(const Duration(hours: 1)),
        tags: ['gaming', 'web3', 'blockchain'],
      ),
    ];
  }

  static List<Community> getDiscoverCommunities() {
    return [
      Community(
        id: '5',
        name: 'Metaverse Builders',
        description: 'Building the future of virtual worlds',
        memberCount: 12453,
        onlineCount: 234,
        isJoined: false,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 10)),
        tags: ['metaverse', 'vr', 'builders'],
      ),
      Community(
        id: '6',
        name: 'Crypto Traders',
        description: 'Trading strategies and market analysis',
        memberCount: 8901,
        onlineCount: 445,
        isJoined: false,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 2)),
        tags: ['trading', 'crypto', 'analysis'],
      ),
      Community(
        id: '7',
        name: 'DAO Innovators',
        description: 'Pushing the boundaries of decentralized organizations',
        memberCount: 4567,
        onlineCount: 123,
        isJoined: false,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 15)),
        tags: ['dao', 'innovation', 'governance'],
      ),
      Community(
        id: '8',
        name: 'Solana Ecosystem',
        description: 'Everything happening in the Solana ecosystem',
        memberCount: 23456,
        onlineCount: 678,
        isJoined: false,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 1)),
        tags: ['solana', 'ecosystem', 'news'],
      ),
      Community(
        id: '9',
        name: 'Web3 Designers',
        description: 'Design community for the decentralized web',
        memberCount: 1876,
        onlineCount: 67,
        isJoined: false,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 30)),
        tags: ['design', 'web3', 'ui/ux'],
      ),
      Community(
        id: '10',
        name: 'Blockchain Entrepreneurs',
        description: 'Building the next generation of blockchain startups',
        memberCount: 3421,
        onlineCount: 98,
        isJoined: false,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 45)),
        tags: ['entrepreneurship', 'blockchain', 'startups'],
      ),
    ];
  }
}
