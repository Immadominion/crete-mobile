import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// Modular search bar widget for DAO search functionality
class DaoSearchBar extends StatelessWidget {
  const DaoSearchBar({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.hintText = 'Search DAOs...',
  });

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkBackgroundSecondary
            : AppColors.gray50,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDarkMode ? AppColors.gray700 : AppColors.gray200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: AppSpacing.md.w),
          Icon(
            Icons.search,
            color: isDarkMode ? AppColors.darkTextHeading : AppColors.gray400,
            size: 20.sp,
          ),
          SizedBox(width: AppSpacing.sm.w),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: AppTypography.geistRegular14.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTypography.geistRegular14.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextHeading
                      : AppColors.gray400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
        ],
      ),
    );
  }
}
