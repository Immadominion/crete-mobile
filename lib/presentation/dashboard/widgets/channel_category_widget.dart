import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

/// Model for channel categories and their channels
class ChannelCategory {
  final String name;
  final List<ChannelItem> channels;
  final PhosphorIconData icon;
  final bool isExpanded;

  const ChannelCategory({
    required this.name,
    required this.channels,
    required this.icon,
    this.isExpanded = true,
  });
}

class ChannelItem {
  final String name;
  final String description;
  final ChannelType type;
  final int? unreadCount;
  final int? memberCount;
  final bool isLocked;
  final bool isActive;

  const ChannelItem({
    required this.name,
    required this.description,
    required this.type,
    this.unreadCount,
    this.memberCount,
    this.isLocked = false,
    this.isActive = false,
  });
}

enum ChannelType { text, voice, announcement, governance, thread }

class ChannelCategoryWidget extends StatefulWidget {
  final ChannelCategory category;
  final bool isDarkMode;
  final void Function(ChannelItem)? onChannelTap;
  final VoidCallback? onCategoryToggle;

  const ChannelCategoryWidget({
    super.key,
    required this.category,
    required this.isDarkMode,
    this.onChannelTap,
    this.onCategoryToggle,
  });

  @override
  State<ChannelCategoryWidget> createState() => _ChannelCategoryWidgetState();
}

class _ChannelCategoryWidgetState extends State<ChannelCategoryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.category.isExpanded;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (_isExpanded) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }

    widget.onCategoryToggle?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategoryHeader(),
        SizeTransition(
          sizeFactor: _expandAnimation,
          child: Column(
            children: widget.category.channels.map((channel) {
              return _buildChannelItem(channel);
            }).toList(),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildCategoryHeader() {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        margin: EdgeInsets.only(bottom: 8.h),
        child: Row(
          children: [
            AnimatedRotation(
              turns: _isExpanded ? 0.0 : -0.25,
              duration: const Duration(milliseconds: 300),
              child: PhosphorIcon(
                PhosphorIcons.caretDown(PhosphorIconsStyle.bold),
                size: 12.sp,
                color: widget.isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
            ),
            SizedBox(width: 8.w),
            PhosphorIcon(
              widget.category.icon,
              size: 16.sp,
              color: widget.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
            SizedBox(width: 8.w),
            Text(
              widget.category.name.toUpperCase(),
              style: AppTypography.geistMedium11.copyWith(
                color: widget.isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            if (widget.category.channels.length > 3)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '${widget.category.channels.length}',
                  style: AppTypography.geistMedium11.copyWith(
                    color: AppColors.primary,
                    fontSize: 10.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelItem(ChannelItem channel) {
    return GestureDetector(
      onTap: () => widget.onChannelTap?.call(channel),
      child: Container(
        margin: EdgeInsets.only(bottom: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: channel.isActive
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            SizedBox(width: 16.w), // Indent for hierarchy
            _buildChannelIcon(channel),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          channel.name,
                          style: AppTypography.geistMedium15.copyWith(
                            color: channel.isActive
                                ? AppColors.primary
                                : widget.isDarkMode
                                ? AppColors.darkTextPrimary
                                : AppColors.gray900,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (channel.unreadCount != null &&
                          channel.unreadCount! > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            channel.unreadCount.toString(),
                            style: AppTypography.geistMedium11.copyWith(
                              color: AppColors.white,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      if (channel.memberCount != null &&
                          channel.memberCount! > 0)
                        Container(
                          margin: EdgeInsets.only(left: 8.w),
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6.w,
                                height: 6.w,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                channel.memberCount.toString(),
                                style: AppTypography.geistMedium11.copyWith(
                                  color: Colors.green,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  if (channel.description.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      channel.description,
                      style: AppTypography.geistRegular12.copyWith(
                        color: widget.isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (channel.isLocked)
              PhosphorIcon(
                PhosphorIcons.lock(PhosphorIconsStyle.regular),
                size: 14.sp,
                color: widget.isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray500,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelIcon(ChannelItem channel) {
    PhosphorIconData icon;
    Color color;

    switch (channel.type) {
      case ChannelType.text:
        icon = PhosphorIcons.hash(PhosphorIconsStyle.regular);
        color = widget.isDarkMode
            ? AppColors.darkTextSecondary
            : AppColors.gray600;
        break;
      case ChannelType.voice:
        icon = PhosphorIcons.speakerHigh(PhosphorIconsStyle.regular);
        color = channel.memberCount != null && channel.memberCount! > 0
            ? Colors.green
            : widget.isDarkMode
            ? AppColors.darkTextSecondary
            : AppColors.gray600;
        break;
      case ChannelType.announcement:
        icon = PhosphorIcons.megaphone(PhosphorIconsStyle.regular);
        color = AppColors.primary;
        break;
      case ChannelType.governance:
        icon = PhosphorIcons.scales(PhosphorIconsStyle.regular);
        color = Colors.amber;
        break;
      case ChannelType.thread:
        icon = PhosphorIcons.chatCircle(PhosphorIconsStyle.regular);
        color = widget.isDarkMode
            ? AppColors.darkTextSecondary
            : AppColors.gray600;
        break;
    }

    return PhosphorIcon(icon, size: 16.sp, color: color);
  }
}
