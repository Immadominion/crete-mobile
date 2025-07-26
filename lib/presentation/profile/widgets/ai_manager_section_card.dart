import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

class AiManagerSectionCard extends StatelessWidget {
  const AiManagerSectionCard({super.key, required this.isDarkMode});
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header with AI glow effect
          Text(
            'Zeus Agent',
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

          // AI features with neural network design
          _buildAiFeatureCard(
            PhosphorIcons.bell(PhosphorIconsStyle.bold),
            'Smart Notifications',
            'AI-powered notification filtering',
            true,
            const Color(0xFF9146FF),
          ),
          SizedBox(height: 12.h),
          _buildAiFeatureCard(
            PhosphorIcons.chatCircleText(PhosphorIconsStyle.bold),
            'Channel Summaries',
            'Catch up on missed conversations',
            false,
            const Color(0xFF5865F2),
          ),
          SizedBox(height: 12.h),
          _buildAiFeatureCard(
            PhosphorIcons.microphone(PhosphorIconsStyle.bold),
            'Voice Transcription',
            'Convert voice to text automatically',
            true,
            const Color(0xFF00D4AA),
          ),
          SizedBox(height: 16.h),

          // AI Preferences button
          _buildAiPreferencesButton(),
        ],
      ),
    );
  }

  Widget _buildAiFeatureCard(
    IconData icon,
    String title,
    String description,
    bool isEnabled,
    Color accentColor,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accentColor.withOpacity(isEnabled ? 0.12 : 0.05),
                accentColor.withOpacity(isEnabled ? 0.06 : 0.02),
              ],
            ),
            border: Border.all(
              color: accentColor.withOpacity(isEnabled ? 0.3 : 0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // AI feature icon with neural glow
              Stack(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          accentColor.withOpacity(isEnabled ? 0.3 : 0.1),
                          accentColor.withOpacity(isEnabled ? 0.1 : 0.05),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withOpacity(isEnabled ? 0.2 : 0.1),
                    ),
                    child: Icon(
                      icon,
                      color: isEnabled
                          ? accentColor
                          : accentColor.withOpacity(0.5),
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16.w),

              // Feature info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.geistMedium15.copyWith(
                        color: isDarkMode ? Colors.white : AppColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      description,
                      style: AppTypography.geistRegular12.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),

              // AI toggle with neural animation
              Container(
                width: 48.w,
                height: 28.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  color: isEnabled
                      ? accentColor
                      : (isDarkMode ? AppColors.gray700 : AppColors.gray300),
                  boxShadow: isEnabled
                      ? [
                          BoxShadow(
                            color: accentColor.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  alignment: isEnabled
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    margin: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isEnabled
                        ? Icon(
                            PhosphorIcons.lightning(PhosphorIconsStyle.bold),
                            color: accentColor,
                            size: 12.sp,
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAiPreferencesButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withOpacity(0.15),
                AppColors.primary.withOpacity(0.08),
              ],
            ),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.3),
                      AppColors.primary.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Icon(
                  PhosphorIcons.brain(PhosphorIconsStyle.bold),
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Preferences',
                      style: AppTypography.geistMedium15.copyWith(
                        color: isDarkMode ? Colors.white : AppColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Manage AI features and neural settings',
                      style: AppTypography.geistRegular12.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
                color: AppColors.primary,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
