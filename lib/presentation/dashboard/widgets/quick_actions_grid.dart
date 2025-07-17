import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

/// Model for quick action items
class QuickActionItem {
  final String title;
  final String subtitle;
  final PhosphorIconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const QuickActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });
}

/// Animated quick actions grid with hover effects
class QuickActionsGrid extends StatefulWidget {
  final List<QuickActionItem> actions;

  const QuickActionsGrid({super.key, required this.actions});

  @override
  State<QuickActionsGrid> createState() => _QuickActionsGridState();
}

class _QuickActionsGridState extends State<QuickActionsGrid>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _rotationAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Calculate safe intervals to prevent going over 1.0
    final itemCount = widget.actions.length;
    if (itemCount == 0) return;

    // Use a more conservative approach for staggered animations
    const maxStaggerRatio = 0.3; // Max 30% of total duration for staggering
    const animationRatio = 0.7; // 70% of total duration for each animation

    final staggerDelay = maxStaggerRatio / itemCount;
    final animationDuration = animationRatio;

    // Create staggered animations for each action
    _scaleAnimations = List.generate(itemCount, (index) {
      final startTime = (index * staggerDelay).clamp(0.0, 0.3);
      final endTime = (startTime + animationDuration).clamp(startTime, 1.0);

      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(startTime, endTime, curve: Curves.elasticOut),
        ),
      );
    });

    _rotationAnimations = List.generate(itemCount, (index) {
      final startTime = (index * staggerDelay).clamp(0.0, 0.3);
      final endTime = (startTime + animationDuration).clamp(startTime, 1.0);

      return Tween<double>(begin: 0.5, end: 0.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(startTime, endTime, curve: Curves.easeOut),
        ),
      );
    });

    // Start animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) _controller.forward();
      });
    });
  }

  @override
  void didUpdateWidget(QuickActionsGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.actions.length != widget.actions.length) {
      _controller.dispose();
      _initializeAnimations();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(isDarkMode),
        SizedBox(height: 16.h),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 1.2,
              ),
              itemCount: widget.actions.length,
              itemBuilder: (context, index) {
                final action = widget.actions[index];
                return Transform.scale(
                  scale: _scaleAnimations[index].value,
                  child: Transform.rotate(
                    angle: _rotationAnimations[index].value,
                    child: _buildActionCard(action, isDarkMode),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(bool isDarkMode) {
    return Row(
      children: [
        Icon(
          PhosphorIcons.lightning(PhosphorIconsStyle.bold),
          color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
          size: 20.sp,
        ),
        SizedBox(width: 8.w),
        Text(
          'Quick Actions',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 18.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(QuickActionItem action, bool isDarkMode) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.black : AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: action.iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(action.icon, color: action.iconColor, size: 24.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              action.title,
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              action.subtitle,
              style: AppTypography.geistRegular11.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
