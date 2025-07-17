import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../communities/communities_page.dart';
import 'chat_page.dart';
import 'profile_page.dart';
import 'voice_page.dart';
import 'widgets/notifications_feed.dart';
import 'widgets/quick_actions_grid.dart';
import 'widgets/recent_activity_section.dart';
import 'widgets/stats_overview_section.dart';
import 'widgets/voice_channels_section.dart';
import 'widgets/wallet_status_card.dart';

/// Modern home page with animated sections and proper navigation
/// Shows wallet status, recent activity, active voice channels, quick actions, and notifications
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _headerAnimation;

  // Demo data - in a real app, this would come from state management
  final bool _isWalletConnected = true;
  final String _walletAddress = '4nTj...mX92';
  final String _balance = '12.45';

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: -50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutQuart),
      ),
    );

    // Start the main animation
    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundPrimary
          : AppColors.backgroundPrimary,
      body: AnimatedBuilder(
        animation: _mainController,
        builder: (context, child) {
          return CustomScrollView(
            slivers: [
              // Header with greeting and wallet status
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 60.h, 16.w, 24.h),
                sliver: SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: Offset(0, _headerAnimation.value),
                    child: _buildHeader(isDarkMode),
                  ),
                ),
              ),

              // Wallet Status Card
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverToBoxAdapter(
                  child: WalletStatusCard(
                    isConnected: _isWalletConnected,
                    walletAddress: _walletAddress,
                    balance: _balance,
                    onTap: _handleWalletTap,
                  ),
                ),
              ),

              // Stats Overview Section
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 0),
                sliver: SliverToBoxAdapter(
                  child: StatsOverviewSection(
                    stats: _getStatsData(),
                  ),
                ),
              ),

              // Recent Activity Section
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 0),
                sliver: SliverToBoxAdapter(
                  child: RecentActivitySection(
                    activities: _getRecentActivities(),
                    onSeeAll: _navigateToActivity,
                  ),
                ),
              ),

              // Voice Channels Section
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 0),
                sliver: SliverToBoxAdapter(
                  child: VoiceChannelsSection(
                    channels: _getVoiceChannels(),
                    onSeeAll: _navigateToVoice,
                  ),
                ),
              ),

              // Quick Actions Grid
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 0),
                sliver: SliverToBoxAdapter(
                  child: QuickActionsGrid(actions: _getQuickActions()),
                ),
              ),

              // Notifications Feed
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 0),
                sliver: SliverToBoxAdapter(
                  child: NotificationsFeed(
                    notifications: _getNotifications(),
                    onSeeAll: _navigateToNotifications,
                  ),
                ),
              ),

              // Bottom padding
              SliverPadding(
                padding: EdgeInsets.only(bottom: 100.h),
                sliver: const SliverToBoxAdapter(child: SizedBox()),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              PhosphorIcons.house(PhosphorIconsStyle.bold),
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Good morning!',
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
                fontSize: 28.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          'Welcome back to your DAO communities',
          style: AppTypography.geistRegular14.copyWith(
            color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
          ),
        ),
      ],
    );
  }

  // Navigation methods
  void _handleWalletTap() {
    if (_isWalletConnected) {
      // Navigate to wallet details or show wallet menu
      Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (context) => const ProfilePage()),
      );
    } else {
      // Show wallet connection dialog
      _showWalletConnectionDialog();
    }
  }

  void _navigateToActivity() {
    // Navigate to activity page
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Navigate to Activity')));
  }

  void _navigateToVoice() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const VoicePage()),
    );
  }

  void _navigateToNotifications() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Navigate to Notifications')));
  }

  void _navigateToChat() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const ChatPage()),
    );
  }

  void _navigateToCommunitiesDiscover() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const CommunitiesPage()),
    );
  }

  void _navigateToGovernance() {
    // Navigate to governance page
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Navigate to Governance')));
  }

  void _showWalletConnectionDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connect Wallet'),
        content: const Text('Please connect your wallet to continue'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Implement wallet connection logic
            },
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  // Demo data methods
  List<RecentActivityItem> _getRecentActivities() {
    return [
      RecentActivityItem(
        title: 'New message in #general',
        subtitle: 'CryptoDAO • Someone shared a new proposal',
        time: '2 min ago',
        icon: PhosphorIcons.chatCircle(PhosphorIconsStyle.bold),
        iconColor: AppColors.primary,
        onTap: _navigateToChat,
      ),
      RecentActivityItem(
        title: 'Vote on Treasury Proposal',
        subtitle: 'DeFi Collective • Voting ends in 2 hours',
        time: '1 hour ago',
        icon: PhosphorIcons.checkCircle(PhosphorIconsStyle.bold),
        iconColor: AppColors.success,
        onTap: _navigateToGovernance,
      ),
      RecentActivityItem(
        title: 'Mentioned in #governance',
        subtitle: 'MetaDAO • @alice mentioned you in a discussion',
        time: '3 hours ago',
        icon: PhosphorIcons.at(PhosphorIconsStyle.bold),
        iconColor: AppColors.warning,
        onTap: _navigateToChat,
      ),
    ];
  }

  List<VoiceChannelItem> _getVoiceChannels() {
    return [
      VoiceChannelItem(
        name: 'General Voice',
        community: 'CryptoDAO',
        memberCount: 3,
        isActive: true,
        onJoin: _navigateToVoice,
      ),
      VoiceChannelItem(
        name: 'Governance Meeting',
        community: 'DeFi Collective',
        memberCount: 7,
        isActive: true,
        onJoin: _navigateToVoice,
      ),
    ];
  }

  List<QuickActionItem> _getQuickActions() {
    return [
      QuickActionItem(
        title: 'Join Voice',
        subtitle: 'Join active voice channels',
        icon: PhosphorIcons.speakerHigh(PhosphorIconsStyle.bold),
        iconColor: AppColors.primary,
        onTap: _navigateToVoice,
      ),
      QuickActionItem(
        title: 'Check Governance',
        subtitle: 'View active proposals',
        icon: PhosphorIcons.checkCircle(PhosphorIconsStyle.bold),
        iconColor: AppColors.success,
        onTap: _navigateToGovernance,
      ),
      QuickActionItem(
        title: 'Start Chat',
        subtitle: 'Send a message',
        icon: PhosphorIcons.chatCircle(PhosphorIconsStyle.bold),
        iconColor: AppColors.info,
        onTap: _navigateToChat,
      ),
      QuickActionItem(
        title: 'Discover',
        subtitle: 'Find new communities',
        icon: PhosphorIcons.compass(PhosphorIconsStyle.bold),
        iconColor: AppColors.warning,
        onTap: _navigateToCommunitiesDiscover,
      ),
    ];
  }

  List<NotificationItem> _getNotifications() {
    return [
      NotificationItem(
        title: 'New proposal in MetaDAO',
        description: 'Treasury allocation proposal needs your vote',
        time: '5 min ago',
        type: NotificationType.proposal,
        isRead: false,
        onTap: _navigateToGovernance,
      ),
      NotificationItem(
        title: 'CryptoDAO mentioned you',
        description: 'Discussion about upcoming upgrades',
        time: '1 hour ago',
        type: NotificationType.mention,
        isRead: false,
        onTap: _navigateToChat,
      ),
      NotificationItem(
        title: 'DeFi Collective vote results',
        description: 'Governance proposal has passed',
        time: '2 hours ago',
        type: NotificationType.vote,
        isRead: true,
        onTap: _navigateToGovernance,
      ),
    ];
  }

  List<StatsItem> _getStatsData() {
    return [
      StatsItem(
        title: 'Total Proposals',
        value: '24',
        subtitle: 'Active votes',
        icon: PhosphorIcons.scales(),
        iconColor: AppColors.primary,
      ),
      StatsItem(
        title: 'Active Members',
        value: '128',
        subtitle: 'Community size',
        icon: PhosphorIcons.users(),
        iconColor: Colors.blue,
      ),
      StatsItem(
        title: 'Online Now',
        value: '12',
        subtitle: 'In voice channels',
        icon: PhosphorIcons.speakerHigh(),
        iconColor: Colors.green,
      ),
    ];
  }
}
