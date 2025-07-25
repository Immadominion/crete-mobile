import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../models/voice_event_models.dart';
import '../models/voice_models.dart';

/// Time-aware notification types
enum NotificationType {
  eventStarting,
  eventLive,
  eventEnding,
  sessionActive,
  rsvpReminder,
  waitlistOpened,
}

/// Time-aware notification model
class TimeAwareNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final Duration? timeLeft;
  final VoiceEvent? event;
  final VoiceSession? session;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final Color? accentColor;

  const TimeAwareNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.timeLeft,
    this.event,
    this.session,
    this.onTap,
    this.onDismiss,
    this.accentColor,
  });

  /// Creates notification for event starting soon
  factory TimeAwareNotification.eventStarting({
    required VoiceEvent event,
    required Duration timeLeft,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
  }) {
    return TimeAwareNotification(
      id: 'event_starting_${event.id}',
      type: NotificationType.eventStarting,
      title: event.title,
      subtitle: 'Starting in ${_formatDuration(timeLeft)}',
      timestamp: event.startTime,
      timeLeft: timeLeft,
      event: event,
      onTap: onTap,
      onDismiss: onDismiss,
      accentColor: AppColors.warning,
    );
  }

  /// Creates notification for live event
  factory TimeAwareNotification.eventLive({
    required VoiceEvent event,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
  }) {
    return TimeAwareNotification(
      id: 'event_live_${event.id}',
      type: NotificationType.eventLive,
      title: event.title,
      subtitle: 'Live now • ${event.goingCount} participants',
      timestamp: event.startTime,
      event: event,
      onTap: onTap,
      onDismiss: onDismiss,
      accentColor: AppColors.error,
    );
  }

  /// Creates notification for event ending soon
  factory TimeAwareNotification.eventEnding({
    required VoiceEvent event,
    required Duration timeLeft,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
  }) {
    return TimeAwareNotification(
      id: 'event_ending_${event.id}',
      type: NotificationType.eventEnding,
      title: event.title,
      subtitle: 'Ending in ${_formatDuration(timeLeft)}',
      timestamp: event.endTime ?? event.startTime,
      timeLeft: timeLeft,
      event: event,
      onTap: onTap,
      onDismiss: onDismiss,
      accentColor: AppColors.info,
    );
  }

  /// Creates notification for active session
  factory TimeAwareNotification.sessionActive({
    required VoiceSession session,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
  }) {
    return TimeAwareNotification(
      id: 'session_active_${session.id}',
      type: NotificationType.sessionActive,
      title: session.title,
      subtitle: '${session.participants.length} people talking',
      timestamp: session.startTime,
      session: session,
      onTap: onTap,
      onDismiss: onDismiss,
      accentColor: AppColors.success,
    );
  }

  /// Creates RSVP reminder notification
  factory TimeAwareNotification.rsvpReminder({
    required VoiceEvent event,
    required Duration timeLeft,
    VoidCallback? onTap,
    VoidCallback? onDismiss,
  }) {
    return TimeAwareNotification(
      id: 'rsvp_reminder_${event.id}',
      type: NotificationType.rsvpReminder,
      title: 'RSVP reminder',
      subtitle: '${event.title} starts in ${_formatDuration(timeLeft)}',
      timestamp: event.startTime,
      timeLeft: timeLeft,
      event: event,
      onTap: onTap,
      onDismiss: onDismiss,
      accentColor: AppColors.primary,
    );
  }

  static String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}

/// Time-aware notification widget with animations and micro-interactions
class TimeAwareNotificationWidget extends StatefulWidget {
  final TimeAwareNotification notification;
  final bool isDarkMode;
  final VoidCallback? onDismiss;

  const TimeAwareNotificationWidget({
    super.key,
    required this.notification,
    required this.isDarkMode,
    this.onDismiss,
  });

  @override
  State<TimeAwareNotificationWidget> createState() =>
      _TimeAwareNotificationWidgetState();
}

