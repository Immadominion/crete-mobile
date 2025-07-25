import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../models/voice_models.dart';

class ScheduledEventsSection extends StatefulWidget {
  final List<VoiceSession> scheduledEvents;
  final VoidCallback? onSeeAll;

  const ScheduledEventsSection({
    super.key,
    required this.scheduledEvents,
    this.onSeeAll,
  });

  @override
  State<ScheduledEventsSection> createState() => _ScheduledEventsSectionState();
}

class _ScheduledEventsSectionState extends State<ScheduledEventsSection>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late List<Animation<double>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimations = List.generate(widget.scheduledEvents.length, (index) {
      final startTime = index * 0.1;
      final endTime = startTime + 0.6;
      return Tween<double>(begin: 30.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _slideController,
          curve: Interval(startTime, endTime, curve: Curves.easeOutQuart),
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (widget.scheduledEvents.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(isDarkMode),
          SizedBox(height: 16.h),
          AnimatedBuilder(
            animation: _slideController,
            builder: (context, child) {
              return Column(
                children: widget.scheduledEvents.asMap().entries.map((entry) {
                  final index = entry.key;
                  final event = entry.value;

                  if (index >= _slideAnimations.length) return const SizedBox();

                  return Transform.translate(
                    offset: Offset(0, _slideAnimations[index].value),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      child: _buildEventCard(event, isDarkMode),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              PhosphorIcons.calendar(PhosphorIconsStyle.bold),
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Scheduled Events',
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

  Widget _buildEventCard(VoiceSession event, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.1)
                : Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildEventTypeIcon(event),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: AppTypography.geistSemiBold15.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.gray900,
                      ),
                    ),
                    if (event.communityName != null)
                      Text(
                        event.communityName!,
                        style: AppTypography.geistRegular12.copyWith(
                          color: isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.gray600,
                        ),
                      ),
                  ],
                ),
              ),
              _buildTimeUntilChip(event, isDarkMode),
            ],
          ),
          SizedBox(height: 12.h),
          if (event.eventDescription != null)
            Text(
              event.eventDescription!,
              style: AppTypography.geistRegular13.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          if (event.eventDescription != null) SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                PhosphorIcons.clock(PhosphorIconsStyle.bold),
                size: 14.sp,
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
              SizedBox(width: 4.w),
              Text(
                _formatEventTime(event),
                style: AppTypography.geistRegular12.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.gray600,
                ),
              ),
              const Spacer(),
              _buildRSVPButton(event, isDarkMode),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventTypeIcon(VoiceSession event) {
    IconData icon;
    Color color;

    switch (event.type) {
      case VoiceSessionType.meeting:
        icon = PhosphorIcons.users(PhosphorIconsStyle.bold);
        color = AppColors.info;
        break;
      case VoiceSessionType.event:
        icon = PhosphorIcons.calendar(PhosphorIconsStyle.bold);
        color = AppColors.primaryLight;
        break;
      case VoiceSessionType.studySession:
        icon = PhosphorIcons.book(PhosphorIconsStyle.bold);
        color = AppColors.success;
        break;
      case VoiceSessionType.game:
        icon = PhosphorIcons.gameController(PhosphorIconsStyle.bold);
        color = AppColors.warning;
        break;
      default:
        icon = PhosphorIcons.microphone(PhosphorIconsStyle.bold);
        color = AppColors.primary;
    }

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(icon, color: color, size: 20.sp),
    );
  }

  Widget _buildTimeUntilChip(VoiceSession event, bool isDarkMode) {
    final timeUntil = event.startTime.difference(DateTime.now());
    final isToday = timeUntil.inHours < 24;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isToday
            ? AppColors.warning.withOpacity(0.1)
            : (isDarkMode
                  ? AppColors.darkBackgroundPrimary
                  : AppColors.backgroundSecondary),
        borderRadius: BorderRadius.circular(12.r),
        border: isToday
            ? Border.all(color: AppColors.warning.withOpacity(0.3))
            : null,
      ),
      child: Text(
        event.durationText,
        style: AppTypography.geistSemiBold13.copyWith(
          color: isToday
              ? AppColors.warning
              : (isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600),
          fontSize: 10.sp,
        ),
      ),
    );
  }

  Widget _buildRSVPButton(VoiceSession event, bool isDarkMode) {
    // In a real app, this would be managed by state management
    final isRSVPed = event.id == '4'; // Mock RSVP status for demo

    return GestureDetector(
      onTap: () {
        // Handle RSVP
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isRSVPed
              ? AppColors.success.withOpacity(0.1)
              : AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isRSVPed ? AppColors.success : AppColors.primary,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isRSVPed
                  ? PhosphorIcons.check(PhosphorIconsStyle.bold)
                  : PhosphorIcons.bell(PhosphorIconsStyle.bold),
              size: 12.sp,
              color: isRSVPed ? AppColors.success : AppColors.primary,
            ),
            SizedBox(width: 4.w),
            Text(
              isRSVPed ? 'Going' : 'RSVP',
              style: AppTypography.geistMedium11.copyWith(
                color: isRSVPed ? AppColors.success : AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatEventTime(VoiceSession event) {
    final start = event.startTime;
    final end = event.endTime;

    final timeFormat =
        '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';

    if (end != null) {
      final endTimeFormat =
          '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
      return '$timeFormat - $endTimeFormat';
    }

    return timeFormat;
  }
}
