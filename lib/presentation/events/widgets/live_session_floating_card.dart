import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../models/voice_models.dart';
import 'pulsing_avatar_ring.dart';

class LiveSessionFloatingCard extends StatefulWidget {
  final VoiceSession session;
  final VoidCallback? onJoin;
  final VoidCallback? onTap;

  const LiveSessionFloatingCard({
    super.key,
    required this.session,
    this.onJoin,
    this.onTap,
  });

  @override
  State<LiveSessionFloatingCard> createState() =>
      _LiveSessionFloatingCardState();
}

class _LiveSessionFloatingCardState extends State<LiveSessionFloatingCard>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _glowController;
  late AnimationController _hoverController;
  late Animation<double> _floatAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _floatAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeOut));

    // Start floating animation
    _floatController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _glowController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isHovered = true);
    _hoverController.forward();
    HapticFeedback.lightImpact();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isHovered = false);
    _hoverController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isHovered = false);
    _hoverController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _floatAnimation,
        _glowAnimation,
        _scaleAnimation,
      ]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              onTap: widget.onTap,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                child: Stack(
                  children: [
                    // Glow effect background
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        boxShadow: [
                          BoxShadow(
                            color: _getSessionColor().withValues(
                              alpha: _glowAnimation.value * 0.5,
                            ),
                            blurRadius: 30,
                            spreadRadius: 2,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: _buildMainCard(isDarkMode),
                    ),

                    // Interactive overlay
                    if (_isHovered)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            color: Colors.white.withValues(alpha: 0.1),
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

  Widget _buildMainCard(bool isDarkMode) {
    return Container(
      width: 350.w, // Increased width to prevent overflow
      height: 120.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getSessionColor().withValues(alpha: 0.1),
            _getSessionColor().withValues(alpha: 0.05),
            (isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.white)
                .withValues(alpha: 0.9),
          ],
          stops: const [0.0, 0.3, 1.0],
        ),
        border: Border.all(
          color: _getSessionColor().withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDarkMode ? Colors.black : Colors.grey).withValues(
              alpha: 0.1,
            ),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: CustomPaint(
                painter: SessionPatternPainter(
                  color: _getSessionColor().withValues(alpha: 0.03),
                  sessionType: widget.session.type,
                ),
              ),
            ),

            // Main content
            Padding(
              padding: EdgeInsets.all(16.w), // Reduced padding
              child: Row(
                mainAxisSize: MainAxisSize.min, // Shrink-wrap the row
                children: [
                  // Avatar ring showing participants
                  PulsingAvatarRing(
                    participants: widget.session.participants,
                    size: 70, // Reduced size
                    onTap: widget.onTap,
                  ),

                  SizedBox(width: 12.w), // Reduced spacing
                  // Session info
                  // Use SizedBox with fixed width instead of Flexible to avoid flex issues
                  SizedBox(
                    width: 160.w, // Increased width for session info
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Session type badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: _getSessionColor().withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            _getSessionTypeText(),
                            style: AppTypography.labelSmall.copyWith(
                              color: _getSessionColor(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // Session title
                        Text(
                          widget.session.title,
                          style: AppTypography.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode
                                ? Colors.white
                                : AppColors.gray900,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        SizedBox(height: 4.h),

                        // Live indicator and participant count
                        Row(
                          children: [
                            Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: _getSessionColor(),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              '${widget.session.participants.length} people',
                              style: AppTypography.labelMedium.copyWith(
                                color: isDarkMode
                                    ? AppColors.darkTextSecondary
                                    : AppColors.gray500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Join button
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.onJoin?.call();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w, // Reduced padding
                        vertical: 10.h, // Reduced padding
                      ),
                      decoration: BoxDecoration(
                        color: _getSessionColor(),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: _getSessionColor().withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        'Join',
                        style: AppTypography.labelMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSessionColor() {
    switch (widget.session.type) {
      case VoiceSessionType.voice:
        return const Color(0xFF00D4AA);
      case VoiceSessionType.video:
        return const Color(0xFF5865F2);
      case VoiceSessionType.game:
        return const Color(0xFFED4245);
      case VoiceSessionType.studySession:
        return const Color(0xFFFAA61A);
      case VoiceSessionType.meeting:
        return const Color(0xFF9146FF);
      case VoiceSessionType.event:
        return AppColors.primary;
    }
  }

  String _getSessionTypeText() {
    switch (widget.session.type) {
      case VoiceSessionType.voice:
        return 'VOICE';
      case VoiceSessionType.video:
        return 'VIDEO';
      case VoiceSessionType.game:
        return 'GAMING';
      case VoiceSessionType.studySession:
        return 'STUDY';
      case VoiceSessionType.meeting:
        return 'MEETING';
      case VoiceSessionType.event:
        return 'EVENT';
    }
  }
}

class SessionPatternPainter extends CustomPainter {
  final Color color;
  final VoiceSessionType sessionType;

  SessionPatternPainter({required this.color, required this.sessionType});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (sessionType) {
      case VoiceSessionType.game:
        _drawGamePattern(canvas, size, paint);
        break;
      case VoiceSessionType.studySession:
        _drawStudyPattern(canvas, size, paint);
        break;
      case VoiceSessionType.video:
        _drawVideoPattern(canvas, size, paint);
        break;
      case VoiceSessionType.voice:
      case VoiceSessionType.meeting:
      case VoiceSessionType.event:
        _drawVoicePattern(canvas, size, paint);
        break;
    }
  }

  void _drawVoicePattern(Canvas canvas, Size size, Paint paint) {
    // Draw sound wave pattern
    for (int i = 0; i < 6; i++) {
      final x = size.width * 0.7 + i * 8;
      final height = 15 + (i % 3) * 10.0;
      canvas.drawRRect(
        RRect.fromLTRBXY(
          x,
          size.height / 2 - height / 2,
          x + 3,
          size.height / 2 + height / 2,
          2,
          2,
        ),
        paint,
      );
    }
  }

  void _drawGamePattern(Canvas canvas, Size size, Paint paint) {
    // Draw game controller pattern
    final controllerPath = Path();
    controllerPath.addOval(
      Rect.fromCircle(
        center: Offset(size.width * 0.8, size.height * 0.3),
        radius: 4,
      ),
    );
    controllerPath.addOval(
      Rect.fromCircle(
        center: Offset(size.width * 0.85, size.height * 0.4),
        radius: 3,
      ),
    );
    controllerPath.addOval(
      Rect.fromCircle(
        center: Offset(size.width * 0.9, size.height * 0.6),
        radius: 5,
      ),
    );
    canvas.drawPath(controllerPath, paint);
  }

  void _drawStudyPattern(Canvas canvas, Size size, Paint paint) {
    // Draw book/study pattern
    for (int i = 0; i < 3; i++) {
      final y = size.height * 0.3 + i * 15;
      canvas.drawRRect(
        RRect.fromLTRBXY(size.width * 0.75, y, size.width * 0.9, y + 3, 2, 2),
        paint,
      );
    }
  }

  void _drawVideoPattern(Canvas canvas, Size size, Paint paint) {
    // Draw video/camera pattern
    final trianglePath = Path();
    trianglePath.moveTo(size.width * 0.8, size.height * 0.4);
    trianglePath.lineTo(size.width * 0.9, size.height * 0.5);
    trianglePath.lineTo(size.width * 0.8, size.height * 0.6);
    trianglePath.close();
    canvas.drawPath(trianglePath, paint);
  }

  @override
  bool shouldRepaint(SessionPatternPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.sessionType != sessionType;
  }
}
