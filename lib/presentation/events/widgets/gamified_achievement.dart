import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

/// Achievement types for gamification
enum AchievementType {
  firstEvent,
  eventCreator,
  communityBuilder,
  earlyBird,
  talkative,
  networkBuilder,
  loyalMember,
  eventHost,
  helpfulMember,
  trendsetter,
}

/// Achievement rarity levels
enum AchievementRarity { common, uncommon, rare, epic, legendary }

/// Achievement model for gamification
class Achievement {
  final String id;
  final String title;
  final String description;
  final AchievementType type;
  final AchievementRarity rarity;
  final IconData icon;
  final Color color;
  final int xpReward;
  final DateTime unlockedAt;
  final bool isNew;
  final int progress;
  final int maxProgress;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.rarity,
    required this.icon,
    required this.color,
    required this.xpReward,
    required this.unlockedAt,
    this.isNew = false,
    this.progress = 0,
    this.maxProgress = 1,
  });

  bool get isCompleted => progress >= maxProgress;
  double get progressPercent => maxProgress > 0 ? progress / maxProgress : 0.0;

  /// Factory constructors for different achievement types
  factory Achievement.firstEvent() {
    return Achievement(
      id: 'first_event',
      title: 'Event Explorer',
      description: 'Attended your first event',
      type: AchievementType.firstEvent,
      rarity: AchievementRarity.common,
      icon: PhosphorIcons.compass(),
      color: AppColors.success,
      xpReward: 10,
      unlockedAt: DateTime.now(),
      isNew: true,
    );
  }

  factory Achievement.eventCreator() {
    return Achievement(
      id: 'event_creator',
      title: 'Event Organizer',
      description: 'Created 5 successful events',
      type: AchievementType.eventCreator,
      rarity: AchievementRarity.rare,
      icon: PhosphorIcons.calendar(),
      color: AppColors.warning,
      xpReward: 100,
      unlockedAt: DateTime.now(),
      progress: 3,
      maxProgress: 5,
    );
  }

  factory Achievement.communityBuilder() {
    return Achievement(
      id: 'community_builder',
      title: 'Community Builder',
      description: 'Helped grow 3 communities to 100+ members',
      type: AchievementType.communityBuilder,
      rarity: AchievementRarity.epic,
      icon: PhosphorIcons.users(),
      color: AppColors.primary,
      xpReward: 250,
      unlockedAt: DateTime.now(),
      progress: 1,
      maxProgress: 3,
    );
  }

  factory Achievement.earlyBird() {
    return Achievement(
      id: 'early_bird',
      title: 'Early Bird',
      description: 'First to join 10 events',
      type: AchievementType.earlyBird,
      rarity: AchievementRarity.uncommon,
      icon: PhosphorIcons.sun(),
      color: AppColors.info,
      xpReward: 50,
      unlockedAt: DateTime.now(),
      progress: 7,
      maxProgress: 10,
    );
  }

  factory Achievement.talkative() {
    return Achievement(
      id: 'talkative',
      title: 'Voice of the Community',
      description: 'Spoke for 100 hours in voice chats',
      type: AchievementType.talkative,
      rarity: AchievementRarity.legendary,
      icon: PhosphorIcons.microphone(),
      color: AppColors.error,
      xpReward: 500,
      unlockedAt: DateTime.now(),
      progress: 87,
      maxProgress: 100,
    );
  }
}

/// Gamified achievement widget with animations and micro-interactions
class GamifiedAchievementWidget extends StatefulWidget {
  final Achievement achievement;
  final bool isDarkMode;
  final VoidCallback? onTap;
  final bool showProgress;
  final bool showXP;

  const GamifiedAchievementWidget({
    super.key,
    required this.achievement,
    required this.isDarkMode,
    this.onTap,
    this.showProgress = true,
    this.showXP = true,
  });

  @override
  State<GamifiedAchievementWidget> createState() =>
      _GamifiedAchievementWidgetState();
}

