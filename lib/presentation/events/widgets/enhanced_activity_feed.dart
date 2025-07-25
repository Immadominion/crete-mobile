import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../models/voice_event_models.dart';
import '../models/voice_models.dart';

/// Activity feed item types
enum ActivityType {
  eventCreated,
  eventStarted,
  eventEnded,
  userJoined,
  userLeft,
  rsvpChanged,
  sessionStarted,
  sessionEnded,
  communityUpdated,
  achievementUnlocked,
}

/// Real-time activity model
class ActivityFeedItem {
  final String id;
  final ActivityType type;
  final String title;
  final String? subtitle;
  final String? userName;
  final String? userAvatarUrl;
  final String? eventTitle;
  final String? communityName;
  final DateTime timestamp;
  final Color? accentColor;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isUnread;
  final Map<String, dynamic>? metadata;

  const ActivityFeedItem({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.userName,
    this.userAvatarUrl,
    this.eventTitle,
    this.communityName,
    required this.timestamp,
    this.accentColor,
    this.icon,
    this.onTap,
    this.isUnread = false,
    this.metadata,
  });

  /// Factory constructors for different activity types
  factory ActivityFeedItem.eventCreated({
    required String id,
    required VoiceEvent event,
    required String userName,
    String? userAvatarUrl,
    VoidCallback? onTap,
  }) {
    return ActivityFeedItem(
      id: id,
      type: ActivityType.eventCreated,
      title: '$userName created "${event.title}"',
      subtitle: _formatEventTime(event.startTime),
      userName: userName,
      userAvatarUrl: userAvatarUrl,
      eventTitle: event.title,
      communityName: event.communityName,
      timestamp: DateTime.now(),
      accentColor: AppColors.primary,
      icon: PhosphorIcons.plus(),
      onTap: onTap,
      isUnread: true,
    );
  }

  factory ActivityFeedItem.eventStarted({
    required String id,
    required VoiceEvent event,
    VoidCallback? onTap,
  }) {
    return ActivityFeedItem(
      id: id,
      type: ActivityType.eventStarted,
      title: '"${event.title}" is now live',
      subtitle: '${event.goingCount} participants joined',
      eventTitle: event.title,
      communityName: event.communityName,
      timestamp: event.startTime,
      accentColor: AppColors.error,
      icon: PhosphorIcons.radioButton(),
      onTap: onTap,
      isUnread: true,
    );
  }

  factory ActivityFeedItem.userJoined({
    required String id,
    required String userName,
    required String eventTitle,
    String? userAvatarUrl,
    String? communityName,
    VoidCallback? onTap,
  }) {
    return ActivityFeedItem(
      id: id,
      type: ActivityType.userJoined,
      title: '$userName joined "$eventTitle"',
      subtitle: communityName != null ? 'in $communityName' : null,
      userName: userName,
      userAvatarUrl: userAvatarUrl,
      eventTitle: eventTitle,
      communityName: communityName,
      timestamp: DateTime.now(),
      accentColor: AppColors.success,
      icon: PhosphorIcons.userPlus(),
      onTap: onTap,
      isUnread: true,
    );
  }

  factory ActivityFeedItem.rsvpChanged({
    required String id,
    required String userName,
    required String eventTitle,
    required RSVPResponse response,
    String? userAvatarUrl,
    String? communityName,
    VoidCallback? onTap,
  }) {
    final responseText = response == RSVPResponse.going
        ? 'is going to'
        : response == RSVPResponse.maybe
        ? 'might attend'
        : 'can\'t attend';

    return ActivityFeedItem(
      id: id,
      type: ActivityType.rsvpChanged,
      title: '$userName $responseText "$eventTitle"',
      subtitle: communityName != null ? 'in $communityName' : null,
      userName: userName,
      userAvatarUrl: userAvatarUrl,
      eventTitle: eventTitle,
      communityName: communityName,
      timestamp: DateTime.now(),
      accentColor: response == RSVPResponse.going
          ? AppColors.success
          : response == RSVPResponse.maybe
          ? AppColors.warning
          : AppColors.gray500,
      icon: response == RSVPResponse.going
          ? PhosphorIcons.check()
          : response == RSVPResponse.maybe
          ? PhosphorIcons.question()
          : PhosphorIcons.x(),
      onTap: onTap,
    );
  }

