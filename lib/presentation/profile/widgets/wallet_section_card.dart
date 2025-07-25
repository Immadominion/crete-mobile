import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

class WalletSectionCard extends StatelessWidget {
  final bool isDarkMode;

  const WalletSectionCard({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main wallet card
        _buildMainWalletCard(),
        SizedBox(height: 12.h),

        // Wallet action cards
        _buildWalletActionCard(
          PhosphorIcons.wallet(PhosphorIconsStyle.bold),
          'Manage Wallets',
          'Connect or disconnect wallets',
          const Color(0xFF5865F2),
        ),
        SizedBox(height: 12.h),
        _buildWalletActionCard(
          PhosphorIcons.clockCounterClockwise(PhosphorIconsStyle.bold),
          'Transaction History',
          'View all your transactions',
          const Color(0xFFFAA61A),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildMainWalletCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
      ),
      child: Column(
        children: [
          // Wallet header
          Row(
            children: [
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
              SizedBox(width: 16.w),
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
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF57F287),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '0x1234...5678',
                      style: AppTypography.geistRegular12.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                PhosphorIcons.dotsThree(PhosphorIconsStyle.bold),
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
                size: 20.sp,
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Balance section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Balance',
                    style: AppTypography.geistRegular12.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '1,234.56 SOL',
                    style: AppTypography.geistSemiBold15.copyWith(
                      color: const Color(0xFF00D4AA),
                      fontSize: 20.sp,
                    ),
                  ),
                ],
              ),
              Icon(
                PhosphorIcons.trendUp(PhosphorIconsStyle.bold),
                color: const Color(0xFF57F287),
                size: 24.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletActionCard(
    IconData icon,
    String title,
    String subtitle,
    Color accentColor,
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
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withOpacity(0.15),
            ),
            child: Icon(icon, color: accentColor, size: 20.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.geistMedium15.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: AppTypography.geistRegular12.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
            color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
            size: 16.sp,
          ),
        ],
      ),
    );
  }
}
