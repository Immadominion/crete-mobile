import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../core/data/community_demo_data.dart';
import '../../domain/entities/community.dart';

import 'widgets/communities_header.dart';
import 'widgets/communities_search_bar.dart';
import 'widgets/community_card.dart';
import 'community_detail_page.dart';

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
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // Start animation after a short delay to allow the UI to build
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) _fadeController.forward();
    });
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
              sliver: SliverToBoxAdapter(
                child: CommunitiesHeader(
                  onCreateCommunity: () => _createNewCommunity(),
                ),
              ),
            ),

            // Search Bar
            SliverPadding(
              padding: EdgeInsets.only(
                left: 15.8.w,
                right: 15.8.w,
                bottom: 22.h,
              ),
              sliver: SliverToBoxAdapter(
                child: CommunitiesSearchBar(
                  hintText: 'Search communities...',
                  onFilterTap: () => _filterCommunities(),
                  onChanged: (query) => _searchCommunities(query),
                ),
              ),
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

  void _createNewCommunity() {
    // Create new community implementation
    debugPrint('Create new community');
  }

  void _filterCommunities() {
    // Filter communities implementation
    debugPrint('Filter communities');
  }

  void _searchCommunities(String query) {
    // Search communities implementation
    debugPrint('Search query: $query');
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
              return CommunityCard(
                community: community,
                isDarkMode: isDarkMode,
                variant: CommunityCardVariant.horizontal,
                onTap: () => _navigateToCommunity(community),
              );
            },
          ),
        ),
        SizedBox(height: 24.h),
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
            return CommunityCard(
              community: community,
              isDarkMode: isDarkMode,
              variant: CommunityCardVariant.vertical,
              showJoinButton: true,
              onTap: () => _navigateToCommunity(community),
            );
          },
        ),
        SizedBox(height: 24.h),
      ],
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
