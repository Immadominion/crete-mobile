import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/models/ui/dao_ui_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

class DaoOverviewContent extends StatelessWidget {
  const DaoOverviewContent({super.key, required this.dao});

  final DaoUiModel dao;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Long description
          Text(
            dao.description,
            style: AppTypography.geistMedium15.copyWith(
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
              letterSpacing: -0.6.sp,
              height: 1.47.h,
            ),
          ),

          SizedBox(height: 21.h),

          // Stats column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatRow(
                icon: PhosphorIcons.tray(),
                text: '46 Proposal',
                isDarkMode: isDarkMode,
              ),
              SizedBox(height: AppSpacing.sm.h),
              _buildStatRow(
                icon: PhosphorIcons.usersFour(),
                text: '${dao.memberCount} Members',
                isDarkMode: isDarkMode,
              ),
              SizedBox(height: AppSpacing.sm.h),
              _buildStatRow(
                icon: PhosphorIcons.vault(),
                text: dao.treasuryAmount,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String text,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24.sp,
          color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
        ),
        SizedBox(width: AppSpacing.sm.w),
        Text(
          text,
          style: AppTypography.geistMedium13.copyWith(
            color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
            letterSpacing: -0.6.sp,
          ),
        ),
      ],
    );
  }
}
