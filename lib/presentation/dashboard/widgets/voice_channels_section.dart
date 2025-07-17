import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

/// Model for voice channel items
class VoiceChannelItem {
  final String name;
  final String community;
  final int memberCount;
  final bool isActive;
  final VoidCallback? onJoin;

  const VoiceChannelItem({
    required this.name,
    required this.community,
    required this.memberCount,
    required this.isActive,
    this.onJoin,
  });
}

/// Animated voice channels section with pulse animation for active channels
class VoiceChannelsSection extends StatefulWidget {
  final List<VoiceChannelItem> channels;
  final VoidCallback? onSeeAll;

  const VoiceChannelsSection({
    super.key,
    required this.channels,
    this.onSeeAll,
  });

  @override
  State<VoiceChannelsSection> createState() => _VoiceChannelsSectionState();
}

class _VoiceChannelsSectionState extends State<VoiceChannelsSection>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late List<Animation<double>> _slideAnimations;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Slide animation for initial appearance
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Pulse animation for active channels
    _pulseController = AnimationController(
      duration: const Duration(
        milliseconds: 3000,
      ), // Adjusted for full sequence
      vsync: this,
    );

    // Calculate safe intervals to prevent going over 1.0
    final itemCount = widget.channels.length;
    if (itemCount == 0) return;

    // Use a more conservative approach for staggered animations
    const maxStaggerRatio = 0.3; // Max 30% of total duration for staggering
    const animationRatio = 0.7; // 70% of total duration for each animation

    final staggerDelay = maxStaggerRatio / itemCount;
    final animationDuration = animationRatio;

    _slideAnimations = List.generate(itemCount, (index) {
      final startTime = (index * staggerDelay).clamp(0.0, 0.3);
      final endTime = (startTime + animationDuration).clamp(startTime, 1.0);

      return Tween<double>(begin: 100.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _slideController,
          curve: Interval(startTime, endTime, curve: Curves.easeOutCubic),
        ),
      );
    });

    // Define the subtle nudge sequence
    _pulseAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.05,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.05,
          end: 0.98,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.98,
          end: 1.02,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.02,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1.0,
      ),
    ]).animate(_pulseController);

    // Start animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _slideController.forward();
          _pulseController
              .repeat(); // Repeat the sequence for continuous subtle nudges
        }
      });
    });
  }

  @override
  void didUpdateWidget(VoiceChannelsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.channels.length != widget.channels.length) {
      _slideController.dispose();
      _initializeAnimations();
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(isDarkMode),
        SizedBox(height: 16.h),
        AnimatedBuilder(
          animation: _slideController,
          builder: (context, child) {
            return Column(
              children: widget.channels.asMap().entries.map((entry) {
                final index = entry.key;
                final channel = entry.value;

                return Transform.translate(
                  offset: Offset(_slideAnimations[index].value, 0),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    child: _buildVoiceChannelItem(channel, isDarkMode),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionHeader(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              PhosphorIcons.speakerHigh(PhosphorIconsStyle.bold),
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Active Voice Channels',
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
        if (widget.onSeeAll != null)
          GestureDetector(
            onTap: widget.onSeeAll,
            child: Text(
              'See All',
              style: AppTypography.geistMedium13.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVoiceChannelItem(VoiceChannelItem channel, bool isDarkMode) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: channel.isActive ? _pulseAnimation.value : 1.0,
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.black : AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: channel.isActive
                    ? AppColors.primary.withOpacity(0.3)
                    : (isDarkMode
                          ? AppColors.darkContainerBorder
                          : AppColors.gray200),
                width: channel.isActive ? 2 : 1,
              ),
              boxShadow: channel.isActive
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        PhosphorIcons.speakerHigh(PhosphorIconsStyle.bold),
                        color: AppColors.primary,
                        size: 20.sp,
                      ),
                    ),
                    if (channel.isActive)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        channel.name,
                        style: AppTypography.geistSemiBold15.copyWith(
                          color: isDarkMode
                              ? AppColors.darkTextPrimary
                              : AppColors.gray900,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Text(
                            channel.community,
                            style: AppTypography.geistRegular12.copyWith(
                              color: isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : AppColors.gray600,
                            ),
                          ),
                          Text(
                            ' • ',
                            style: AppTypography.geistRegular12.copyWith(
                              color: isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : AppColors.gray600,
                            ),
                          ),
                          Icon(
                            PhosphorIcons.users(PhosphorIconsStyle.regular),
                            size: 12.sp,
                            color: isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.gray600,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${channel.memberCount}',
                            style: AppTypography.geistRegular12.copyWith(
                              color: isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : AppColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: channel.onJoin,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'Join',
                      style: AppTypography.geistMedium11.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
