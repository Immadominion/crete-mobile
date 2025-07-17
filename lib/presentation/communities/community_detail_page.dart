import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../domain/entities/community.dart';
import 'chat/channel_chat_page.dart';

/// Model for channel categories
class ChannelCategory {

  const ChannelCategory({
    required this.id,
    required this.name,
    required this.channels,
    this.isCollapsed = false,
    required this.icon,
  });
  final String id;
  final String name;
  final List<Channel> channels;
  final bool isCollapsed;
  final PhosphorIconData icon;
}

/// Model for individual channels
class Channel {

  const Channel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.unreadCount = 0,
    this.membersCount = 0,
    this.isPrivate = false,
    this.recentEmojis = const [],
    this.lastMessage,
    this.lastActivity,
  });
  final String id;
  final String name;
  final String description;
  final ChannelType type;
  final int unreadCount;
  final int membersCount;
  final bool isPrivate;
  final List<String> recentEmojis;
  final String? lastMessage;
  final DateTime? lastActivity;
}

enum ChannelType { text, voice, announcement, stage, forum }

/// Discord-like Community Detail Page with channels organized by categories
class CommunityDetailPage extends StatefulWidget {

  const CommunityDetailPage({super.key, required this.community});
  final Community community;

  @override
  State<CommunityDetailPage> createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final Map<String, bool> _categoryCollapseStates = {};

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundPrimary
          : AppColors.backgroundPrimary,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverAppBar(
              backgroundColor: isDarkMode
                  ? AppColors.darkBackgroundPrimary
                  : AppColors.backgroundPrimary,
              elevation: 0,
              pinned: true,
              expandedHeight: 200.h,
              leading: IconButton(
                icon: PhosphorIcon(
                  PhosphorIcons.arrowLeft(),
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: PhosphorIcon(
                    PhosphorIcons.magnifyingGlass(),
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                  ),
                  onPressed: () => _showSearchOverlay(),
                ),
                IconButton(
                  icon: PhosphorIcon(
                    PhosphorIcons.dotsThreeVertical(),
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                  ),
                  onPressed: () => _showCommunityMenu(),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: _buildCommunityHeader(isDarkMode),
              ),
            ),

            // Quick Actions
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              sliver: SliverToBoxAdapter(child: _buildQuickActions(isDarkMode)),
            ),

