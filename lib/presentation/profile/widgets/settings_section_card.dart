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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (isDarkMode ? Colors.white : Colors.black).withOpacity(0.1),
                  (isDarkMode ? Colors.white : Colors.black).withOpacity(0.05),
                ],
              ),
              border: Border.all(
                color: (isDarkMode ? Colors.white : Colors.black).withOpacity(
                  0.1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section header with glow effect
                Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF9146FF),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF9146FF).withOpacity(0.6),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Settings ',
                      style: AppTypography.heading4.copyWith(
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
                  ],
                ),
                SizedBox(height: 24.h),

                // Settings grid with glassmorphic cards
                _buildSettingsGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsGrid() {
    final settings = [
      {
        'icon': PhosphorIcons.moon(PhosphorIconsStyle.bold),
        'title': 'Theme',
        'subtitle': 'Light, Dark, or System',
        'color': const Color(0xFF5865F2),
      },
      {
        'icon': PhosphorIcons.bell(PhosphorIconsStyle.bold),
        'title': 'Notifications',
        'subtitle': 'Manage preferences',
        'color': const Color(0xFFED4245),
      },
      {
        'icon': PhosphorIcons.shield(PhosphorIconsStyle.bold),
        'title': 'Security',
        'subtitle': 'Privacy & security',
        'color': const Color(0xFFFAA61A),
      },
      {
        'icon': PhosphorIcons.globe(PhosphorIconsStyle.bold),
        'title': 'Language',
        'subtitle': 'App language',
        'color': const Color(0xFF00D4AA),
      },
    ];

    return Column(
      children: [
        // Top row
        Row(
          children: [
            Expanded(child: _buildSettingCard(settings[0])),
            SizedBox(width: 12.w),
            Expanded(child: _buildSettingCard(settings[1])),
          ],
        ),
        SizedBox(height: 12.h),
        // Bottom row
        Row(
          children: [
            Expanded(child: _buildSettingCard(settings[2])),
            SizedBox(width: 12.w),
            Expanded(child: _buildSettingCard(settings[3])),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingCard(Map<String, dynamic> setting) {
    final Color accentColor = setting['color'] as Color;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: EdgeInsets.all(16.w),
          height: 120.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accentColor.withOpacity(0.12),
                accentColor.withOpacity(0.06),
              ],
            ),
            border: Border.all(color: accentColor.withOpacity(0.25), width: 1),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon with glow effect
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      accentColor.withOpacity(0.3),
                      accentColor.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Icon(
                  setting['icon'] as IconData,
                  color: accentColor,
                  size: 18.sp,
                ),
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
        ),
      ),
    );
  }
}
