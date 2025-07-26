import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../pages/conversation_page.dart';
import 'chat_card.dart';

/// DMS Chat Tabs widget - Direct Messages and Group DMs tabs
class DMSChatTabs extends StatelessWidget {
  const DMSChatTabs({
    super.key,
    required this.tabController,
    required this.searchQuery,
  });
  final TabController tabController;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Tab bar
        Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkIconBackground : AppColors.gray50,
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(
              color: isDarkMode
                  ? AppColors.darkContainerBorder
                  : AppColors.gray200,
            ),
          ),
          child: TabBar(
            controller: tabController,
            indicator: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(50.r),
            ),
            splashFactory: NoSplash.splashFactory,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: AppColors.white,
            unselectedLabelColor: isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.gray600,
            labelStyle: AppTypography.geistMedium13.copyWith(fontSize: 14.sp),
            unselectedLabelStyle: AppTypography.geistMedium13.copyWith(
              fontSize: 14.sp,
            ),
            tabs: const [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Direct Messages')],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Group DMs')],
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
  const _DirectMessagesTab({required this.searchQuery});
  final String searchQuery;

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
        'message': "Let's discuss the tokenomics tomorrow",
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

  void _navigateToChat(BuildContext context, String username) {
    // Navigate to conversation page
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) =>
            ConversationPage(conversationId: username, title: username),
      ),
    );
  }
}

/// Group DMs tab content
class _GroupDMsTab extends StatelessWidget {
  const _GroupDMsTab({required this.searchQuery});
  final String searchQuery;

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
