import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../models/voice_models.dart';

class CommunityActivityCard extends StatefulWidget {
  final String communityName;
  final String communityLogo;
  final int activeCount;
  final List<VoiceSession> activeSessions;
  final VoidCallback? onTap;

  const CommunityActivityCard({
    super.key,
    required this.communityName,
    required this.communityLogo,
    required this.activeCount,
    required this.activeSessions,
    this.onTap,
  });

  @override
  State<CommunityActivityCard> createState() => _CommunityActivityCardState();
}

class _CommunityActivityCardState extends State<CommunityActivityCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _pulseController;
  late Animation<double> _hoverAnimation;
  late Animation<double> _pulseAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _hoverAnimation = CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start pulsing if there's activity
    if (widget.activeCount > 0) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pulseController.dispose();
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
      animation: Listenable.merge([_hoverAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: widget.activeCount > 0 ? _pulseAnimation.value : 1.0,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.onTap,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              height: 110.h, // Increased height to prevent overflow
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _getGradientColors(isDarkMode),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        (widget.activeCount > 0
                                ? AppColors.primary
                                : Colors.black)
                            .withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: widget.activeCount > 0
                    ? Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1.5,
                      )
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: Stack(
                  children: [
                    // Background pattern for active communities
                    if (widget.activeCount > 0)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: ActivityPatternPainter(
                            color: AppColors.primary.withValues(alpha: 0.05),
                          ),
                        ),
                      ),

                    // Main content
                    Padding(
                      padding: EdgeInsets.all(16.w), // Reduced padding
                      child: Row(
                        children: [
                          // Community logo with activity indicator
                          Stack(
                            children: [
                              Container(
                                width: 60.w,
                                height: 60.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(widget.communityLogo),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                    color: widget.activeCount > 0
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                              ),

                              // Activity indicator
                              if (widget.activeCount > 0)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    width: 20.w,
                                    height: 20.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _getActivityColor(),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          SizedBox(width: 16.w),

                          // Community info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize
                                  .min, // Add this to prevent overflow
                              children: [
                                Text(
                                  widget.communityName,
                                  style: AppTypography.heading5.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : AppColors.gray900,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                SizedBox(height: 2.h), // Reduced spacing

                                Text(
                                  _getActivityText(),
                                  style: AppTypography.labelMedium.copyWith(
                                    color: widget.activeCount > 0
                                        ? AppColors.primary
                                        : (isDarkMode
                                              ? AppColors.darkTextSecondary
                                              : AppColors.gray500),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                // Active sessions preview
                                if (widget.activeSessions.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 2.h,
                                    ), // Reduced spacing
                                    child: Text(
                                      widget.activeSessions.first.title,
                                      style: AppTypography.labelSmall.copyWith(
                                        color: isDarkMode
                                            ? AppColors.darkTextSecondary
                                                  .withValues(alpha: 0.7)
                                            : AppColors.gray500.withValues(
                                                alpha: 0.8,
                                              ),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Action indicator
                          Icon(
                            PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
                            color: widget.activeCount > 0
                                ? AppColors.primary
                                : (isDarkMode
                                      ? AppColors.darkTextSecondary
                                      : AppColors.gray500),
                            size: 20.sp,
                          ),
                        ],
                      ),
                    ),

                    // Hover overlay
                    if (_isHovered)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
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

  List<Color> _getGradientColors(bool isDarkMode) {
    if (widget.activeCount > 0) {
      return [
        AppColors.primary.withValues(alpha: 0.1),
        AppColors.primary.withValues(alpha: 0.05),
      ];
    }

    return isDarkMode
        ? [
            AppColors.darkBackgroundSecondary,
            AppColors.darkBackgroundSecondary.withValues(alpha: 0.8),
          ]
        : [
            AppColors.backgroundSecondary,
            AppColors.backgroundSecondary.withValues(alpha: 0.9),
          ];
  }

  Color _getActivityColor() {
    if (widget.activeCount >= 10)
      return const Color(0xFFED4245); // Red - Very active
    if (widget.activeCount >= 5)
      return const Color(0xFFFAA61A); // Orange - Active
    return const Color(0xFF57F287); // Green - Some activity
  }

  String _getActivityText() {
    if (widget.activeCount == 0) {
      return 'No active sessions';
    } else if (widget.activeCount == 1) {
      return '1 person active now';
    } else {
      return '$widget.activeCount people active now';
    }
  }
}

class ActivityPatternPainter extends CustomPainter {
  final Color color;

  ActivityPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw organic bubble pattern
    for (int i = 0; i < 8; i++) {
      final x = (i * size.width / 4) % size.width;
      final y = (i * size.height / 3) % size.height;
      final radius = 10 + (i % 3) * 5.0;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(ActivityPatternPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
