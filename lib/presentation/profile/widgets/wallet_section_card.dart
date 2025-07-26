import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

class WalletSectionCard extends StatelessWidget {
  const WalletSectionCard({super.key, required this.isDarkMode});
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wallet',
          style: AppTypography.heading5.copyWith(
            color: isDarkMode ? Colors.white : AppColors.gray900,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.2)
                    : Colors.white.withOpacity(0.6),
                offset: const Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          margin: EdgeInsets.only(bottom: 24.sp),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.black : AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDarkMode
                  ? AppColors.darkContainerBorder
                  : AppColors.gray200,
            ),
          ),
          child: Column(
            children: [
              // Wallet header with balance
              _buildWalletHeader(),
              SizedBox(height: 16.h),

              // Quick actions row
              _buildQuickActionsRow(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWalletHeader() {
    return Row(
      children: [
        // Wallet icon and info
        Container(
          width: 48.w,
          height: 48.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF00D4AA),
          ),
          child: Icon(
            PhosphorIcons.wallet(PhosphorIconsStyle.bold),
            color: Colors.white,
            size: 22.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Phantom',
                    style: AppTypography.geistSemiBold15.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextPrimary
                          : AppColors.gray900,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF57F287),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                '85sh...CCq3',
                style: AppTypography.geistRegular12.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.gray600,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
        // Balance section - moved to the right
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Total Balance',
              style: AppTypography.geistRegular12.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
                fontSize: 11.sp,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              '1,234.56 SOL',
              style: AppTypography.geistSemiBold15.copyWith(
                color: const Color(0xFF00D4AA),
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildCompactActionButton(
            PhosphorIcons.wallet(PhosphorIconsStyle.bold),
            'Manage',
            AppColors.chatBubbleMe,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildCompactActionButton(
            PhosphorIcons.clockCounterClockwise(PhosphorIconsStyle.bold),
            'History',
            AppColors.chatAway,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactActionButton(
    IconData icon,
    String title,
    Color accentColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: accentColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: accentColor, size: 16.sp),
          SizedBox(width: 6.w),
          Text(
            title,
            style: AppTypography.geistMedium15.copyWith(
              color: accentColor,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
