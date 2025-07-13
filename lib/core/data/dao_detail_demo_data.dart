import '../models/ui/dao_chat_message_model.dart';
import '../models/ui/dao_governance_model.dart';

/// Demo data for DAO detail page
class DaoDetailDemoData {
  /// Demo chat messages
  static final List<DaoChatMessageModel> chatMessages = [
    DaoChatMessageModel(
      id: '1',
      userId: 'user1',
      userName: 'cryptodev',
      userAvatarUrl:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
      message:
          "Great proposal! I think this will really help our community grow. Welcome to our DAO community! We're thrilled to have you here. As a new member, you'll have the opportunity",
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isVerified: true,
      reactions: const [
        MessageReaction(type: ReactionType.heart, count: 12),
        MessageReaction(type: ReactionType.chat, count: 3),
        MessageReaction(type: ReactionType.smile, count: 8),
      ],
    ),
    DaoChatMessageModel(
      id: '2',
      userId: 'user2',
      userName: 'daobuilder',
      userAvatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      message:
          "When does the voting period end? I want to make sure I don't miss it.",
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      isVerified: false,
      reactions: const [
        MessageReaction(type: ReactionType.heart, count: 5),
        MessageReaction(type: ReactionType.chat, count: 1),
      ],
    ),
    DaoChatMessageModel(
      id: '3',
      userId: 'user3',
      userName: 'solanastar',
      userAvatarUrl:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
      message:
          'The treasury allocation looks solid. Looking forward to seeing this implemented.',
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      isVerified: true,
      reactions: const [
        MessageReaction(type: ReactionType.heart, count: 18),
        MessageReaction(type: ReactionType.smile, count: 4),
      ],
    ),
  ];

  /// Demo governance proposals
  static final List<DaoGovernanceProposalModel> governanceProposals = [
    DaoGovernanceProposalModel(
      id: '1',
      title: 'Treasury Allocation for Q1 2024',
      description:
          'Proposal to allocate 500K USDC for marketing and development initiatives.',
      status: ProposalStatus.inProgress,
      proposalType: 'Treasury',
      timeframe: 'Ends in 3d',
      proposer: 'Therealchaseeb.solana',
      passThreshold: '60% Yes',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    DaoGovernanceProposalModel(
      id: '2',
      title: 'New Partnership with Solana Foundation',
      description:
          'Establishing strategic partnership for ecosystem development.',
      status: ProposalStatus.completed,
      proposalType: 'Partnership',
      timeframe: 'Ended 3d ago',
      proposer: 'Toly.sol',
      passThreshold: '75% Yes',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    DaoGovernanceProposalModel(
      id: '3',
      title: 'Community Rewards Program',
      description: 'Launch a rewards program for active community members.',
      status: ProposalStatus.failed,
      proposalType: 'Community',
      timeframe: 'Ended 1w ago',
      proposer: '0xMert.solana',
      passThreshold: '45% Yes',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  /// Demo members (for overlapping avatars)
  static final List<DaoMemberModel> members = [
    DaoMemberModel(
      id: '1',
      name: 'CryptoBuilder',
      avatarUrl:
          'https://images.unsplash.com/photo-1494790108755-2616b25a9d48?w=400',
      isVerified: true,
      joinedAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    DaoMemberModel(
      id: '2',
      name: 'SolanaExplorer',
      avatarUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      isVerified: false,
      joinedAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
    DaoMemberModel(
      id: '3',
      name: 'DeFiGuru',
      avatarUrl:
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
      isVerified: true,
      joinedAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    DaoMemberModel(
      id: '4',
      name: 'TokenMaster',
      avatarUrl:
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
      isVerified: false,
      joinedAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];
}