            // Channel Categories
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final categories = _getChannelCategories();
                  final category = categories[index];
                  return _buildChannelCategory(category, isDarkMode);
                }, childCount: _getChannelCategories().length),
              ),
            ),

            // Bottom padding for floating action button
            SliverPadding(
              padding: EdgeInsets.only(bottom: 100.h),
              sliver: const SliverToBoxAdapter(child: SizedBox()),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(isDarkMode),
    );
  }

  Widget _buildCommunityHeader(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withOpacity(0.1),
            (isDarkMode
                    ? AppColors.darkBackgroundPrimary
                    : AppColors.backgroundPrimary)
                .withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              // Community Avatar
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: PhosphorIcon(
                    PhosphorIcons.users(PhosphorIconsStyle.bold),
                    color: AppColors.white,
                    size: 32.sp,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.community.name,
                      style: AppTypography.sfProSemiBold32.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.gray900,
                        fontSize: 24.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          '${widget.community.onlineCount} online',
                          style: AppTypography.geistRegular13.copyWith(
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        PhosphorIcon(
                          PhosphorIcons.users(),
                          size: 14.sp,
                          color: isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.gray600,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${widget.community.memberCount} members',
                          style: AppTypography.geistRegular13.copyWith(
                            color: isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.gray600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            widget.community.description,
            style: AppTypography.geistRegular14.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray700,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isDarkMode) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildQuickActionChip(
            'Rules',
            PhosphorIcons.shieldCheck(),
            AppColors.primary,
            isDarkMode,
          ),
          SizedBox(width: 8.w),
          _buildQuickActionChip(
            'Events',
            PhosphorIcons.calendarCheck(),
            Colors.orange,
            isDarkMode,
          ),
          SizedBox(width: 8.w),
          _buildQuickActionChip(
            'Emojis',
            PhosphorIcons.smiley(),
            Colors.yellow.shade700,
            isDarkMode,
          ),
          SizedBox(width: 8.w),
          _buildQuickActionChip(
            'Members',
            PhosphorIcons.users(),
            Colors.blue,
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionChip(
    String label,
    PhosphorIconData icon,
    Color color,
    bool isDarkMode,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(icon, size: 16.sp, color: color),
          SizedBox(width: 6.w),
          Text(
            label,
            style: AppTypography.geistMedium13.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelCategory(ChannelCategory category, bool isDarkMode) {
    final isCollapsed =
        _categoryCollapseStates[category.id] ?? category.isCollapsed;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header
          GestureDetector(
            onTap: () => _toggleCategory(category.id),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color:
                    (isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray200)
                        .withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  PhosphorIcon(
                    isCollapsed
                        ? PhosphorIcons.caretRight(PhosphorIconsStyle.bold)
                        : PhosphorIcons.caretDown(PhosphorIconsStyle.bold),
                    size: 12.sp,
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600,
                  ),
                  SizedBox(width: 8.w),
                  PhosphorIcon(
                    category.icon,
                    size: 16.sp,
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    category.name.toUpperCase(),
                    style: AppTypography.geistSemiBold13.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${category.channels.length}',
                    style: AppTypography.geistRegular12.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Channels List
          if (!isCollapsed) ...[
            SizedBox(height: 8.h),
            ...category.channels.map(
              (channel) => _buildChannelItem(channel, isDarkMode),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChannelItem(Channel channel, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      decoration: BoxDecoration(
        color: channel.unreadCount > 0
            ? AppColors.primary.withOpacity(0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: _getChannelColor(channel.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: PhosphorIcon(
              _getChannelIcon(channel.type),
              size: 18.sp,
              color: _getChannelColor(channel.type),
            ),
          ),
        ),
        title: Row(
          children: [
            if (channel.isPrivate) ...[
              PhosphorIcon(
                PhosphorIcons.lock(),
                size: 12.sp,
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray500,
              ),
              SizedBox(width: 4.w),
            ],
            Expanded(
              child: Text(
                channel.name,
                style: AppTypography.geistSemiBold15.copyWith(
                  color: channel.unreadCount > 0
                      ? (isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.gray900)
                      : (isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600),
                ),
              ),
            ),
            if (channel.unreadCount > 0) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  channel.unreadCount.toString(),
                  style: AppTypography.geistMedium11.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              channel.description,
              style: AppTypography.geistRegular12.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (channel.lastMessage != null) ...[
              SizedBox(height: 4.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      channel.lastMessage!,
                      style: AppTypography.geistRegular11.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (channel.recentEmojis.isNotEmpty) ...[
                    SizedBox(width: 8.w),
                    ...channel.recentEmojis
                        .take(3)
                        .map(
                          (emoji) =>
                              Text(emoji, style: TextStyle(fontSize: 12.sp)),
                        ),
                  ],
                ],
              ),
            ],
          ],
        ),
        trailing: channel.type == ChannelType.voice && channel.membersCount > 0
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${channel.membersCount}',
                      style: AppTypography.geistMedium11.copyWith(
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              )
            : null,
        onTap: () => _navigateToChannel(channel),
      ),
    );
  }

  Widget _buildFloatingActionButton(bool isDarkMode) {
    return FloatingActionButton.extended(
      onPressed: () => _showCreateChannelDialog(),
      backgroundColor: AppColors.primary,
      icon: PhosphorIcon(
        PhosphorIcons.plus(PhosphorIconsStyle.bold),
        color: AppColors.white,
      ),
      label: Text(
        'Create Channel',
        style: AppTypography.geistMedium15.copyWith(color: AppColors.white),
      ),
    );
  }

  // Helper methods
  void _toggleCategory(String categoryId) {
    setState(() {
      _categoryCollapseStates[categoryId] =
          !(_categoryCollapseStates[categoryId] ?? false);
    });
  }

  Color _getChannelColor(ChannelType type) {
    switch (type) {
      case ChannelType.text:
        return AppColors.primary;
      case ChannelType.voice:
        return Colors.green;
      case ChannelType.announcement:
        return Colors.orange;
      case ChannelType.stage:
        return Colors.purple;
      case ChannelType.forum:
        return Colors.blue;
    }
  }

  PhosphorIconData _getChannelIcon(ChannelType type) {
    switch (type) {
      case ChannelType.text:
        return PhosphorIcons.hash();
      case ChannelType.voice:
        return PhosphorIcons.speakerHigh();
      case ChannelType.announcement:
        return PhosphorIcons.megaphone();
      case ChannelType.stage:
        return PhosphorIcons.microphone();
      case ChannelType.forum:
        return PhosphorIcons.chatCircle();
    }
  }

  List<ChannelCategory> _getChannelCategories() {
    return [
      ChannelCategory(
        id: 'general',
        name: 'General',
        icon: PhosphorIcons.chatCircle(),
        channels: [
          const Channel(
            id: 'general',
            name: 'general',
            description: 'General community discussions',
            type: ChannelType.text,
            unreadCount: 5,
            lastMessage: 'Welcome to the community! 🎉',
            recentEmojis: ['🎉', '👋', '🔥'],
          ),
          const Channel(
            id: 'introductions',
            name: 'introductions',
            description: 'Introduce yourself to the community',
            type: ChannelType.text,
            unreadCount: 2,
            lastMessage: 'Hey everyone, new member here!',
            recentEmojis: ['👋', '🎯'],
          ),
          const Channel(
            id: 'announcements',
            name: 'announcements',
            description: 'Important updates and news',
            type: ChannelType.announcement,
            unreadCount: 1,
            lastMessage: 'New governance proposal is live!',
            recentEmojis: ['📢', '🗳️'],
          ),
        ],
      ),
      ChannelCategory(
        id: 'voice',
        name: 'Voice Channels',
        icon: PhosphorIcons.speakerHigh(),
        channels: [
          const Channel(
            id: 'general-voice',
            name: 'General Voice',
            description: 'Join for casual conversations',
            type: ChannelType.voice,
            membersCount: 3,
          ),
          const Channel(
            id: 'community-stage',
            name: 'Community Stage',
            description: 'Weekly community talks',
            type: ChannelType.stage,
            membersCount: 12,
          ),
        ],
      ),
      ChannelCategory(
        id: 'governance',
        name: 'Governance',
        icon: PhosphorIcons.scales(),
        channels: [
          const Channel(
            id: 'proposals',
            name: 'proposals',
            description: 'Submit and discuss governance proposals',
            type: ChannelType.forum,
            unreadCount: 3,
            lastMessage: 'Proposal #42: Treasury allocation',
            recentEmojis: ['🗳️', '💰', '👍'],
          ),
          const Channel(
            id: 'voting',
            name: 'voting',
            description: 'Active votes and results',
            type: ChannelType.text,
            unreadCount: 1,
            lastMessage: 'Vote ends in 2 hours!',
            recentEmojis: ['⏰', '🗳️'],
          ),
        ],
      ),
      ChannelCategory(
        id: 'development',
        name: 'Development',
        icon: PhosphorIcons.code(),
        channels: [
          const Channel(
            id: 'dev-general',
            name: 'dev-general',
            description: 'Development discussions',
            type: ChannelType.text,
            lastMessage: 'Anyone working on the new features?',
            recentEmojis: ['💻', '🚀'],
          ),
          const Channel(
            id: 'dev-private',
            name: 'core-dev',
            description: 'Core development team',
            type: ChannelType.text,
            isPrivate: true,
            unreadCount: 7,
            lastMessage: 'Security patch deployed',
            recentEmojis: ['🔒', '✅'],
          ),
        ],
      ),
    ];
  }

  void _showSearchOverlay() {
    // TODO: Implement search overlay
    debugPrint('Show search overlay');
  }

  void _showCommunityMenu() {
    // TODO: Implement community menu
    debugPrint('Show community menu');
  }

  void _navigateToChannel(Channel channel) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) =>
            ChannelChatPage(community: widget.community, channel: channel),
      ),
    );
  }

  void _showCreateChannelDialog() {
    // TODO: Show create channel dialog
    debugPrint('Show create channel dialog');
  }
}