  factory ActivityFeedItem.sessionStarted({
    required String id,
    required VoiceSession session,
    VoidCallback? onTap,
  }) {
    return ActivityFeedItem(
      id: id,
      type: ActivityType.sessionStarted,
      title: 'Voice session started',
      subtitle:
          '${session.title} • ${session.participants.length} participants',
      eventTitle: session.title,
      communityName: session.communityName,
      timestamp: session.startTime,
      accentColor: AppColors.info,
      icon: PhosphorIcons.waveform(),
      onTap: onTap,
      isUnread: true,
    );
  }

  factory ActivityFeedItem.achievementUnlocked({
    required String id,
    required String userName,
    required String achievementTitle,
    String? userAvatarUrl,
    VoidCallback? onTap,
  }) {
    return ActivityFeedItem(
      id: id,
      type: ActivityType.achievementUnlocked,
      title: '$userName unlocked "$achievementTitle"',
      subtitle: 'Achievement completed',
      userName: userName,
      userAvatarUrl: userAvatarUrl,
      timestamp: DateTime.now(),
      accentColor: AppColors.warning,
      icon: PhosphorIcons.trophy(),
      onTap: onTap,
      isUnread: true,
    );
  }

  static String _formatEventTime(DateTime eventTime) {
    final now = DateTime.now();
    final difference = eventTime.difference(now);

    if (difference.isNegative) {
      return 'Started';
    } else if (difference.inDays > 0) {
      return 'in ${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return 'in ${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return 'in ${difference.inMinutes}m';
    } else {
      return 'Starting soon';
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${difference.inDays ~/ 7}w ago';
    }
  }
}

/// Enhanced activity feed widget with real-time updates and animations
class EnhancedActivityFeedWidget extends StatefulWidget {
  final List<ActivityFeedItem> activities;
  final bool isDarkMode;
  final VoidCallback? onRefresh;
  final VoidCallback? onMarkAllRead;
  final int maxItems;
  final bool showUnreadIndicator;

  const EnhancedActivityFeedWidget({
    super.key,
    required this.activities,
    required this.isDarkMode,
    this.onRefresh,
    this.onMarkAllRead,
    this.maxItems = 20,
    this.showUnreadIndicator = true,
  });

  @override
  State<EnhancedActivityFeedWidget> createState() =>
      _EnhancedActivityFeedWidgetState();
}

class _EnhancedActivityFeedWidgetState extends State<EnhancedActivityFeedWidget>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  final List<AnimationController> _itemControllers = [];
  final List<Animation<Offset>> _slideAnimations = [];
  final List<Animation<double>> _fadeAnimations = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _staggerController = AnimationController(
      duration: Duration(milliseconds: 300 + (widget.activities.length * 100)),
      vsync: this,
    );

    final displayedActivities = widget.activities
        .take(widget.maxItems)
        .toList();

    for (int i = 0; i < displayedActivities.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      );
      _itemControllers.add(controller);

