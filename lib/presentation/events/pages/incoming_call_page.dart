import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/voice_models.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../widgets/participant_avatar.dart';

class IncomingCallPage extends StatefulWidget {
  final VoiceSession session;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const IncomingCallPage({
    super.key,
    required this.session,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  State<IncomingCallPage> createState() => _IncomingCallPageState();
}

class _IncomingCallPageState extends State<IncomingCallPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for avatar
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Slide animation for entry
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_slideController);

    // Start animations
    _slideController.forward();
    _pulseController.repeat(reverse: true);

    // Set immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();

    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }

  void _acceptCall() {
    HapticFeedback.lightImpact();
    _slideController.reverse().then((_) {
      widget.onAccept();
    });
  }

  void _declineCall() {
    HapticFeedback.mediumImpact();
    _slideController.reverse().then((_) {
      widget.onDecline();
    });
  }

  @override
  Widget build(BuildContext context) {
    final caller = widget.session.participants.first;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _slideController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withOpacity(
                    0.8 * _backgroundAnimation.value,
                  ),
                  AppColors.primaryDark.withOpacity(
                    0.9 * _backgroundAnimation.value,
                  ),
                  Colors.black.withOpacity(0.95 * _backgroundAnimation.value),
                ],
              ),
            ),
            child: SlideTransition(
              position: _slideAnimation,
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 60.h),

                    // Incoming call label
                    Text(
                      'Incoming ${widget.session.typeDisplayName}',
                      style: AppTypography.geistRegular16.copyWith(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Call title
                    Text(
                      widget.session.title,
                      style: AppTypography.geistSemiBold15.copyWith(
                        fontSize: 24.sp,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    if (widget.session.communityName != null) ...[
                      SizedBox(height: 8.h),

                      Text(
                        widget.session.communityName!,
                        style: AppTypography.geistRegular14.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],

                    SizedBox(height: 60.h),

                    // Caller avatar with pulse
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: ParticipantAvatar(
                              participant: caller,
                              size: 120.w,
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 40.h),

                    // Caller name
                    Text(
                      caller.name,
                      style: AppTypography.geistSemiBold15.copyWith(
                        fontSize: 28.sp,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Participants count
                    if (widget.session.participants.length > 1)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          '${widget.session.participants.length} participants',
                          style: AppTypography.geistMedium13.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),

                    const Spacer(),

                    // Action buttons
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Decline button
                          GestureDetector(
                            onTap: _declineCall,
                            child: Container(
                              width: 70.w,
                              height: 70.h,
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.error.withOpacity(0.3),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.call_end,
                                color: Colors.white,
                                size: 32.sp,
                              ),
                            ),
                          ),

                          // Accept button
                          GestureDetector(
                            onTap: _acceptCall,
                            child: Container(
                              width: 70.w,
                              height: 70.h,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.success.withOpacity(0.3),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.call,
                                color: Colors.white,
                                size: 32.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 60.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
