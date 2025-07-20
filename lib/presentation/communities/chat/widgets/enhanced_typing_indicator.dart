import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';

/// Advanced typing indicator with fluid animations and user avatars
class EnhancedTypingIndicator extends StatefulWidget {
  const EnhancedTypingIndicator({
    super.key,
    required this.typingUsers,
    required this.isDarkMode,
  });

  final List<String> typingUsers;
  final bool isDarkMode;

  @override
  State<EnhancedTypingIndicator> createState() =>
      _EnhancedTypingIndicatorState();
}

class _EnhancedTypingIndicatorState extends State<EnhancedTypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _dotsController;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Dots animation controller
    _dotsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Slide animation controller
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Create improved bouncing dot animations with better timing
    _dotAnimations = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _dotsController,
          curve: Interval(
            index * 0.15,
            (index * 0.15) + 0.5,
            curve: Curves.elasticOut,
          ),
        ),
      );
    });

    // Start entrance animation
    if (widget.typingUsers.isNotEmpty) {
      _slideController.forward();
    }
  }

  @override
  void didUpdateWidget(EnhancedTypingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.typingUsers.isNotEmpty && oldWidget.typingUsers.isEmpty) {
      _slideController.forward();
    } else if (widget.typingUsers.isEmpty && oldWidget.typingUsers.isNotEmpty) {
      _slideController.reverse();
    }
  }

  @override
  void dispose() {
    _dotsController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.typingUsers.isEmpty) {
      return const SizedBox.shrink();
    }

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? AppColors.darkBackgroundSecondary.withValues(alpha: 0.8)
              : AppColors.backgroundSecondary.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: widget.isDarkMode
                ? AppColors.darkContainerBorder.withValues(alpha: 0.3)
                : AppColors.gray200.withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: widget.isDarkMode ? 0.3 : 0.1,
              ),
              offset: Offset(0, 2.h),
              blurRadius: 8.r,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTypingDots(),
            SizedBox(width: 12.w),
            Flexible(
              child: Text(
                _buildTypingText(),
                style: AppTypography.geistRegular13.copyWith(
                  color: widget.isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.gray600,
                  fontSize: 13.sp,
                  fontStyle: FontStyle.italic,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingDots() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? AppColors.darkContainerBorder.withValues(alpha: 0.3)
            : AppColors.gray100,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) => _buildBouncingDot(index)),
      ),
    );
  }

  Widget _buildBouncingDot(int index) {
    return AnimatedBuilder(
      animation: _dotAnimations[index],
      builder: (context, child) {
        return Container(
          margin: index > 0 ? EdgeInsets.only(left: 4.w) : EdgeInsets.zero,
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            color: widget.isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.gray600,
            shape: BoxShape.circle,
          ),
          transform: Matrix4.translationValues(
            0,
            -4.0 *
                _dotAnimations[index].value *
                (1 - _dotAnimations[index].value),
            0,
          ),
        );
      },
    );
  }

  String _buildTypingText() {
    final users = widget.typingUsers;
    if (users.isEmpty) return '';

    if (users.length == 1) {
      return '${users.first} is typing...';
    } else if (users.length == 2) {
      return '${users[0]} and ${users[1]} are typing...';
    } else if (users.length == 3) {
      return '${users[0]}, ${users[1]}, and ${users[2]} are typing...';
    } else {
      return '${users[0]}, ${users[1]}, and ${users.length - 2} others are typing...';
    }
  }
}
