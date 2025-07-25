import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

class CallChatOverlay extends StatefulWidget {
  final VoidCallback onClose;
  final String sessionId;

  const CallChatOverlay({
    super.key,
    required this.onClose,
    required this.sessionId,
  });

  @override
  State<CallChatOverlay> createState() => _CallChatOverlayState();
}

class _CallChatOverlayState extends State<CallChatOverlay>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocus = FocusNode();

  // Demo messages for the call chat
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      senderName: 'Alice',
      message: 'Hey everyone! 👋',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatMessage(
      id: '2',
      senderName: 'Bob',
      message: 'Great to see you all here',
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
    ChatMessage(
      id: '3',
      senderName: 'You',
      message: 'Thanks for joining!',
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      isMe: true,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _messageController.dispose();
    _messageFocus.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderName: 'You',
          message: _messageController.text.trim(),
          timestamp: DateTime.now(),
          isMe: true,
        ),
      );
    });

    _messageController.clear();
  }

  void _closeChat() {
    _slideController.reverse().then((_) {
      widget.onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SlideTransition(
      position: _slideAnimation,
      child: Positioned(
        right: 0,
        top: 0,
        bottom: 0,
        width: 300.w,
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkBackgroundSecondary.withOpacity(0.95)
                : Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              bottomLeft: Radius.circular(20.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(-2, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? AppColors.darkContainerBorder
                          : AppColors.gray200,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Chat',
                        style: AppTypography.geistSemiBold15.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.gray900,
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: _closeChat,
                      child: Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkIconBackground
                              : AppColors.gray100,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 18.sp,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.gray600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Messages
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return _buildMessageBubble(message, isDark);
                  },
                ),
              ),

              // Input
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? AppColors.darkContainerBorder
                          : AppColors.gray200,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        focusNode: _messageFocus,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: AppTypography.geistRegular14.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary.withOpacity(0.6)
                                : AppColors.gray500,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? AppColors.darkIconBackground
                              : AppColors.gray50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                        ),
                        style: AppTypography.geistRegular14.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.gray900,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),

                    SizedBox(width: 8.w),

                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isDark) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: message.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              radius: 12.r,
              backgroundColor: AppColors.primary.withOpacity(0.2),
              child: Text(
                message.senderName[0].toUpperCase(),
                style: AppTypography.geistMedium11.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),

            SizedBox(width: 8.w),
          ],

          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: message.isMe
                    ? AppColors.primary
                    : (isDark
                          ? AppColors.darkIconBackground
                          : AppColors.gray100),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!message.isMe)
                    Text(
                      message.senderName,
                      style: AppTypography.geistMedium11.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600,
                      ),
                    ),

                  Text(
                    message.message,
                    style: AppTypography.geistRegular14.copyWith(
                      color: message.isMe
                          ? Colors.white
                          : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.gray900),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (message.isMe) ...[
            SizedBox(width: 8.w),

            CircleAvatar(
              radius: 12.r,
              backgroundColor: AppColors.secondary.withOpacity(0.2),
              child: Text(
                'M',
                style: AppTypography.geistMedium11.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ChatMessage {
  final String id;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isMe;

  const ChatMessage({
    required this.id,
    required this.senderName,
    required this.message,
    required this.timestamp,
    this.isMe = false,
  });
}
