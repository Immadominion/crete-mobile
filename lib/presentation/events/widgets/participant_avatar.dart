import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../models/voice_models.dart';

class ParticipantAvatar extends StatefulWidget {
  final VoiceParticipant participant;
  final double size;
  final bool showVoiceIndicator;

  const ParticipantAvatar({
    super.key,
    required this.participant,
    this.size = 40.0,
    this.showVoiceIndicator = true,
  });

  @override
  State<ParticipantAvatar> createState() => _ParticipantAvatarState();
}

class _ParticipantAvatarState extends State<ParticipantAvatar>
    with TickerProviderStateMixin {
  late AnimationController _voiceController;
  late Animation<double> _voiceAnimation;

  @override
  void initState() {
    super.initState();
    _voiceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _voiceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _voiceController, curve: Curves.easeInOut),
    );

    if (widget.participant.isSpeaking) {
      _voiceController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ParticipantAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.participant.isSpeaking != oldWidget.participant.isSpeaking) {
      if (widget.participant.isSpeaking) {
        _voiceController.repeat(reverse: true);
      } else {
        _voiceController.stop();
        _voiceController.reset();
      }
    }
  }

  @override
  void dispose() {
    _voiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _voiceAnimation,
          builder: (context, child) {
            return Container(
              width: widget.size.w,
              height: widget.size.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    widget.showVoiceIndicator && widget.participant.isSpeaking
                    ? Border.all(
                        color: AppColors.success.withOpacity(
                          0.5 + _voiceAnimation.value * 0.5,
                        ),
                        width: 3,
                      )
                    : Border.all(color: AppColors.white, width: 2),
                boxShadow:
                    widget.showVoiceIndicator && widget.participant.isSpeaking
                    ? [
                        BoxShadow(
                          color: AppColors.success.withOpacity(
                            0.3 + _voiceAnimation.value * 0.4,
                          ),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: CircleAvatar(
                radius: (widget.size / 2).r,
                backgroundColor: _getAvatarColor(),
                backgroundImage: widget.participant.avatarUrl != null
                    ? NetworkImage(widget.participant.avatarUrl!)
                    : null,
                child: widget.participant.avatarUrl == null
                    ? Text(
                        _getInitials(),
                        style: AppTypography.geistSemiBold13.copyWith(
                          color: AppColors.white,
                          fontSize: (widget.size / 3).sp,
                        ),
                      )
                    : null,
              ),
            );
          },
        ),

        // Host indicator
        if (widget.participant.isHost)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: (widget.size / 4).w,
              height: (widget.size / 4).h,
              decoration: const BoxDecoration(
                color: AppColors.warning,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.star,
                size: (widget.size / 6).sp,
                color: AppColors.white,
              ),
            ),
          ),

        // Muted indicator
        if (widget.participant.isMuted)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: (widget.size / 3).w,
              height: (widget.size / 3).h,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mic_off,
                size: (widget.size / 5).sp,
                color: AppColors.white,
              ),
            ),
          ),
      ],
    );
  }

  String _getInitials() {
    final names = widget.participant.name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return widget.participant.name.substring(0, 1).toUpperCase();
  }

  Color _getAvatarColor() {
    // Generate a consistent color based on participant ID
    final hash = widget.participant.id.hashCode;
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.info,
      AppColors.warning,
      AppColors.success,
      AppColors.primaryLight,
    ];
    return colors[hash.abs() % colors.length];
  }
}
