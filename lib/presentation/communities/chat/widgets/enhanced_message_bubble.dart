import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../../../../domain/models/chat/chat_message.dart';
import 'asset_message_card.dart';
import 'reactions_widget.dart';

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
              return ColoredBox(
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
        // Username and timestamp row
        if (widget.showTimestamp) _buildUsernameRow(),

        // Message content
        Builder(
          builder: (context) {
            // Choose the appropriate display based on message type
            if (widget.message.type == MessageType.sticker) {
              return _buildStickerMessage();
            } else if (widget.message.sentAsset != null &&
                (widget.message.type == MessageType.token ||
                    widget.message.type == MessageType.nft ||
                    widget.message.type == MessageType.role ||
                    widget.message.type == MessageType.tag)) {
              return _buildAssetMessage();
            } else {
              return _buildMessageBubble();
            }
          },
        ),

        // Attachments
        if (widget.message.attachments.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: 8.h),
            child: _buildAttachments(),
          ),

        // Reactions - now shows proper reaction interface
        Container(
          margin: EdgeInsets.only(top: 8.h),
          child: ReactionsWidget(
            reactions: _convertReactionsList(widget.message.reactions),
            onReactionToggle: (reaction, isAdding) {
              widget.onReact(widget.message, reaction);
            },
            isDarkMode: widget.isDarkMode,
          ),
        ),
      ],
    );
  }

  Widget _buildAssetMessage() {
    final asset = widget.message.sentAsset;
    if (asset == null) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 4.h),
      child: AssetMessageCard(
        asset: asset,
        type: widget.message.type,
        isClaimable: widget.message.isClaimable,
        claimableUntil: widget.message.claimableUntil,
        isDarkMode: widget.isDarkMode,
        onClaim: () {
          // TODO: Implement claim functionality
          debugPrint('Claiming asset: ${asset.name}');
        },
      ),
    );
  }

  // Methods removed as they're now handled by modular components

  Widget _buildUsernameRow() {
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

  // Method removed as it's not used

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

  // Method removed as it's now handled by ReactionsWidget

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

  // Helper method to convert reaction list to map for ReactionsWidget
  Map<String, int> _convertReactionsList(List<String> reactions) {
    final Map<String, int> reactionCounts = {};
    for (final reaction in reactions) {
      reactionCounts[reaction] = (reactionCounts[reaction] ?? 0) + 1;
    }
    return reactionCounts;
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
      builder: (context) => SizedBox(
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

  Widget _buildStickerMessage() {
    return Container(
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? AppColors.darkContainerBorder.withOpacity(0.15)
            : AppColors.gray50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(widget.message.content, style: TextStyle(fontSize: 64.sp)),
    );
  }
}
