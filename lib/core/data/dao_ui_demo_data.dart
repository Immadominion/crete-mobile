import '../models/ui/dao_ui_model.dart';

/// Demo data for DAO UI components
class DaoUiDemoData {
  /// Mock data for "My DAOs" section
  static final List<DaoUiModel> myDaos = [
    const DaoUiModel(
      id: '1',
      name: 'RadiantsDAO',
      description:
          'An on-chain cadre of talented storytellers, creators, developers, & artists. Hosts of the @SolanaMobile Hackathon, notifications on for updates.',
      longDescription:
          'RadiantsDAO is a vibrant community of creative professionals and builders on Solana. We host hackathons, sponsor developer events, and provide grants to emerging projects. Our focus is on bridging the gap between traditional creative industries and blockchain technology.',
      imageUrl:
          'https://pbs.twimg.com/profile_images/1938270844079280128/YDkStciF_400x400.jpg',
      bannerImageUrl:
          'https://pbs.twimg.com/profile_banners/1446275363202502844/1751387551/1500x500',
      memberCount: 1200,
      treasuryAmount: r'$3.5M',
      category: 'Treasury governance',
      isMyDao: true,
      keywords: ['governance', 'treasury', 'community'],
      stats: DaoStats(
        proposalCount: 46,
        memberCount: 1200,
        treasuryValue: r'$3.5M',
      ),
      members: [
        DaoMemberUi(
          id: '1',
          name: 'Alice.sol',
          avatarUrl:
              'https://images.unsplash.com/photo-1494790108755-2616b25a9d48?w=400',
          isVerified: true,
        ),
        DaoMemberUi(
          id: '2',
          name: 'Bob.eth',
          avatarUrl:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
          isVerified: false,
        ),
        DaoMemberUi(
          id: '3',
          name: 'Charlie.dao',
          avatarUrl:
              'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400',
          isVerified: true,
        ),
        DaoMemberUi(
          id: '4',
          name: 'Diana.web3',
          avatarUrl:
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400',
          isVerified: false,
        ),
      ],
    ),
    const DaoUiModel(
      id: '2',
      name: 'Moustache DAO',
      description:
          r'Stake $SOL with our @solana validator: @stachenode Convert your $SOL to $LSTache, our Liquid Staking Token',
      longDescription:
          r'Stake $SOL with our @solana validator: @stachenode Convert your $SOL to $LSTache, our Liquid Staking Token. Stake $SOL with our @solana validator: @stachenode Convert your $SOL to $LSTache, our Liquid Staking Token',
      imageUrl:
          'https://pbs.twimg.com/profile_images/1861004913641132032/etgLlGv7_400x400.jpg',
      bannerImageUrl:
          'https://pbs.twimg.com/profile_banners/1599758004198543360/1675442969/1500x500',
      memberCount: 850,
      treasuryAmount: r'$1.2M',
      category: 'Development',
      isMyDao: true,
      keywords: ['development', 'solana', 'hackathon'],
      stats: DaoStats(
        proposalCount: 23,
        memberCount: 850,
        treasuryValue: r'$1.2M',
      ),
      members: [
        DaoMemberUi(
          id: '5',
          name: 'DevAlice',
          avatarUrl: 'https://example.com/dev-alice.jpg',
          isVerified: true,
        ),
        DaoMemberUi(
          id: '6',
          name: 'CodeBob',
          avatarUrl: 'https://example.com/code-bob.jpg',
          isVerified: true,
        ),
      ],
    ),
    const DaoUiModel(
      id: '3',
      name: 'Onion DAO',
      description: 'Solana developer event in Chicago',
      longDescription:
          'Solana developer event in Chicago. DeFi Collective is focused on building and investing in the next generation of decentralized finance protocols. We provide funding, governance, and strategic support to DeFi projects.',
      imageUrl:
          'https://pbs.twimg.com/profile_images/1921320843306520576/LB7vPgcg_400x400.jpg',
      bannerImageUrl:
          'https://pbs.twimg.com/profile_banners/1894639180535533569/1746913560/1500x500',
      memberCount: 2100,
      treasuryAmount: r'$8.7M',
      category: 'DeFi',
      isMyDao: true,
      keywords: ['defi', 'yield', 'protocols'],
      stats: DaoStats(
        proposalCount: 67,
        memberCount: 2100,
        treasuryValue: r'$8.7M',
      ),
      members: [
        DaoMemberUi(
          id: '7',
          name: 'YieldHunter',
          avatarUrl: 'https://example.com/yield-hunter.jpg',
          isVerified: true,
        ),
        DaoMemberUi(
          id: '8',
          name: 'DeFiDegen',
          avatarUrl: 'https://example.com/defi-degen.jpg',
          isVerified: false,
        ),
      ],
    ),
  ];

