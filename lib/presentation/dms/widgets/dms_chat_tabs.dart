import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../pages/conversation_page.dart';
import 'chat_card.dart';

/// DMS Chat Tabs widget - Direct Messages and Group DMs tabs
class DMSChatTabs extends StatelessWidget {
  final TabController tabController;
  final String searchQuery;

  const DMSChatTabs({
    super.key,
    required this.tabController,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Tab bar
        Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkIconBackground : AppColors.gray50,
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(
              color: isDarkMode
                  ? AppColors.darkContainerBorder
                  : AppColors.gray200,
              width: 1,
            ),
          ),
          child: TabBar(
            controller: tabController,
            indicator: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20.r),
            ),
            dividerColor: Colors.transparent,
            labelColor: AppColors.white,
            unselectedLabelColor: isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.gray600,
            labelStyle: AppTypography.geistMedium13.copyWith(fontSize: 14.sp),
            unselectedLabelStyle: AppTypography.geistMedium13.copyWith(
              fontSize: 14.sp,
            ),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      PhosphorIcons.chatCircle(PhosphorIconsStyle.regular),
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    const Text('Direct Messages'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      PhosphorIcons.users(PhosphorIconsStyle.regular),
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    const Text('Group DMs'),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),

        // Tab view content
        SizedBox(
          height: 600.h, // Fixed height for the tab content
          child: TabBarView(
            controller: tabController,
            children: [
              _DirectMessagesTab(searchQuery: searchQuery),
              _GroupDMsTab(searchQuery: searchQuery),
            ],
          ),
        ),
      ],
    );
  }
}

/// Direct Messages tab content
class _DirectMessagesTab extends StatelessWidget {
  final String searchQuery;

  const _DirectMessagesTab({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with New button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Direct Messages',
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
                fontSize: 18.sp,
              ),
            ),
            GestureDetector(
              onTap: () => _showNewDMDialog(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      PhosphorIcons.plus(PhosphorIconsStyle.regular),
                      size: 14.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'New',
                      style: AppTypography.geistMedium13.copyWith(
                        color: AppColors.primary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Chat list
        Expanded(
          child: ListView(children: _buildDirectMessagesList(searchQuery)),
        ),
      ],
    );
  }

  List<Widget> _buildDirectMessagesList(String searchQuery) {
    // TODO: Replace with actual data from state management
    final mockDirectMessages = [
      {
        'username': 'alice.sol',
        'message': 'Hey! Are you joining the governance call?',
        'time': '2 min ago',
        'unreadCount': 3,
        'isOnline': true,
        'isTyping': true,
      },
      {
        'username': 'bob_crypto',
        'message': 'Thanks for the proposal feedback 👍',
        'time': '15 min ago',
        'unreadCount': 0,
        'isOnline': true,
        'isTyping': false,
      },
      {
        'username': 'carol_defi',
        'message': 'The NFT drop was amazing! Got my piece',
        'time': '1 hour ago',
        'unreadCount': 1,
        'isOnline': false,
        'isTyping': false,
      },
      {
        'username': 'dave_sol',
        'message': 'Let\'s discuss the tokenomics tomorrow',
        'time': '3 hours ago',
        'unreadCount': 0,
        'isOnline': true,
        'isTyping': false,
      },
    ];

    // Filter based on search query
    final filteredMessages = searchQuery.isEmpty
        ? mockDirectMessages
        : mockDirectMessages
              .where(
                (dm) =>
                    (dm['username']! as String).toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ||
                    (dm['message']! as String).toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ),
              )
              .toList();

    return filteredMessages
        .map(
          (dm) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Builder(
              builder: (context) => ChatCard(
                username: dm['username']! as String,
                message: dm['message']! as String,
                time: dm['time']! as String,
                unreadCount: dm['unreadCount']! as int,
                isOnline: dm['isOnline']! as bool,
                isTyping: dm['isTyping']! as bool,
                onTap: () =>
                    _navigateToChat(context, dm['username']! as String),
              ),
            ),
          ),
        )
        .toList();
  }

  void _showNewDMDialog(BuildContext context) {
    // TODO: Implement new DM dialog
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Direct Message'),
        content: const Text('Select a user to start a conversation'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Select'),
          ),
        ],
      ),
    );
  }

  void _navigateToChat(BuildContext context, String username) {
    // Navigate to conversation page
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => ConversationPage(
          conversationId: username,
          title: username,
          isGroup: false,
        ),
      ),
    );
  }
}

/// Group DMs tab content
class _GroupDMsTab extends StatelessWidget {
  final String searchQuery;

  const _GroupDMsTab({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with New button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Group Chats',
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
                fontSize: 18.sp,
              ),
            ),
            GestureDetector(
              onTap: () => _showNewGroupDialog(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      PhosphorIcons.plus(PhosphorIconsStyle.regular),
                      size: 14.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'New',
                      style: AppTypography.geistMedium13.copyWith(
                        color: AppColors.primary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Group chat list
        Expanded(child: ListView(children: _buildGroupChatsList(searchQuery))),
      ],
    );
  }

  List<Widget> _buildGroupChatsList(String searchQuery) {
    // TODO: Replace with actual data from state management
    final mockGroupChats = [
      {
        'groupName': 'Solana Developers',
        'message': 'Emma: The new SDK update looks promising',
        'time': '5 min ago',
        'unreadCount': 7,
        'memberCount': 12,
        'isActive': true,
      },
      {
        'groupName': 'DeFi Discussion',
        'message': 'Alex: Anyone tried the new yield farming?',
        'time': '30 min ago',
        'unreadCount': 2,
        'memberCount': 8,
        'isActive': true,
      },
      {
        'groupName': 'NFT Collectors',
        'message': 'Sarah: Minting starts in 1 hour!',
        'time': '2 hours ago',
        'unreadCount': 0,
        'memberCount': 25,
        'isActive': false,
      },
    ];

    // Filter based on search query
    final filteredGroups = searchQuery.isEmpty
        ? mockGroupChats
        : mockGroupChats
              .where(
                (group) =>
                    (group['groupName']! as String).toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ) ||
                    (group['message']! as String).toLowerCase().contains(
                      searchQuery.toLowerCase(),
                    ),
              )
              .toList();

    return filteredGroups
        .map(
          (group) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Builder(
              builder: (context) => ChatCard(
                username: group['groupName']! as String,
                message: group['message']! as String,
                time: group['time']! as String,
                unreadCount: group['unreadCount']! as int,
                isOnline: group['isActive']! as bool,
                isTyping: false,
                isGroup: true,
                memberCount: group['memberCount']! as int,
                onTap: () => _navigateToGroupChat(
                  context,
                  group['groupName']! as String,
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  void _showNewGroupDialog(BuildContext context) {
    // TODO: Implement new group dialog
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Group Chat'),
        content: const Text('Create a new group conversation'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _navigateToGroupChat(BuildContext context, String groupName) {
    // Navigate to group conversation page
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => ConversationPage(
          conversationId: groupName,
          title: groupName,
          isGroup: true,
        ),
      ),
    );
  }
}
