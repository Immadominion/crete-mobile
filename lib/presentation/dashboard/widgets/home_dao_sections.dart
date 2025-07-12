import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/dao_card.dart';
import '../../../core/widgets/dao_section.dart';
import '../../../core/widgets/section_header.dart';
import '../../daos/dao_page_service.dart';

/// Modular DAO sections for the home page
/// These are reusable components that can be used across different pages
class HomeDaoSections {
  /// Build My DAOs section for home page
  static Widget buildMyDaosSection(
    BuildContext context,
    DaoPageService daoService,
  ) {
    return DaoSection(
      sectionHeader: SectionHeader(
        title: 'My DAOs',
        iconPath: 'assets/icons/svgs/pinned.svg',
        onSeeAll: () => daoService.navigateToMyDaos(context),
      ),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(right: index == 2 ? 0 : AppSpacing.md.w),
          child: const DaoCard(isMyDao: true),
        );
      },
    );
  }

  /// Build Featured DAOs section for home page
  static Widget buildFeaturedDaosSection(
    BuildContext context,
    DaoPageService daoService,
  ) {
    return Column(
      children: [
        SizedBox(height: AppSpacing.xl.h),
        DaoSection(
          sectionHeader: SectionHeader(
            title: 'Featured DAOs',
            icon: Icons.star,
            onSeeAll: () => daoService.navigateToFeaturedDaos(context),
          ),
          itemCount: 3,
          isHorizontal: false,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md.h),
              child: const DaoCard(isMyDao: false),
            );
          },
        ),
      ],
    );
  }

  /// Build Quick Actions section for home page
  static Widget buildQuickActionsSection(
    BuildContext context,
    DaoPageService daoService,
  ) {
    return Column(
      children: [
        SizedBox(height: AppSpacing.xl.h),
        SectionHeader(
          title: 'Quick Actions',
          icon: Icons.bolt,
          onSeeAll: () => daoService.navigateToCreateDao(context),
        ),
        SizedBox(height: AppSpacing.md.h),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.add,
                title: 'Create DAO',
                onTap: () => daoService.navigateToCreateDao(context),
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: _buildQuickActionCard(
                context,
                icon: Icons.how_to_vote,
                title: 'Vote',
                onTap: () => daoService.navigateToAllDaos(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build Recent Activity section for home page
  static Widget buildRecentActivitySection(
    BuildContext context,
    DaoPageService daoService,
  ) {
    return Column(
      children: [
        SizedBox(height: AppSpacing.xl.h),
        SectionHeader(
          title: 'Recent Activity',
          icon: Icons.history,
          onSeeAll: () => daoService.navigateToAllDaos(context),
        ),
        SizedBox(height: AppSpacing.md.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return _buildActivityItem(context, index);
          },
        ),
      ],
    );
  }

  /// Helper method to build quick action cards
  static Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.darkBackgroundSecondary
              : AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDarkMode ? AppColors.gray700 : AppColors.gray200,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32.sp, color: AppColors.primary),
            SizedBox(height: AppSpacing.sm.h),
            Text(
              title,
              style: AppTypography.geistMedium13.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to build activity items
  static Widget _buildActivityItem(BuildContext context, int index) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final activities = [
      {
        'title': 'Voted on Proposal #42',
        'dao': 'DeFi DAO',
        'time': '2 hours ago',
        'icon': Icons.how_to_vote,
      },
      {
        'title': 'Joined New DAO',
        'dao': 'Gaming DAO',
        'time': '1 day ago',
        'icon': Icons.group_add,
      },
      {
        'title': 'Created Proposal',
        'dao': 'Investment DAO',
        'time': '3 days ago',
        'icon': Icons.note_add,
      },
    ];

    final activity = activities[index];

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      margin: EdgeInsets.only(bottom: AppSpacing.sm.h),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDarkMode ? AppColors.gray700 : AppColors.gray200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            activity['icon'] as IconData,
            size: 24.sp,
            color: AppColors.primary,
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'] as String,
                  style: AppTypography.geistMedium13.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${activity['dao']} • ${activity['time']}',
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
    );
  }
}
