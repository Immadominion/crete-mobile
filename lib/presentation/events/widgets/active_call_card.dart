import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../models/voice_models.dart';
import 'participant_avatar.dart';
import 'voice_activity_indicator.dart';

class EnhancedActiveSessionCard extends StatefulWidget {
  final VoiceSession session;
  final VoidCallback? onJoin;
  final VoidCallback? onTap;

  const EnhancedActiveSessionCard({
    super.key,
    required this.session,
    this.onJoin,
    this.onTap,
  });

  @override
  State<EnhancedActiveSessionCard> createState() =>
      _EnhancedActiveSessionCardState();
}

class _EnhancedActiveSessionCardState extends State<EnhancedActiveSessionCard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    if (widget.session.status == VoiceSessionStatus.active) {
      _pulseController.repeat(reverse: true);
      _waveController.repeat();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isActive = widget.session.status == VoiceSessionStatus.active;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isActive ? _pulseAnimation.value : 1.0,
            child: Container(
              width: 240.w,
              margin: EdgeInsets.only(right: 16.w),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkBackgroundSecondary
                    : AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isActive
                      ? _getSessionTypeColor().withOpacity(0.4)
                      : (isDarkMode
                            ? AppColors.darkContainerBorder
                            : AppColors.gray200),
                  width: isActive ? 2 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isDarkMode),
                  SizedBox(height: 8.h),
                  _buildSessionInfo(isDarkMode),
                  SizedBox(height: 12.h),
                  if (isActive) _buildVoiceActivityIndicator(),
                  if (isActive) SizedBox(height: 12.h),
                  _buildParticipantsSection(isDarkMode),
                  SizedBox(height: 12.h),
                  _buildActionSection(isDarkMode),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Row(
      children: [
        _buildSessionTypeIcon(),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            widget.session.title,
            style: AppTypography.geistSemiBold15.copyWith(
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _buildStatusBadge(isDarkMode),
      ],
    );
  }

  Widget _buildSessionTypeIcon() {
    IconData icon;
    switch (widget.session.type) {
      case VoiceSessionType.voice:
        icon = PhosphorIcons.microphone(PhosphorIconsStyle.bold);
        break;
      case VoiceSessionType.video:
        icon = PhosphorIcons.videoCamera(PhosphorIconsStyle.bold);
        break;
      case VoiceSessionType.game:
        icon = PhosphorIcons.gameController(PhosphorIconsStyle.bold);
        break;
      case VoiceSessionType.studySession:
        icon = PhosphorIcons.book(PhosphorIconsStyle.bold);
        break;
      case VoiceSessionType.meeting:
        icon = PhosphorIcons.users(PhosphorIconsStyle.bold);
        break;
      case VoiceSessionType.event:
        icon = PhosphorIcons.calendar(PhosphorIconsStyle.bold);
        break;
    }

    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: _getSessionTypeColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(icon, color: _getSessionTypeColor(), size: 18.sp),
    );
  }

  Widget _buildStatusBadge(bool isDarkMode) {
    if (widget.session.status != VoiceSessionStatus.active)
      return const SizedBox();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.h,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'LIVE',
            style: AppTypography.geistSemiBold13.copyWith(
              color: AppColors.success,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionInfo(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.session.communityName != null)
          Row(
            children: [
              Icon(
                PhosphorIcons.buildings(PhosphorIconsStyle.bold),
                size: 14.sp,
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
              SizedBox(width: 4.w),
              Text(
                widget.session.communityName!,
                style: AppTypography.geistMedium13.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.gray600,
                ),
              ),
            ],
          ),
        SizedBox(height: 4.h),
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
              widget.session.durationText,
              style: AppTypography.geistRegular12.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '• ${widget.session.typeDisplayName}',
              style: AppTypography.geistRegular12.copyWith(
                color: _getSessionTypeColor(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVoiceActivityIndicator() {
    return AnimatedBuilder(
      animation: _waveAnimation,
      builder: (context, child) {
        return VoiceActivityIndicator(
          animation: _waveAnimation,
          color: _getSessionTypeColor(),
        );
      },
    );
  }

  Widget _buildParticipantsSection(bool isDarkMode) {
    final speakingParticipants = widget.session.participants
        .where((p) => p.isSpeaking)
        .toList();

    return Row(
      children: [
        Expanded(child: _buildParticipantAvatars()),
        if (speakingParticipants.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: _getSessionTypeColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '${speakingParticipants.length} speaking',
              style: AppTypography.geistRegular11.copyWith(
                color: _getSessionTypeColor(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildParticipantAvatars() {
    final visibleParticipants = widget.session.participants.take(4).toList();
    final remainingCount = widget.session.participants.length - 4;

    return SizedBox(
      height: 32.h,
      child: Stack(
        children: [
          ...visibleParticipants.asMap().entries.map((entry) {
            final index = entry.key;
            final participant = entry.value;
            return Positioned(
              left: (index * 24).toDouble().w,
              child: ParticipantAvatar(participant: participant, size: 32.w),
            );
          }),
          if (remainingCount > 0)
            Positioned(
              left: (visibleParticipants.length * 24).toDouble().w,
              child: Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: AppColors.gray500,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    '+$remainingCount',
                    style: AppTypography.geistSemiBold13.copyWith(
                      color: AppColors.white,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionSection(bool isDarkMode) {
    return Row(
      children: [
        Text(
          '${widget.session.participants.length}/${widget.session.maxParticipants}',
          style: AppTypography.geistRegular12.copyWith(
            color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
          ),
        ),
        const Spacer(),
        _buildJoinButton(),
      ],
    );
  }

  Widget _buildJoinButton() {
    final isJoined = widget.session.isJoined;

    return GestureDetector(
      onTap: widget.onJoin,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isJoined
              ? _getSessionTypeColor().withOpacity(0.1)
              : _getSessionTypeColor(),
          borderRadius: BorderRadius.circular(20.r),
          border: isJoined ? Border.all(color: _getSessionTypeColor()) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isJoined
                  ? PhosphorIcons.signOut(PhosphorIconsStyle.bold)
                  : PhosphorIcons.signIn(PhosphorIconsStyle.bold),
              size: 14.sp,
              color: isJoined ? _getSessionTypeColor() : AppColors.white,
            ),
            SizedBox(width: 4.w),
            Text(
              isJoined ? 'Leave' : 'Join',
              style: AppTypography.geistMedium13.copyWith(
                color: isJoined ? _getSessionTypeColor() : AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
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
}
