import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/data/dao_detail_demo_data.dart';
import '../../../../core/models/ui/dao_ui_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

class DaoDetailHeader extends StatelessWidget {
  const DaoDetailHeader({super.key, required this.dao});

  final DaoUiModel dao;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Banner
        Container(
          width: 393.w,
          height: 123.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12.r),
              bottomRight: Radius.circular(12.r),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12.r),
              bottomRight: Radius.circular(12.r),
            ),
            child: Image.network(
              dao.bannerImageUrl ?? 'https://example.com/banner.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.r),
                      bottomRight: Radius.circular(12.r),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        SizedBox(height: AppSpacing.md.h),

        // DAO info row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
          child: Row(
            children: [
              // DAO avatar
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
                    color: isDarkMode
                        ? AppColors.darkContainerBorder
                        : AppColors.gray200,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.r),
                  child: Image.network(
                    dao.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container();
                    },
                  ),
                ),
              ),

              SizedBox(width: AppSpacing.sm.w),

              // DAO name
              Text(
                dao.name,
                style: AppTypography.geistSemiBold15.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: AppSpacing.md.h),

        // Members info
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
          child: Row(
            children: [
              // Overlapping member avatars
              SizedBox(
                width: 69.w,
                height: 21.75.h,
                child: Stack(
                  children: [
                    ...DaoDetailDemoData.members.take(4).map((member) {
                      final index = DaoDetailDemoData.members.indexOf(member);
                      return Positioned(
                        left: (index * 12.5).w,
                        child: Container(
                          width: 21.75.w,
                          height: 21.75.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDarkMode
                                  ? AppColors.darkBackgroundPrimary
                                  : AppColors.white,
                              width: 1.w,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.r),
                            child: Image.network(
                              member.avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(color: AppColors.primary);
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              SizedBox(width: 6.5.w),

              // Member count
              Text(
                '${dao.memberCount} members',
                style: AppTypography.geistMedium13.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.gray600,
                  letterSpacing: -0.6.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
