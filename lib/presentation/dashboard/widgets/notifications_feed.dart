import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

/// Model for notification items
class NotificationItem {
  final String title;
  final String description;
  final String time;
  final NotificationType type;
  final bool isRead;
  final VoidCallback? onTap;

  const NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    required this.isRead,
    this.onTap,
  });
}

/// Notification types with their respective icons and colors
enum NotificationType { message, mention, vote, proposal, voice, system }

/// Animated notifications feed with slide-in animation
class NotificationsFeed extends StatefulWidget {
  final List<NotificationItem> notifications;
  final VoidCallback? onSeeAll;

  const NotificationsFeed({
    super.key,
    required this.notifications,
    this.onSeeAll,
  });

  @override
  State<NotificationsFeed> createState() => _NotificationsFeedState();
}

class _NotificationsFeedState extends State<NotificationsFeed>
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
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    // Calculate safe intervals to prevent going over 1.0
    final itemCount = widget.notifications.length;
    if (itemCount == 0) return;

    // Use a more conservative approach for staggered animations
    const maxStaggerRatio = 0.3; // Max 30% of total duration for staggering
    const animationRatio = 0.7; // 70% of total duration for each animation

    final staggerDelay = maxStaggerRatio / itemCount;
    final animationDuration = animationRatio;

    // Create staggered animations for each notification
    _slideAnimations = List.generate(itemCount, (index) {
      final startTime = (index * staggerDelay).clamp(0.0, 0.3);
      final endTime = (startTime + animationDuration).clamp(startTime, 1.0);

      return Tween<double>(begin: 80.0, end: 0.0).animate(
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

    // Start animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) _controller.forward();
      });
    });
  }

  @override
  void didUpdateWidget(NotificationsFeed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notifications.length != widget.notifications.length) {
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
              children: widget.notifications.asMap().entries.map((entry) {
                final index = entry.key;
                final notification = entry.value;

                return Transform.translate(
                  offset: Offset(0, _slideAnimations[index].value),
                  child: Opacity(
                    opacity: _fadeAnimations[index].value,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      child: _buildNotificationItem(notification, isDarkMode),
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
              PhosphorIcons.bell(PhosphorIconsStyle.bold),
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Notifications',
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

  Widget _buildNotificationItem(
    NotificationItem notification,
    bool isDarkMode,
  ) {
    final iconData = _getNotificationIcon(notification.type);
    final iconColor = _getNotificationColor(notification.type);

    return GestureDetector(
      onTap: notification.onTap,
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
          boxShadow: !notification.isRead
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(iconData, color: iconColor, size: 20.sp),
                ),
                if (!notification.isRead)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: AppTypography.geistSemiBold15.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextPrimary
                          : AppColors.gray900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.description,
                    style: AppTypography.geistRegular12.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.time,
                    style: AppTypography.geistRegular11.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextHeading
                          : AppColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PhosphorIconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return PhosphorIcons.chatCircle(PhosphorIconsStyle.bold);
      case NotificationType.mention:
        return PhosphorIcons.at(PhosphorIconsStyle.bold);
      case NotificationType.vote:
        return PhosphorIcons.checkCircle(PhosphorIconsStyle.bold);
      case NotificationType.proposal:
        return PhosphorIcons.fileText(PhosphorIconsStyle.bold);
      case NotificationType.voice:
        return PhosphorIcons.speakerHigh(PhosphorIconsStyle.bold);
      case NotificationType.system:
        return PhosphorIcons.info(PhosphorIconsStyle.bold);
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return AppColors.primary;
      case NotificationType.mention:
        return AppColors.warning;
      case NotificationType.vote:
        return AppColors.success;
      case NotificationType.proposal:
        return AppColors.info;
      case NotificationType.voice:
        return AppColors.primary;
      case NotificationType.system:
        return AppColors.gray600;
    }
  }
}