class _GamifiedAchievementWidgetState extends State<GamifiedAchievementWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _glowController;
  late AnimationController _bounceController;
  late AnimationController _progressController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _slideController.forward();

    // Start glow animation for new achievements
    if (widget.achievement.isNew) {
      _glowController.repeat(reverse: true);
    }

    // Animate progress bar
    if (widget.showProgress && widget.achievement.progress > 0) {
      _progressController.forward();
    }
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeOut),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOutQuart),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _glowController.dispose();
    _bounceController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    if (isHovered) {
      _bounceController.forward();
    } else {
      _bounceController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: AnimatedBuilder(
        animation: Listenable.merge([_glowAnimation, _bounceAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceAnimation.value,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  if (widget.achievement.isNew)
                    BoxShadow(
                      color: widget.achievement.color.withOpacity(
                        0.3 * _glowAnimation.value,
                      ),
                      blurRadius: 20.r * _glowAnimation.value,
                      offset: const Offset(0, 4),
                    ),
                  BoxShadow(
                    color: (widget.isDarkMode ? Colors.black : Colors.grey)
                        .withOpacity(0.1),
                    blurRadius: 8.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildAchievementCard(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAchievementCard() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: MouseRegion(
          onEnter: (_) => _onHover(true),
          onExit: (_) => _onHover(false),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? AppColors.darkBackgroundSecondary
                  : AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: widget.achievement.isCompleted
                    ? widget.achievement.color.withOpacity(0.4)
                    : (widget.isDarkMode
                          ? AppColors.darkContainerBorder
                          : AppColors.gray300),
                width: widget.achievement.isCompleted ? 1.5 : 1.0,
              ),
              gradient: widget.achievement.isCompleted
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.achievement.color.withOpacity(0.05),
                        Colors.transparent,
                      ],
                    )
                  : null,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildAchievementIcon(),
                    SizedBox(width: 12.w),
                    Expanded(child: _buildAchievementInfo()),
                    _buildTrailingElements(),
                  ],
                ),
                if (widget.showProgress && !widget.achievement.isCompleted) ...[
                  SizedBox(height: 12.h),
                  _buildProgressBar(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementIcon() {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: widget.achievement.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: widget.achievement.color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Icon(
        widget.achievement.icon,
        size: 24.sp,
        color: widget.achievement.color,
      ),
    );
  }

  Widget _buildAchievementInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.achievement.title,
                style: AppTypography.geistSemiBold15.copyWith(
                  color: widget.isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            _buildRarityBadge(),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          widget.achievement.description,
          style: AppTypography.geistRegular13.copyWith(
            color: widget.isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.gray600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTrailingElements() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (widget.achievement.isNew) _buildNewBadge(),
        if (widget.showXP) ...[SizedBox(height: 4.h), _buildXPReward()],
        if (!widget.achievement.isCompleted) ...[
          SizedBox(height: 4.h),
          _buildProgressText(),
        ],
      ],
    );
  }

  Widget _buildRarityBadge() {
    Color rarityColor;
    String rarityText;

    switch (widget.achievement.rarity) {
      case AchievementRarity.common:
        rarityColor = AppColors.gray500;
        rarityText = 'Common';
        break;
      case AchievementRarity.uncommon:
        rarityColor = AppColors.success;
        rarityText = 'Uncommon';
        break;
      case AchievementRarity.rare:
        rarityColor = AppColors.info;
        rarityText = 'Rare';
        break;
      case AchievementRarity.epic:
        rarityColor = AppColors.warning;
        rarityText = 'Epic';
        break;
      case AchievementRarity.legendary:
        rarityColor = AppColors.error;
        rarityText = 'Legendary';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: rarityColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: rarityColor.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        rarityText.toUpperCase(),
        style: AppTypography.geistMedium11.copyWith(
          color: rarityColor,
          fontSize: 9.sp,
        ),
      ),
    );
  }

  Widget _buildNewBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        'NEW',
        style: AppTypography.geistMedium11.copyWith(
          color: AppColors.white,
          fontSize: 9.sp,
        ),
      ),
    );
  }

  Widget _buildXPReward() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(PhosphorIcons.star(), size: 10.sp, color: AppColors.primary),
          SizedBox(width: 2.w),
          Text(
            '${widget.achievement.xpReward} XP',
            style: AppTypography.geistMedium11.copyWith(
              color: AppColors.primary,
              fontSize: 9.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressText() {
    return Text(
      '${widget.achievement.progress}/${widget.achievement.maxProgress}',
      style: AppTypography.geistRegular11.copyWith(
        color: widget.isDarkMode
            ? AppColors.darkTextSecondary
            : AppColors.gray500,
      ),
    );
  }

  Widget _buildProgressBar() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: AppTypography.geistMedium11.copyWith(
                    color: widget.isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600,
                  ),
                ),
                Text(
                  '${((widget.achievement.progressPercent * _progressAnimation.value) * 100).toInt()}%',
                  style: AppTypography.geistMedium11.copyWith(
                    color: widget.achievement.color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            LinearProgressIndicator(
              value:
                  widget.achievement.progressPercent * _progressAnimation.value,
              backgroundColor: widget.achievement.color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(widget.achievement.color),
              minHeight: 4.h,
            ),
          ],
        );
      },
    );
  }
}
