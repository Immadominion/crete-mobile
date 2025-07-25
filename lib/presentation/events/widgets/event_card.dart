import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../models/voice_event_models.dart';
import '../models/voice_models.dart';

class EventCard extends StatefulWidget {
  final VoiceEvent event;
  final String? currentUserId;
  final void Function(String eventId, RSVPResponse response)? onRSVPChanged;
  final VoidCallback? onTap;
  final bool showDetails;

  const EventCard({
    super.key,
    required this.event,
    this.currentUserId,
    this.onRSVPChanged,
    this.onTap,
    this.showDetails = true,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> with TickerProviderStateMixin {
  late AnimationController _rsvpController;
  late AnimationController _pulseController;
  late Animation<double> _rsvpAnimation;
  late Animation<double> _pulseAnimation;

  EventRSVP? _currentUserRSVP;

  @override
  void initState() {
    super.initState();

    _rsvpController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rsvpAnimation = CurvedAnimation(
      parent: _rsvpController,
      curve: Curves.elasticOut,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _findCurrentUserRSVP();

    // Start pulse animation for upcoming events
    if (widget.event.timeUntilStart.inHours < 24 &&
        widget.event.timeUntilStart.isNegative == false) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _rsvpController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _findCurrentUserRSVP() {
    if (widget.currentUserId != null) {
      try {
        _currentUserRSVP = widget.event.rsvps.firstWhere(
          (rsvp) => rsvp.userId == widget.currentUserId,
        );
      } catch (e) {
        _currentUserRSVP = null;
      }
    }
  }

  void _handleRSVP(RSVPResponse response) {
    setState(() {
      if (_currentUserRSVP?.response == response) {
        // If clicking the same response, remove RSVP
        _currentUserRSVP = null;
      } else {
        // Update or create RSVP
        _currentUserRSVP = EventRSVP(
          userId: widget.currentUserId ?? 'current_user',
          userName: 'Current User', // In real app, get from user state
          response: response,
          timestamp: DateTime.now(),
        );
      }
    });

    _rsvpController.forward().then((_) {
      _rsvpController.reverse();
    });

    widget.onRSVPChanged?.call(widget.event.id, response);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkBackgroundSecondary
                    : AppColors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isDarkMode
                      ? AppColors.darkContainerBorder
                      : AppColors.gray200,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.black.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isDarkMode),
                  SizedBox(height: 12.h),
                  _buildEventInfo(isDarkMode),
                  if (widget.showDetails) ...[
                    SizedBox(height: 12.h),
                    _buildEventDetails(isDarkMode),
                    SizedBox(height: 16.h),
                    _buildRSVPSection(isDarkMode),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Row(
      children: [
        _buildEventIcon(),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.event.title,
                style: AppTypography.geistSemiBold15.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                  fontSize: 16.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (widget.event.communityName != null)
                Text(
                  widget.event.communityName!,
                  style: AppTypography.geistRegular12.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600,
                  ),
                ),
            ],
          ),
        ),
        _buildStatusChip(isDarkMode),
      ],
    );
  }

  Widget _buildEventIcon() {
    IconData icon;
    Color color;

    switch (widget.event.type) {
      case VoiceSessionType.game:
        icon = PhosphorIcons.gameController(PhosphorIconsStyle.bold);
        color = AppColors.error;
        break;
      case VoiceSessionType.studySession:
        icon = PhosphorIcons.graduationCap(PhosphorIconsStyle.bold);
        color = AppColors.success;
        break;
      case VoiceSessionType.meeting:
        icon = PhosphorIcons.briefcase(PhosphorIconsStyle.bold);
        color = AppColors.warning;
        break;
      case VoiceSessionType.event:
        icon = PhosphorIcons.calendar(PhosphorIconsStyle.bold);
        color = AppColors.primary;
        break;
      case VoiceSessionType.video:
        icon = PhosphorIcons.videoCamera(PhosphorIconsStyle.bold);
        color = AppColors.info;
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

  Widget _buildStatusChip(bool isDarkMode) {
    final timeText = widget.event.timeUntilStartText;
    final isUrgent =
        widget.event.timeUntilStart.inHours < 24 &&
        !widget.event.timeUntilStart.isNegative;

    Color backgroundColor;
    Color textColor;
    Color borderColor;

    switch (widget.event.status) {
      case EventStatus.active:
        backgroundColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        borderColor = AppColors.success;
        break;
      case EventStatus.cancelled:
        backgroundColor = AppColors.error.withOpacity(0.1);
        textColor = AppColors.error;
        borderColor = AppColors.error;
        break;
      default:
        if (isUrgent) {
          backgroundColor = AppColors.warning.withOpacity(0.1);
          textColor = AppColors.warning;
          borderColor = AppColors.warning;
        } else {
          backgroundColor = isDarkMode
              ? AppColors.darkBackgroundPrimary
              : AppColors.backgroundSecondary;
          textColor = isDarkMode
              ? AppColors.darkTextSecondary
              : AppColors.gray600;
          borderColor = Colors.transparent;
        }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: borderColor != Colors.transparent
            ? Border.all(color: borderColor.withOpacity(0.3))
            : null,
      ),
      child: Text(
        timeText,
        style: AppTypography.geistSemiBold13.copyWith(
          color: textColor,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  Widget _buildEventInfo(bool isDarkMode) {
    if (!widget.showDetails) return const SizedBox();

    return Text(
      widget.event.description,
      style: AppTypography.geistRegular13.copyWith(
        color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildEventDetails(bool isDarkMode) {
    if (!widget.showDetails) return const SizedBox();

    return Row(
      children: [
        _buildDetailItem(
          icon: PhosphorIcons.clock(PhosphorIconsStyle.regular),
          text: _formatEventTime(),
          isDarkMode: isDarkMode,
        ),
        SizedBox(width: 16.w),
        _buildDetailItem(
          icon: PhosphorIcons.users(PhosphorIconsStyle.regular),
          text: '${widget.event.goingCount}/${widget.event.maxParticipants}',
          isDarkMode: isDarkMode,
        ),
        if (widget.event.hasWaitlist) ...[
          SizedBox(width: 16.w),
          _buildDetailItem(
            icon: PhosphorIcons.queue(PhosphorIconsStyle.regular),
            text: '${widget.event.waitlistCount} waiting',
            isDarkMode: isDarkMode,
            color: AppColors.warning,
          ),
        ],
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String text,
    required bool isDarkMode,
    Color? color,
  }) {
    final itemColor =
        color ?? (isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: itemColor),
        SizedBox(width: 4.w),
        Text(
          text,
          style: AppTypography.geistRegular12.copyWith(color: itemColor),
        ),
      ],
    );
  }

  Widget _buildRSVPSection(bool isDarkMode) {
    if (!widget.showDetails) return const SizedBox();

    return Column(
      children: [
        if (widget.event.rsvps.isNotEmpty) _buildRSVPSummary(isDarkMode),
        SizedBox(height: 12.h),
        _buildRSVPButtons(isDarkMode),
      ],
    );
  }

  Widget _buildRSVPSummary(bool isDarkMode) {
    return Row(
      children: [
        _buildRSVPCount(
          'Going',
          widget.event.goingCount,
          AppColors.success,
          isDarkMode,
        ),
        SizedBox(width: 16.w),
        _buildRSVPCount(
          'Maybe',
          widget.event.maybeCount,
          AppColors.warning,
          isDarkMode,
        ),
        SizedBox(width: 16.w),
        _buildRSVPCount(
          'Can\'t go',
          widget.event.notGoingCount,
          AppColors.error,
          isDarkMode,
        ),
      ],
    );
  }

  Widget _buildRSVPCount(
    String label,
    int count,
    Color color,
    bool isDarkMode,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4.w),
        Text(
          '$count $label',
          style: AppTypography.geistRegular12.copyWith(
            color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
          ),
        ),
      ],
    );
  }

  Widget _buildRSVPButtons(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: _buildRSVPButton(
            RSVPResponse.going,
            'Going',
            PhosphorIcons.check(PhosphorIconsStyle.bold),
            AppColors.success,
            isDarkMode,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildRSVPButton(
            RSVPResponse.maybe,
            'Maybe',
            PhosphorIcons.question(PhosphorIconsStyle.bold),
            AppColors.warning,
            isDarkMode,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _buildRSVPButton(
            RSVPResponse.notGoing,
            'Can\'t go',
            PhosphorIcons.x(PhosphorIconsStyle.bold),
            AppColors.error,
            isDarkMode,
          ),
        ),
      ],
    );
  }

  Widget _buildRSVPButton(
    RSVPResponse response,
    String label,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) {
    final isSelected = _currentUserRSVP?.response == response;

    return AnimatedBuilder(
      animation: _rsvpAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isSelected && _rsvpAnimation.value > 0
              ? 1.0 + (_rsvpAnimation.value * 0.1)
              : 1.0,
          child: GestureDetector(
            onTap: () => _handleRSVP(response),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withOpacity(0.1)
                    : (isDarkMode
                          ? AppColors.darkBackgroundPrimary
                          : AppColors.backgroundSecondary),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: isSelected
                      ? color
                      : (isDarkMode
                            ? AppColors.darkContainerBorder
                            : AppColors.gray300),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 14.sp,
                    color: isSelected
                        ? color
                        : (isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.gray600),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    label,
                    style: AppTypography.geistMedium13.copyWith(
                      color: isSelected
                          ? color
                          : (isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.gray600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatEventTime() {
    final start = widget.event.startTime;
    final timeFormat =
        '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';

    if (widget.event.endTime != null) {
      final end = widget.event.endTime!;
      final endTimeFormat =
          '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
      return '$timeFormat - $endTimeFormat';
    } else if (widget.event.duration != null) {
      final endTime = start.add(widget.event.duration!);
      final endTimeFormat =
          '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
      return '$timeFormat - $endTimeFormat';
    }

    return timeFormat;
  }
}
