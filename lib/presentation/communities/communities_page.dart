import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/data/community_demo_data.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../domain/entities/community.dart';
import 'community_detail_page.dart';
import 'widgets/communities_header.dart';
import 'widgets/communities_search_bar.dart';
import 'widgets/compact_community_card.dart';
import 'widgets/enhanced_community_card.dart';
import 'my_communities_page.dart';

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

  // Controller for the horizontal scroll position indicator
  late ScrollController _horizontalScrollController;

  // For tracking scroll position
  double _scrollPosition = 0.0;
  double _maxScrollExtent = 1.0;

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

    // Initialize the horizontal scroll controller
    _horizontalScrollController = ScrollController();
    _horizontalScrollController.addListener(_updateScrollIndicator);

    // Use post-frame callback to ensure the UI is built and ready
    // before starting animations which helps with semantic updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Slight delay helps with initialization and semantic update conflicts
        Future.delayed(const Duration(milliseconds: 50), () {
          if (mounted) _fadeController.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _horizontalScrollController.dispose();
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                PhosphorIcon(
                  PhosphorIcons.star(PhosphorIconsStyle.bold),
                  color: AppColors.primary,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'My Communities',
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                // Navigate to the full My Communities page
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) =>
                        MyCommunitiesPage(communities: _myCommunities),
                  ),
                );
              },
              child: Row(
                children: [
                  Text(
                    'See All',
                    style: AppTypography.geistMedium13.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  PhosphorIcon(
                    PhosphorIcons.arrowRight(PhosphorIconsStyle.regular),
                    color: AppColors.primary,
                    size: 14.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        // Horizontal scrollable layout for My Communities
        Column(
          children: [
            SizedBox(
              height: 145.h, // Increased height to avoid overflow
              child: ListView.builder(
                controller: _horizontalScrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(left: 2.w, right: 15.w),
                itemCount: _myCommunities.length,
                itemBuilder: (context, index) {
                  final community = _myCommunities[index];
                  final status = _getCommunityStatus(community, index);

                  return CompactCommunityCard(
                    community: community,
                    isDarkMode: isDarkMode,
                    hasUnreadMessages: status['hasUnreadMessages']!,
                    hasActiveVoiceCall: status['hasActiveVoiceCall']!,
                    hasOngoingEvent: status['hasOngoingEvent']!,
                    heroTag: 'my_community_${community.id}',
                    onTap: () => _navigateToCommunity(community),
                  );
                },
              ),
            ),

            // Scroll indicator
            SizedBox(height: 8.h),
            _buildScrollIndicator(),
          ],
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildDiscoverSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Discover header with browse more action
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                PhosphorIcon(
                  PhosphorIcons.compass(PhosphorIconsStyle.bold),
                  color: AppColors.warning,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Discover',
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                // Browse more communities
                debugPrint('Browse more communities');
              },
              child: Row(
                children: [
                  Text(
                    'Browse More',
                    style: AppTypography.geistMedium13.copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  PhosphorIcon(
                    PhosphorIcons.arrowRight(PhosphorIconsStyle.regular),
                    color: AppColors.warning,
                    size: 14.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        // Add a category row for filtering
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildCategoryChip('All', true),
              _buildCategoryChip('Gaming', false),
              _buildCategoryChip('Finance', false),
              _buildCategoryChip('NFT', false),
              _buildCategoryChip('Social', false),
              _buildCategoryChip('DeFi', false),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        // Discover communities list
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _discoverCommunities.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final community = _discoverCommunities[index];
            return EnhancedCommunityCard(
              community: community,
              isDarkMode: isDarkMode,
              isJoined: community.isJoined,
              showJoinButton: !community.isJoined,
              heroTag: 'discover_community_${community.id}',
              onTap: () => _navigateToCommunity(community),
              onJoin: () => _joinCommunity(community),
            );
          },
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      child: FilterChip(
        selected: isSelected,
        showCheckmark: false,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkBackgroundSecondary
            : Colors.white,
        selectedColor: AppColors.warning.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(
            color: isSelected
                ? AppColors.warning
                : (Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkContainerBorder
                      : AppColors.gray200),
            width: 1,
          ),
        ),
        label: Text(
          label,
          style: AppTypography.geistMedium13.copyWith(
            color: isSelected
                ? AppColors.warning
                : (Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkTextSecondary
                      : AppColors.gray700),
          ),
        ),
        onSelected: (selected) {
          // Handle category filter
          debugPrint('Filter by category: $label');
        },
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
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

  // Helper method to determine community status based on its data
  Map<String, bool> _getCommunityStatus(Community community, int index) {
    // In a real application, these would be determined by actual data
    // For this demo, we're using the index to simulate different states
    final hasUnreadMessages = community.unreadCount > 0 || index % 3 == 0;
    final hasActiveVoiceCall = index % 4 == 1; // Simulate active voice calls
    final hasOngoingEvent =
        community.lastActivity != null &&
            community.lastActivity!.isAfter(
              DateTime.now().subtract(const Duration(hours: 1)),
            ) ||
        index % 5 == 2; // Simulate ongoing events

    return {
      'hasUnreadMessages': hasUnreadMessages,
      'hasActiveVoiceCall': hasActiveVoiceCall,
      'hasOngoingEvent': hasOngoingEvent,
    };
  }

  void _joinCommunity(Community community) {
    // Join community implementation
    debugPrint('Join community: ${community.name}');
    // TODO: Implement join community logic with state management
  }

  void _updateScrollIndicator() {
    if (mounted) {
      setState(() {
        _scrollPosition = _horizontalScrollController.offset;
        _maxScrollExtent = _horizontalScrollController.position.maxScrollExtent;
      });
    }
  }

  Widget _buildScrollIndicator() {
    // Calculate the progress (0.0 to 1.0)
    final progress = _maxScrollExtent <= 0.0
        ? 0.0
        : (_scrollPosition / _maxScrollExtent).clamp(0.0, 1.0);

    // Calculate the indicator position
    final double indicatorWidth = 60.w;
    final double totalWidth = 100.w;
    final double maxOffset = totalWidth - indicatorWidth;
    final double indicatorOffset = progress * maxOffset;

    return SizedBox(
      width: totalWidth,
      height: 4.h,
      child: Stack(
        children: [
          // Background track
          Center(
            child: Container(
              width: totalWidth,
              height: 3.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(1.5.r),
              ),
            ),
          ),
          // Animated indicator
          Positioned(
            left: indicatorOffset,
            child: Container(
              width: indicatorWidth,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.7),
                borderRadius: BorderRadius.circular(2.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 4.r,
                    offset: Offset(0, 1.h),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
