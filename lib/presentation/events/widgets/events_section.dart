import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../models/voice_event_models.dart';
import 'event_card.dart';
import '../pages/event_details_page.dart';

class EventsSection extends StatefulWidget {
  final List<VoiceEvent> events;
  final String? currentUserId;
  final String sectionTitle;
  final IconData? sectionIcon;
  final VoidCallback? onSeeAll;
  final bool showRSVP;
  final int maxVisibleEvents;

  const EventsSection({
    super.key,
    required this.events,
    this.currentUserId,
    required this.sectionTitle,
    this.sectionIcon,
    this.onSeeAll,
    this.showRSVP = true,
    this.maxVisibleEvents = 3,
  });

  @override
  State<EventsSection> createState() => _EventsSectionState();
}

class _EventsSectionState extends State<EventsSection>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late List<Animation<double>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    final visibleEvents = widget.events.take(widget.maxVisibleEvents).toList();
    _slideAnimations = List.generate(visibleEvents.length, (index) {
      final startTime = index * 0.1;
      final endTime = startTime + 0.6;
      return Tween<double>(begin: 30.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _slideController,
          curve: Interval(startTime, endTime, curve: Curves.easeOutQuart),
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 300), () {
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

  void _navigateToEventDetails(VoiceEvent event) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) =>
            EventDetailsPage(event: event, currentUserId: widget.currentUserId),
      ),
    );
  }

  void _handleRSVPChanged(String eventId, RSVPResponse response) {
    // In a real app, this would update via state management or API call
    setState(() {
      // Update local event state for demo
      final eventIndex = widget.events.indexWhere((e) => e.id == eventId);
      if (eventIndex >= 0) {
        final event = widget.events[eventIndex];
        final updatedRSVPs = List<EventRSVP>.from(event.rsvps);
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

        // Note: In a real app, you'd update this through state management
        // For now, we'll just show a success message
      }
    });

    // Show feedback
    final responseText = response == RSVPResponse.going
        ? 'going'
        : response == RSVPResponse.maybe
        ? 'maybe'
        : 'not going';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('RSVP updated to $responseText'),
        backgroundColor: _getResponseColor(response),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
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

    if (widget.events.isEmpty) {
      return const SizedBox.shrink();
    }

    final visibleEvents = widget.events.take(widget.maxVisibleEvents).toList();

    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(isDarkMode),
          SizedBox(height: 16.h),
          AnimatedBuilder(
            animation: _slideController,
            builder: (context, child) {
              return Column(
                children: visibleEvents.asMap().entries.map((entry) {
                  final index = entry.key;
                  final event = entry.value;

                  if (index >= _slideAnimations.length) return const SizedBox();

                  return Transform.translate(
                    offset: Offset(0, _slideAnimations[index].value),
                    child: EventCard(
                      event: event,
                      currentUserId: widget.currentUserId,
                      onRSVPChanged: widget.showRSVP
                          ? _handleRSVPChanged
                          : null,
                      onTap: () => _navigateToEventDetails(event),
                      showDetails: widget.showRSVP,
                    ),
                  );
                }).toList(),
              );
            },
          ),
          if (widget.events.length > widget.maxVisibleEvents)
            _buildSeeMoreButton(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (widget.sectionIcon != null) ...[
                Icon(
                  widget.sectionIcon,
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
              ],
              Text(
                widget.sectionTitle,
                style: AppTypography.geistSemiBold15.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                  fontSize: 18.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${widget.events.length}',
                  style: AppTypography.geistMedium11.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          if (widget.onSeeAll != null)
            GestureDetector(
              onTap: widget.onSeeAll,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'See All',
                      style: AppTypography.geistMedium13.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      PhosphorIcons.caretRight(),
                      color: AppColors.primary,
                      size: 14.sp,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSeeMoreButton(bool isDarkMode) {
    final hiddenCount = widget.events.length - widget.maxVisibleEvents;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: GestureDetector(
        onTap: widget.onSeeAll,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDarkMode
                ? AppColors.darkBackgroundSecondary
                : AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDarkMode
                  ? AppColors.darkContainerBorder
                  : AppColors.gray200,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'View $hiddenCount more events',
                style: AppTypography.geistMedium13.copyWith(
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                PhosphorIcons.caretDown(),
                color: AppColors.primary,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
