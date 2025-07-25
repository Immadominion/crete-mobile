import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../models/voice_filter_models.dart';
import '../models/voice_models.dart';

class VoiceFilterBottomSheet extends StatefulWidget {
  final VoiceFilters currentFilters;
  final VoiceSortOption currentSort;
  final void Function(VoiceFilters filters, VoiceSortOption sort)
  onApplyFilters;

  const VoiceFilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.currentSort,
    required this.onApplyFilters,
  });

  @override
  State<VoiceFilterBottomSheet> createState() => _VoiceFilterBottomSheetState();
}

class _VoiceFilterBottomSheetState extends State<VoiceFilterBottomSheet>
    with TickerProviderStateMixin {
  late VoiceFilters _filters;
  late VoiceSortOption _sortOption;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _filters = widget.currentFilters;
    _sortOption = widget.currentSort;

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.darkBackgroundPrimary
              : AppColors.backgroundPrimary,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: EdgeInsets.only(top: 8.h),
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkTextSecondary.withOpacity(0.3)
                    : AppColors.gray400.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
              child: Row(
                children: [
                  Text(
                    'Filter & Sort',
                    style: AppTypography.geistSemiBold15.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextPrimary
                          : AppColors.gray900,
                      fontSize: 18.sp,
                    ),
                  ),
                  const Spacer(),
                  if (_filters.hasActiveFilters ||
                      _sortOption != VoiceSortOption.newest)
                    GestureDetector(
                      onTap: _clearAllFilters,
                      child: Text(
                        'Clear All',
                        style: AppTypography.geistMedium13.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sort Section
                    _buildSortSection(isDarkMode),

                    SizedBox(height: 32.h),

                    // Session Types
                    _buildSessionTypesSection(isDarkMode),

                    SizedBox(height: 32.h),

                    // Session Status
                    _buildSessionStatusSection(isDarkMode),

                    SizedBox(height: 32.h),

                    // Additional Filters
                    _buildAdditionalFiltersSection(isDarkMode),

                    SizedBox(height: 32.h),

                    // Participant Count
                    _buildParticipantCountSection(isDarkMode),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),

            // Apply Button
            Container(
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
              child: SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApplyFilters(_filters, _sortOption);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Apply Filters',
                    style: AppTypography.geistMedium15.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort By',
          style: AppTypography.geistMedium15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: VoiceSortOption.values.map((option) {
            final isSelected = _sortOption == option;
            return GestureDetector(
              onTap: () => setState(() => _sortOption = option),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.1)
                      : (isDarkMode
                            ? AppColors.darkBackgroundSecondary
                            : AppColors.backgroundSecondary),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isDarkMode
                              ? AppColors.darkContainerBorder
                              : AppColors.gray300),
                  ),
                ),
                child: Text(
                  option.displayName,
                  style: AppTypography.geistMedium13.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : (isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.gray600),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSessionTypesSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session Types',
          style: AppTypography.geistMedium15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: VoiceSessionType.values.map((type) {
            final isSelected = _filters.sessionTypes.contains(type);
            return GestureDetector(
              onTap: () => _toggleSessionType(type),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.1)
                      : (isDarkMode
                            ? AppColors.darkBackgroundSecondary
                            : AppColors.backgroundSecondary),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isDarkMode
                              ? AppColors.darkContainerBorder
                              : AppColors.gray300),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getSessionTypeIcon(type),
                      size: 14.sp,
                      color: isSelected
                          ? AppColors.primary
                          : (isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.gray600),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      _getSessionTypeDisplayName(type),
                      style: AppTypography.geistMedium13.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : (isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : AppColors.gray600),
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

  Widget _buildSessionStatusSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session Status',
          style: AppTypography.geistMedium15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: VoiceSessionStatus.values.map((status) {
            final isSelected = _filters.sessionStatuses.contains(status);
            return GestureDetector(
              onTap: () => _toggleSessionStatus(status),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.1)
                      : (isDarkMode
                            ? AppColors.darkBackgroundSecondary
                            : AppColors.backgroundSecondary),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isDarkMode
                              ? AppColors.darkContainerBorder
                              : AppColors.gray300),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      _getStatusDisplayName(status),
                      style: AppTypography.geistMedium13.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : (isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : AppColors.gray600),
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

  Widget _buildAdditionalFiltersSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Filters',
          style: AppTypography.geistMedium15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
          ),
        ),
        SizedBox(height: 12.h),

        // Only Joined Sessions
        GestureDetector(
          onTap: () => setState(() {
            _filters = _filters.copyWith(
              onlyJoinedSessions: !_filters.onlyJoinedSessions,
            );
          }),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.darkBackgroundSecondary
                  : AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isDarkMode
                    ? AppColors.darkContainerBorder
                    : AppColors.gray300,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _filters.onlyJoinedSessions
                      ? PhosphorIcons.checkSquare(PhosphorIconsStyle.fill)
                      : PhosphorIcons.square(PhosphorIconsStyle.regular),
                  size: 18.sp,
                  color: _filters.onlyJoinedSessions
                      ? AppColors.primary
                      : (isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Only sessions I joined',
                    style: AppTypography.geistRegular14.copyWith(
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

        SizedBox(height: 8.h),

        // Only Events
        GestureDetector(
          onTap: () => setState(() {
            _filters = _filters.copyWith(
              onlyWithEvents: !_filters.onlyWithEvents,
            );
          }),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.darkBackgroundSecondary
                  : AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isDarkMode
                    ? AppColors.darkContainerBorder
                    : AppColors.gray300,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _filters.onlyWithEvents
                      ? PhosphorIcons.checkSquare(PhosphorIconsStyle.fill)
                      : PhosphorIcons.square(PhosphorIconsStyle.regular),
                  size: 18.sp,
                  color: _filters.onlyWithEvents
                      ? AppColors.primary
                      : (isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Only scheduled events',
                    style: AppTypography.geistRegular14.copyWith(
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
      ],
    );
  }

  Widget _buildParticipantCountSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Participant Count',
          style: AppTypography.geistMedium15.copyWith(
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Filter by minimum number of participants',
          style: AppTypography.geistRegular13.copyWith(
            color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [2, 5, 10, 20, 50].map((count) {
            final isSelected = _filters.minParticipants == count;
            return GestureDetector(
              onTap: () => setState(() {
                _filters = _filters.copyWith(
                  minParticipants: isSelected ? null : count,
                  clearMinParticipants: isSelected,
                );
              }),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.1)
                      : (isDarkMode
                            ? AppColors.darkBackgroundSecondary
                            : AppColors.backgroundSecondary),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isDarkMode
                              ? AppColors.darkContainerBorder
                              : AppColors.gray300),
                  ),
                ),
                child: Text(
                  '$count+ people',
                  style: AppTypography.geistMedium13.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : (isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.gray600),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _toggleSessionType(VoiceSessionType type) {
    setState(() {
      final types = Set<VoiceSessionType>.from(_filters.sessionTypes);
      if (types.contains(type)) {
        types.remove(type);
      } else {
        types.add(type);
      }
      _filters = _filters.copyWith(sessionTypes: types);
    });
  }

  void _toggleSessionStatus(VoiceSessionStatus status) {
    setState(() {
      final statuses = Set<VoiceSessionStatus>.from(_filters.sessionStatuses);
      if (statuses.contains(status)) {
        statuses.remove(status);
      } else {
        statuses.add(status);
      }
      _filters = _filters.copyWith(sessionStatuses: statuses);
    });
  }

  void _clearAllFilters() {
    setState(() {
      _filters = const VoiceFilters();
      _sortOption = VoiceSortOption.newest;
    });
  }

  IconData _getSessionTypeIcon(VoiceSessionType type) {
    switch (type) {
      case VoiceSessionType.voice:
        return PhosphorIcons.microphone(PhosphorIconsStyle.regular);
      case VoiceSessionType.video:
        return PhosphorIcons.videoCamera(PhosphorIconsStyle.regular);
      case VoiceSessionType.game:
        return PhosphorIcons.gameController(PhosphorIconsStyle.regular);
      case VoiceSessionType.studySession:
        return PhosphorIcons.student(PhosphorIconsStyle.regular);
      case VoiceSessionType.meeting:
        return PhosphorIcons.users(PhosphorIconsStyle.regular);
      case VoiceSessionType.event:
        return PhosphorIcons.calendar(PhosphorIconsStyle.regular);
    }
  }

  String _getSessionTypeDisplayName(VoiceSessionType type) {
    switch (type) {
      case VoiceSessionType.voice:
        return 'Voice';
      case VoiceSessionType.video:
        return 'Video';
      case VoiceSessionType.game:
        return 'Gaming';
      case VoiceSessionType.studySession:
        return 'Study';
      case VoiceSessionType.meeting:
        return 'Meeting';
      case VoiceSessionType.event:
        return 'Event';
    }
  }

  Color _getStatusColor(VoiceSessionStatus status) {
    switch (status) {
      case VoiceSessionStatus.active:
        return AppColors.success;
      case VoiceSessionStatus.scheduled:
        return AppColors.warning;
      case VoiceSessionStatus.ended:
        return AppColors.gray500;
      case VoiceSessionStatus.cancelled:
        return AppColors.error;
    }
  }

  String _getStatusDisplayName(VoiceSessionStatus status) {
    switch (status) {
      case VoiceSessionStatus.active:
        return 'Active';
      case VoiceSessionStatus.scheduled:
        return 'Scheduled';
      case VoiceSessionStatus.ended:
        return 'Ended';
      case VoiceSessionStatus.cancelled:
        return 'Cancelled';
    }
  }
}
