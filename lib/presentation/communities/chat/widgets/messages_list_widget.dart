import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../domain/models/chat/chat_message.dart';
import 'enhanced_message_bubble.dart';

/// Messages list component with improved UI
class MessagesListWidget extends StatelessWidget {
  const MessagesListWidget({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.isDarkMode,
    required this.onReply,
    required this.onReact,
    required this.onEdit,
    required this.onDelete,
    required this.onUserTap,
  });

  final List<ChatMessage> messages;
  final ScrollController scrollController;
  final bool isDarkMode;
  final void Function(ChatMessage) onReply;
  final void Function(ChatMessage, String) onReact;
  final void Function(ChatMessage) onEdit;
  final void Function(ChatMessage) onDelete;
  final void Function(String) onUserTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isConsecutive =
            index > 0 &&
            messages[index - 1].userId == message.userId &&
            message.timestamp
                    .difference(messages[index - 1].timestamp)
                    .inMinutes <
                5;

        return EnhancedMessageBubble(
          message: message,
          isCurrentUser: message.userId == 'current_user',
          isGrouped: isConsecutive,
          showAvatar: !isConsecutive,
          showTimestamp: !isConsecutive,
          onReply: onReply,
          onReact: onReact,
          onEdit: onEdit,
          onDelete: onDelete,
          onUserTap: onUserTap,
          isDarkMode: isDarkMode,
        );
      },
    );
  }
}