class _TimeAwareNotificationWidgetState
    extends State<TimeAwareNotificationWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _dismissController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _dismissAnimation;

  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _slideController.forward();

    // Start pulse animation for live notifications
    if (widget.notification.type == NotificationType.eventLive ||
        widget.notification.type == NotificationType.sessionActive) {
      _pulseController.repeat(reverse: true);
    }
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _dismissController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutQuart),
        );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _dismissAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _dismissController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    _dismissController.dispose();
    super.dispose();
  }

  Future<void> _handleDismiss() async {
    if (_isDismissing) return;

    setState(() => _isDismissing = true);
    await _dismissController.forward();

    if (mounted) {
      widget.onDismiss?.call();
      widget.notification.onDismiss?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _dismissAnimation,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: widget.isDarkMode
                      ? AppColors.darkBackgroundSecondary
                      : AppColors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color:
                        widget.notification.accentColor?.withOpacity(0.3) ??
                        (widget.isDarkMode
                            ? AppColors.darkContainerBorder
                            : AppColors.gray300),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (widget.notification.accentColor ?? AppColors.primary)
                              .withOpacity(0.1),
                      blurRadius: 8.r,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _buildNotificationContent(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationContent() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.notification.onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              _buildLeadingIcon(),
              SizedBox(width: 12.w),
              Expanded(child: _buildContent()),
              _buildTrailingActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    IconData icon;
    Color iconColor = widget.notification.accentColor ?? AppColors.primary;

    switch (widget.notification.type) {
      case NotificationType.eventStarting:
        icon = PhosphorIcons.clock();
        break;
      case NotificationType.eventLive:
        icon = PhosphorIcons.radioButton();
        break;
      case NotificationType.eventEnding:
        icon = PhosphorIcons.clockCountdown();
        break;
      case NotificationType.sessionActive:
        icon = PhosphorIcons.waveform();
        break;
      case NotificationType.rsvpReminder:
        icon = PhosphorIcons.calendar();
        break;
      case NotificationType.waitlistOpened:
        icon = PhosphorIcons.queue();
        break;
    }

    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(icon, size: 16.sp, color: iconColor),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.notification.title,
                style: AppTypography.geistSemiBold13.copyWith(
                  color: widget.isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (_shouldShowLiveBadge()) ...[
              SizedBox(width: 8.w),
              _buildLiveBadge(),
            ],
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          widget.notification.subtitle,
          style: AppTypography.geistRegular12.copyWith(
            color: widget.isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.gray600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (widget.notification.timeLeft != null) ...[
          SizedBox(height: 4.h),
          _buildTimeProgress(),
        ],
      ],
    );
  }

  Widget _buildTrailingActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_shouldShowJoinButton()) _buildJoinButton(),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: _handleDismiss,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Icon(
              PhosphorIcons.x(),
              size: 14.sp,
              color: widget.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLiveBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        'LIVE',
        style: AppTypography.geistMedium11.copyWith(
          color: AppColors.white,
          fontSize: 9.sp,
        ),
      ),
    );
  }

  Widget _buildJoinButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: widget.notification.accentColor ?? AppColors.primary,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        'Join',
        style: AppTypography.geistMedium11.copyWith(
          color: AppColors.white,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  Widget _buildTimeProgress() {
    if (widget.notification.timeLeft == null) {
      return const SizedBox.shrink();
    }

    final totalMinutes =
        widget.notification.type == NotificationType.eventStarting
        ? 30 // 30 minutes warning
        : 60; // 1 hour for ending
    final remainingMinutes = widget.notification.timeLeft!.inMinutes;
    final progress = (totalMinutes - remainingMinutes) / totalMinutes;

    return Column(
      children: [
        SizedBox(height: 4.h),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor:
              (widget.notification.accentColor ?? AppColors.primary)
                  .withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation(
            widget.notification.accentColor ?? AppColors.primary,
          ),
          minHeight: 2.h,
        ),
      ],
    );
  }

  bool _shouldShowLiveBadge() {
    return widget.notification.type == NotificationType.eventLive ||
        widget.notification.type == NotificationType.sessionActive;
  }

  bool _shouldShowJoinButton() {
    return widget.notification.type == NotificationType.eventLive ||
        widget.notification.type == NotificationType.sessionActive ||
        widget.notification.type == NotificationType.eventStarting;
  }
}
