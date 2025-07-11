import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/spacing.dart';
import '../../core/navigation/route_paths.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
          'Profile',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
          ),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 64.sp,
              color: isDarkMode ? AppColors.darkTextHeading : AppColors.gray400,
            ),
            SizedBox(height: AppSpacing.lg.h),
            Text(
              'Profile Page',
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              'Manage your profile and settings',
              style: AppTypography.geistRegular12.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextHeading
                    : AppColors.gray600,
              ),
            ),
            SizedBox(height: AppSpacing.lg.h),
            ElevatedButton(
              onPressed: () {
                context.go(RoutePaths.themeTest);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode
                    ? AppColors.primary
                    : AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'Theme Test Page',
                style: AppTypography.geistMedium13.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
