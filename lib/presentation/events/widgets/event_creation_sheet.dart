import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../models/voice_event_models.dart';
import '../models/voice_models.dart';

class EventCreationSheet extends StatefulWidget {
  final String? communityId;
  final String? communityName;
  final void Function(VoiceEvent event) onEventCreated;

  const EventCreationSheet({
    super.key,
    this.communityId,
    this.communityName,
    required this.onEventCreated,
  });

  @override
  State<EventCreationSheet> createState() => _EventCreationSheetState();
}

class _EventCreationSheetState extends State<EventCreationSheet>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();

  // Form state
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Event details
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  VoiceSessionType _selectedType = VoiceSessionType.event;
  DateTime _startDate = DateTime.now().add(const Duration(hours: 1));
  TimeOfDay _startTime = TimeOfDay.now();
  Duration _duration = const Duration(hours: 1);
  int _maxParticipants = 50;
  EventPrivacy _privacy = EventPrivacy.community;
  bool _allowWaitlist = true;
  EventReminder? _reminder = const EventReminder(
    beforeEvent: Duration(minutes: 15),
    type: ReminderType.notification,
  );
  EventRecurrence? _recurrence;
  final List<String> _tags = [];
  final _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutQuart),
        );

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.95,
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.darkBackgroundPrimary
              : AppColors.backgroundPrimary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            _buildHeader(isDarkMode),
            _buildProgressIndicator(isDarkMode),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildBasicDetailsStep(isDarkMode),
                  _buildSchedulingStep(isDarkMode),
                  _buildSettingsStep(isDarkMode),
                  _buildReviewStep(isDarkMode),
                ],
              ),
            ),
            _buildBottomActions(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 20.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _handleBack,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkBackgroundSecondary
                    : AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                PhosphorIcons.arrowLeft(),
                size: 20.sp,
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray700,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Event',
                  style: AppTypography.heading4.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (widget.communityName != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    'in ${widget.communityName}',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              PhosphorIcons.x(),
              size: 24.sp,
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: List.generate(_totalSteps, (index) {
          final isCompleted = index < _currentStep;
          final isCurrent = index == _currentStep;

          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < _totalSteps - 1 ? 8.w : 0),
              height: 4.h,
              decoration: BoxDecoration(
                color: isCompleted || isCurrent
                    ? AppColors.primary
                    : (isDarkMode
                          ? AppColors.darkContainerBorder
                          : AppColors.gray200),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBasicDetailsStep(bool isDarkMode) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepTitle('Event Details', isDarkMode),
            SizedBox(height: 24.h),

            // Event Title
            _buildInputField(
              'Event Title',
              'Enter a descriptive title',
              _titleController,
              isDarkMode,
              validator: (value) =>
                  value?.isEmpty == true ? 'Title is required' : null,
            ),
            SizedBox(height: 16.h),

            // Event Type
            _buildEventTypeSelector(isDarkMode),
            SizedBox(height: 16.h),

            // Description
            _buildInputField(
              'Description',
              'What will this event be about?',
              _descriptionController,
              isDarkMode,
              maxLines: 4,
              validator: (value) =>
                  value?.isEmpty == true ? 'Description is required' : null,
            ),
            SizedBox(height: 16.h),

            // Tags
            _buildTagsSection(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildSchedulingStep(bool isDarkMode) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle('When & How Long', isDarkMode),
          SizedBox(height: 24.h),

          // Date Picker
          _buildDateTimeSelector(isDarkMode),
          SizedBox(height: 20.h),

          // Duration
          _buildDurationSelector(isDarkMode),
          SizedBox(height: 20.h),

          // Recurrence
          _buildRecurrenceSelector(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildSettingsStep(bool isDarkMode) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle('Event Settings', isDarkMode),
          SizedBox(height: 24.h),

          // Max Participants
          _buildParticipantSettings(isDarkMode),
          SizedBox(height: 20.h),

          // Privacy Settings
          _buildPrivacySettings(isDarkMode),
          SizedBox(height: 20.h),

          // Reminder Settings
          _buildReminderSettings(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildReviewStep(bool isDarkMode) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle('Review & Create', isDarkMode),
          SizedBox(height: 24.h),

          _buildEventPreview(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildStepTitle(String title, bool isDarkMode) {
    return Text(
      title,
      style: AppTypography.heading5.copyWith(
        color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller,
    bool isDarkMode, {
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          style: AppTypography.bodyMedium.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray500,
            ),
            filled: true,
            fillColor: isDarkMode
                ? AppColors.darkBackgroundSecondary
                : AppColors.backgroundSecondary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: isDarkMode
                    ? AppColors.darkContainerBorder
                    : AppColors.gray300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: isDarkMode
                    ? AppColors.darkContainerBorder
                    : AppColors.gray300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEventTypeSelector(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Type',
          style: AppTypography.labelMedium.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: VoiceSessionType.values.map((type) {
            final isSelected = _selectedType == type;
            return GestureDetector(
              onTap: () => setState(() => _selectedType = type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.15)
                      : (isDarkMode
                            ? AppColors.darkBackgroundSecondary
                            : AppColors.backgroundSecondary),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isDarkMode
                              ? AppColors.darkContainerBorder
                              : AppColors.gray300),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getEventTypeIcon(type),
                      size: 16.sp,
                      color: isSelected
                          ? AppColors.primary
                          : (isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.gray600),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      _getEventTypeDisplayName(type),
                      style: AppTypography.labelMedium.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : (isDarkMode
                                  ? AppColors.darkTextPrimary
                                  : AppColors.gray700),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTagsSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags (Optional)',
          style: AppTypography.labelMedium.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _tagController,
          style: AppTypography.bodyMedium.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
          ),
          decoration: InputDecoration(
            hintText: 'Add tags to help people find your event',
            hintStyle: AppTypography.bodyMedium.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray500,
            ),
            filled: true,
            fillColor: isDarkMode
                ? AppColors.darkBackgroundSecondary
                : AppColors.backgroundSecondary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: isDarkMode
                    ? AppColors.darkContainerBorder
                    : AppColors.gray300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: isDarkMode
                    ? AppColors.darkContainerBorder
                    : AppColors.gray300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            suffixIcon: IconButton(
              onPressed: _addTag,
              icon: Icon(
                PhosphorIcons.plus(),
                size: 20.sp,
                color: AppColors.primary,
              ),
            ),
          ),
          onSubmitted: (_) => _addTag(),
        ),
        if (_tags.isNotEmpty) ...[
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _tags.map((tag) {
              return Chip(
                label: Text(
                  tag,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: AppColors.primary.withOpacity(0.1),
                deleteIcon: Icon(
                  PhosphorIcons.x(),
                  size: 14.sp,
                  color: AppColors.primary,
                ),
                onDeleted: () => setState(() => _tags.remove(tag)),
                side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildDateTimeSelector(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Start Date & Time',
          style: AppTypography.labelMedium.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.darkBackgroundSecondary
                        : AppColors.backgroundSecondary,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isDarkMode
                          ? AppColors.darkContainerBorder
                          : AppColors.gray300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        PhosphorIcons.calendar(),
                        size: 20.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          _formatDate(_startDate),
                          style: AppTypography.bodyMedium.copyWith(
                            color: isDarkMode
                                ? AppColors.darkTextPrimary
                                : AppColors.gray900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectTime(context),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.darkBackgroundSecondary
                        : AppColors.backgroundSecondary,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isDarkMode
                          ? AppColors.darkContainerBorder
                          : AppColors.gray300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        PhosphorIcons.clock(),
                        size: 20.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          _startTime.format(context),
                          style: AppTypography.bodyMedium.copyWith(
                            color: isDarkMode
                                ? AppColors.darkTextPrimary
                                : AppColors.gray900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDurationSelector(bool isDarkMode) {
    final durations = [
      const Duration(minutes: 30),
      const Duration(hours: 1),
      const Duration(hours: 2),
      const Duration(hours: 3),
      const Duration(hours: 4),
      const Duration(hours: 6),
      const Duration(hours: 8),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duration',
          style: AppTypography.labelMedium.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: durations.map((duration) {
            final isSelected = _duration == duration;
            return GestureDetector(
              onTap: () => setState(() => _duration = duration),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.15)
                      : (isDarkMode
                            ? AppColors.darkBackgroundSecondary
                            : AppColors.backgroundSecondary),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isDarkMode
                              ? AppColors.darkContainerBorder
                              : AppColors.gray300),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  _formatDuration(duration),
                  style: AppTypography.labelMedium.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : (isDarkMode
                              ? AppColors.darkTextPrimary
                              : AppColors.gray700),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecurrenceSelector(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Repeat Event',
              style: AppTypography.labelMedium.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Switch(
              value: _recurrence != null,
              onChanged: (value) {
                setState(() {
                  _recurrence = value
                      ? const EventRecurrence(type: RecurrenceType.weekly)
                      : null;
                });
              },
              activeColor: AppColors.primary,
            ),
          ],
        ),
        if (_recurrence != null) ...[
          SizedBox(height: 12.h),
          // Recurrence options would go here
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.darkBackgroundSecondary
                  : AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isDarkMode
                    ? AppColors.darkContainerBorder
                    : AppColors.gray300,
              ),
            ),
            child: Text(
              'Recurring event options coming soon!',
              style: AppTypography.bodySmall.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildParticipantSettings(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Participant Limit',
          style: AppTypography.labelMedium.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.h),
        Slider(
          value: _maxParticipants.toDouble(),
          min: 5,
          max: 200,
          divisions: 39,
          activeColor: AppColors.primary,
          label: '$_maxParticipants participants',
          onChanged: (value) =>
              setState(() => _maxParticipants = value.round()),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Icon(
              PhosphorIcons.users(),
              size: 16.sp,
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
            SizedBox(width: 8.w),
            Text(
              'Allow Waitlist',
              style: AppTypography.bodyMedium.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
            ),
            const Spacer(),
            Switch(
              value: _allowWaitlist,
              onChanged: (value) => setState(() => _allowWaitlist = value),
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrivacySettings(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Privacy',
          style: AppTypography.labelMedium.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 12.h),
        ...EventPrivacy.values.map((privacy) {
          final isSelected = _privacy == privacy;
          return GestureDetector(
            onTap: () => setState(() => _privacy = privacy),
            child: Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : (isDarkMode
                          ? AppColors.darkBackgroundSecondary
                          : AppColors.backgroundSecondary),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : (isDarkMode
                            ? AppColors.darkContainerBorder
                            : AppColors.gray300),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.gray400,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? Center(
                            child: Container(
                              width: 10.w,
                              height: 10.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : null,
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          privacy.displayName,
                          style: AppTypography.bodyMedium.copyWith(
                            color: isDarkMode
                                ? AppColors.darkTextPrimary
                                : AppColors.gray900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          privacy.description,
                          style: AppTypography.bodySmall.copyWith(
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
            ),
          );
        }),
      ],
    );
  }

  Widget _buildReminderSettings(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Event Reminder',
              style: AppTypography.labelMedium.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Switch(
              value: _reminder != null,
              onChanged: (value) {
                setState(() {
                  _reminder = value
                      ? const EventReminder(
                          beforeEvent: Duration(minutes: 15),
                          type: ReminderType.notification,
                        )
                      : null;
                });
              },
              activeColor: AppColors.primary,
            ),
          ],
        ),
        if (_reminder != null) ...[
          SizedBox(height: 12.h),
          Text(
            'Remind me 15 minutes before the event',
            style: AppTypography.bodyMedium.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEventPreview(bool isDarkMode) {
    final startDateTime = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _startTime.hour,
      _startTime.minute,
    );

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkBackgroundSecondary
            : AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  _getEventTypeIcon(_selectedType),
                  size: 24.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _titleController.text.isEmpty
                          ? 'Event Title'
                          : _titleController.text,
                      style: AppTypography.heading5.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _getEventTypeDisplayName(_selectedType),
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          if (_descriptionController.text.isNotEmpty) ...[
            Text(
              _descriptionController.text,
              style: AppTypography.bodyMedium.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray700,
              ),
            ),
            SizedBox(height: 16.h),
          ],

          _buildPreviewRow(
            PhosphorIcons.calendar(),
            _formatDateTime(startDateTime),
            isDarkMode,
          ),
          SizedBox(height: 8.h),

          _buildPreviewRow(
            PhosphorIcons.clock(),
            _formatDuration(_duration),
            isDarkMode,
          ),
          SizedBox(height: 8.h),

          _buildPreviewRow(
            PhosphorIcons.users(),
            'Up to $_maxParticipants participants',
            isDarkMode,
          ),
          SizedBox(height: 8.h),

          _buildPreviewRow(
            PhosphorIcons.lock(),
            _privacy.displayName,
            isDarkMode,
          ),

          if (_tags.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Wrap(
              spacing: 8.w,
              children: _tags.map((tag) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    tag,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreviewRow(IconData icon, String text, bool isDarkMode) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
        ),
        SizedBox(width: 12.w),
        Text(
          text,
          style: AppTypography.bodyMedium.copyWith(
            color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray700,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  side: BorderSide(
                    color: isDarkMode
                        ? AppColors.darkContainerBorder
                        : AppColors.gray300,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Back',
                  style: AppTypography.labelLarge.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
          ],

          Expanded(
            flex: _currentStep > 0 ? 2 : 1,
            child: ElevatedButton(
              onPressed: _isNextButtonEnabled() ? _nextStep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                _currentStep == _totalSteps - 1 ? 'Create Event' : 'Next',
                style: AppTypography.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  IconData _getEventTypeIcon(VoiceSessionType type) {
    switch (type) {
      case VoiceSessionType.voice:
        return PhosphorIcons.waveform();
      case VoiceSessionType.video:
        return PhosphorIcons.camera();
      case VoiceSessionType.game:
        return PhosphorIcons.gameController();
      case VoiceSessionType.studySession:
        return PhosphorIcons.graduationCap();
      case VoiceSessionType.meeting:
        return PhosphorIcons.presentation();
      case VoiceSessionType.event:
        return PhosphorIcons.calendarPlus();
    }
  }

  String _getEventTypeDisplayName(VoiceSessionType type) {
    switch (type) {
      case VoiceSessionType.voice:
        return 'Voice Chat';
      case VoiceSessionType.video:
        return 'Video Call';
      case VoiceSessionType.game:
        return 'Gaming Session';
      case VoiceSessionType.studySession:
        return 'Study Session';
      case VoiceSessionType.meeting:
        return 'Meeting';
      case VoiceSessionType.event:
        return 'Community Event';
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    final date = _formatDate(dateTime);
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final ampm = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final time = '$displayHour:${minute.toString().padLeft(2, '0')} $ampm';
    return '$date at $time';
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      if (minutes == 0) {
        return '${hours}h';
      } else {
        return '${hours}h ${minutes}m';
      }
    } else {
      return '${duration.inMinutes}m';
    }
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _startDate = date;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );

    if (time != null) {
      setState(() {
        _startTime = time;
      });
    }
  }

  bool _isNextButtonEnabled() {
    switch (_currentStep) {
      case 0:
        return _titleController.text.isNotEmpty &&
            _descriptionController.text.isNotEmpty;
      case 1:
      case 2:
      case 3:
        return true;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _createEvent();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleBack() {
    if (_currentStep > 0) {
      _previousStep();
    } else {
      Navigator.pop(context);
    }
  }

  void _createEvent() {
    if (!_formKey.currentState!.validate()) return;

    final startDateTime = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _startTime.hour,
      _startTime.minute,
    );

    final event = VoiceEvent(
      id: 'event_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text,
      description: _descriptionController.text,
      communityId: widget.communityId,
      communityName: widget.communityName,
      type: _selectedType,
      status: EventStatus.scheduled,
      startTime: startDateTime,
      endTime: startDateTime.add(_duration),
      duration: _duration,
      maxParticipants: _maxParticipants,
      recurrence: _recurrence,
      privacy: _privacy,
      hostId: 'current_user_id', // In real app, get from auth state
      hostName: 'Current User', // In real app, get from auth state
      rsvps: const [],
      tags: _tags,
      reminder: _reminder,
      allowWaitlist: _allowWaitlist,
      createdAt: DateTime.now(),
    );

    widget.onEventCreated(event);
    Navigator.pop(context);

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Event "${event.title}" created successfully!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
