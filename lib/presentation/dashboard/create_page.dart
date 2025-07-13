import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

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
          'Create',
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
              Icons.add_circle_outline,
              size: 64.sp,
              color: isDarkMode 
                  ? AppColors.darkTextHeading 
                  : AppColors.gray400,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              'Create Page',
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode 
                    ? AppColors.darkTextPrimary 
                    : AppColors.gray900,
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              'Create new DAOs and proposals',
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
