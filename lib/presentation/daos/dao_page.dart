import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/dao_app_bar.dart';
import '../../core/widgets/dao_search_bar.dart';
import 'dao_page_service.dart';
import 'widgets/dao_page_sections.dart';

/// Dedicated DAO page for comprehensive DAO management
/// This page provides full access to all DAO-related functionality
/// Accessible via the /daos route and bottom navigation
class DaoPage extends StatelessWidget {
  const DaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final daoService = DaoPageService();

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundPrimary
          : AppColors.backgroundPrimary,
      body: CustomScrollView(
        slivers: [
          // DAO App Bar with create button
          DaoAppBar(
            title: 'DAOs',
            showCreateButton: true,
            onCreatePressed: () => daoService.navigateToCreateDao(context),
          ),

          // Search Bar
          SliverPadding(
            padding: EdgeInsets.only(left: 15.8.w, right: 15.8.w, bottom: 22.h),
            sliver: SliverToBoxAdapter(
              child: DaoSearchBar(
                onChanged: daoService.handleSearch,
                onSubmitted: daoService.handleSearch,
              ),
            ),
          ),

          // My DAOs Section
          SliverPadding(
            padding: EdgeInsets.only(
              left: 15.8.w,
              top: AppSpacing.lg.h,
              right: 15.8.w,
            ),
            sliver: SliverToBoxAdapter(
              child: DaoPageSections.buildMyDaosSection(context, daoService),
            ),
          ),

          // Featured DAOs Section
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 15.8.w),
            sliver: SliverToBoxAdapter(
              child: DaoPageSections.buildFeaturedDaosSection(
                context,
                daoService,
              ),
            ),
          ),

          // Trending DAOs Section
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 15.8.w),
            sliver: SliverToBoxAdapter(
              child: DaoPageSections.buildTrendingDaosSection(
                context,
                daoService,
              ),
            ),
          ),

          // Recently Joined Section
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 15.8.w),
            sliver: SliverToBoxAdapter(
              child: DaoPageSections.buildRecentlyJoinedSection(
                context,
                daoService,
              ),
            ),
          ),

          // Categories Section
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 15.8.w),
            sliver: SliverToBoxAdapter(
              child: DaoPageSections.buildCategoriesSection(
                context,
                daoService,
              ),
            ),
          ),

          // Bottom padding
          SliverPadding(
            padding: EdgeInsets.only(bottom: AppSpacing.huge.h),
            sliver: const SliverToBoxAdapter(child: SizedBox()),
          ),
        ],
      ),
    );
  }
}
