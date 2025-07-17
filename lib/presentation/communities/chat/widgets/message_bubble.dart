import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../models/chat_models.dart';

/// Production-level animated message bubble widget
class MessageBubble extends StatefulWidget {
  final ChatMessage message;
  final bool isCurrentUser;
  final bool isGrouped;
  final bool showAvatar;
  final bool showTimestamp;
  final void Function(ChatMessage) onReply;
  final void Function(ChatMessage, String) onReact;
  final void Function(ChatMessage) onEdit;
  final void Function(ChatMessage) onDelete;
  final void Function(String) onUserTap;
  final bool isDarkMode;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.isGrouped,
    required this.showAvatar,
    required this.showTimestamp,
    required this.onReply,
    required this.onReact,
    required this.onEdit,
    required this.onDelete,
    required this.onUserTap,
    required this.isDarkMode,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _showReactions = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: EdgeInsets.only(
            top: widget.isGrouped ? 2.h : 8.h,
            bottom: 2.h,
            left: 16.w,
            right: 16.w,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              if (widget.showAvatar)
                GestureDetector(
                  onTap: () => widget.onUserTap(widget.message.userId),
                  child: CircleAvatar(
                    radius: 16.r,
                    backgroundImage: NetworkImage(widget.message.avatar),
                    backgroundColor: widget.isDarkMode
                        ? AppColors.darkBackgroundSecondary
                        : AppColors.gray200,
                  ),
                )
              else
                SizedBox(width: 32.w),
              SizedBox(width: 8.w),
              // Message content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header (username and timestamp)
                    if (!widget.isGrouped)
                      Row(
                        children: [
                          Text(
                            widget.message.displayName,
                            style: AppTypography.geistMedium13.copyWith(
                              color: widget.isDarkMode
                                  ? AppColors.darkTextPrimary
                                  : AppColors.gray900,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            _formatTimestamp(widget.message.timestamp),
                            style: AppTypography.geistRegular12.copyWith(
                              color: widget.isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : AppColors.gray500,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: widget.isGrouped ? 0 : 4.h),
                    // Message content
                    _buildMessageContent(),
                    // Reactions
                    if (widget.message.reactions.isNotEmpty)
                      _buildReactions(),
                    // Timestamp for grouped messages
                    if (widget.showTimestamp && widget.isGrouped)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          _formatTimestamp(widget.message.timestamp),
                          style: AppTypography.geistRegular12.copyWith(
                            color: widget.isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.gray500,
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

  Widget _buildMessageContent() {
    return GestureDetector(
      onLongPress: _showContextMenu,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? AppColors.darkBackgroundSecondary
              : AppColors.gray100,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: widget.isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reply indicator
            if (widget.message.replyTo != null)
              _buildReplyIndicator(),
            // Message text
            Text(
              widget.message.content,
              style: AppTypography.geistRegular14.copyWith(
                color: widget.isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
            ),
            // Attachments
            if (widget.message.attachments.isNotEmpty)
              _buildAttachments(),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyIndicator() {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? AppColors.darkBackgroundPrimary
            : AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: widget.isDarkMode
              ? AppColors.darkContainerBorder
              : AppColors.gray200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            PhosphorIcons.arrowBendUpLeft(),
            size: 12.sp,
            color: widget.isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.gray500,
          ),
          SizedBox(width: 4.w),
          Text(
            'Reply to message',
            style: AppTypography.geistRegular12.copyWith(
              color: widget.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachments() {
    return Column(
      children: widget.message.attachments.map((attachment) {
        if (attachment.type == AttachmentType.image) {
          return Container(
            margin: EdgeInsets.only(top: 8.h),
            height: 200.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: widget.isDarkMode
                    ? AppColors.darkContainerBorder
                    : AppColors.gray200,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                attachment.url,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: widget.isDarkMode
                        ? AppColors.darkBackgroundPrimary
                        : AppColors.gray100,
                    child: Icon(
                      PhosphorIcons.image(),
                      size: 40.sp,
                      color: widget.isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray500,
                    ),
                  );
                },
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      }).toList(),
    );
  }

  Widget _buildReactions() {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Wrap(
        spacing: 4.w,
        children: widget.message.reactions.map((reaction) {
          return GestureDetector(
            onTap: () => widget.onReact(widget.message, reaction.emoji),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: widget.isDarkMode
                    ? AppColors.darkBackgroundSecondary
                    : AppColors.gray100,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: widget.isDarkMode
                      ? AppColors.darkContainerBorder
                      : AppColors.gray200,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    reaction.emoji,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    reaction.count.toString(),
                    style: AppTypography.geistMedium11.copyWith(
                      color: widget.isDarkMode
                          ? AppColors.darkTextPrimary
                          : AppColors.gray900,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showContextMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: widget.isDarkMode ? AppColors.black : AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: widget.isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildContextMenuItem(
              PhosphorIcons.arrowBendUpLeft(),
              'Reply',
              () => widget.onReply(widget.message),
            ),
            _buildContextMenuItem(
              PhosphorIcons.smiley(),
              'Add Reaction',
              () => widget.onReact(widget.message, '👍'),
            ),
            if (widget.isCurrentUser) ...[
              _buildContextMenuItem(
                PhosphorIcons.pencil(),
                'Edit',
                () => widget.onEdit(widget.message),
              ),
              _buildContextMenuItem(
                PhosphorIcons.trash(),
                'Delete',
                () => widget.onDelete(widget.message),
                isDestructive: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
    PhosphorIconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? AppColors.error
            : (widget.isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900),
      ),
      title: Text(
        title,
        style: AppTypography.geistMedium13.copyWith(
          color: isDestructive
              ? AppColors.error
              : (widget.isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'now';
    }
  }
}
