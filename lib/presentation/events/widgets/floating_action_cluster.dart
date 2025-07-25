import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

class FloatingActionCluster extends StatefulWidget {
  final VoidCallback? onVoiceTap;
  final VoidCallback? onVideoTap;
  final VoidCallback? onScreenShareTap;

  const FloatingActionCluster({
    super.key,
    this.onVoiceTap,
    this.onVideoTap,
    this.onScreenShareTap,
  });

  @override
  State<FloatingActionCluster> createState() => _FloatingActionClusterState();
}

class _FloatingActionClusterState extends State<FloatingActionCluster>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _expansionController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _expansionController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _expansionController,
      curve: Curves.elasticOut,
    );

    // Start gentle pulsing animation
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _expansionController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _expansionController.forward();
      _pulseController.stop();
    } else {
      _expansionController.reverse();
      _pulseController.repeat(reverse: true);
    }

    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      right: 20.w,
      bottom: 100.h,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseAnimation, _scaleAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _isExpanded ? 1.0 : _pulseAnimation.value,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Main FAB
                GestureDetector(
                  onTap: _toggleExpansion,
                  child: Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isExpanded
                          ? PhosphorIcons.x(PhosphorIconsStyle.bold)
                          : PhosphorIcons.plus(PhosphorIconsStyle.bold),
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                ),

                // Voice Action
                if (_isExpanded)
                  Positioned(
                    right: 0,
                    bottom: 70.h * _scaleAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: _buildActionButton(
                        icon: PhosphorIcons.microphone(PhosphorIconsStyle.bold),
                        label: 'Voice',
                        color: const Color(0xFF00D4AA),
                        onTap: widget.onVoiceTap,
                        delay: 100,
                      ),
                    ),
                  ),

                // Video Action
                if (_isExpanded)
                  Positioned(
                    right: 50.w * _scaleAnimation.value,
                    bottom: 50.h * _scaleAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: _buildActionButton(
                        icon: PhosphorIcons.videoCamera(
                          PhosphorIconsStyle.bold,
                        ),
                        label: 'Video',
                        color: const Color(0xFF5865F2),
                        onTap: widget.onVideoTap,
                        delay: 200,
                      ),
                    ),
                  ),

                // Screen Share Action
                if (_isExpanded)
                  Positioned(
                    right: 70.w * _scaleAnimation.value,
                    bottom: 0,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: _buildActionButton(
                        icon: PhosphorIcons.monitor(PhosphorIconsStyle.bold),
                        label: 'Share',
                        color: const Color(0xFFED4245),
                        onTap: widget.onScreenShareTap,
                        delay: 300,
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

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
    required int delay,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