  /// Mock data for "Featured DAOs" section
  static final List<DaoUiModel> featuredDaos = [
    const DaoUiModel(
      id: '4',
      name: 'Realms DAO',
      description:
          'The home for on-chain communities in the Solana ecosystem. Helping ~3K Web3 organizations and their members thrive.',
      longDescription:
          'The home for on-chain communities in the Solana ecosystem. Helping ~3K Web3 organizations and their members thrive. Official links: https://bento.me/realms',
      imageUrl:
          'https://pbs.twimg.com/profile_images/1863509572947755008/qeRLYFSK_400x400.jpg',
      bannerImageUrl:
          'https://pbs.twimg.com/profile_banners/1480889392482893829/1733130280/1500x500',
      memberCount: 1500,
      treasuryAmount: r'$2.8M',
      category: 'Art & Culture',
      isMyDao: false,
      keywords: ['nft', 'art', 'creators'],
      stats: DaoStats(
        proposalCount: 34,
        memberCount: 1500,
        treasuryValue: r'$2.8M',
      ),
      members: [
        DaoMemberUi(
          id: '9',
          name: 'ArtisticSoul',
          avatarUrl: 'https://example.com/artistic-soul.jpg',
          isVerified: true,
        ),
      ],
    ),
    const DaoUiModel(
      id: '5',
      name: 'MetaDAO',
      description: 'ICOs, but better',
      longDescription:
          'ICOs, but better | backed by @Paradigm | https://linktr.ee/futarchy',
      imageUrl:
          'https://pbs.twimg.com/profile_images/1717367001776099328/MbO6f8Su_400x400.jpg',
      bannerImageUrl:
          'https://pbs.twimg.com/profile_banners/1635493703996395521/1711436799/1500x500',
      memberCount: 980,
      treasuryAmount: r'$4.2M',
      category: 'Impact',
      isMyDao: false,
      keywords: ['climate', 'environment', 'impact'],
      stats: DaoStats(
        proposalCount: 28,
        memberCount: 980,
        treasuryValue: r'$4.2M',
      ),
      members: [
        DaoMemberUi(
          id: '10',
          name: 'EcoWarrior',
          avatarUrl: 'https://example.com/eco-warrior.jpg',
          isVerified: true,
        ),
      ],
    ),
    const DaoUiModel(
      id: '6',
      name: 'Metaplex',
      description:
          'The standard for launching tokens and NFTs on @solana and the SVM.',
      longDescription:
          r'The standard for launching tokens and NFTs on @solana and the SVM. 920M assets, 14 million users and $36M+ in protocol revenue. Powered by $MPLX. GameFi Alliance is at the forefront of blockchain gaming innovation. We invest in and support game developers building the next generation of play-to-earn and NFT gaming experiences.',
      imageUrl:
          'https://pbs.twimg.com/profile_images/1877049596536385536/-yXYQPGU_400x400.jpg',
      bannerImageUrl:
          'https://pbs.twimg.com/profile_banners/158758371/1744233345/1500x500',
      memberCount: 3200,
      treasuryAmount: r'$12.5M',
      category: 'Gaming',
      isMyDao: false,
      keywords: ['gaming', 'gamefi', 'play-to-earn'],
      stats: DaoStats(
        proposalCount: 89,
        memberCount: 3200,
        treasuryValue: r'$12.5M',
      ),
      members: [
        DaoMemberUi(
          id: '11',
          name: 'GameMaster',
          avatarUrl: 'https://example.com/game-master.jpg',
          isVerified: true,
        ),
      ],
    ),
  ];

  /// All DAOs combined
  static List<DaoUiModel> get allDaos => [...myDaos, ...featuredDaos];
}
