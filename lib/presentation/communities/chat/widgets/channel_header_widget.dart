import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';

/// Enhanced channel header with animated elements and rich interactions
class ChannelHeaderWidget extends StatefulWidget {
  const ChannelHeaderWidget({
    super.key,
    required this.channelName,
    required this.channelDescription,
    required this.channelIcon,
    required this.onlineCount,
    required this.isDarkMode,
    required this.onBackPressed,
    required this.showMenu,
    this.onMembersPressed,
    this.onSearchPressed,
    this.onVideoCallPressed,
    this.onVoiceCallPressed,
  });

  final String channelName;
  final String channelDescription;
  final PhosphorIconData channelIcon;
  final int onlineCount;
  final bool isDarkMode;
  final VoidCallback onBackPressed;
  final VoidCallback showMenu;
  final VoidCallback? onMembersPressed;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onVideoCallPressed;
  final VoidCallback? onVoiceCallPressed;

  @override
  State<ChannelHeaderWidget> createState() => _ChannelHeaderWidgetState();
}

class _ChannelHeaderWidgetState extends State<ChannelHeaderWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? AppColors.darkBackgroundPrimary
              : AppColors.backgroundPrimary,
          border: Border(
            bottom: BorderSide(
              color: widget.isDarkMode
                  ? AppColors.darkContainerBorder.withOpacity(0.3)
                  : AppColors.gray200.withOpacity(0.5),
              width: 1,
            ),
          ),
          boxShadow: [
            if (!widget.isDarkMode)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
          ],
        ),
        child: Row(
          children: [
            // Enhanced back button
            _buildBackButton(),

            SizedBox(width: 12.w),

            // Channel icon with subtle animation
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_pulseAnimation.value - 1.0) * 0.05,
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      widget.channelIcon,
                      color: AppColors.primary,
                      size: 18.sp,
                    ),
                  ),
                );
              },
            ),

            SizedBox(width: 12.w),

            // Channel info with improved typography
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.channelName,
                          style: AppTypography.geistSemiBold15.copyWith(
                            color: widget.isDarkMode
                                ? AppColors.darkTextPrimary
                                : AppColors.gray900,
                            fontSize: 16.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      _buildOnlineIndicator(),
                    ],
                  ),
                  if (widget.channelDescription.isNotEmpty)
                    Text(
                      widget.channelDescription,
                      style: AppTypography.geistRegular12.copyWith(
                        color: widget.isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // Action buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? AppColors.darkContainerBorder.withOpacity(0.3)
            : AppColors.gray100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: widget.onBackPressed,
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              PhosphorIcons.arrowLeft(PhosphorIconsStyle.bold),
              color: widget.isDarkMode
                  ? AppColors.darkTextPrimary
                  : AppColors.gray900,
              size: 20.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: const BoxDecoration(
              color: AppColors.secondary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            '${widget.onlineCount}',
            style: AppTypography.geistMedium11.copyWith(
              color: AppColors.secondary,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search button
        if (widget.onSearchPressed != null) ...[
          _buildIconButton(
            PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
            widget.onSearchPressed!,
          ),
          SizedBox(width: 8.w),
        ],

        // Voice call button
        if (widget.onVoiceCallPressed != null) ...[
          _buildIconButton(
            PhosphorIcons.phone(PhosphorIconsStyle.bold),
            widget.onVoiceCallPressed!,
          ),
          SizedBox(width: 8.w),
        ],

        // Video call button
        if (widget.onVideoCallPressed != null) ...[
          _buildIconButton(
            PhosphorIcons.videoCamera(PhosphorIconsStyle.bold),
            widget.onVideoCallPressed!,
          ),
          SizedBox(width: 8.w),
        ],

        // Members button
        if (widget.onMembersPressed != null) ...[
          _buildIconButton(
            PhosphorIcons.users(PhosphorIconsStyle.bold),
            widget.onMembersPressed!,
          ),
          SizedBox(width: 8.w),
        ],

        // Menu button
        _buildIconButton(
          PhosphorIcons.dotsThreeVertical(PhosphorIconsStyle.bold),
          widget.showMenu,
        ),
      ],
    );
  }

  Widget _buildIconButton(PhosphorIconData icon, VoidCallback onTap) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? AppColors.darkContainerBorder.withOpacity(0.3)
            : AppColors.gray100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              icon,
              color: widget.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
              size: 18.sp,
            ),
          ),
        ),
      ),
    );
  }
}
