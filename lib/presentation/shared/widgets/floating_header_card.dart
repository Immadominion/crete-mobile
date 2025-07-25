import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

class FloatingHeaderCard extends StatelessWidget {
  const FloatingHeaderCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isDarkMode,
    this.avatarUrl,
    this.padding,
  });
  final String title;
  final String subtitle;
  final bool isDarkMode;
  final String? avatarUrl;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 40.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (isDarkMode ? Colors.white : Colors.black).withValues(
                    alpha: 0.1,
                  ),
                  (isDarkMode ? Colors.white : Colors.black).withValues(
                    alpha: 0.05,
                  ),
                ],
              ),
              border: Border.all(
                color: (isDarkMode ? Colors.white : Colors.black).withValues(
                  alpha: 0.1,
                ),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.heading1.copyWith(
                          color: isDarkMode ? Colors.white : AppColors.gray900,
                          fontWeight: FontWeight.bold,
                          fontSize: 32.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        subtitle,
                        style: AppTypography.geistMedium16.copyWith(
                          color: isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Pulsing avatar portal
                _buildAvatarPortal(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPortal() {
    final defaultAvatarUrl =
        avatarUrl ??
        'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100';

    return Stack(
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.8),
                AppColors.primary.withValues(alpha: 0.2),
              ],
            ),
          ),
        ),
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(defaultAvatarUrl),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: AppColors.primary, width: 2),
          ),
        ),
      ],
    );
  }
}
