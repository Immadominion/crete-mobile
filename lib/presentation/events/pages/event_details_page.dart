import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../models/voice_event_models.dart';
import '../models/voice_models.dart';
import '../widgets/event_card.dart';

class EventDetailsPage extends StatefulWidget {
  final VoiceEvent event;
  final String? currentUserId;

  const EventDetailsPage({super.key, required this.event, this.currentUserId});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late TabController _tabController;

  VoiceEvent _event = VoiceEvent(
    id: '',
    title: '',
    description: '',
    type: VoiceSessionType.event,
    status: EventStatus.scheduled,
    startTime: DateTime.now(),
    hostId: '',
    hostName: '',
    createdAt: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _event = widget.event;

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _tabController = TabController(length: 4, vsync: this);

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutQuart),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _handleRSVPChanged(String eventId, RSVPResponse response) {
    // In a real app, this would update via state management or API call
    setState(() {
      // Update local event state for demo
      final updatedRSVPs = List<EventRSVP>.from(_event.rsvps);
      final existingIndex = updatedRSVPs.indexWhere(
        (rsvp) => rsvp.userId == widget.currentUserId,
      );

      if (existingIndex >= 0) {
        updatedRSVPs[existingIndex] = updatedRSVPs[existingIndex].copyWith(
          response: response,
          timestamp: DateTime.now(),
        );
      } else {
        updatedRSVPs.add(
          EventRSVP(
            userId: widget.currentUserId ?? 'current_user',
            userName: 'Current User',
            response: response,
            timestamp: DateTime.now(),
          ),
        );
      }

      _event = _event.copyWith(rsvps: updatedRSVPs);
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('RSVP updated to ${response.name}'),
        backgroundColor: _getResponseColor(response),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color _getResponseColor(RSVPResponse response) {
    switch (response) {
      case RSVPResponse.going:
        return AppColors.success;
      case RSVPResponse.maybe:
        return AppColors.warning;
      case RSVPResponse.notGoing:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundPrimary
          : AppColors.backgroundPrimary,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(isDarkMode),
            SliverToBoxAdapter(
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    EventCard(
                      event: _event,
                      currentUserId: widget.currentUserId,
                      onRSVPChanged: _handleRSVPChanged,
                      showDetails: true,
                    ),
                    SizedBox(height: 24.h),
                    _buildTabBar(isDarkMode),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDetailsTab(isDarkMode),
                  _buildParticipantsTab(isDarkMode),
                  _buildChatTab(isDarkMode),
                  _buildMoreTab(isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDarkMode) {
    return SliverAppBar(
      expandedHeight: 200.h,
      pinned: true,
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundPrimary
          : AppColors.backgroundPrimary,
      iconTheme: IconThemeData(
        color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
      ),
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          _event.title,
          style: AppTypography.geistSemiBold15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontSize: 16.sp,
          ),
        ),
        background: _event.imageUrl != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(_event.imageUrl!, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          (isDarkMode
                                  ? AppColors.darkBackgroundPrimary
                                  : AppColors.backgroundPrimary)
                              .withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.secondary.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    PhosphorIcons.calendar(PhosphorIconsStyle.bold),
                    size: 48.sp,
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
              ),
      ),
      actions: [
        IconButton(
          icon: Icon(PhosphorIcons.shareNetwork()),
          onPressed: _shareEvent,
        ),
        PopupMenuButton<String>(
          icon: Icon(PhosphorIcons.dotsThreeVertical()),
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'add_to_calendar',
              child: Text('Add to Calendar'),
            ),
            const PopupMenuItem(
              value: 'set_reminder',
              child: Text('Set Reminder'),
            ),
            if (_isEventHost())
              const PopupMenuItem(
                value: 'edit_event',
                child: Text('Edit Event'),
              ),
            const PopupMenuItem(
              value: 'report_event',
              child: Text('Report Event'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabBar(bool isDarkMode) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkBackgroundSecondary
            : AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: isDarkMode
            ? AppColors.darkTextSecondary
            : AppColors.gray600,
        labelStyle: AppTypography.geistMedium13,
        unselectedLabelStyle: AppTypography.geistRegular13,
        tabs: const [
          Tab(text: 'Details'),
          Tab(text: 'People'),
          Tab(text: 'Chat'),
          Tab(text: 'More'),
        ],
      ),
    );
  }

  Widget _buildDetailsTab(bool isDarkMode) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailSection(
            'Description',
            _event.description,
            PhosphorIcons.note(),
            isDarkMode,
          ),
          SizedBox(height: 24.h),
          _buildDetailSection(
            'When',
            _formatFullEventTime(),
            PhosphorIcons.clock(),
            isDarkMode,
          ),
          if (_event.locationUrl != null) ...[
            SizedBox(height: 24.h),
            _buildDetailSection(
              'Location',
              _event.locationUrl!,
              PhosphorIcons.mapPin(),
              isDarkMode,
            ),
          ],
          if (_event.tags.isNotEmpty) ...[
            SizedBox(height: 24.h),
            _buildTagsSection(isDarkMode),
          ],
          if (_event.recurrence != null) ...[
            SizedBox(height: 24.h),
            _buildRecurrenceSection(isDarkMode),
          ],
        ],
      ),
    );
  }

  Widget _buildParticipantsTab(bool isDarkMode) {
    final goingList = _event.rsvps
        .where((rsvp) => rsvp.response == RSVPResponse.going)
        .toList();
    final maybeList = _event.rsvps
        .where((rsvp) => rsvp.response == RSVPResponse.maybe)
        .toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildParticipantSection(
            'Going',
            goingList,
            AppColors.success,
            isDarkMode,
          ),
          if (maybeList.isNotEmpty) ...[
            SizedBox(height: 24.h),
            _buildParticipantSection(
              'Maybe',
              maybeList,
              AppColors.warning,
              isDarkMode,
            ),
          ],
          if (_event.hasWaitlist) ...[
            SizedBox(height: 24.h),
            _buildWaitlistSection(isDarkMode),
          ],
        ],
      ),
    );
  }

  Widget _buildChatTab(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkBackgroundSecondary
                    : AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      PhosphorIcons.chatCircle(),
                      size: 48.sp,
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray400,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Event Chat',
                      style: AppTypography.geistSemiBold15.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.gray900,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Chat will be available when the event starts',
                      style: AppTypography.geistRegular13.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreTab(bool isDarkMode) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildMoreOption(
            'Add to Calendar',
            'Never miss this event',
            PhosphorIcons.calendar(),
            () => _addToCalendar(),
            isDarkMode,
          ),
          SizedBox(height: 16.h),
          _buildMoreOption(
            'Set Reminder',
            'Get notified before the event',
            PhosphorIcons.bell(),
            () => _setReminder(),
            isDarkMode,
          ),
          SizedBox(height: 16.h),
          _buildMoreOption(
            'Share Event',
            'Invite friends to join',
            PhosphorIcons.shareNetwork(),
            () => _shareEvent(),
            isDarkMode,
          ),
          if (_isEventHost()) ...[
            SizedBox(height: 24.h),
            Divider(
              color: isDarkMode
                  ? AppColors.darkContainerBorder
                  : AppColors.gray200,
            ),
            SizedBox(height: 16.h),
            _buildMoreOption(
              'Edit Event',
              'Modify event details',
              PhosphorIcons.pencil(),
              () => _editEvent(),
              isDarkMode,
            ),
            SizedBox(height: 16.h),
            _buildMoreOption(
              'Cancel Event',
              'Cancel this event',
              PhosphorIcons.x(),
              () => _cancelEvent(),
              isDarkMode,
              isDestructive: true,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailSection(
    String title,
    String content,
    IconData icon,
    bool isDarkMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            ),
            SizedBox(width: 8.w),
            Text(
              title,
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          content,
          style: AppTypography.geistRegular14.copyWith(
            color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              PhosphorIcons.tag(),
              size: 20.sp,
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            ),
            SizedBox(width: 8.w),
            Text(
              'Tags',
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: _event.tags
              .map((tag) => _buildTag(tag, isDarkMode))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildTag(String tag, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Text(
        tag,
        style: AppTypography.geistRegular12.copyWith(color: AppColors.primary),
      ),
    );
  }

  Widget _buildRecurrenceSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              PhosphorIcons.repeat(),
              size: 20.sp,
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            ),
            SizedBox(width: 8.w),
            Text(
              'Recurrence',
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Text(
          _formatRecurrence(),
          style: AppTypography.geistRegular14.copyWith(
            color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantSection(
    String title,
    List<EventRSVP> participants,
    Color color,
    bool isDarkMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            SizedBox(width: 8.w),
            Text(
              '$title (${participants.length})',
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ...participants.map((rsvp) => _buildParticipantItem(rsvp, isDarkMode)),
      ],
    );
  }

  Widget _buildParticipantItem(EventRSVP rsvp, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkBackgroundSecondary
            : AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: rsvp.userAvatarUrl != null
                ? NetworkImage(rsvp.userAvatarUrl!)
                : null,
            child: rsvp.userAvatarUrl == null
                ? Text(
                    rsvp.userName.substring(0, 1).toUpperCase(),
                    style: AppTypography.geistMedium13.copyWith(
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rsvp.userName,
                  style: AppTypography.geistMedium13.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                  ),
                ),
                if (rsvp.note != null)
                  Text(
                    rsvp.note!,
                    style: AppTypography.geistRegular12.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray600,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitlistSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(PhosphorIcons.queue(), size: 20.sp, color: AppColors.warning),
            SizedBox(width: 8.w),
            Text(
              'Waitlist (${_event.waitlistCount})',
              style: AppTypography.geistSemiBold15.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.warning.withOpacity(0.2)),
          ),
          child: Text(
            'This event is full. Join the waitlist to be notified if spots become available.',
            style: AppTypography.geistRegular13.copyWith(
              color: AppColors.warning,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoreOption(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
    bool isDarkMode, {
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.error : AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.geistMedium13.copyWith(color: color),
                  ),
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
            Icon(PhosphorIcons.caretRight(), color: color, size: 16.sp),
          ],
        ),
      ),
    );
  }

  // Helper methods
  bool _isEventHost() {
    return widget.currentUserId == _event.hostId;
  }

  String _formatFullEventTime() {
    final start = _event.startTime;
    final formatter =
        '${start.day}/${start.month}/${start.year} at ${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';

    if (_event.endTime != null) {
      final end = _event.endTime!;
      return '$formatter - ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    } else if (_event.duration != null) {
      final endTime = start.add(_event.duration!);
      return '$formatter - ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    }

    return formatter;
  }

  String _formatRecurrence() {
    if (_event.recurrence == null) return 'No recurrence';

    final recurrence = _event.recurrence!;
    switch (recurrence.type) {
      case RecurrenceType.none:
        return 'No recurrence';
      case RecurrenceType.daily:
        return recurrence.interval == 1
            ? 'Daily'
            : 'Every ${recurrence.interval} days';
      case RecurrenceType.weekly:
        return recurrence.interval == 1
            ? 'Weekly'
            : 'Every ${recurrence.interval} weeks';
      case RecurrenceType.monthly:
        return recurrence.interval == 1
            ? 'Monthly'
            : 'Every ${recurrence.interval} months';
      case RecurrenceType.yearly:
        return recurrence.interval == 1
            ? 'Yearly'
            : 'Every ${recurrence.interval} years';
    }
  }

  // Action methods
  void _shareEvent() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon')),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'add_to_calendar':
        _addToCalendar();
        break;
      case 'set_reminder':
        _setReminder();
        break;
      case 'edit_event':
        _editEvent();
        break;
      case 'report_event':
        _reportEvent();
        break;
    }
  }

  void _addToCalendar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add to calendar functionality coming soon'),
      ),
    );
  }

  void _setReminder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Set reminder functionality coming soon')),
    );
  }

  void _editEvent() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit event functionality coming soon')),
    );
  }

  void _cancelEvent() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Event'),
        content: const Text(
          'Are you sure you want to cancel this event? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Event'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle cancel event
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Event cancelled'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Cancel Event'),
          ),
        ],
      ),
    );
  }

  void _reportEvent() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report event functionality coming soon')),
    );
  }
}
