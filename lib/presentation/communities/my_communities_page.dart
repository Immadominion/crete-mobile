import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../domain/entities/community.dart';
import 'community_detail_page.dart';
import 'widgets/enhanced_community_card.dart';

/// Page showing all communities the user is a member of in a standard grid layout
class MyCommunitiesPage extends StatelessWidget {
  const MyCommunitiesPage({super.key, required this.communities});

  final List<Community> communities;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundPrimary
          : AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: PhosphorIcon(
            PhosphorIcons.caretLeft(PhosphorIconsStyle.bold),
            size: 20.sp,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Communities',
          style: AppTypography.geistSemiBold15.copyWith(
            fontSize: 18.sp,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(16.w),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final community = communities[index];
                  return EnhancedCommunityCard(
                    community: community,
                    isDarkMode: isDarkMode,
                    isJoined: true,
                    showJoinButton: false,
                    heroTag: 'my_community_all_${community.id}',
                    onTap: () => _navigateToCommunity(context, community),
                  );
                }, childCount: communities.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.75,
                ),
              ),
            ),
            // Bottom padding
            SliverPadding(
              padding: EdgeInsets.only(bottom: 16.h),
              sliver: const SliverToBoxAdapter(child: SizedBox()),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCommunity(BuildContext context, Community community) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => CommunityDetailPage(community: community),
      ),
    );
  }
}
