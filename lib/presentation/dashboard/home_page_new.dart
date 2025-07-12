import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../core/widgets/dao_search_bar.dart';
import '../daos/dao_page_service.dart';
import 'widgets/home_dao_sections.dart';

/// Home page of the dashboard - Overview of user's DAO activity
/// This is the main landing page when users open the app
class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          // Home App Bar
          SliverPadding(
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
                    'DAOs',
                    style: AppTypography.sfProSemiBold32.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextPrimary
                          : AppColors.gray900,
                      fontSize: 32.sp,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => daoService.navigateToCreateDao(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
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
                ],
              ),
            ),
          ),

          // Search Bar
          SliverPadding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 23.h),
            sliver: SliverToBoxAdapter(
              child: DaoSearchBar(
                onChanged: daoService.handleSearch,
                onSubmitted: daoService.handleSearch,
              ),
            ),
          ),

          // My DAOs Section
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverToBoxAdapter(
              child: HomeDaoSections.buildMyDaosSection(context, daoService),
            ),
          ),

          // Quick Actions Section
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverToBoxAdapter(
              child: HomeDaoSections.buildQuickActionsSection(
                context,
                daoService,
              ),
            ),
          ),

          // Recent Activity Section
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverToBoxAdapter(
              child: HomeDaoSections.buildRecentActivitySection(
                context,
                daoService,
              ),
            ),
          ),

          // Featured DAOs Section
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverToBoxAdapter(
              child: HomeDaoSections.buildFeaturedDaosSection(
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
