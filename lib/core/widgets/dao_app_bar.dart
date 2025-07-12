import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// Modular app bar widget for DAO pages
class DaoAppBar extends StatelessWidget {
  const DaoAppBar({
    super.key,
    required this.title,
    this.showCreateButton = false,
    this.onCreatePressed,
    this.actions,
  });

  final String title;
  final bool showCreateButton;
  final VoidCallback? onCreatePressed;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SliverPadding(
      padding: EdgeInsets.only(
        left: 15.8.w,
        right: 15.8.w,
        top: 33.h,
        bottom: 24.h,
      ),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTypography.sfProSemiBold32.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
                fontSize: 32.sp,
              ),
            ),
            if (showCreateButton)
              ElevatedButton(
                onPressed: onCreatePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.5.w,
                    vertical: 2.5.h,
                  ),
                  fixedSize: Size(108.w, 27.h),
                  elevation: 0,
                ),
                child: Text(
                  'Create a DAO',
                  style: AppTypography.geistMedium13.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }
}
