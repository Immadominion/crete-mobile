import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';

/// Enhanced reactions widget with beautiful animations and particle effects
class EnhancedReactionsWidget extends StatefulWidget {
  const EnhancedReactionsWidget({
    super.key,
    required this.reactions,
    required this.onReactionTap,
    required this.onAddReaction,
    required this.isDarkMode,
    this.maxReactionsShown = 6,
  });

  final Map<String, int> reactions;
  final void Function(String) onReactionTap;
  final VoidCallback onAddReaction;
  final bool isDarkMode;
  final int maxReactionsShown;

  @override
  State<EnhancedReactionsWidget> createState() =>
      _EnhancedReactionsWidgetState();
}

class _EnhancedReactionsWidgetState extends State<EnhancedReactionsWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _reactionControllers;
  late List<Animation<double>> _reactionAnimations;
  late AnimationController _addButtonController;
  late Animation<double> _addButtonAnimation;

  final Map<String, AnimationController> _particleControllers = {};
  final GlobalKey _reactionsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    final reactionCount = widget.reactions.length;

    // Initialize reaction animations
    _reactionControllers = List.generate(
      reactionCount,
      (index) => AnimationController(
        duration: Duration(milliseconds: 300 + (index * 50)),
        vsync: this,
      ),
    );

    _reactionAnimations = _reactionControllers.map((controller) {
      return CurvedAnimation(parent: controller, curve: Curves.elasticOut);
    }).toList();

    // Initialize add button animation
    _addButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _addButtonAnimation = CurvedAnimation(
      parent: _addButtonController,
      curve: Curves.easeInOut,
    );

    // Start staggered entrance animations
    _startEntranceAnimation();
  }

  void _startEntranceAnimation() {
    for (int i = 0; i < _reactionControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _reactionControllers[i].forward();
        }
      });
    }

    // Animate add button after reactions
    Future.delayed(
      Duration(milliseconds: _reactionControllers.length * 100 + 200),
      () {
        if (mounted) {
          _addButtonController.forward();
        }
      },
    );
  }

  @override
  void didUpdateWidget(EnhancedReactionsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle reactions being added/removed
    if (widget.reactions.length != oldWidget.reactions.length) {
      _updateAnimations();
    }
  }

  void _updateAnimations() {
    // Dispose old controllers
    for (final controller in _reactionControllers) {
      controller.dispose();
    }

    // Reinitialize with new count
    _initializeAnimations();
  }

  @override
  void dispose() {
    for (final controller in _reactionControllers) {
      controller.dispose();
    }
    _addButtonController.dispose();
    for (final controller in _particleControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reactions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      key: _reactionsKey,
      margin: EdgeInsets.only(top: 8.h),
      child: Wrap(
        spacing: 6.w,
        runSpacing: 6.h,
        children: [..._buildReactionChips(), _buildAddReactionButton()],
      ),
    );
  }

  List<Widget> _buildReactionChips() {
    final sortedReactions = widget.reactions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final reactionsToShow = sortedReactions.take(widget.maxReactionsShown);

    return reactionsToShow.map((entry) {
      final index = sortedReactions.indexOf(entry);
      final animationIndex = min(index, _reactionAnimations.length - 1);

      return _buildAnimatedReactionChip(entry.key, entry.value, animationIndex);
    }).toList();
  }

  Widget _buildAnimatedReactionChip(
    String emoji,
    int count,
    int animationIndex,
  ) {
    final animation = animationIndex < _reactionAnimations.length
        ? _reactionAnimations[animationIndex]
        : _reactionAnimations.last;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: _buildReactionChip(emoji, count),
        );
      },
    );
  }

  Widget _buildReactionChip(String emoji, int count) {
    return GestureDetector(
      onTap: () {
        _animateReactionTap(emoji);
        widget.onReactionTap(emoji);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? AppColors.darkIconBackground.withOpacity(0.7)
              : AppColors.gray100.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: widget.isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.isDarkMode
                  ? AppColors.black.withOpacity(0.3)
                  : AppColors.gray400.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: 14.sp)),
            if (count > 1) ...[
              SizedBox(width: 4.w),
              Text(
                count.toString(),
                style: AppTypography.geistMedium11.copyWith(
                  color: widget.isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.gray600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAddReactionButton() {
    return AnimatedBuilder(
      animation: _addButtonAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _addButtonAnimation.value,
          child: GestureDetector(
            onTap: () {
              _animateAddButtonTap();
              widget.onAddReaction();
            },
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: widget.isDarkMode
                    ? AppColors.darkIconBackground.withOpacity(0.5)
                    : AppColors.gray100.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: widget.isDarkMode
                      ? AppColors.darkContainerBorder
                      : AppColors.gray300,
                  width: 1,
                ),
              ),
              child: Icon(
                PhosphorIcons.plus(PhosphorIconsStyle.bold),
                size: 14.sp,
                color: widget.isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
            ),
          ),
        );
      },
    );
  }

  void _animateReactionTap(String emoji) {
    // Create particle effect for reaction tap
    _createParticleEffect(emoji);

    // Scale animation for the tapped reaction
    final reactionIndex = widget.reactions.keys.toList().indexOf(emoji);
    if (reactionIndex >= 0 && reactionIndex < _reactionControllers.length) {
      final controller = _reactionControllers[reactionIndex];
      controller.reverse().then((_) {
        if (mounted) {
          controller.forward();
        }
      });
    }
  }

  void _animateAddButtonTap() {
    _addButtonController.reverse().then((_) {
      if (mounted) {
        _addButtonController.forward();
      }
    });
  }

  void _createParticleEffect(String emoji) {
    // Create floating emoji particles
    final particleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _particleControllers[emoji] = particleController;

    // Show particles
    if (_reactionsKey.currentContext != null) {
      final RenderBox renderBox =
          _reactionsKey.currentContext!.findRenderObject()! as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);

      _showFloatingParticles(emoji, position, particleController);
    }

    particleController.forward().then((_) {
      particleController.dispose();
      _particleControllers.remove(emoji);
    });
  }

  void _showFloatingParticles(
    String emoji,
    Offset position,
    AnimationController controller,
  ) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Positioned(
            left: position.dx,
            top: position.dy,
            child: IgnorePointer(
              child: _buildParticleSystem(emoji, controller.value),
            ),
          );
        },
      ),
    );

    overlay.insert(overlayEntry);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        overlayEntry.remove();
      }
    });
  }

  Widget _buildParticleSystem(String emoji, double progress) {
    return SizedBox(
      width: 100.w,
      height: 100.h,
      child: Stack(
        children: List.generate(5, (index) {
          final angle = (index * 72) * (pi / 180); // 72 degrees apart
          final distance = progress * 50.w;
          final x = cos(angle) * distance;
          final y = sin(angle) * distance;

          return Transform.translate(
            offset: Offset(x, y),
            child: Transform.scale(
              scale: 1.0 - progress,
              child: Opacity(
                opacity: 1.0 - progress,
                child: Text(emoji, style: TextStyle(fontSize: 12.sp)),
              ),
            ),
          );
        }),
      ),
    );
  }
}
