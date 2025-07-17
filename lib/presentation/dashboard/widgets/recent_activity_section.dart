import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

/// Model for recent activity items
class RecentActivityItem {

  const RecentActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });
  final String title;
  final String subtitle;
  final String time;
  final PhosphorIconData icon;
  final Color iconColor;
  final VoidCallback? onTap;
}

/// Animated recent activity section with staggered animation
class RecentActivitySection extends StatefulWidget {

  const RecentActivitySection({
    super.key,
    required this.activities,
    this.onSeeAll,
  });
  final List<RecentActivityItem> activities;
  final VoidCallback? onSeeAll;

  @override
  State<RecentActivitySection> createState() => _RecentActivitySectionState();
}

class _RecentActivitySectionState extends State<RecentActivitySection>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;

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
    final itemCount = widget.activities.length;
    if (itemCount == 0) return;

    // Use a more conservative approach for staggered animations
    const maxStaggerRatio = 0.3; // Max 30% of total duration for staggering
    const animationRatio = 0.7; // 70% of total duration for each animation

    final staggerDelay = maxStaggerRatio / itemCount;
    const animationDuration = animationRatio;

    // Create staggered animations for each item
    _slideAnimations = List.generate(itemCount, (index) {
      final startTime = (index * staggerDelay).clamp(0.0, 0.3);
      final endTime = (startTime + animationDuration).clamp(startTime, 1.0);

      return Tween<double>(begin: 50.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(startTime, endTime, curve: Curves.easeOutQuart),
        ),
      );
    });

    _fadeAnimations = List.generate(itemCount, (index) {
      final startTime = (index * staggerDelay).clamp(0.0, 0.3);
      final endTime = (startTime + animationDuration).clamp(startTime, 1.0);

      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(startTime, endTime, curve: Curves.easeOut),
        ),
      );
    });

    // Start animation after a delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) _controller.forward();
      });
    });
  }

  @override
  void didUpdateWidget(RecentActivitySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activities.length != widget.activities.length) {
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
            return Column(
              children: widget.activities.asMap().entries.map((entry) {
                final index = entry.key;
                final activity = entry.value;

                return Transform.translate(
                  offset: Offset(0, _slideAnimations[index].value),
                  child: Opacity(
                    opacity: _fadeAnimations[index].value,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      child: _buildActivityItem(activity, isDarkMode),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              PhosphorIcons.clock(PhosphorIconsStyle.bold),
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Recent Activity',
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
        if (widget.onSeeAll != null)
          GestureDetector(
            onTap: widget.onSeeAll,
            child: Text(
              'See All',
              style: AppTypography.geistMedium13.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActivityItem(RecentActivityItem activity, bool isDarkMode) {
    return GestureDetector(
      onTap: activity.onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.black : AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: activity.iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                activity.icon,
                color: activity.iconColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: AppTypography.geistSemiBold15.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextPrimary
                          : AppColors.gray900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    activity.subtitle,
                    style: AppTypography.geistRegular12.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              activity.time,
              style: AppTypography.geistRegular11.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextHeading
                    : AppColors.gray500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
