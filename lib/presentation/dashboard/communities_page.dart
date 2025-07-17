import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../core/data/community_demo_data.dart';
import '../../domain/entities/community.dart';

/// Communities page - Server list, discover new ones
/// Shows My Communities (joined servers) and Discover (public servers)
/// This is the Discord-like server list experience
class CommunitiesPage extends StatefulWidget {
  const CommunitiesPage({super.key});

  @override
  State<CommunitiesPage> createState() => _CommunitiesPageState();
}

class _CommunitiesPageState extends State<CommunitiesPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Community> _myCommunities = CommunityDemoData.getMyCommunities();
  final List<Community> _discoverCommunities =
      CommunityDemoData.getDiscoverCommunities();

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
            // Header
            SliverPadding(
              padding: EdgeInsets.only(
                left: 15.8.w,
                right: 15.8.w,
                top: 33.h,
                bottom: 24.h,
              ),
              sliver: SliverToBoxAdapter(child: _buildHeader(isDarkMode)),
            ),

            // Search Bar
            SliverPadding(
              padding: EdgeInsets.only(
                left: 15.8.w,
                right: 15.8.w,
                bottom: 22.h,
              ),
              sliver: SliverToBoxAdapter(child: _buildSearchBar(isDarkMode)),
            ),

            // My Communities Section
            SliverPadding(
              padding: EdgeInsets.only(left: 15.8.w, top: AppSpacing.lg.h),
              sliver: SliverToBoxAdapter(
                child: _buildMyCommunitiesSection(isDarkMode),
              ),
            ),

            // Discover Section
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.8.w),
              sliver: SliverToBoxAdapter(
                child: _buildDiscoverSection(isDarkMode),
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
              'Communities',
              style: AppTypography.sfProSemiBold32.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
                fontSize: 32.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Server list, discover new ones',
              style: AppTypography.geistRegular14.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.black : AppColors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isDarkMode
                  ? AppColors.darkContainerBorder
                  : AppColors.gray200,
            ),
          ),
          child: Icon(
            Icons.add_outlined,
            size: 20.sp,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_outlined,
            size: 20.sp,
            color: isDarkMode ? AppColors.darkTextHeading : AppColors.gray500,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Search communities',
              style: AppTypography.geistRegular14.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextHeading
                    : AppColors.gray500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyCommunitiesSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Communities',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 200.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(right: 15.8.w),
            itemCount: _myCommunities.length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final community = _myCommunities[index];
              return _buildCommunityCard(
                community,
                isDarkMode,
                onTap: () => _navigateToCommunity(community),
              );
            },
          ),
        ),
        SizedBox(height: 32.h),
      ],
    );
  }

  Widget _buildDiscoverSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Discover',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _discoverCommunities.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final community = _discoverCommunities[index];
            return _buildDiscoverCommunityCard(
              community,
              isDarkMode,
              onTap: () => _navigateToCommunity(community),
            );
          },
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildCommunityCard(
    Community community,
    bool isDarkMode, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 292.w,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.black : AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                    Icons.groups_outlined,
                    color: AppColors.white,
                    size: 18.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              community.name,
                              style: AppTypography.geistSemiBold15.copyWith(
                                color: isDarkMode
                                    ? AppColors.darkTextPrimary
                                    : AppColors.gray900,
                              ),
                            ),
                          ),
                          if (community.unreadCount > 0)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                community.unreadCount.toString(),
                                style: AppTypography.geistMedium11.copyWith(
                                  color: AppColors.white,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '${community.onlineCount} online ⊙ ${community.memberCount} members',
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
            SizedBox(height: 12.h),
            Text(
              community.description,
              style: AppTypography.geistRegular12.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
                letterSpacing: -0.6.sp,
                height: 1.2.h,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverCommunityCard(
    Community community,
    bool isDarkMode, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.black : AppColors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
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
                Icons.groups_outlined,
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
                    community.name,
                    style: AppTypography.geistSemiBold15.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextPrimary
                          : AppColors.gray900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    community.description,
                    style: AppTypography.geistRegular12.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${community.onlineCount} online ⊙ ${community.memberCount} members',
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
      ),
    );
  }

  void _navigateToCommunity(Community community) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => CommunityDetailPage(community: community),
      ),
    );
  }
}

// Community Detail Page (Discord-like server view)
class CommunityDetailPage extends StatelessWidget {
  final Community community;

  const CommunityDetailPage({super.key, required this.community});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundPrimary
          : AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? AppColors.darkBackgroundPrimary
            : AppColors.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          community.name,
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_outlined,
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Server Header
          SliverPadding(
            padding: EdgeInsets.all(16.w),
            sliver: SliverToBoxAdapter(child: _buildServerHeader(isDarkMode)),
          ),

          // Channel List
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverToBoxAdapter(child: _buildChannelList(isDarkMode)),
          ),
        ],
      ),
    );
  }

  Widget _buildServerHeader(bool isDarkMode) {
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
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Icon(
                  Icons.groups_outlined,
                  color: AppColors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      community.name,
                      style: AppTypography.geistSemiBold15.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.gray900,
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${community.onlineCount} online ⊙ ${community.memberCount} members',
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
          SizedBox(height: 16.h),
          Text(
            community.description,
            style: AppTypography.geistRegular12.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelList(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        Text(
          'Text Channels',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        _buildChannelItem('# general', 'General discussions', isDarkMode),
        _buildChannelItem('# announcements', 'Important updates', isDarkMode),
        _buildChannelItem('# random', 'Off-topic conversations', isDarkMode),

        SizedBox(height: 24.h),
        Text(
          'Voice Channels',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        _buildVoiceChannelItem('🔊 General Voice', 0, isDarkMode),
        _buildVoiceChannelItem('🔊 Meeting Room', 3, isDarkMode),

        SizedBox(height: 24.h),
        Text(
          'Governance',
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 16.h),
        _buildChannelItem(
          '# proposals',
          'Create and discuss proposals',
          isDarkMode,
        ),
        _buildChannelItem('# voting', 'Active votes and results', isDarkMode),

        SizedBox(height: 100.h),
      ],
    );
  }

  Widget _buildChannelItem(String name, String description, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
          Icon(
            Icons.tag,
            size: 20.sp,
            color: isDarkMode ? AppColors.darkTextHeading : AppColors.gray500,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceChannelItem(String name, int memberCount, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
          Icon(
            Icons.volume_up_outlined,
            size: 20.sp,
            color: isDarkMode ? AppColors.darkTextHeading : AppColors.gray500,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                  ),
                ),
                if (memberCount > 0) ...[
                  SizedBox(height: 4.h),
                  Text(
                    '$memberCount members',
                    style: AppTypography.geistRegular12.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (memberCount > 0)
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
}
