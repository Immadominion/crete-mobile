import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../models/chat_models.dart';

/// Production-level typing indicator with animations
class TypingIndicatorWidget extends StatefulWidget {
  final List<TypingIndicator> typingUsers;
  final bool isDarkMode;

  const TypingIndicatorWidget({
    super.key,
    required this.typingUsers,
    required this.isDarkMode,
  });

  @override
  State<TypingIndicatorWidget> createState() => _TypingIndicatorWidgetState();
}

class _TypingIndicatorWidgetState extends State<TypingIndicatorWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    if (widget.typingUsers.isNotEmpty) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(TypingIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.typingUsers.isNotEmpty && oldWidget.typingUsers.isEmpty) {
      _animationController.forward();
    } else if (widget.typingUsers.isEmpty && oldWidget.typingUsers.isNotEmpty) {
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
    if (widget.typingUsers.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  SizedBox(width: 52.w), // Avatar space
                  _buildTypingDots(),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      _buildTypingText(),
                      style: AppTypography.geistRegular13.copyWith(
                        color: widget.isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600,
                        fontSize: 13.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypingDots() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? AppColors.darkContainerBorder.withOpacity(0.3)
            : AppColors.gray100,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBouncingDot(0),
          SizedBox(width: 4.w),
          _buildBouncingDot(1),
          SizedBox(width: 4.w),
          _buildBouncingDot(2),
        ],
      ),
    );
  }

  Widget _buildBouncingDot(int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _getBouncingOffset(index)),
          child: Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  double _getBouncingOffset(int index) {
    final progress = _animationController.value;
    final delayedProgress = (progress - (index * 0.1)).clamp(0.0, 1.0);
    return -4.0 * (1.0 - (delayedProgress * 2.0 - 1.0).abs());
  }

  String _buildTypingText() {
    final users = widget.typingUsers;
    if (users.isEmpty) return '';

    if (users.length == 1) {
      return '${users.first.username} is typing...';
    } else if (users.length == 2) {
      return '${users[0].username} and ${users[1].username} are typing...';
    } else if (users.length == 3) {
      return '${users[0].username}, ${users[1].username}, and ${users[2].username} are typing...';
    } else {
      return '${users[0].username}, ${users[1].username}, and ${users.length - 2} others are typing...';
    }
  }
}
