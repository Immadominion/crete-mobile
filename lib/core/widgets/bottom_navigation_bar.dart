import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/spacing.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84.h,
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        border: Border(
          top: BorderSide(color: Theme.of(context).shadowColor, width: 1.sp),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              context: context,
              index: 0,
              iconPath: 'assets/icons/svgs/bottom-navigation/dao-home.svg',
              label: 'Home',
            ),
            _buildNavItem(
              context: context,
              index: 1,
              iconPath: 'assets/icons/svgs/bottom-navigation/Watch.svg',
              label: 'Activity',
            ),
            _buildNavItem(
              context: context,
              index: 2,
              iconPath: 'assets/icons/svgs/bottom-navigation/Eclipse.svg',
              label: 'Create',
            ),
            _buildNavItem(
              context: context,
              index: 3,
              iconPath: 'assets/icons/svgs/bottom-navigation/compass.svg',
              label: 'Explore',
            ),

            _buildNavItem(
              context: context,
              index: 4,
              iconPath: 'assets/icons/svgs/bottom-navigation/profile.svg',
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String iconPath,
    required String label,
  }) {
    // final isActive = currentIndex == index;
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.sm.w,
          vertical: AppSpacing.xs.h,
        ),
        child: SizedBox(
          width: 24.w,
          height: 24.h,
          child: SvgPicture.asset(
            iconPath,
            fit: BoxFit.fill,
            // colorFilter: ColorFilter.mode(
            //   isActive
            //       ? AppColors.primary
            //       : isDarkMode
            //       ? AppColors.navigationInactive
            //       : AppColors.gray500,
            //   BlendMode.srcIn,
            // ),
          ),
        ),
      ),
    );
  }
}
