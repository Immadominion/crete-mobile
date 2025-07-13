import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';

class DaoDetailTabs extends StatelessWidget {
  const DaoDetailTabs({
    super.key,
    required this.tabs,
    required this.tabController,
  });

  final List<String> tabs;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          height: 26.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: TabBar(
            controller: tabController,
            isScrollable: true,
            indicatorColor: AppColors.primary,
            indicatorWeight: 1.w,
            labelColor: isDarkMode
                ? AppColors.darkTextPrimary
                : AppColors.gray900,
            unselectedLabelColor: isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.gray600,
            labelStyle: AppTypography.geistMedium13,
            unselectedLabelStyle: AppTypography.geistMedium13,
            tabs: tabs.map((tab) => Tab(text: tab)).toList(),
          ),
        ),
        Container(
          height: 1.h,
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
      ],
    );
  }
}
