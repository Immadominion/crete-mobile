import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_secondary_button.dart';
import '../widgets/auth_text_button.dart';

class SignInPageContent extends StatelessWidget {
  const SignInPageContent({
    super.key,
    required this.isDarkMode,
    required this.statusBarHeight,
    required this.isConnecting,
    required this.onWalletConnect,
    required this.onDiscordImport,
    required this.onGuestMode,
  });

  final bool isDarkMode;
  final double statusBarHeight;
  final bool isConnecting;
  final VoidCallback onWalletConnect;
  final VoidCallback onDiscordImport;
  final VoidCallback onGuestMode;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Top illustration - clips to status bar and fills width
          _buildTopIllustration(statusBarHeight),

          // Content section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: Column(
              children: [
                // Main heading
                _buildMainHeading(isDarkMode),

                SizedBox(height: 14.h),

                // Subtitle
                _buildSubtitle(isDarkMode),

                SizedBox(height: 92.h),

                // CTA buttons
                _buildCTAButtons(isDarkMode),

                SizedBox(height: 50.h), // Bottom padding
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopIllustration(double statusBarHeight) {
    return SizedBox(
      width: double.infinity,
      height: 370.91.h + statusBarHeight, // Include status bar coverage
      child: Stack(
        children: [
          // Illustration fills the entire container
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/icons/svgs/crete_login_illustrations.svg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Overlay AppStore image at specified position
          Positioned(
            top: 250.h,
            left: 0.w,
            right: 0.w,
            child: Center(
              child: SizedBox(
                width: 180.w,
                child: Image.asset(
                  'assets/icons/transparent/appstore.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainHeading(bool isDarkMode) {
    return Text(
      'All your DAO needs in one place',
      textAlign: TextAlign.center,
      style: AppTypography.signInHeading.copyWith(
        fontSize: 32.sp,
        color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
      ),
    );
  }

  Widget _buildSubtitle(bool isDarkMode) {
    return Text(
      'One home for DAO chats, votes, and community tools, without the chaos.',
      textAlign: TextAlign.center,
      style: AppTypography.signInSubtitle.copyWith(
        fontSize: 14.sp,
        color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
      ),
    );
  }

  Widget _buildCTAButtons(bool isDarkMode) {
    return Column(
      children: [
        // Connect Wallet Button
        AuthButton(
          text: 'Connect your wallet',
          onPressed: isConnecting ? null : onWalletConnect,
          isLoading: isConnecting,
          width: 293.w,
          height: 45.h,
        ),

        SizedBox(height: 12.h),

        // Import from Discord Button
        AuthSecondaryButton(
          text: 'Import from discord',
          iconPath: 'assets/icons/svgs/discord.svg',
          onPressed: onDiscordImport,
          width: 293.w,
          height: 45.h,
        ),

        SizedBox(height: 12.h),

        // Browse as Guest Button
        AuthTextButton(
          text: 'Browse as guest',
          onPressed: onGuestMode,
          width: 140.w, // Increased width to accommodate the text
          height: 21.h,
        ),
      ],
    );
  }
}
