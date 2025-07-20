import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';

/// Enhanced reaction system with proper toggling behavior and animations
class ReactionsWidget extends StatefulWidget {
  const ReactionsWidget({
    super.key,
    required this.reactions,
    required this.onReactionToggle,
    required this.isDarkMode,
    this.userReactions = const [],
  });

  final Map<String, int> reactions;
  final void Function(String, bool) onReactionToggle;
  final bool isDarkMode;
  final List<String> userReactions;

  @override
  State<ReactionsWidget> createState() => _ReactionsWidgetState();
}

class _ReactionsWidgetState extends State<ReactionsWidget>
    with TickerProviderStateMixin {
  bool _showReactionPicker = false;
  late AnimationController _pickerAnimationController;
  late AnimationController _reactionAnimationController;
  late Animation<double> _pickerScaleAnimation;
  late Animation<double> _pickerOpacityAnimation;
  late Animation<double> _reactionBounceAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pickerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _reactionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pickerScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _pickerAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _pickerOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pickerAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _reactionBounceAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _reactionAnimationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _pickerAnimationController.dispose();
    _reactionAnimationController.dispose();
    super.dispose();
  }

  void _animateReactionToggle() {
    _reactionAnimationController.forward().then((_) {
      _reactionAnimationController.reverse();
    });
  }

  final List<String> _availableReactions = [
    '👍',
    '❤️',
    '😂',
    '😮',
    '😢',
    '😡',
    '🎉',
    '🙏',
  ];
  @override
  Widget build(BuildContext context) {
    final hasReactions = widget.reactions.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Reactions row - existing reactions + add button on same line
        Row(
          children: [
            // Existing reactions
            if (hasReactions)
              Expanded(
                child: Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: widget.reactions.entries.map((entry) {
                    final isSelected = widget.userReactions.contains(entry.key);
                    return AnimatedBuilder(
                      animation: _reactionBounceAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: isSelected
                              ? _reactionBounceAnimation.value
                              : 1.0,
                          child: _buildReactionBubble(
                            entry.key,
                            entry.value,
                            isSelected,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),

            // Add reaction button - always visible
            SizedBox(width: hasReactions ? 8.w : 0),
            _buildAddReactionButton(),
          ],
        ),

        // Reaction picker (when visible)
        if (_showReactionPicker) ...[
          SizedBox(height: 8.h),
          AnimatedBuilder(
            animation: _pickerAnimationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _pickerScaleAnimation.value,
                child: Opacity(
                  opacity: _pickerOpacityAnimation.value,
                  child: _buildReactionPicker(),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildReactionBubble(String emoji, int count, bool isSelected) {
    return GestureDetector(
      onTap: () {
        _animateReactionToggle();
        widget.onReactionToggle(emoji, !isSelected);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.2)
              : widget.isDarkMode
              ? AppColors.darkContainerBorder.withOpacity(0.5)
              : AppColors.gray200,
          borderRadius: BorderRadius.circular(20.r),
          border: isSelected
              ? Border.all(
                  color: AppColors.primary.withOpacity(0.5),
                  width: 1.5,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: 14.sp)),
            SizedBox(width: 4.w),
            Text(
              count.toString(),
              style: AppTypography.geistMedium13.copyWith(
                color: isSelected
                    ? AppColors.primary
                    : widget.isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray700,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddReactionButton() {
    final hasReactions = widget.reactions.isNotEmpty;

    return GestureDetector(
      onTap: () {
        setState(() {
          _showReactionPicker = !_showReactionPicker;
        });

        if (_showReactionPicker) {
          _pickerAnimationController.forward();
        } else {
          _pickerAnimationController.reverse();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: hasReactions ? 6.w : 12.w,
          vertical: hasReactions ? 6.w : 8.h,
        ),
        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? AppColors.darkContainerBorder.withOpacity(0.3)
              : AppColors.gray100,
          borderRadius: BorderRadius.circular(hasReactions ? 20.r : 12.r),
          border: _showReactionPicker
              ? Border.all(
                  color: AppColors.primary.withOpacity(0.5),
                  width: 1.5,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _showReactionPicker ? Icons.close : Icons.add_reaction_outlined,
              color: widget.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
              size: hasReactions ? 16.sp : 18.sp,
            ),
            if (!hasReactions) ...[
              SizedBox(width: 6.w),
              Text(
                'React',
                style: AppTypography.geistMedium13.copyWith(
                  color: widget.isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.gray600,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildReactionPicker() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? AppColors.darkBackgroundSecondary
            : AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _availableReactions
            .map((emoji) => _buildReactionPickerItem(emoji))
            .toList(),
      ),
    );
  }

  Widget _buildReactionPickerItem(String emoji) {
    final isSelected = widget.userReactions.contains(emoji);

    return GestureDetector(
      onTap: () {
        _animateReactionToggle();
        widget.onReactionToggle(emoji, !isSelected);
        setState(() {
          _showReactionPicker = false;
        });
        _pickerAnimationController.reverse();
      },
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.2)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Text(emoji, style: TextStyle(fontSize: 20.sp)),
      ),
    );
  }
}
