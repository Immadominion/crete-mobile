import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onSeeAll;

  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.darkIconBackground
                : AppColors.gray100,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            color: isDarkMode
                ? AppColors.darkIconForeground
                : AppColors.gray600,
            size: 18.sp,
          ),
        ),
        SizedBox(width: AppSpacing.sm.w),
        Expanded(
          child: Text(
            title,
            style: AppTypography.geistSemiBold15.copyWith(
              color: isDarkMode ? AppColors.darkTextHeading : AppColors.gray900,
            ),
          ),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
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
}
