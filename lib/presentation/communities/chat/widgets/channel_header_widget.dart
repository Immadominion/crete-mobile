import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
// Removed unused import

/// Channel header widget with online indicator and menu
class ChannelHeaderWidget extends StatelessWidget {
  const ChannelHeaderWidget({
    super.key,
    required this.channelName,
    required this.channelDescription,
    required this.channelIcon,
    required this.onlineCount,
    required this.isDarkMode,
    required this.onBackPressed,
    required this.showMenu,
  });

  final String channelName;
  final String channelDescription;
  final PhosphorIconData channelIcon;
  final int onlineCount;
  final bool isDarkMode;
  final VoidCallback onBackPressed;
  final VoidCallback showMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkBackgroundPrimary
            : AppColors.backgroundPrimary,
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 2),
              blurRadius: 5,
            ),
        ],
      ),
      child: Row(
        children: [
          // Back button with animation
          _buildBackButton(),
          SizedBox(width: 12.w),

          // Channel icon and name
          Icon(channelIcon, color: AppColors.primary, size: 20.sp),
          SizedBox(width: 8.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Channel name
                    Text(
                      channelName,
                      style: AppTypography.geistSemiBold15.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.gray900,
                        fontSize: 17.sp,
                      ),
                    ),
                    SizedBox(width: 6.w),

                    // Embedded online indicator
                    _buildEmbeddedOnlineCount(),
                  ],
                ),
                if (channelDescription.isNotEmpty)
                  Text(
                    channelDescription,
                    style: AppTypography.geistRegular13.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray600,
                      fontSize: 13.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          // Consolidated action button
          _buildMenuButton(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkContainerBorder.withOpacity(0.3)
            : AppColors.gray100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: onBackPressed,
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              PhosphorIcons.arrowLeft(PhosphorIconsStyle.bold),
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
              size: 20.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton() {
    return _buildIconButton(
      PhosphorIcons.dotsThreeVertical(PhosphorIconsStyle.bold),
    );
  }

  Widget _buildIconButton(PhosphorIconData icon) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkContainerBorder.withOpacity(0.3)
            : AppColors.gray100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: showMenu,
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              icon,
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
              size: 18.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmbeddedOnlineCount() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkContainerBorder.withOpacity(0.2)
            : AppColors.gray100,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            '$onlineCount',
            style: AppTypography.geistRegular13.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
