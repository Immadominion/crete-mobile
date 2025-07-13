import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.iconPath,
    this.onSeeAll,
  });
  final String title;
  final IconData? icon;
  final String? iconPath;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (iconPath != null)
              Container(
                width: 22.w,
                height: 22.h,
                padding: EdgeInsets.all(4.23.sp),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.darkIconBackground
                      : AppColors.gray100,
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: SvgPicture.asset(
                  iconPath!,
                  width: 8.99.w,
                  height: 10.12.h,
                  colorFilter: ColorFilter.mode(
                    isDarkMode ? AppColors.darkIconColor : AppColors.gray600,
                    BlendMode.srcIn,
                  ),
                ),
              )
            else if (icon != null)
              Container(
                width: 22.w,
                height: 22.h,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.darkIconBackground
                      : AppColors.gray100,
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Icon(
                  icon,
                  color: isDarkMode
                      ? AppColors.darkIconForeground
                      : AppColors.gray600,
                  size: 14.sp,
                ),
              ),
            if (iconPath != null || icon != null)
              SizedBox(width: AppSpacing.sm.w),
            Text(
              title,
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextHeader
                    : AppColors.gray700,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Icon(
              PhosphorIcons.squaresFour(),
              color: AppColors.darkIconBackground,
            ),
          ),
      ],
    );
  }
}
