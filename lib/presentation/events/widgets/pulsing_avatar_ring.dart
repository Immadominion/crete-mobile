import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors.dart';
import '../models/voice_models.dart';

class PulsingAvatarRing extends StatefulWidget {
  final List<VoiceParticipant> participants;
  final int maxVisible;
  final double size;
  final VoidCallback? onTap;

  const PulsingAvatarRing({
    super.key,
    required this.participants,
    this.maxVisible = 4,
    this.size = 80,
    this.onTap,
  });

  @override
  State<PulsingAvatarRing> createState() => _PulsingAvatarRingState();
}

class _PulsingAvatarRingState extends State<PulsingAvatarRing>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late Map<String, AnimationController> _speakingControllers;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Create speaking animation controllers for each participant
    _speakingControllers = {};
    for (final participant in widget.participants) {
      _speakingControllers[participant.id] = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      );

      // Simulate speaking animation for active speakers
      if (participant.isSpeaking) {
        _speakingControllers[participant.id]?.repeat(reverse: true);
      }
    }

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    for (final controller in _speakingControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleParticipants = widget.participants
        .take(widget.maxVisible)
        .toList();

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Container(
            width: widget.size.w,
            height: widget.size.w,
            child: Stack(
              children: [
                // Background ring with gradient
                Container(
                  width: widget.size.w,
                  height: widget.size.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.1),
                        AppColors.primary.withValues(alpha: 0.05),
                      ],
                    ),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                ),

                // Participants arranged in a circle
                ...visibleParticipants.asMap().entries.map((entry) {
                  final index = entry.key;
                  final participant = entry.value;
                  final radius = (widget.size / 2 - 20).w;

                  final x =
                      radius *
                      (1 +
                          0.7 *
                              (index.isEven ? 1 : -1) *
                              (index / visibleParticipants.length));
                  final y =
                      radius *
                      (1 +
                          0.7 *
                              (index.isOdd ? 1 : -1) *
                              (index / visibleParticipants.length));

                  return Positioned(
                    left: widget.size.w / 2 + x - 16.w,
                    top: widget.size.w / 2 + y - 16.w,
                    child: _buildParticipantAvatar(participant),
                  );
                }),

                // Center indicator showing count or activity
                Positioned(
                  left: widget.size.w / 2 - 20.w,
                  top: widget.size.w / 2 - 20.w,
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        widget.participants.length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // Activity pulse overlay for active sessions
                if (widget.participants.any((p) => p.isSpeaking))
                  Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: widget.size.w,
                      height: widget.size.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.6),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildParticipantAvatar(VoiceParticipant participant) {
    final speakingController = _speakingControllers[participant.id];

    return AnimatedBuilder(
      animation: speakingController ?? AlwaysStoppedAnimation<double>(0.0),
      builder: (context, child) {
        final speakingScale = participant.isSpeaking
            ? 1.0 + 0.2 * (speakingController?.value ?? 0.0)
            : 1.0;

        return Transform.scale(
          scale: speakingScale,
          child: Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: participant.isSpeaking
                    ? AppColors.primary
                    : Colors.transparent,
                width: 2,
              ),
              boxShadow: participant.isSpeaking
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: CircleAvatar(
              radius: 14.w,
              backgroundImage: participant.avatarUrl != null
                  ? NetworkImage(participant.avatarUrl!)
                  : null,
              backgroundColor: AppColors.primary.withValues(alpha: 0.3),
              child: participant.avatarUrl == null
                  ? Text(
                      participant.name[0].toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ),
        );
      },
    );
  }
}
