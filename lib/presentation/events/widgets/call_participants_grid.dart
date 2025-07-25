import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/voice_models.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import 'participant_avatar.dart';
import 'voice_activity_indicator.dart';

class CallParticipantsGrid extends StatefulWidget {
  final List<VoiceParticipant> participants;
  final bool isVideoCall;
  final bool isScreenSharing;
  final VoiceParticipant? screenShareParticipant;

  const CallParticipantsGrid({
    super.key,
    required this.participants,
    this.isVideoCall = false,
    this.isScreenSharing = false,
    this.screenShareParticipant,
  });

  @override
  State<CallParticipantsGrid> createState() => _CallParticipantsGridState();
}

class _CallParticipantsGridState extends State<CallParticipantsGrid>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildScreenShareView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          // Screen share content placeholder
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.screen_share,
                  size: 64.sp,
                  color: Colors.white.withOpacity(0.6),
                ),

                SizedBox(height: 16.h),

                Text(
                  '${widget.screenShareParticipant?.name ?? "Someone"} is sharing',
                  style: AppTypography.geistMedium16.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),

                SizedBox(height: 8.h),

                Text(
                  'Screen Share',
                  style: AppTypography.geistRegular14.copyWith(
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),

          // Participants strip at bottom
          Positioned(
            bottom: 16.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              height: 80.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.participants.length,
                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  final participant = widget.participants[index];
                  return _buildMiniParticipantCard(participant);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniParticipantCard(VoiceParticipant participant) {
    return Container(
      width: 60.w,
      child: Column(
        children: [
          Stack(
            children: [
              ParticipantAvatar(participant: participant, size: 48.w),

              if (participant.isSpeaking)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.success,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),

          SizedBox(height: 4.h),

          Text(
            participant.name,
            style: AppTypography.geistRegular13.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantGrid() {
    final participantCount = widget.participants.length;
    int columns;

    if (participantCount <= 2) {
      columns = participantCount;
    } else if (participantCount <= 4) {
      columns = 2;
    } else if (participantCount <= 9) {
      columns = 3;
    } else {
      columns = 4;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.8,
        ),
        itemCount: widget.participants.length,
        itemBuilder: (context, index) {
          final participant = widget.participants[index];
          return _buildParticipantCard(participant);
        },
      ),
    );
  }

  Widget _buildParticipantCard(VoiceParticipant participant) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: participant.isSpeaking
            ? AppColors.primary.withOpacity(0.1)
            : Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16.r),
        border: participant.isSpeaking
            ? Border.all(color: AppColors.success, width: 2)
            : null,
      ),
      child: Stack(
        children: [
          // Video/Avatar area
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: widget.isVideoCall && participant.isVideoOn
                  ? _buildVideoPlaceholder(participant)
                  : _buildAvatarView(participant),
            ),
          ),

          // Name overlay
          Positioned(
            bottom: 8.h,
            left: 8.w,
            right: 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      participant.name,
                      style: AppTypography.geistMedium13.copyWith(
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  if (participant.isMuted)
                    Icon(
                      Icons.mic_off,
                      size: 14.sp,
                      color: Colors.white.withOpacity(0.8),
                    ),
                ],
              ),
            ),
          ),

          // Host indicator
          if (participant.isHost)
            Positioned(
              top: 8.h,
              right: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'HOST',
                  style: AppTypography.geistMedium11.copyWith(
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

          // Speaking indicator
          if (participant.isSpeaking)
            Positioned(
              top: 8.h,
              left: 8.w,
              child: VoiceActivityIndicator(
                animation: _pulseAnimation,
                color: AppColors.success,
                height: 16.0,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVideoPlaceholder(VoiceParticipant participant) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam,
              size: 32.sp,
              color: Colors.white.withOpacity(0.6),
            ),

            SizedBox(height: 8.h),

            Text(
              'Video',
              style: AppTypography.geistRegular14.copyWith(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarView(VoiceParticipant participant) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.3),
            AppColors.primaryLight.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: ParticipantAvatar(participant: participant, size: 80.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isScreenSharing) {
      return _buildScreenShareView();
    }

    return _buildParticipantGrid();
  }
}
