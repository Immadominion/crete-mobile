import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

class SettingsSectionCard extends StatelessWidget {
  const SettingsSectionCard({super.key, required this.isDarkMode});
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: AppTypography.heading5.copyWith(
            color: isDarkMode ? Colors.white : AppColors.gray900,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.2)
                    : Colors.white.withOpacity(0.6),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),

        // Settings grid with glassmorphic cards
        _buildSettingsGrid(),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildSettingsGrid() {
    final settings = [
      {
        'icon': PhosphorIcons.sun(),
        'title': 'Theme',
        'subtitle': 'Light, Dark, or System',
      },
      {
        'icon': PhosphorIcons.bell(),
        'title': 'Notifications',
        'subtitle': 'Manage preferences',
      },
      {
        'icon': PhosphorIcons.shield(),
        'title': 'Security',
        'subtitle': 'Privacy & security',
      },
      {
        'icon': PhosphorIcons.globe(),
        'title': 'Language',
        'subtitle': 'App language',
      },
    ];

    return Column(
      children: [
        // Top row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSettingCard(settings[0]),
            _buildSettingCard(settings[2]),
            _buildSettingCard(settings[1]),
          ],
        ),
        SizedBox(height: 7.h),
        // Bottom row
        Row(children: [_buildSettingCard(settings[3])]),
      ],
    );
  }

  Widget _buildSettingCard(Map<String, dynamic> setting) {
    return Container(
      constraints: BoxConstraints.tight(Size(116.w, 100.h)),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: isDarkMode
            ? AppColors.black
            : AppColors.chatBubbleOther.withAlpha(150),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon with glow effect
          Icon(
            setting['icon'] as IconData,
            color: !isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
            size: 24.sp,
          ),
          const Spacer(),

          // Title and subtitle
          Text(
            setting['title'] as String,
            style: AppTypography.geistMedium13.copyWith(
              color: isDarkMode ? Colors.white : AppColors.gray900,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Text(
            setting['subtitle'] as String,
            style: AppTypography.geistRegular11.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
