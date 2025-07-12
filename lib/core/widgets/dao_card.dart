import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

class DaoCard extends StatelessWidget {
  const DaoCard({super.key, required this.isMyDao});
  final bool isMyDao;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 292.w,
      padding: EdgeInsets.all(AppSpacing.md.sp),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(16.sp),
        border: Border.all(
          color: isDarkMode ? AppColors.gray700 : AppColors.gray200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.group, color: AppColors.white, size: 24.sp),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RadiantsDAO',
                      style: AppTypography.geistSemiBold15.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.gray900,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '1.2K members',
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
          SizedBox(height: 12.h),
          Text(
            'An on-chain cadre of talented storytellers, creators, developers, & artists. Hosts of the @SolanaMobile Hackathon, notifications on for updates.',
            style: AppTypography.geistRegular12.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
              fontSize: 12.sp,
              letterSpacing: -0.6.sp,
              height: 1.2, // Adjusted line height to reduce bottom space
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
