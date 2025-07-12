import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/spacing.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDarkMode 
          ? AppColors.darkBackgroundPrimary 
          : AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: isDarkMode 
            ? AppColors.darkBackgroundPrimary 
            : AppColors.backgroundPrimary,
        elevation: 0,
        title: Text(
          'Activity',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode 
                ? AppColors.darkTextPrimary 
                : AppColors.gray900,
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline,
              size: 64.sp,
              color: isDarkMode 
                  ? AppColors.darkTextHeading 
                  : AppColors.gray400,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              'Activity Page',
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode 
                    ? AppColors.darkTextPrimary 
                    : AppColors.gray900,
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              'Track your DAO activities and voting history',
              style: AppTypography.geistRegular12.copyWith(
                color: isDarkMode 
                    ? AppColors.darkTextHeading 
                    : AppColors.gray600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
