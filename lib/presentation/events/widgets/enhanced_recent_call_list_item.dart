import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../models/voice_models.dart';

class EnhancedRecentCallListItem extends StatefulWidget {
  final VoiceSession session;
  final VoidCallback? onTap;
  final VoidCallback? onCallBack;

  const EnhancedRecentCallListItem({
    super.key,
    required this.session,
    this.onTap,
    this.onCallBack,
  });

  @override
  State<EnhancedRecentCallListItem> createState() =>
      _EnhancedRecentCallListItemState();
}

class _EnhancedRecentCallListItemState extends State<EnhancedRecentCallListItem>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 20.0, end: 0.0).animate(
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

    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: GestureDetector(
            onTap: widget.onTap,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? (isDarkMode
                            ? AppColors.darkBackgroundSecondary.withOpacity(0.8)
                            : AppColors.backgroundSecondary.withOpacity(0.8))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    _buildSessionAvatar(isDarkMode),
                    SizedBox(width: 12.w),
                    Expanded(child: _buildSessionInfo(isDarkMode)),
                    _buildTimeAndActions(isDarkMode),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSessionAvatar(bool isDarkMode) {
    return Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: _getSessionTypeColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _getSessionTypeColor().withOpacity(0.3)),
      ),
      child: Icon(
        _getSessionTypeIcon(),
        color: _getSessionTypeColor(),
        size: 24.sp,
      ),
    );
  }

  Widget _buildSessionInfo(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.session.title,
                style: AppTypography.geistMedium16.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.session.isJoined)
              Container(
                margin: EdgeInsets.only(left: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Joined',
                  style: AppTypography.geistMedium11.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            if (widget.session.communityName != null) ...[
              Icon(
                PhosphorIcons.buildings(PhosphorIconsStyle.bold),
                size: 12.sp,
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
              SizedBox(width: 4.w),
              Text(
                widget.session.communityName!,
                style: AppTypography.geistRegular13.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.gray600,
                ),
              ),
              Text(
                ' • ',
                style: AppTypography.geistRegular13.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.gray600,
                ),
              ),
            ],
            Icon(
              PhosphorIcons.users(PhosphorIconsStyle.bold),
              size: 12.sp,
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
            SizedBox(width: 4.w),
            Text(
              '${widget.session.participants.length} participants',
              style: AppTypography.geistRegular13.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeAndActions(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _formatTimeAgo(),
          style: AppTypography.geistRegular12.copyWith(
            color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.session.durationText,
              style: AppTypography.geistMedium11.copyWith(
                color: _getSessionTypeColor(),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: widget.onCallBack,
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: _getSessionTypeColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  PhosphorIcons.phone(PhosphorIconsStyle.bold),
                  size: 14.sp,
                  color: _getSessionTypeColor(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData _getSessionTypeIcon() {
    switch (widget.session.type) {
      case VoiceSessionType.voice:
        return PhosphorIcons.microphone(PhosphorIconsStyle.bold);
      case VoiceSessionType.video:
        return PhosphorIcons.videoCamera(PhosphorIconsStyle.bold);
      case VoiceSessionType.game:
        return PhosphorIcons.gameController(PhosphorIconsStyle.bold);
      case VoiceSessionType.studySession:
        return PhosphorIcons.book(PhosphorIconsStyle.bold);
      case VoiceSessionType.meeting:
        return PhosphorIcons.users(PhosphorIconsStyle.bold);
      case VoiceSessionType.event:
        return PhosphorIcons.calendar(PhosphorIconsStyle.bold);
    }
  }

  Color _getSessionTypeColor() {
    switch (widget.session.type) {
      case VoiceSessionType.voice:
        return AppColors.primary;
      case VoiceSessionType.video:
        return AppColors.info;
      case VoiceSessionType.game:
        return AppColors.warning;
      case VoiceSessionType.studySession:
        return AppColors.success;
      case VoiceSessionType.meeting:
        return AppColors.secondary;
      case VoiceSessionType.event:
        return AppColors.primaryLight;
    }
  }

  String _formatTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(
      widget.session.endTime ?? widget.session.startTime,
    );

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
