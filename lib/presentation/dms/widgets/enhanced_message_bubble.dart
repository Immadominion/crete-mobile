import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

/// Enhanced message bubble with animations and interactions for DMS
class EnhancedMessageBubble extends StatefulWidget {
  const EnhancedMessageBubble({
    super.key,
    required this.message,
    required this.timestamp,
    required this.isMe,
    required this.isDarkMode,
    this.isRead = false,
    this.hasReactions = false,
    this.reactions = const {},
    this.hasAttachment = false,
    this.attachmentType,
    this.attachmentPreview,
    this.isLastInGroup = false,
    this.onReply,
    this.onReact,
    this.onEdit,
    this.onDelete,
    this.onTap,
    this.onLongPress,
  });

  final String message;
  final String timestamp;
  final bool isMe;
  final bool isDarkMode;
  final bool isRead;
  final bool hasReactions;
  final Map<String, int> reactions;
  final bool hasAttachment;
  final String? attachmentType;
  final Widget? attachmentPreview;
  final bool isLastInGroup;
  final VoidCallback? onReply;
  final Function(String)? onReact;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  State<EnhancedMessageBubble> createState() => _EnhancedMessageBubbleState();
}

class _EnhancedMessageBubbleState extends State<EnhancedMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool _showActions = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuint),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleActions() {
    setState(() {
      _showActions = !_showActions;
      if (_showActions) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_showActions) {
          setState(() {
            _showActions = false;
            _animationController.reverse();
          });
        } else if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      onLongPress: () {
        _toggleActions();
        if (widget.onLongPress != null) {
          widget.onLongPress!();
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            alignment: widget.isMe
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: child,
          );
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: widget.isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: widget.isMe ? 64.w : 0,
                    right: !widget.isMe ? 64.w : 0,
                    bottom: 4.h,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getBubbleColor(),
                    borderRadius: _getBubbleRadius(),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5.r,
                        offset: Offset(0, 2.h),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Attachment preview if exists
                      if (widget.hasAttachment &&
                          widget.attachmentPreview != null) ...[
                        widget.attachmentPreview!,
                        SizedBox(height: 8.h),
                      ],

                      // Message text
                      Text(
                        widget.message,
                        style: AppTypography.geistRegular14.copyWith(
                          color: _getTextColor(),
                        ),
                      ),

                      SizedBox(height: 4.h),

                      // Timestamp and read status
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.timestamp,
                            style: AppTypography.geistRegular11.copyWith(
                              color: _getSecondaryTextColor(),
                              fontSize: 11.sp,
                            ),
                          ),
                          if (widget.isMe) ...[
                            SizedBox(width: 4.w),
                            Icon(
                              widget.isRead
                                  ? PhosphorIcons.checkCircle(
                                      PhosphorIconsStyle.fill,
                                    )
                                  : PhosphorIcons.check(
                                      
                                    ),
                              size: 12.sp,
                              color: widget.isRead
                                  ? AppColors.secondary
                                  : _getSecondaryTextColor(),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Reactions
                if (widget.hasReactions) _buildReactions(),
              ],
            ),

            // Quick actions
            if (_showActions) _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Positioned(
      top: -10.h,
      right: widget.isMe ? null : 70.w,
      left: widget.isMe ? 70.w : null,
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? AppColors.darkBackgroundSecondary
              : AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionButton(
              icon: PhosphorIcons.arrowBendUpLeft(),
              onTap: widget.onReply,
              tooltip: 'Reply',
            ),
            _buildActionButton(
              icon: PhosphorIcons.smileySticker(),
              onTap: () => widget.onReact?.call('😊'),
              tooltip: 'React',
            ),
            if (widget.isMe) ...[
              _buildActionButton(
                icon: PhosphorIcons.pencilSimple(),
                onTap: widget.onEdit,
                tooltip: 'Edit',
              ),
              _buildActionButton(
                icon: PhosphorIcons.trash(),
                onTap: widget.onDelete,
                tooltip: 'Delete',
                isDestructive: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required PhosphorIconData icon,
    VoidCallback? onTap,
    required String tooltip,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: tooltip,
        child: Container(
          width: 32.w,
          height: 32.h,
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Icon(
            icon,
            size: 18.sp,
            color: isDestructive
                ? Colors.red
                : (widget.isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.gray700),
          ),
        ),
      ),
    );
  }

  Widget _buildReactions() {
    return Container(
      margin: EdgeInsets.only(
        left: widget.isMe ? 80.w : 16.w,
        right: widget.isMe ? 16.w : 80.w,
      ),
      child: Wrap(
        spacing: 8.w,
        children: widget.reactions.entries.map((entry) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? AppColors.darkIconBackground
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
                Text(entry.key),
                SizedBox(width: 4.w),
                Text(
                  entry.value.toString(),
                  style: AppTypography.geistMedium11.copyWith(
                    color: widget.isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray700,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  BorderRadius _getBubbleRadius() {
    const double regularRadius = 20;
    const double specialRadius = 4;

    return BorderRadius.only(
      topLeft: Radius.circular(regularRadius.r),
      topRight: Radius.circular(regularRadius.r),
      bottomLeft: Radius.circular(
        widget.isMe
            ? regularRadius.r
            : (widget.isLastInGroup ? specialRadius.r : regularRadius.r),
      ),
      bottomRight: Radius.circular(
        widget.isMe
            ? (widget.isLastInGroup ? specialRadius.r : regularRadius.r)
            : regularRadius.r,
      ),
    );
  }

  Color _getBubbleColor() {
    if (widget.isMe) {
      return AppColors.primary;
    } else {
      return widget.isDarkMode
          ? AppColors.darkIconBackground
          : AppColors.gray100;
    }
  }

  Color _getTextColor() {
    if (widget.isMe) {
      return AppColors.white;
    } else {
      return widget.isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900;
    }
  }

  Color _getSecondaryTextColor() {
    if (widget.isMe) {
      return AppColors.white.withOpacity(0.7);
    } else {
      return widget.isDarkMode
          ? AppColors.darkTextSecondary
          : AppColors.gray500;
    }
  }
}
