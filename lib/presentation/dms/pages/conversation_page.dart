import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

/// Individual conversation page for direct messages or group chats
class ConversationPage extends StatefulWidget {
  final String conversationId;
  final String title;
  final bool isGroup;

  const ConversationPage({
    super.key,
    required this.conversationId,
    required this.title,
    this.isGroup = false,
  });

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
      body: Column(
        children: [
          // Messages list
          Expanded(child: _buildMessagesList(isDarkMode)),
          // Message input
          _buildMessageInput(isDarkMode),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDarkMode) {
    return AppBar(
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundSecondary
          : AppColors.white,
      elevation: 1,
      leading: IconButton(
        icon: Icon(
          PhosphorIcons.arrowLeft(PhosphorIconsStyle.regular),
          color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          // Avatar
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.isGroup
                    ? [AppColors.secondary, AppColors.primaryLight]
                    : [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: widget.isGroup
                  ? Icon(
                      PhosphorIcons.users(PhosphorIconsStyle.regular),
                      color: AppColors.white,
                      size: 18.sp,
                    )
                  : Text(
                      widget.title[0].toUpperCase(),
                      style: AppTypography.geistSemiBold15.copyWith(
                        color: AppColors.white,
                        fontSize: 16.sp,
                      ),
                    ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                    fontSize: 16.sp,
                  ),
                ),
                if (!widget.isGroup)
                  Text(
                    'Online now',
                    style: AppTypography.geistRegular11.copyWith(
                      color: AppColors.secondary,
                      fontSize: 12.sp,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            PhosphorIcons.phone(PhosphorIconsStyle.regular),
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray700,
          ),
          onPressed: () => _startVoiceCall(),
        ),
        IconButton(
          icon: Icon(
            PhosphorIcons.videoCamera(PhosphorIconsStyle.regular),
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray700,
          ),
          onPressed: () => _startVideoCall(),
        ),
        IconButton(
          icon: Icon(
            PhosphorIcons.dotsThreeVertical(PhosphorIconsStyle.regular),
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray700,
          ),
          onPressed: () => _showMoreOptions(),
        ),
      ],
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
      },
      {
        'id': '2',
        'content':
            'I\'m doing great! Just working on some new features for the app.',
        'timestamp': '10:32 AM',
        'isMe': true,
        'isRead': true,
      },
      {
        'id': '3',
        'content': 'That sounds exciting! Can you tell me more about it?',
        'timestamp': '10:35 AM',
        'isMe': false,
        'isRead': true,
      },
      {
        'id': '4',
        'content':
            'Sure! We\'re working on a new DMS system that will make messaging much better.',
        'timestamp': '10:37 AM',
        'isMe': true,
        'isRead': false,
      },
    ];

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16.w),
      itemCount: mockMessages.length,
      itemBuilder: (context, index) {
        final message = mockMessages[index];
        return _buildMessageBubble(message, isDarkMode);
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isDarkMode) {
    final isMe = message['isMe'] as bool;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: 0.75.sw),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isMe
                ? AppColors.primary
                : (isDarkMode
                      ? AppColors.darkIconBackground
                      : AppColors.gray100),
            borderRadius: BorderRadius.circular(20.r).copyWith(
              bottomRight: isMe ? Radius.circular(4.r) : null,
              bottomLeft: !isMe ? Radius.circular(4.r) : null,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message['content'] as String,
                style: AppTypography.geistRegular14.copyWith(
                  color: isMe
                      ? AppColors.white
                      : (isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.gray900),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                message['timestamp'] as String,
                style: AppTypography.geistRegular11.copyWith(
                  color: isMe
                      ? AppColors.white.withOpacity(0.7)
                      : (isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray500),
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Attachment button
          IconButton(
            icon: Icon(
              PhosphorIcons.plus(PhosphorIconsStyle.regular),
              color: AppColors.primary,
            ),
            onPressed: () => _showAttachmentOptions(),
          ),
          // Message input field
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkIconBackground
                    : AppColors.gray50,
                borderRadius: BorderRadius.circular(25.r),
                border: Border.all(
                  color: isDarkMode
                      ? AppColors.darkContainerBorder
                      : AppColors.gray200,
                  width: 1,
                ),
              ),
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
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (value) => _sendMessage(),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // Send button
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.fill),
                color: AppColors.white,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      // TODO: Implement message sending logic
      print('Sending message: $message');
      _messageController.clear();
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
              leading: Icon(
                PhosphorIcons.userCircle(PhosphorIconsStyle.regular),
              ),
              title: const Text('View Profile'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(PhosphorIcons.gear(PhosphorIconsStyle.regular)),
              title: const Text('Chat Settings'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(PhosphorIcons.prohibit(PhosphorIconsStyle.regular)),
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
              leading: Icon(PhosphorIcons.image(PhosphorIconsStyle.regular)),
              title: const Text('Photo'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(PhosphorIcons.file(PhosphorIconsStyle.regular)),
              title: const Text('Document'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(
                PhosphorIcons.currencyCircleDollar(PhosphorIconsStyle.regular),
              ),
              title: const Text('Send Tokens'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
