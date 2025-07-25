import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../models/voice_models.dart';

class VoiceHubStatsSection extends StatefulWidget {
  final VoiceHubStats stats;

  const VoiceHubStatsSection({super.key, required this.stats});

  @override
  State<VoiceHubStatsSection> createState() => _VoiceHubStatsSectionState();
}

class _VoiceHubStatsSectionState extends State<VoiceHubStatsSection>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _countController;
  late List<Animation<double>> _slideAnimations;
  late Animation<int> _participantCountAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _countController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create staggered slide animations for each stat card
    _slideAnimations = List.generate(4, (index) {
      final startTime = index * 0.1;
      final endTime = startTime + 0.4;
      return Tween<double>(begin: 50.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _slideController,
          curve: Interval(startTime, endTime, curve: Curves.easeOutQuart),
        ),
      );
    });

    _participantCountAnimation =
        IntTween(begin: 0, end: widget.stats.totalActiveParticipants).animate(
          CurvedAnimation(parent: _countController, curve: Curves.easeOutQuart),
        );

    // Start animations
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _slideController.forward();
        _countController.forward();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Activity',
            style: AppTypography.geistSemiBold15.copyWith(
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 16.h),
          AnimatedBuilder(
            animation: _slideController,
            builder: (context, child) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimations[0].value),
                          child: _buildMainStatCard(isDarkMode),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimations[1].value),
                          child: _buildEventsCard(isDarkMode),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimations[2].value),
                          child: _buildTimeCard(isDarkMode),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Transform.translate(
                          offset: Offset(0, _slideAnimations[3].value),
                          child: _buildAchievementsCard(isDarkMode),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMainStatCard(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primaryLight.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  PhosphorIcons.users(PhosphorIconsStyle.bold),
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'LIVE',
                  style: AppTypography.geistSemiBold13.copyWith(
                    color: AppColors.success,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          AnimatedBuilder(
            animation: _participantCountAnimation,
            builder: (context, child) {
              return Text(
                '${_participantCountAnimation.value}',
                style: AppTypography.geistSemiBold15.copyWith(
                  fontSize: 24.sp,
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                ),
              );
            },
          ),
          SizedBox(height: 4.h),
          Text(
            'Active Participants',
            style: AppTypography.geistRegular12.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsCard(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkBackgroundSecondary
            : AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            PhosphorIcons.calendar(PhosphorIconsStyle.bold),
            color: AppColors.info,
            size: 24.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            '${widget.stats.scheduledEventsCount}',
            style: AppTypography.geistSemiBold15.copyWith(
              fontSize: 24.sp,
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Scheduled Events',
            style: AppTypography.geistRegular12.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkBackgroundSecondary
            : AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            PhosphorIcons.clock(PhosphorIconsStyle.bold),
            color: AppColors.warning,
            size: 24.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            '${widget.stats.todayVoiceTime.inHours}h ${widget.stats.todayVoiceTime.inMinutes % 60}m',
            style: AppTypography.geistSemiBold15.copyWith(
              fontSize: 20.sp,
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Voice Time Today',
            style: AppTypography.geistRegular12.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsCard(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkBackgroundSecondary
            : AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            PhosphorIcons.trophy(PhosphorIconsStyle.bold),
            color: AppColors.warning,
            size: 24.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            '${widget.stats.achievements.length}',
            style: AppTypography.geistSemiBold15.copyWith(
              fontSize: 24.sp,
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Achievements',
            style: AppTypography.geistRegular12.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
          ),
        ],
      ),
    );
  }
}
