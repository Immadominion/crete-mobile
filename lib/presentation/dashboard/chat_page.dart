import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';

/// Chat page - Direct messages
/// Shows DM list, group DMs, voice DMs, video DMs, and file sharing
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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
            // Header
            SliverPadding(
              padding: EdgeInsets.only(
                left: 15.8.w,
                right: 15.8.w,
                top: 33.h,
                bottom: 24.h,
              ),
              sliver: SliverToBoxAdapter(child: _buildHeader(isDarkMode)),
            ),

            // Search Bar
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.8.w),
              sliver: SliverToBoxAdapter(child: _buildSearchBar(isDarkMode)),
            ),

            // Direct Messages
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.8.w),
              sliver: SliverToBoxAdapter(
                child: _buildDirectMessages(isDarkMode),
              ),
            ),

            // Group DMs
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.8.w),
              sliver: SliverToBoxAdapter(child: _buildGroupDMs(isDarkMode)),
            ),

            // Bottom padding
            SliverPadding(
              padding: EdgeInsets.only(bottom: 100.h),
              sliver: const SliverToBoxAdapter(child: SizedBox()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chat',
              style: AppTypography.sfProSemiBold32.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
                fontSize: 32.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Direct messages',
              style: AppTypography.geistRegular14.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.black : AppColors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isDarkMode
                  ? AppColors.darkContainerBorder
                  : AppColors.gray200,
            ),
          ),
          child: Icon(
            Icons.add_outlined,
            size: 20.sp,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(bool isDarkMode) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.black : AppColors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isDarkMode
                  ? AppColors.darkContainerBorder
                  : AppColors.gray200,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_outlined,
                size: 20.sp,
                color: isDarkMode
                    ? AppColors.darkTextHeading
                    : AppColors.gray500,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Search conversations',
                  style: AppTypography.geistRegular14.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextHeading
                        : AppColors.gray500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildDirectMessages(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Direct Messages',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        _buildChatCard(
          'alice.sol',
          'Hey! Are you joining the governance call?',
          '2 min ago',
          unreadCount: 3,
          isOnline: true,
          isDarkMode: isDarkMode,
          onTap: () => _navigateToChat('alice.sol'),
        ),
        SizedBox(height: 12.h),
        _buildChatCard(
          'bob_crypto',
          'Thanks for the proposal feedback 👍',
          '1 hour ago',
          unreadCount: 0,
          isOnline: false,
          isDarkMode: isDarkMode,
          onTap: () => _navigateToChat('bob_crypto'),
        ),
        SizedBox(height: 12.h),
        _buildChatCard(
          'charlie.dao',
          'Can you review the treasury docs?',
          '3 hours ago',
          unreadCount: 1,
          isOnline: true,
          isDarkMode: isDarkMode,
          onTap: () => _navigateToChat('charlie.dao'),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildGroupDMs(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Group DMs',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        _buildChatCard(
          'Core Team',
          'alice.sol: Meeting at 3 PM EST',
          '30 min ago',
          unreadCount: 5,
          isDarkMode: isDarkMode,
          isGroup: true,
          onTap: () => _navigateToGroupChat('Core Team'),
        ),
        SizedBox(height: 12.h),
        _buildChatCard(
          'Dev Squad',
          'bob_crypto: New PR ready for review',
          '2 hours ago',
          unreadCount: 0,
          isDarkMode: isDarkMode,
          isGroup: true,
          onTap: () => _navigateToGroupChat('Dev Squad'),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildChatCard(
    String name,
    String lastMessage,
    String time, {
    required int unreadCount,
    bool? isOnline,
    required bool isDarkMode,
    bool isGroup = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.black : AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 37.65.w,
                  height: 37.65.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isGroup
                          ? [AppColors.secondary, AppColors.primaryLight]
                          : [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Icon(
                    isGroup ? Icons.group_outlined : Icons.person_outlined,
                    color: AppColors.white,
                    size: 18.sp,
                  ),
                ),
                if (isOnline != null)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: isOnline
                            ? AppColors.secondary
                            : AppColors.gray400,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDarkMode ? AppColors.black : AppColors.white,
                          width: 2.w,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: AppTypography.geistSemiBold15.copyWith(
                            color: isDarkMode
                                ? AppColors.darkTextPrimary
                                : AppColors.gray900,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: AppTypography.geistRegular11.copyWith(
                          color: isDarkMode
                              ? AppColors.darkTextHeading
                              : AppColors.gray500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage,
                          style: AppTypography.geistRegular12.copyWith(
                            color: isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.gray600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unreadCount > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: AppTypography.geistMedium11.copyWith(
                              color: AppColors.white,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToChat(String username) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChatDetailPage(chatName: username, isGroup: false),
      ),
    );
  }

  void _navigateToGroupChat(String groupName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChatDetailPage(chatName: groupName, isGroup: true),
      ),
    );
  }
}

// Chat Detail Page
class ChatDetailPage extends StatefulWidget {

  const ChatDetailPage({
    super.key,
    required this.chatName,
    required this.isGroup,
  });
  final String chatName;
  final bool isGroup;

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      sender: 'alice.sol',
      message: 'Hey! Are you joining the governance call?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      isMe: false,
    ),
    ChatMessage(
      sender: 'You',
      message: "Yes, I'll be there in 5 minutes",
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      isMe: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundPrimary
          : AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? AppColors.darkBackgroundPrimary
            : AppColors.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.isGroup
                      ? [AppColors.secondary, AppColors.primaryLight]
                      : [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Icon(
                widget.isGroup ? Icons.group_outlined : Icons.person_outlined,
                color: AppColors.white,
                size: 16.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              widget.chatName,
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.videocam_outlined,
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.call_outlined,
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message, isDarkMode);
              },
            ),
          ),
          _buildMessageInput(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isMe) ...[
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Icon(
                Icons.person_outlined,
                color: AppColors.white,
                size: 16.sp,
              ),
            ),
            SizedBox(width: 12.w),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: message.isMe
                        ? AppColors.primary
                        : (isDarkMode ? AppColors.black : AppColors.white),
                    borderRadius: BorderRadius.circular(12.r),
                    border: message.isMe
                        ? null
                        : Border.all(
                            color: isDarkMode
                                ? AppColors.darkContainerBorder
                                : AppColors.gray200,
                          ),
                  ),
                  child: Text(
                    message.message,
                    style: AppTypography.geistRegular14.copyWith(
                      color: message.isMe
                          ? AppColors.white
                          : (isDarkMode
                                ? AppColors.darkTextPrimary
                                : AppColors.gray900),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  _formatTime(message.timestamp),
                  style: AppTypography.geistRegular11.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextHeading
                        : AppColors.gray500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkBackgroundPrimary
            : AppColors.backgroundPrimary,
        border: Border(
          top: BorderSide(
            color: isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.black : AppColors.white,
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(
                  color: isDarkMode
                      ? AppColors.darkContainerBorder
                      : AppColors.gray200,
                ),
              ),
              child: TextField(
                controller: _messageController,
                style: AppTypography.geistRegular14.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: AppTypography.geistRegular14.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextHeading
                        : AppColors.gray500,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: null,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.send, color: AppColors.white, size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          sender: 'You',
          message: _messageController.text.trim(),
          timestamp: DateTime.now(),
          isMe: true,
        ),
      );
    });

    _messageController.clear();
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) {
      return 'now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}

class ChatMessage {

  ChatMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
    required this.isMe,
  });
  final String sender;
  final String message;
  final DateTime timestamp;
  final bool isMe;
}
