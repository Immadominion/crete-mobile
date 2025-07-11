import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/theme/spacing.dart';
import '../../core/widgets/dao_card.dart';
import '../../core/widgets/section_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundPrimary
          : AppColors.backgroundPrimary,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.h,
            floating: false,
            pinned: true,
            backgroundColor: isDarkMode
                ? AppColors.darkBackgroundPrimary
                : AppColors.backgroundPrimary,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Welcome to Crete',
                style: AppTypography.sfProSemiBold32.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                  fontSize: 24.sp,
                ),
              ),
              titlePadding: EdgeInsets.only(
                left: AppSpacing.lg.w,
                bottom: AppSpacing.md.h,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(AppSpacing.lg.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SectionHeader(
                  title: 'My DAOs',
                  icon: Icons.group,
                  onSeeAll: () {
                    // Navigate to My DAOs page
                  },
                ),
                SizedBox(height: AppSpacing.md.h),
                SizedBox(
                  height: 200.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: AppSpacing.md.w),
                        child: const DaoCard(isMyDao: true),
                      );
                    },
                  ),
                ),
                SizedBox(height: AppSpacing.xl.h),
                SectionHeader(
                  title: 'Featured DAOs',
                  icon: Icons.star,
                  onSeeAll: () {
                    // Navigate to Featured DAOs page
                  },
                ),
                SizedBox(height: AppSpacing.md.h),
                SizedBox(
                  height: 200.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: AppSpacing.md.w),
                        child: const DaoCard(isMyDao: false),
                      );
                    },
                  ),
                ),
                SizedBox(height: AppSpacing.xl.h),
                SectionHeader(
                  title: 'Recent Activity',
                  icon: Icons.timeline,
                  onSeeAll: () {
                    // Navigate to Activity page
                  },
                ),
                SizedBox(height: AppSpacing.md.h),
                _buildRecentActivity(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: AppSpacing.sm.h),
          padding: EdgeInsets.all(AppSpacing.md.w),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.darkBackgroundSecondary
                : AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDarkMode ? AppColors.gray700 : AppColors.gray200,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.darkIconBackground
                      : AppColors.gray100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.how_to_vote,
                  color: isDarkMode
                      ? AppColors.darkIconForeground
                      : AppColors.gray600,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New proposal in DeFi DAO',
                      style: AppTypography.geistSemiBold13.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.gray900,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '2 hours ago',
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
                  color: AppColors.daoVotingInProgress.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'Voting',
                  style: AppTypography.geistMedium11.copyWith(
                    color: AppColors.daoVotingInProgress,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