      final slideAnimation =
          Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: _staggerController,
              curve: Interval(
                i * 0.1,
                (i * 0.1) + 0.6,
                curve: Curves.easeOutQuart,
              ),
            ),
          );
      _slideAnimations.add(slideAnimation);

      final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(i * 0.1, (i * 0.1) + 0.4, curve: Curves.easeOut),
        ),
      );
      _fadeAnimations.add(fadeAnimation);
    }

    _staggerController.forward();
  }

  @override
  void didUpdateWidget(EnhancedActivityFeedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.activities.length != oldWidget.activities.length) {
      _resetAnimations();
    }
  }

  void _resetAnimations() {
    for (final controller in _itemControllers) {
      controller.dispose();
    }
    _itemControllers.clear();
    _slideAnimations.clear();
    _fadeAnimations.clear();

    _initializeAnimations();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    for (final controller in _itemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.activities.isEmpty) {
      return _buildEmptyState();
    }

    final displayedActivities = widget.activities
        .take(widget.maxItems)
        .toList();
    final unreadCount = displayedActivities.where((a) => a.isUnread).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(unreadCount),
        SizedBox(height: 12.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: displayedActivities.length,
          itemBuilder: (context, index) {
            if (index >= _slideAnimations.length)
              return const SizedBox.shrink();

            return SlideTransition(
              position: _slideAnimations[index],
              child: FadeTransition(
                opacity: _fadeAnimations[index],
                child: ActivityFeedItemWidget(
                  activity: displayedActivities[index],
                  isDarkMode: widget.isDarkMode,
                  showUnreadIndicator: widget.showUnreadIndicator,
                ),
              ),
            );
          },
        ),
        if (widget.activities.length > widget.maxItems) ...[
          SizedBox(height: 12.h),
          _buildViewMoreButton(),
        ],
      ],
    );
  }

  Widget _buildHeader(int unreadCount) {
    return Row(
      children: [
        Text(
          'Recent Activity',
          style: AppTypography.geistSemiBold15.copyWith(
            color: widget.isDarkMode
                ? AppColors.darkTextPrimary
                : AppColors.gray900,
          ),
        ),
        if (unreadCount > 0 && widget.showUnreadIndicator) ...[
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '$unreadCount',
              style: AppTypography.geistMedium11.copyWith(
                color: AppColors.white,
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
        const Spacer(),
        if (widget.onMarkAllRead != null && unreadCount > 0)
          GestureDetector(
            onTap: widget.onMarkAllRead,
            child: Text(
              'Mark all read',
              style: AppTypography.geistMedium13.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        if (widget.onRefresh != null) ...[
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: widget.onRefresh,
            child: Icon(
              PhosphorIcons.arrowClockwise(),
              size: 16.sp,
              color: widget.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            PhosphorIcons.bell(),
            size: 48.sp,
            color: widget.isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.gray400,
          ),
          SizedBox(height: 16.h),
          Text(
            'No recent activity',
            style: AppTypography.geistMedium15.copyWith(
              color: widget.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Join events and communities to see updates here',
            style: AppTypography.geistRegular13.copyWith(
              color: widget.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildViewMoreButton() {
    return Center(
      child: GestureDetector(
        onTap: () {
          // Handle view more
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: widget.isDarkMode
                  ? AppColors.darkContainerBorder
                  : AppColors.gray300,
            ),
          ),
          child: Text(
            'View more',
            style: AppTypography.geistMedium13.copyWith(
              color: widget.isDarkMode
                  ? AppColors.darkTextPrimary
                  : AppColors.gray700,
            ),
          ),
        ),
      ),
    );
  }
}

/// Individual activity feed item widget
class ActivityFeedItemWidget extends StatefulWidget {
  final ActivityFeedItem activity;
  final bool isDarkMode;
  final bool showUnreadIndicator;

  const ActivityFeedItemWidget({
    super.key,
    required this.activity,
    required this.isDarkMode,
    this.showUnreadIndicator = true,
  });

  @override
  State<ActivityFeedItemWidget> createState() => _ActivityFeedItemWidgetState();
}

class _ActivityFeedItemWidgetState extends State<ActivityFeedItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.01,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4.h),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.activity.onTap,
                borderRadius: BorderRadius.circular(8.r),
                child: MouseRegion(
                  onEnter: (_) => _onHover(true),
                  onExit: (_) => _onHover(false),
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color:
                          widget.activity.isUnread && widget.showUnreadIndicator
                          ? (widget.activity.accentColor ?? AppColors.primary)
                                .withValues(alpha: 0.05)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8.r),
                      border:
                          widget.activity.isUnread && widget.showUnreadIndicator
                          ? Border.all(
                              color:
                                  (widget.activity.accentColor ??
                                          AppColors.primary)
                                      .withValues(alpha: 0.2),
                              width: 0.5,
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        _buildActivityIcon(),
                        SizedBox(width: 12.w),
                        Expanded(child: _buildActivityContent()),
                        _buildTimeStamp(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivityIcon() {
    if (widget.activity.userAvatarUrl != null) {
      return Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          image: DecorationImage(
            image: NetworkImage(widget.activity.userAvatarUrl!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: (widget.activity.accentColor ?? AppColors.primary).withValues(
          alpha: 0.15,
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        widget.activity.icon ?? PhosphorIcons.bell(),
        size: 16.sp,
        color: widget.activity.accentColor ?? AppColors.primary,
      ),
    );
  }

  Widget _buildActivityContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.activity.title,
          style: AppTypography.geistMedium13.copyWith(
            color: widget.isDarkMode
                ? AppColors.darkTextPrimary
                : AppColors.gray900,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (widget.activity.subtitle != null) ...[
          SizedBox(height: 2.h),
          Text(
            widget.activity.subtitle!,
            style: AppTypography.geistRegular12.copyWith(
              color: widget.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildTimeStamp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.activity.timeAgo,
          style: AppTypography.geistRegular11.copyWith(
            color: widget.isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.gray500,
          ),
        ),
        if (widget.activity.isUnread && widget.showUnreadIndicator) ...[
          SizedBox(height: 4.h),
          Container(
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: widget.activity.accentColor ?? AppColors.primary,
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
        ],
      ],
    );
  }
}
