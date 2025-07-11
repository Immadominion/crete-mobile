import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';
import '../theme/spacing.dart';

class DaoCard extends StatelessWidget {
  final bool isMyDao;

  const DaoCard({super.key, required this.isMyDao});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 280.w,
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDarkMode ? AppColors.gray700 : AppColors.gray200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                  gradient: LinearGradient(
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
                      'DeFi DAO',
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
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm.w,
                  vertical: AppSpacing.xs.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.daoActive.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'Active',
                  style: AppTypography.geistMedium11.copyWith(
                    color: AppColors.daoActive,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          Text(
            'Decentralized governance for DeFi protocols and yield farming strategies.',
            style: AppTypography.geistRegular12.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSpacing.md.h),
          Row(
            children: [
              _buildStat(context, 'Proposals', '12', Icons.how_to_vote),
              SizedBox(width: AppSpacing.md.w),
              _buildStat(
                context,
                'Treasury',
                '2.5M',
                Icons.account_balance_wallet,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: isDarkMode ? AppColors.darkTextHeading : AppColors.gray500,
          ),
          SizedBox(width: 4.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTypography.geistSemiBold13.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                ),
              ),
              Text(
                label,
                style: AppTypography.geistRegular11.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextHeading
                      : AppColors.gray500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
