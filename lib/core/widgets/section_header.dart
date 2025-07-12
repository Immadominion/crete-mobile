import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? iconPath;
  final VoidCallback? onSeeAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.iconPath,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (iconPath != null)
              SvgPicture.asset(
                iconPath!,
                width: 20.w,
                height: 20.h,
                colorFilter: ColorFilter.mode(
                  isDarkMode ? AppColors.darkTextHeading : AppColors.gray600,
                  BlendMode.srcIn,
                ),
              )
            else if (icon != null)
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
            if (iconPath != null || icon != null)
              SizedBox(width: AppSpacing.sm.w),
            Text(
              title,
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
            ),
          ],
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              'See all',
              style: AppTypography.geistMedium13.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}
