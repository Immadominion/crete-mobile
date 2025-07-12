import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/spacing.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

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
          'Explore',
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
              Icons.explore,
              size: 64.sp,
              color: isDarkMode 
                  ? AppColors.darkTextHeading 
                  : AppColors.gray400,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              'Explore Page',
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode 
                    ? AppColors.darkTextPrimary 
                    : AppColors.gray900,
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              'Discover new DAOs and communities',
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
