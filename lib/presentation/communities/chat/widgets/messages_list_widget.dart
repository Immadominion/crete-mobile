import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../domain/models/chat/chat_message.dart';
import 'enhanced_message_bubble.dart';
import 'message_group_spacer.dart';

/// Production-level messages list with staggered animations and optimized performance
class MessagesListWidget extends StatefulWidget {
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
    this.bottomPadding = 0, // Added parameter for typing indicator padding
  });

  final List<ChatMessage> messages;
  final ScrollController scrollController;
  final bool isDarkMode;
  final void Function(ChatMessage) onReply;
  final void Function(ChatMessage, String) onReact;
  final void Function(ChatMessage) onEdit;
  final void Function(ChatMessage) onDelete;
  final void Function(String) onUserTap;
  final double bottomPadding; // Added field for typing indicator overlay

  @override
  State<MessagesListWidget> createState() => _MessagesListWidgetState();
}

class _MessagesListWidgetState extends State<MessagesListWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Start animation after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView.builder(
        controller: widget.scrollController,
        padding: EdgeInsets.only(
          top: 16.h,
          bottom:
              100.h +
              widget
                  .bottomPadding, // Extra bottom padding for input area + typing indicator
        ),
        itemCount: widget.messages.length * 2 - 1, // Double for spacers
        physics: const BouncingScrollPhysics(), // iOS-style bouncing
        itemBuilder: (context, index) {
          // If odd index, it's a spacer
          if (index.isOdd) {
            final messageIndex = index ~/ 2;
            final currentMessage = widget.messages[messageIndex];
            final nextMessage = messageIndex < widget.messages.length - 1
                ? widget.messages[messageIndex + 1]
                : null;

            final bool isConsecutive =
                nextMessage != null && _isConsecutiveMessage(messageIndex + 1);

            final bool isEndOfGroup =
                nextMessage == null ||
                currentMessage.userId != nextMessage.userId;

            final bool showDateDivider =
                nextMessage != null &&
                _shouldShowDateDivider(currentMessage, nextMessage);

            final String? dateText = showDateDivider
                ? _formatDate(nextMessage.timestamp)
                : null;

            return MessageGroupSpacer(
              isConsecutive: isConsecutive,
              isEndOfGroup: isEndOfGroup,
              isStartOfGroup: !isConsecutive && nextMessage != null,
              showDateDivider: showDateDivider,
              dateText: dateText,
            );
          }

          // Even index, it's a message
          final messageIndex = index ~/ 2;
          final message = widget.messages[messageIndex];
          final isConsecutive = _isConsecutiveMessage(messageIndex);
          final isStartOfGroup =
              messageIndex == 0 ||
              widget.messages[messageIndex].userId !=
                  widget.messages[messageIndex - 1].userId;

          return AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              // Staggered animation for each message
              final delay = (messageIndex * 50).clamp(0, 300).toDouble();
              final animationValue =
                  (_animationController.value * 1000 - delay).clamp(
                    0.0,
                    300.0,
                  ) /
                  300.0;

              // Determine if this is the last message in a group
              final isLastInGroup = _isLastInGroup(messageIndex);

              return Transform.translate(
                offset: Offset(0, 20 * (1 - animationValue)),
                child: Opacity(
                  opacity: animationValue,
                  child: EnhancedMessageBubble(
                    message: message,
                    isCurrentUser: message.userId == 'current_user',
                    isGrouped: isConsecutive && !isStartOfGroup,
                    showAvatar: isStartOfGroup || !isConsecutive,
                    showTimestamp: isStartOfGroup || !isConsecutive,
                    onReply: widget.onReply,
                    onReact: widget.onReact,
                    onEdit: widget.onEdit,
                    onDelete: widget.onDelete,
                    onUserTap: widget.onUserTap,
                    isDarkMode: widget.isDarkMode,
                    isHighlighted: _shouldHighlightMessage(message),
                    isLastInGroup: isLastInGroup,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  bool _shouldShowDateDivider(ChatMessage current, ChatMessage next) {
    final currentDate = DateTime(
      current.timestamp.year,
      current.timestamp.month,
      current.timestamp.day,
    );

    final nextDate = DateTime(
      next.timestamp.year,
      next.timestamp.month,
      next.timestamp.day,
    );

    // Show divider if the date changes or if there's a significant time gap (> 4 hours)
    if (currentDate != nextDate) {
      return true;
    }

    // Also show divider for significant time gaps within the same day
    final timeDifference = next.timestamp.difference(current.timestamp).inHours;
    return timeDifference >= 4; // Show divider if messages are 4+ hours apart
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else {
      // Check if it's within the current year
      if (date.year == now.year) {
        return DateFormat(
          'EEEE, MMMM d',
        ).format(date); // e.g. "Monday, July 20"
      } else {
        return DateFormat('MMMM d, yyyy').format(date); // e.g. "July 20, 2025"
      }
    }
  }

  bool _isConsecutiveMessage(int index) {
    if (index == 0) return false;

    final currentMessage = widget.messages[index];
    final previousMessage = widget.messages[index - 1];

    // Consider messages consecutive if:
    // 1. They're from the same user AND
    // 2. They're within 3 minutes of each other
    return previousMessage.userId == currentMessage.userId &&
        currentMessage.timestamp
                .difference(previousMessage.timestamp)
                .inMinutes <
            3;
  }

  bool _shouldHighlightMessage(ChatMessage message) {
    // Highlight messages with mentions, replies, or special content
    return message.mentionedUsers.isNotEmpty ||
        message.replyTo != null ||
        message.isClaimable == true;
  }

  bool _isLastInGroup(int index) {
    if (index >= widget.messages.length - 1) {
      // Last message is always the last in its group
      return true;
    }

    final currentMessage = widget.messages[index];
    final nextMessage = widget.messages[index + 1];

    // It's the last in a group if:
    // 1. The next message is from a different user OR
    // 2. There's a significant time gap between messages (3+ minutes)
    return currentMessage.userId != nextMessage.userId ||
        nextMessage.timestamp.difference(currentMessage.timestamp).inMinutes >=
            3;
  }
}
