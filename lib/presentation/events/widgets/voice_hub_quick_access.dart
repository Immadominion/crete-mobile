import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../models/voice_models.dart';
import '../data/voice_hub_demo_data.dart';
import 'participant_avatar.dart';

/// Quick access to voice hub functionality for the home page
/// Shows active sessions preview and provides navigation to the full voice hub
class VoiceHubQuickAccess extends StatefulWidget {
  final VoidCallback? onSeeAll;

  const VoiceHubQuickAccess({super.key, this.onSeeAll});

  @override
  State<VoiceHubQuickAccess> createState() => _VoiceHubQuickAccessState();
}

class _VoiceHubQuickAccessState extends State<VoiceHubQuickAccess>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late List<Animation<double>> _slideAnimations;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Slide animation for initial appearance
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Pulse animation for active sessions
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Get active sessions for animation setup
    final activeSessions = VoiceHubDemoData.getActiveSessions();
    final itemCount = activeSessions.length.clamp(
      0,
      3,
    ); // Limit to 3 for home page

    if (itemCount > 0) {
      // Calculate safe intervals for staggered animations
      const maxStaggerRatio = 0.3;
      const animationRatio = 0.7;
      final staggerDelay = maxStaggerRatio / itemCount;

      _slideAnimations = List.generate(itemCount, (index) {
        final startTime = (index * staggerDelay).clamp(0.0, 0.3);
        final endTime = (startTime + animationRatio).clamp(startTime, 1.0);

        return Tween<double>(begin: 100.0, end: 0.0).animate(
          CurvedAnimation(
            parent: _slideController,
            curve: Interval(startTime, endTime, curve: Curves.easeOutCubic),
          ),
        );
      });
    } else {
      _slideAnimations = [];
    }

    // Pulse animation for active indicators
    _pulseAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.05,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.05,
          end: 0.98,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.98,
          end: 1.02,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.02,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1.0,
      ),
    ]).animate(_pulseController);

    // Start animations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _slideController.forward();
        _pulseController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final activeSessions = VoiceHubDemoData.getActiveSessions()
        .take(3)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(isDarkMode),
        SizedBox(height: 16.h),
        if (activeSessions.isNotEmpty)
          AnimatedBuilder(
            animation: _slideController,
            builder: (context, child) {
              return Column(
                children: activeSessions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final session = entry.value;

                  if (index < _slideAnimations.length) {
                    return Transform.translate(
                      offset: Offset(0, _slideAnimations[index].value),
                      child: _buildVoiceSessionItem(session, isDarkMode),
                    );
                  }
                  return _buildVoiceSessionItem(session, isDarkMode);
                }).toList(),
              );
            },
          )
        else
          _buildEmptyState(isDarkMode),
      ],
    );
  }

  Widget _buildSectionHeader(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                PhosphorIcons.microphoneStage(),
                size: 20.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Events',
              style: AppTypography.heading4.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
            ),
          ],
        ),
        if (widget.onSeeAll != null)
          GestureDetector(
            onTap: widget.onSeeAll,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'See All',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    PhosphorIcons.arrowRight(),
                    size: 12.sp,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVoiceSessionItem(VoiceSession session, bool isDarkMode) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          child: Transform.scale(
            scale: session.status == VoiceSessionStatus.active
                ? _pulseAnimation.value
                : 1.0,
            child: GestureDetector(
              onTap: () => _handleSessionTap(session),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.darkBackgroundSecondary
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: session.status == VoiceSessionStatus.active
                        ? AppColors.primary.withOpacity(0.3)
                        : isDarkMode
                        ? AppColors.darkContainerBorder
                        : AppColors.gray200,
                    width: session.status == VoiceSessionStatus.active ? 2 : 1,
                  ),
                  boxShadow: session.status == VoiceSessionStatus.active
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: isDarkMode
                                ? Colors.black.withOpacity(0.2)
                                : Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ],
                ),
                child: Row(
                  children: [
                    // Session info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Live indicator
                              if (session.status == VoiceSessionStatus.active)
                                Container(
                                  margin: EdgeInsets.only(right: 8.w),
                                  child: SizedBox(
                                    width: 16.sp,
                                    height: 16.sp,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.mic,
                                        size: 8.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  session.title,
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode
                                        ? AppColors.darkTextPrimary
                                        : AppColors.gray900,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          if (session.communityName != null)
                            Text(
                              session.communityName!,
                              style: AppTypography.caption.copyWith(
                                color: isDarkMode
                                    ? AppColors.darkTextSecondary
                                    : AppColors.gray600,
                              ),
                            ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              // Participant avatars
                              ...session.participants.take(3).map((
                                participant,
                              ) {
                                return Padding(
                                  padding: EdgeInsets.only(right: 4.w),
                                  child: ParticipantAvatar(
                                    participant: participant,
                                    size: 24.sp,
                                    showVoiceIndicator: true,
                                  ),
                                );
                              }),
                              if (session.participants.length > 3)
                                Container(
                                  width: 24.sp,
                                  height: 24.sp,
                                  decoration: BoxDecoration(
                                    color: AppColors.gray300,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '+${session.participants.length - 3}',
                                      style: AppTypography.caption.copyWith(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.gray700,
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(width: 8.w),
                              Text(
                                '${session.participants.length} / ${session.maxParticipants}',
                                style: AppTypography.caption.copyWith(
                                  color: isDarkMode
                                      ? AppColors.darkTextSecondary
                                      : AppColors.gray600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Join button
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: session.status == VoiceSessionStatus.active
                            ? AppColors.primary
                            : AppColors.gray300,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        session.status == VoiceSessionStatus.active
                            ? 'Join'
                            : 'Ended',
                        style: AppTypography.labelSmall.copyWith(
                          color: session.status == VoiceSessionStatus.active
                              ? Colors.white
                              : AppColors.gray600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkBackgroundSecondary
            : AppColors.gray50,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            PhosphorIcons.microphoneSlash(),
            size: 32.sp,
            color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray400,
          ),
          SizedBox(height: 12.h),
          Text(
            'No active voice sessions',
            style: AppTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Start a call or join a community event',
            style: AppTypography.caption.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _handleSessionTap(VoiceSession session) {
    if (widget.onSeeAll != null) {
      widget.onSeeAll!();
    }
  }
}
