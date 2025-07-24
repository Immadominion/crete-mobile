import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../widgets/enhanced_message_bubble.dart';
import '../widgets/typing_indicator.dart';

/// Individual conversation page for direct messages or group chats
class ConversationPage extends StatefulWidget {
  const ConversationPage({
    super.key,
    required this.conversationId,
    required this.title,
    this.isGroup = false,
  });
  final String conversationId;
  final String title;
  final bool isGroup;

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundPrimary
          : AppColors.backgroundPrimary,
      appBar: _buildAppBar(isDarkMode),
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(child: _buildChatBackground(isDarkMode)),

          // Main content
          Column(
            children: [
              // Messages list
              Expanded(child: _buildMessagesList(isDarkMode)),
              // Message input
              _buildMessageInput(isDarkMode),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatBackground(bool isDarkMode) {
    return Stack(
      children: [
        // Doodle SVG pattern
        Positioned.fill(
          child: Opacity(
            // Increase pattern visibility significantly
            opacity: isDarkMode ? 0.6 : 0.7,
            child: SvgPicture.asset(
              'assets/svgs/doodle.svg',
              fit: BoxFit.cover,
              // Use colorFilter to make SVG more visible
              colorFilter: ColorFilter.mode(
                isDarkMode
                    ? Colors.white.withOpacity(0.3)
                    : Colors.black.withOpacity(0.3),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        // Gradient overlay for readability (subtle)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  // top transparent
                  (isDarkMode
                          ? AppColors.darkBackgroundPrimary
                          : AppColors.backgroundPrimary)
                      .withOpacity(0.0),
                  // bottom light tint
                  (isDarkMode
                          ? AppColors.darkBackgroundPrimary
                          : AppColors.backgroundPrimary)
                      .withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundSecondary
          : AppColors.white,
      elevation: 0, // Remove elevation for cleaner look
      shadowColor: Colors.black.withOpacity(0.05), // Subtle shadow
      leadingWidth: 48.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: Hero(
          tag: 'back_button',
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              customBorder: const CircleBorder(),
              child: Container(
                padding: EdgeInsets.all(8.w),
                child: Icon(
                  PhosphorIcons.arrowLeft(),
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                  size: 24.sp,
                ),
              ),
            ),
          ),
        ),
      ),
      titleSpacing: 0,
      title: InkWell(
        onTap: () => _navigateToProfile(),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              // Avatar with animation
              Hero(
                tag: 'avatar_${widget.conversationId}',
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutQuint,
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.isGroup
                          ? [AppColors.secondary, AppColors.primaryLight]
                          : [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (widget.isGroup
                                    ? AppColors.secondary
                                    : AppColors.primary)
                                .withOpacity(0.25),
                        offset: Offset(0, 2.h),
                        blurRadius: 8.r,
                      ),
                    ],
                  ),
                  child: Center(
                    child: widget.isGroup
                        ? Icon(
                            PhosphorIcons.users(PhosphorIconsStyle.bold),
                            color: AppColors.white,
                            size: 20.sp,
                          )
                        : Text(
                            widget.title[0].toUpperCase(),
                            style: AppTypography.geistSemiBold15.copyWith(
                              color: AppColors.white,
                              fontSize: 18.sp,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: AppTypography.geistSemiBold15.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.gray900,
                        fontSize: 16.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!widget.isGroup)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Online indicator dot
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Online now',
                            style: AppTypography.geistRegular11.copyWith(
                              color: isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : AppColors.gray600,
                              fontSize: 12.sp,
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
      ),
      actions: [
        _buildAppBarActionButton(
          icon: PhosphorIcons.phone(),
          color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray700,
          onTap: _startVoiceCall,
          tooltip: 'Voice Call',
        ),
        _buildAppBarActionButton(
          icon: PhosphorIcons.videoCamera(),
          color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray700,
          onTap: _startVideoCall,
          tooltip: 'Video Call',
        ),
        _buildAppBarActionButton(
          icon: PhosphorIcons.dotsThreeVertical(),
          color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray700,
          onTap: _showMoreOptions,
          tooltip: 'More Options',
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  Widget _buildAppBarActionButton({
    required PhosphorIconData icon,
    required Color color,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 38.w,
            height: 38.h,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Center(
              child: Icon(icon, color: color, size: 22.sp),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToProfile() {
    // TODO: Implement navigation to profile
    print('Navigating to profile');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Viewing ${widget.title}'s profile")),
    );
  }

  Widget _buildMessagesList(bool isDarkMode) {
    // TODO: Replace with actual messages from state management
    final mockMessages = [
      {
        'id': '1',
        'content': 'Hey! How are you doing?',
        'timestamp': '10:30 AM',
        'isMe': false,
        'isRead': true,
        'hasReactions': false,
        'reactions': <String, int>{},
        'hasAttachment': false,
      },
      {
        'id': '2',
        'content':
            "I'm doing great! Just working on some new features for the app.",
        'timestamp': '10:32 AM',
        'isMe': true,
        'isRead': true,
        'hasReactions': true,
        'reactions': {'👍': 1, '🔥': 2},
        'hasAttachment': false,
      },
      {
        'id': '3',
        'content': 'That sounds exciting! Can you tell me more about it?',
        'timestamp': '10:35 AM',
        'isMe': false,
        'isRead': true,
        'hasReactions': false,
        'reactions': <String, int>{},
        'hasAttachment': false,
      },
      {
        'id': '4',
        'content':
            "Sure! We're working on a new DMS system that will make messaging much better.",
        'timestamp': '10:37 AM',
        'isMe': true,
        'isRead': false,
        'hasReactions': false,
        'reactions': <String, int>{},
        'hasAttachment': false,
      },
    ];

    // Mock typing users - in a real app this would be updated from a state management system
    final List<String> typingUsers = ['Alice'];

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        RefreshIndicator(
          onRefresh: _loadOlderMessages,
          color: AppColors.primary,
          backgroundColor: isDarkMode
              ? AppColors.darkBackgroundSecondary
              : AppColors.white,
          displacement: 20.h,
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(
              16.w,
            ).copyWith(bottom: typingUsers.isNotEmpty ? 70.h : 16.h, top: 30.h),
            physics:
                const AlwaysScrollableScrollPhysics(), // Enable pull-to-refresh
            itemCount: mockMessages.length + 1, // +1 for date header
            itemBuilder: (context, index) {
              if (index == 0) {
                // Date header
                return Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 24.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkBackgroundSecondary.withOpacity(0.8)
                          : AppColors.gray100.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: isDarkMode
                            ? AppColors.darkContainerBorder
                            : AppColors.gray200,
                      ),
                    ),
                    child: Text(
                      'Today',
                      style: AppTypography.caption.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray700,
                      ),
                    ),
                  ),
                );
              }

              final messageIndex = index - 1;
              final message = mockMessages[messageIndex];
              final isLastInGroup =
                  messageIndex == mockMessages.length - 1 ||
                  mockMessages[messageIndex + 1]['isMe'] != message['isMe'];

              // Add visual grouping - reduced padding between messages from same user
              final isNextSameUser =
                  messageIndex < mockMessages.length - 1 &&
                  mockMessages[messageIndex + 1]['isMe'] == message['isMe'];

              return Padding(
                padding: EdgeInsets.only(bottom: isNextSameUser ? 8.h : 16.h),
                child: EnhancedMessageBubble(
                  message: message['content']! as String,
                  timestamp: message['timestamp']! as String,
                  isMe: message['isMe']! as bool,
                  isDarkMode: isDarkMode,
                  isRead: message['isRead']! as bool,
                  hasReactions: message['hasReactions']! as bool,
                  reactions: message['reactions']! as Map<String, int>,
                  hasAttachment: message['hasAttachment']! as bool,
                  isLastInGroup: isLastInGroup,
                  onReply: () => _replyToMessage(message['id']! as String),
                  onReact: (emoji) =>
                      _addReaction(message['id']! as String, emoji),
                  onEdit: message['isMe']! as bool
                      ? () => _editMessage(message['id']! as String)
                      : null,
                  onDelete: message['isMe']! as bool
                      ? () => _deleteMessage(message['id']! as String)
                      : null,
                ),
              );
            },
          ),
        ),

        // Typing indicator overlay
        Positioned(
          bottom: 8.h,
          left: 0,
          right: 0,
          child: TypingIndicator(
            typingUsers: typingUsers,
            isDarkMode: isDarkMode,
            onHeightChanged: (height) {
              // This can be used to adjust padding when typing indicator appears/disappears
            },
          ),
        ),
      ],
    );
  }

  // Load older messages when user pulls down to refresh
  Future<void> _loadOlderMessages() async {
    // TODO: Implement loading older messages from your backend/state
    // For now, simulate a loading delay
    await Future<void>.delayed(const Duration(seconds: 1));

    // In a real app, you would fetch older messages here
    print('Loading older messages...');

    // Show feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Loaded older messages'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // Message interaction methods
  void _replyToMessage(String messageId) {
    // TODO: Implement reply functionality
    print('Replying to message $messageId');

    // In a real app, this would set up a reply state
    // and update the message input to show reply context
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Replying to message')));
  }

  void _addReaction(String messageId, String emoji) {
    // If emoji is null, show reaction picker
    if (emoji == '😊') {
      _showReactionPicker(messageId);
      return;
    }

    // TODO: Implement reaction functionality
    print('Adding reaction $emoji to message $messageId');

    // In a real app, this would update the message's reactions in state
    // and send the reaction to your backend

    // Visual feedback
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added reaction: $emoji'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Haptic feedback for added reaction
    HapticFeedback.mediumImpact();
  }

  void _editMessage(String messageId) {
    // TODO: Implement edit functionality
    print('Editing message $messageId');

    // In a real app, this would populate the input field with the message text
    // and change the send button to an update button
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Editing message')));
  }

  void _deleteMessage(String messageId) {
    // TODO: Implement delete functionality
    print('Deleting message $messageId');

    // In a real app, this would remove the message from state
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Message deleted')));
  }

  Widget _buildMessageInput(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.white,
        border: Border(
          top: BorderSide(
            color: isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, -2.h),
            blurRadius: 6.r,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Reply indicator (hidden by default, would show when replying)
          // _buildReplyIndicator(isDarkMode),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Attachment button with hover effect
              _buildIconButton(
                icon: PhosphorIcons.plus(),
                onTap: _showAttachmentOptions,
                color: AppColors.primary,
                tooltip: 'Add attachment',
              ),

              // Message input field with expanded functionality
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.darkIconBackground
                        : AppColors.gray50,
                    borderRadius: BorderRadius.circular(25.r),
                    border: Border.all(
                      color: isDarkMode
                          ? AppColors.darkContainerBorder
                          : AppColors.gray200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          focusNode: _messageFocusNode,
                          style: AppTypography.geistRegular14.copyWith(
                            color: isDarkMode
                                ? AppColors.darkTextPrimary
                                : AppColors.gray900,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: AppTypography.geistRegular14.copyWith(
                              color: isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : AppColors.gray500,
                            ),
                            border: InputBorder.none,
                            isDense: true, // reduce default padding
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isCollapsed: true,
                          ),
                          maxLines: 5,
                          minLines: 1,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (text) {
                            // This would trigger typing indicator for other users
                            // In a real app, this would be debounced and sent to backend
                          },
                        ),
                      ),

                      // Emoji button
                      GestureDetector(
                        onTap: _showEmojiPicker,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: Icon(
                            PhosphorIcons.smileySticker(),
                            color: isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.gray500,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Conditional render of either recording button or send button
              if (_messageController.text.isEmpty)
                _buildIconButton(
                  icon: PhosphorIcons.microphone(PhosphorIconsStyle.fill),
                  onTap: _startVoiceRecording,
                  color: AppColors.secondary,
                  background: AppColors.secondary.withOpacity(0.1),
                  tooltip: 'Record voice message',
                )
              else
                _buildSendButton(isDarkMode),
            ],
          ),

          // Quick actions row (optional - for frequently used responses)
          // _buildQuickActions(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required PhosphorIconData icon,
    required VoidCallback onTap,
    required Color color,
    Color? background,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: background ?? Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(icon, color: color, size: 22.sp),
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton(bool isDarkMode) {
    return GestureDetector(
      onTap: _sendMessage,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              offset: Offset(0, 2.h),
              blurRadius: 6.r,
            ),
          ],
        ),
        child: Icon(
          PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.fill),
          color: AppColors.white,
          size: 20.sp,
        ),
      ),
    );
  }

  void _showEmojiPicker() {
    // TODO: Implement emoji picker
    print('Showing emoji picker');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Emoji picker coming soon')));
  }

  void _startVoiceRecording() {
    // TODO: Implement voice recording
    print('Starting voice recording');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice recording coming soon')),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      // Clear the input field immediately for better UX
      final sentMessage = message;
      _messageController.clear();

      // Add a small delay to simulate network request
      // In a real app, this would be handled by your state management
      Future<void>.delayed(const Duration(milliseconds: 300), () {
        // You would actually update your state here in a real app
        print('Message sent: $sentMessage');

        // Scroll to bottom after sending
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );

        // Haptic feedback for sent message
        HapticFeedback.lightImpact();
      });

      // Sound feedback (optional)
      SystemSound.play(SystemSoundType.click);
    }
  }

  void _startVoiceCall() {
    // TODO: Implement voice call functionality
    print('Starting voice call');
  }

  void _startVideoCall() {
    // TODO: Implement video call functionality
    print('Starting video call');
  }

  void _showMoreOptions() {
    // TODO: Implement more options menu
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkBackgroundSecondary
              : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(PhosphorIcons.userCircle()),
              title: const Text('View Profile'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(PhosphorIcons.gear()),
              title: const Text('Chat Settings'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(PhosphorIcons.prohibit()),
              title: const Text('Block User'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    // TODO: Implement attachment options
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkBackgroundSecondary
              : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(PhosphorIcons.image()),
              title: const Text('Photo'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(PhosphorIcons.file()),
              title: const Text('Document'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(PhosphorIcons.currencyCircleDollar()),
              title: const Text('Send Tokens'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  // Show reaction picker bottom sheet
  void _showReactionPicker(String messageId) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.darkBackgroundSecondary
                : AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10.r,
                offset: Offset(0, -5.h),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.w, bottom: 16.h),
                child: Text(
                  'Quick reactions',
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                  ),
                ),
              ),
              SizedBox(
                height: 60.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      ['👍', '❤️', '😂', '😮', '😢', '😡', '🎉', '🔥', '✅']
                          .map((emoji) => _buildEmojiButton(emoji, messageId))
                          .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmojiButton(String emoji, String messageId) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _addReaction(messageId, emoji);
      },
      child: Container(
        width: 50.w,
        height: 50.h,
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkIconBackground
              : AppColors.gray100,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(emoji, style: TextStyle(fontSize: 24.sp)),
        ),
      ),
    );
  }
}
