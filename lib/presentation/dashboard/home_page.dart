import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';

/// Home page - Your communities, recent activity
/// Shows wallet status, recent activity, active voice channels, quick actions, and notifications
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundPrimary
          : AppColors.backgroundPrimary,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // Header with wallet status
            SliverPadding(
              padding: EdgeInsets.only(
                left: 15.8.w,
                right: 15.8.w,
                top: 33.h,
                bottom: 24.h,
              ),
              sliver: SliverToBoxAdapter(child: _buildHeader(isDarkMode)),
            ),

            // Recent Activity Section
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.8.w),
              sliver: SliverToBoxAdapter(
                child: _buildRecentActivity(isDarkMode),
              ),
            ),

            // Active Voice Channels
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.8.w),
              sliver: SliverToBoxAdapter(
                child: _buildActiveVoiceChannels(isDarkMode),
              ),
            ),

            // Quick Actions
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.8.w),
              sliver: SliverToBoxAdapter(child: _buildQuickActions(isDarkMode)),
            ),

            // Notifications
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.8.w),
              sliver: SliverToBoxAdapter(
                child: _buildNotifications(isDarkMode),
              ),
            ),

            // Bottom padding
            SliverPadding(
              padding: EdgeInsets.only(bottom: 100.h),
              sliver: const SliverToBoxAdapter(child: SizedBox()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Home',
              style: AppTypography.sfProSemiBold32.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
                fontSize: 32.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your communities, recent activity',
              style: AppTypography.geistRegular14.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.w,
                height: 8.h,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'Connected',
                style: AppTypography.geistMedium11.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        _buildActivityCard(
          'New message in #general',
          'CryptoDAO',
          '2 min ago',
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildActivityCard(
          'Vote on Treasury Proposal',
          'DeFi Collective',
          '1 hour ago',
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildActivityCard(
          'Mentioned in #governance',
          'MetaDAO',
          '3 hours ago',
          isDarkMode,
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildActivityCard(
    String title,
    String community,
    String time,
    bool isDarkMode,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
      ),
      child: Row(
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
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: AppColors.white,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$community • $time',
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

  Widget _buildActiveVoiceChannels(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Voice Channels',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        _buildVoiceChannelCard('General Voice', 'CryptoDAO', 3, isDarkMode),
        SizedBox(height: 12.h),
        _buildVoiceChannelCard(
          'Governance Meeting',
          'DeFi Collective',
          7,
          isDarkMode,
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildVoiceChannelCard(
    String channelName,
    String community,
    int memberCount,
    bool isDarkMode,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 37.65.w,
            height: 37.65.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Icon(
              Icons.volume_up_outlined,
              color: AppColors.primary,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  channelName,
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$community • $memberCount members',
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
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Join',
              style: AppTypography.geistMedium11.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.volume_up_outlined,
                title: 'Join Voice',
                subtitle: 'Join active voice channels',
                isDarkMode: isDarkMode,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildActionCard(
                icon: Icons.poll_outlined,
                title: 'Check Governance',
                subtitle: 'View active proposals',
                isDarkMode: isDarkMode,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Icons.add_outlined,
                title: 'Create Channel',
                subtitle: 'Start a new channel',
                isDarkMode: isDarkMode,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildActionCard(
                icon: Icons.explore_outlined,
                title: 'Discover',
                subtitle: 'Find new communities',
                isDarkMode: isDarkMode,
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDarkMode,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24.sp, color: AppColors.primary),
          SizedBox(height: 8.h),
          Text(
            title,
            style: AppTypography.geistSemiBold15.copyWith(
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: AppTypography.geistRegular11.copyWith(
              color: isDarkMode ? AppColors.darkTextHeading : AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotifications(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notifications',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        _buildNotificationCard(
          'New proposal in MetaDAO',
          'Treasury allocation proposal needs your vote',
          '5 min ago',
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildNotificationCard(
          'CryptoDAO mentioned you',
          'Discussion about upcoming upgrades',
          '1 hour ago',
          isDarkMode,
        ),
        SizedBox(height: 12.h),
        _buildNotificationCard(
          'DeFi Collective vote results',
          'Governance proposal has passed',
          '2 hours ago',
          isDarkMode,
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildNotificationCard(
    String title,
    String description,
    String time,
    bool isDarkMode,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 37.65.w,
            height: 37.65.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: AppColors.primary,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: AppTypography.geistRegular12.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  time,
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
