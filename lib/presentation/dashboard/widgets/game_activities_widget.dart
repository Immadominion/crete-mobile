import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

/// Game activities widget for DeFi/gaming integration
class GameActivitiesWidget extends StatelessWidget {

  const GameActivitiesWidget({
    super.key,
    required this.isDarkMode,
    required this.onClose,
  });
  final bool isDarkMode;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.h,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDarkMode
                      ? AppColors.darkContainerBorder
                      : AppColors.gray200,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Activities',
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                    fontSize: 18.sp,
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: Icon(
                    PhosphorIcons.x(PhosphorIconsStyle.bold),
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
          // Activities list
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.w),
              children: [
                _buildActivityItem(
                  icon: PhosphorIcons.gameController(PhosphorIconsStyle.bold),
                  title: 'Start Game Session',
                  description: 'Invite members to play together',
                  color: Colors.blue,
                  onTap: () => _startGameSession(),
                ),
                SizedBox(height: 12.h),
                _buildActivityItem(
                  icon: PhosphorIcons.coins(PhosphorIconsStyle.bold),
                  title: 'Token Swap',
                  description: 'Quick token exchange',
                  color: Colors.orange,
                  onTap: () => _openTokenSwap(),
                ),
                SizedBox(height: 12.h),
                _buildActivityItem(
                  icon: PhosphorIcons.chartLine(PhosphorIconsStyle.bold),
                  title: 'Price Charts',
                  description: 'View community token prices',
                  color: Colors.green,
                  onTap: () => _openPriceCharts(),
                ),
                SizedBox(height: 12.h),
                _buildActivityItem(
                  icon: PhosphorIcons.handshake(PhosphorIconsStyle.bold),
                  title: 'P2P Trading',
                  description: 'Direct member-to-member trading',
                  color: Colors.purple,
                  onTap: () => _openP2PTrading(),
                ),
                SizedBox(height: 12.h),
                _buildActivityItem(
                  icon: PhosphorIcons.trophy(PhosphorIconsStyle.bold),
                  title: 'Leaderboard',
                  description: 'Community achievements',
                  color: Colors.yellow,
                  onTap: () => _openLeaderboard(),
                ),
                SizedBox(height: 12.h),
                _buildActivityItem(
                  icon: PhosphorIcons.gift(PhosphorIconsStyle.bold),
                  title: 'Rewards',
                  description: 'Claim community rewards',
                  color: Colors.pink,
                  onTap: () => _openRewards(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required PhosphorIconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.darkContainerBorder.withOpacity(0.3)
              : AppColors.gray100,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 24.sp),
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
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: AppTypography.geistRegular12.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray600,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              PhosphorIcons.arrowRight(PhosphorIconsStyle.bold),
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _startGameSession() {
    // Start game session
    debugPrint('Start game session');
  }

  void _openTokenSwap() {
    // Open token swap
    debugPrint('Open token swap');
  }

  void _openPriceCharts() {
    // Open price charts
    debugPrint('Open price charts');
  }

  void _openP2PTrading() {
    // Open P2P trading
    debugPrint('Open P2P trading');
  }

  void _openLeaderboard() {
    // Open leaderboard
    debugPrint('Open leaderboard');
  }

  void _openRewards() {
    // Open rewards
    debugPrint('Open rewards');
  }
}
