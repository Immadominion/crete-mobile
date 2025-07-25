import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/voice_models.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import 'participant_avatar.dart';
import 'voice_activity_indicator.dart';

class MiniPlayer extends StatefulWidget {
  final VoiceSession session;
  final bool isMuted;
  final VoidCallback onTap;
  final VoidCallback onEndCall;
  final VoidCallback onToggleMute;

  const MiniPlayer({
    super.key,
    required this.session,
    required this.isMuted,
    required this.onTap,
    required this.onEndCall,
    required this.onToggleMute,
  });

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  bool _isDragging = false;
  Offset _dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String get _formatDuration {
    final duration = DateTime.now().difference(widget.session.startTime);
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  VoiceParticipant? get _currentSpeaker {
    try {
      return widget.session.participants.firstWhere((p) => p.isSpeaking);
    } catch (e) {
      return null;
    }
  }

  void _handlePanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    // If dragged down significantly, end the call
    if (_dragOffset.dy > 50) {
      widget.onEndCall();
    } else {
      // Snap back to position
      setState(() {
        _dragOffset = Offset.zero;
        _isDragging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final speaker = _currentSpeaker;

    return SlideTransition(
      position: _slideAnimation,
      child: AnimatedContainer(
        duration: Duration(milliseconds: _isDragging ? 0 : 300),
        transform: Matrix4.translationValues(_dragOffset.dx, _dragOffset.dy, 0),
        child: Positioned(
          top: 60.h,
          right: 16.w,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onTap();
            },
            onPanStart: _handlePanStart,
            onPanUpdate: _handlePanUpdate,
            onPanEnd: _handlePanEnd,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: speaker != null ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 280.w,
                    height: 64.h,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkBackgroundSecondary.withOpacity(0.95)
                          : Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(32.r),
                      border: speaker != null
                          ? Border.all(color: AppColors.success, width: 2)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          // Live indicator and participants
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Main avatar (current speaker or first participant)
                              ParticipantAvatar(
                                participant:
                                    speaker ??
                                    widget.session.participants.first,
                                size: 40.w,
                              ),

                              // Second participant (if exists)
                              if (widget.session.participants.length > 1)
                                Positioned(
                                  left: 20.w,
                                  child: ParticipantAvatar(
                                    participant: widget.session.participants[1],
                                    size: 32.w,
                                  ),
                                ),

                              // Live indicator
                              Positioned(
                                top: -2.h,
                                right: -2.w,
                                child: Container(
                                  width: 12.w,
                                  height: 12.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isDark
                                          ? AppColors.darkBackgroundSecondary
                                          : Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            width: widget.session.participants.length > 1
                                ? 24.w
                                : 12.w,
                          ),

                          // Call info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.session.title,
                                  style: AppTypography.geistMedium13.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.gray900,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                SizedBox(height: 2.h),

                                Row(
                                  children: [
                                    // Voice activity indicator
                                    if (speaker != null)
                                      SizedBox(
                                        width: 20.w,
                                        child: VoiceActivityIndicator(
                                          animation: _pulseAnimation,
                                          color: AppColors.success,
                                          height: 12.0,
                                          barCount: 3,
                                        ),
                                      )
                                    else
                                      Text(
                                        _formatDuration,
                                        style: AppTypography.geistRegular11
                                            .copyWith(
                                              color: isDark
                                                  ? AppColors.darkTextSecondary
                                                  : AppColors.gray600,
                                            ),
                                      ),

                                    if (speaker != null) ...[
                                      SizedBox(width: 4.w),

                                      Text(
                                        speaker.name,
                                        style: AppTypography.geistRegular11
                                            .copyWith(
                                              color: isDark
                                                  ? AppColors.darkTextSecondary
                                                  : AppColors.gray600,
                                            ),
                                      ),
                                    ],

                                    const Spacer(),

                                    // Participants count
                                    Text(
                                      '${widget.session.participants.length}',
                                      style: AppTypography.geistRegular11
                                          .copyWith(
                                            color: isDark
                                                ? AppColors.darkTextSecondary
                                                : AppColors.gray600,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 8.w),

                          // Controls
                          Row(
                            children: [
                              // Mute button
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  widget.onToggleMute();
                                },
                                child: Container(
                                  width: 32.w,
                                  height: 32.h,
                                  decoration: BoxDecoration(
                                    color: widget.isMuted
                                        ? AppColors.error.withOpacity(0.1)
                                        : (isDark
                                              ? AppColors.darkIconBackground
                                              : AppColors.gray100),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    widget.isMuted ? Icons.mic_off : Icons.mic,
                                    size: 16.sp,
                                    color: widget.isMuted
                                        ? AppColors.error
                                        : (isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.gray600),
                                  ),
                                ),
                              ),

                              SizedBox(width: 8.w),

                              // End call button
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  widget.onEndCall();
                                },
                                child: Container(
                                  width: 32.w,
                                  height: 32.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.call_end,
                                    size: 16.sp,
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
