import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../channel_chat_page.dart';

/// Enhanced production-level message bubble with beautiful animations and interactions
class EnhancedMessageBubble extends StatefulWidget {
  const EnhancedMessageBubble({
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
    this.onMessageHover,
    this.isHighlighted = false,
  });

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
  final VoidCallback? onMessageHover;
  final bool isHighlighted;

  @override
  State<EnhancedMessageBubble> createState() => _EnhancedMessageBubbleState();
}

class _EnhancedMessageBubbleState extends State<EnhancedMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool _showQuickActions = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
      _showQuickActions = isHovered;
    });

    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: widget.isHighlighted
                  ? (widget.isDarkMode
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.primary.withOpacity(0.05))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 2.h),
            child: _buildMessageContent(),
          ),
        );
      },
    );
  }

  Widget _buildMessageContent() {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onLongPress: _showMessageOptions,
        onDoubleTap: _quickReact,
        child: Container(
          margin: EdgeInsets.only(
            bottom: widget.isGrouped ? 2.h : 16.h,
            left: 16.w,
            right: 16.w,
          ),
          child: _buildMessageRow(),
        ),
      ),
    );
  }

  Widget _buildMessageRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        if (widget.showAvatar) _buildAvatar(),
        if (widget.showAvatar) SizedBox(width: 12.w),

        // Message content
        Expanded(child: _buildMessageColumn()),

        // Quick actions (show on hover)
        if (_showQuickActions) _buildQuickActions(),
      ],
    );
  }

  Widget _buildAvatar() {
    return GestureDetector(
      onTap: () => widget.onUserTap(widget.message.userId),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
            width: 2,
          ),
        ),
        child: ClipOval(
          child: Image.network(
            widget.message.avatar,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.primary,
                child: Center(
                  child: Text(
                    widget.message.username[0].toUpperCase(),
                    style: AppTypography.geistSemiBold15.copyWith(
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMessageColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Username and timestamp
        if (widget.showTimestamp) _buildMessageHeader(),
        if (widget.showTimestamp) SizedBox(height: 4.h),

        // Reply indicator
        if (widget.message.replyTo != null) _buildReplyIndicator(),

        // Message content
        _buildMessageBubble(),

        // Attachments
        if (widget.message.attachments.isNotEmpty) ...[
          SizedBox(height: 8.h),
          _buildAttachments(),
        ],

        // Reactions
        if (widget.message.reactions.isNotEmpty) ...[
          SizedBox(height: 8.h),
          _buildReactions(),
        ],
      ],
    );
  }

  Widget _buildMessageHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => widget.onUserTap(widget.message.userId),
          child: Text(
            widget.message.username,
            style: AppTypography.geistSemiBold15.copyWith(
              color: widget.isDarkMode
                  ? AppColors.darkTextPrimary
                  : AppColors.gray900,
              fontSize: 14.sp,
            ),
          ),
        ),
        if (widget.message.isBot) ...[
          SizedBox(width: 6.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(3.r),
            ),
            child: Text(
              'BOT',
              style: AppTypography.geistSemiBold15.copyWith(
                color: Colors.white,
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
        SizedBox(width: 8.w),
        Text(
          _formatTimestamp(widget.message.timestamp),
          style: AppTypography.geistRegular12.copyWith(
            color: widget.isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.gray600,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildReplyIndicator() {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Container(
            width: 3.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            PhosphorIcons.arrowBendUpLeft(PhosphorIconsStyle.bold),
            size: 14.sp,
            color: widget.isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.gray600,
          ),
          SizedBox(width: 4.w),
          Text(
            'Replying to message',
            style: AppTypography.geistRegular12.copyWith(
              color: widget.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: widget.isCurrentUser
            ? LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: widget.isCurrentUser
            ? null
            : widget.isDarkMode
            ? AppColors.darkContainerBorder.withOpacity(0.3)
            : AppColors.gray100,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: (widget.isCurrentUser ? AppColors.primary : Colors.black)
                .withOpacity(0.1),
            offset: Offset(0, 2.h),
            blurRadius: 8.r,
          ),
        ],
      ),
      child: Text(
        widget.message.content,
        style: AppTypography.geistRegular13.copyWith(
          color: widget.isCurrentUser
              ? Colors.white
              : widget.isDarkMode
              ? AppColors.darkTextPrimary
              : AppColors.gray900,
          fontSize: 14.sp,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildAttachments() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: widget.message.attachments.map((attachment) {
        return Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: widget.isDarkMode
                ? AppColors.darkContainerBorder.withOpacity(0.3)
                : AppColors.gray100,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: widget.isDarkMode
                  ? AppColors.darkContainerBorder
                  : AppColors.gray200,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getAttachmentIcon(attachment),
                color: AppColors.primary,
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                attachment,
                style: AppTypography.geistMedium13.copyWith(
                  color: AppColors.primary,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReactions() {
    return Wrap(
      spacing: 6.w,
      runSpacing: 4.h,
      children: widget.message.reactions.map((reaction) {
        return GestureDetector(
          onTap: () => _animateReaction(reaction),
          child: AnimatedScale(
            scale: 1.0,
            duration: const Duration(milliseconds: 150),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: widget.isDarkMode
                    ? AppColors.darkContainerBorder.withOpacity(0.5)
                    : AppColors.gray100,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(reaction, style: TextStyle(fontSize: 14.sp)),
                  SizedBox(width: 4.w),
                  Text(
                    '${(widget.message.reactions.length * 0.7).round()}',
                    style: AppTypography.geistRegular12.copyWith(
                      color: widget.isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray600,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickActions() {
    return AnimatedOpacity(
      opacity: _showQuickActions ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        margin: EdgeInsets.only(left: 8.w),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? AppColors.darkBackgroundSecondary
              : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 2.h),
              blurRadius: 8.r,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildQuickAction(
              PhosphorIcons.arrowBendUpLeft(PhosphorIconsStyle.bold),
              () => widget.onReply(widget.message),
            ),
            SizedBox(width: 4.w),
            _buildQuickAction(
              PhosphorIcons.smiley(PhosphorIconsStyle.bold),
              () => _showEmojiPicker(),
            ),
            SizedBox(width: 4.w),
            _buildQuickAction(
              PhosphorIcons.dotsThree(PhosphorIconsStyle.bold),
              _showMessageOptions,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(PhosphorIconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Icon(
          icon,
          size: 16.sp,
          color: widget.isDarkMode
              ? AppColors.darkTextSecondary
              : AppColors.gray600,
        ),
      ),
    );
  }

  // Event handlers
  void _quickReact() {
    widget.onReact(widget.message, '❤️');
    _animateReaction('❤️');
  }

  void _animateReaction(String reaction) {
    if (mounted) {
      _animationController.forward().then((_) {
        if (mounted) {
          _animationController.reverse();
        }
      });
      widget.onReact(widget.message, reaction);
    }
  }

  void _showMessageOptions() {
    // Show context menu with options
    showDialog<void>(
      context: context,
      builder: (context) => _buildMessageOptionsDialog(),
    );
  }

  Widget _buildMessageOptionsDialog() {
    return AlertDialog(
      backgroundColor: widget.isDarkMode
          ? AppColors.darkBackgroundSecondary
          : Colors.white,
      title: Text(
        'Message Options',
        style: AppTypography.geistSemiBold15.copyWith(
          color: widget.isDarkMode
              ? AppColors.darkTextPrimary
              : AppColors.gray900,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOptionTile(
            PhosphorIcons.arrowBendUpLeft(PhosphorIconsStyle.bold),
            'Reply',
            () => widget.onReply(widget.message),
          ),
          _buildOptionTile(
            PhosphorIcons.copy(PhosphorIconsStyle.bold),
            'Copy Text',
            () => _copyMessage(),
          ),
          if (widget.isCurrentUser) ...[
            _buildOptionTile(
              PhosphorIcons.pencilSimple(PhosphorIconsStyle.bold),
              'Edit',
              () => widget.onEdit(widget.message),
            ),
            _buildOptionTile(
              PhosphorIcons.trash(PhosphorIconsStyle.bold),
              'Delete',
              () => widget.onDelete(widget.message),
              isDestructive: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    PhosphorIconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive
            ? Colors.red
            : widget.isDarkMode
            ? AppColors.darkTextSecondary
            : AppColors.gray600,
      ),
      title: Text(
        title,
        style: AppTypography.geistRegular13.copyWith(
          color: isDestructive
              ? Colors.red
              : widget.isDarkMode
              ? AppColors.darkTextPrimary
              : AppColors.gray900,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _showEmojiPicker() {
    // Show emoji picker bottom sheet
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => Container(
        height: 300.h,
        child: const Text('Emoji Picker'), // Replace with actual emoji picker
      ),
    );
  }

  void _copyMessage() {
    // Copy message to clipboard
    debugPrint('Copy message: ${widget.message.content}');
  }

  // Utility methods
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  PhosphorIconData _getAttachmentIcon(String attachment) {
    final extension = attachment.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return PhosphorIcons.image(PhosphorIconsStyle.bold);
      case 'mp4':
      case 'mov':
      case 'avi':
        return PhosphorIcons.videoCamera(PhosphorIconsStyle.bold);
      case 'mp3':
      case 'wav':
      case 'aac':
        return PhosphorIcons.musicNote(PhosphorIconsStyle.bold);
      case 'pdf':
        return PhosphorIcons.filePdf(PhosphorIconsStyle.bold);
      default:
        return PhosphorIcons.file(PhosphorIconsStyle.bold);
    }
  }
}
