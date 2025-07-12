import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/theme/typography.dart';
import '../../../core/widgets/dao_card.dart';
import '../../../core/widgets/dao_section.dart';
import '../../../core/widgets/section_header.dart';
import '../dao_page_service.dart';

/// Modular DAO sections for the dedicated DAO page
/// These sections are specifically designed for comprehensive DAO management
class DaoPageSections {
  /// Build My DAOs section with expanded view
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
      itemCount: 5, // Show more items on dedicated page
      isHorizontal: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(right: index == 4 ? 0 : AppSpacing.md.w),
          child: const DaoCard(isMyDao: true),
        );
      },
    );
  }

  /// Build Featured DAOs section
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
          itemCount: 5,
          isHorizontal: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: index == 4 ? 0 : AppSpacing.md.w),
              child: const DaoCard(isMyDao: false),
            );
          },
        ),
      ],
    );
  }

  /// Build Trending DAOs section
  static Widget buildTrendingDaosSection(
    BuildContext context,
    DaoPageService daoService,
  ) {
    return Column(
      children: [
        SizedBox(height: AppSpacing.xl.h),
        DaoSection(
          sectionHeader: SectionHeader(
            title: 'Trending DAOs',
            icon: Icons.trending_up,
            onSeeAll: () => daoService.navigateToTrendingDaos(context),
          ),
          itemCount: 5,
          isHorizontal: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: index == 4 ? 0 : AppSpacing.md.w),
              child: const DaoCard(isMyDao: false),
            );
          },
        ),
      ],
    );
  }

  /// Build Recently Joined DAOs section
  static Widget buildRecentlyJoinedSection(
    BuildContext context,
    DaoPageService daoService,
  ) {
    return Column(
      children: [
        SizedBox(height: AppSpacing.xl.h),
        DaoSection(
          sectionHeader: SectionHeader(
            title: 'Recently Joined',
            icon: Icons.access_time,
            onSeeAll: () => daoService.navigateToAllDaos(context),
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

  /// Build Categories section
  static Widget buildCategoriesSection(
    BuildContext context,
    DaoPageService daoService,
  ) {
    return Column(
      children: [
        SizedBox(height: AppSpacing.xl.h),
        SectionHeader(
          title: 'Categories',
          icon: Icons.category,
          onSeeAll: () => daoService.navigateToAllDaos(context),
        ),
        SizedBox(height: AppSpacing.md.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            crossAxisSpacing: AppSpacing.md.w,
            mainAxisSpacing: AppSpacing.md.h,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            final categories = [
              {'title': 'DeFi', 'icon': Icons.account_balance},
              {'title': 'NFTs', 'icon': Icons.collections},
              {'title': 'Gaming', 'icon': Icons.sports_esports},
              {'title': 'Social', 'icon': Icons.people},
              {'title': 'Investment', 'icon': Icons.trending_up},
              {'title': 'Governance', 'icon': Icons.how_to_vote},
            ];
            final category = categories[index];
            return _buildCategoryCard(
              context,
              icon: category['icon'] as IconData,
              title: category['title'] as String,
              onTap: () => daoService.navigateToAllDaos(context),
            );
          },
        ),
      ],
    );
  }

  /// Helper method to build category cards
  static Widget _buildCategoryCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md.w),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.darkBackgroundSecondary
              : AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDarkMode ? AppColors.gray700 : AppColors.gray200,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: isDarkMode ? AppColors.darkTextHeading : AppColors.gray600,
            ),
            SizedBox(width: AppSpacing.sm.w),
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
}
