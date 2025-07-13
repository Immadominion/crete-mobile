import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../models/ui/dao_ui_model.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

class DaoCard extends StatelessWidget {
  const DaoCard({super.key, required this.isMyDao, this.dao, this.onTap});

  final bool isMyDao;
  final DaoUiModel? dao;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 292.w,
        padding: EdgeInsets.all(AppSpacing.md.sp),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.black : AppColors.white,
          borderRadius: BorderRadius.circular(10.sp),
          border: Border.all(
            color: isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 37.65.w,
                  height: 37.65.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(100.r),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.r),
                    child: Image.network(
                      dao?.imageUrl ?? 'https://example.com/default-dao.jpg',
                      width: 37.65.w,
                      height: 37.65.h,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Icon(
                          PhosphorIcons.circleNotch(),
                          color: AppColors.white,
                          size: 24.sp,
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          PhosphorIcons.circleNotch(),
                          color: AppColors.white,
                          size: 24.sp,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.tn.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dao?.name ?? 'Unknown DAO',
                        style: AppTypography.geistSemiBold15.copyWith(
                          color: isDarkMode
                              ? AppColors.darkTextPrimary
                              : AppColors.gray900,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${dao?.category ?? 'General'} ⊙ ${dao?.memberCount ?? 0} members',
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
              dao?.description ?? 'No description available.',
              style: AppTypography.geistRegular12.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
                fontSize: 12.sp,
                letterSpacing: -0.6.sp,
                height: 1.2.h,
              ),
              maxLines: 4,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
