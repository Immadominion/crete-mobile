import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

/// Enhanced header for the DMS page with search toggle and new chat options
class DMSHeader extends StatelessWidget {
  final bool isSearching;
  final VoidCallback onSearchToggle;
  final VoidCallback onNewChatTap;

  const DMSHeader({
    super.key,
    required this.isSearching,
    required this.onSearchToggle,
    required this.onNewChatTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Messages',
              style: AppTypography.sfProSemiBold32.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
                fontSize: 32.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Stay connected with your community',
              style: AppTypography.geistRegular14.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // New group chat button
            GestureDetector(
              onTap: onNewChatTap,
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  PhosphorIcons.usersThree(PhosphorIconsStyle.regular),
                  size: 20.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Search toggle button
            GestureDetector(
              onTap: onSearchToggle,
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: isSearching
                      ? AppColors.primary
                      : (isDarkMode
                            ? AppColors.darkIconBackground
                            : AppColors.gray100),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSearching
                        ? AppColors.primary
                        : (isDarkMode
                              ? AppColors.darkContainerBorder
                              : AppColors.gray200),
                    width: 1,
                  ),
                ),
                child: Icon(
                  PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.regular),
                  size: 20.sp,
                  color: isSearching
                      ? AppColors.white
                      : (isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
