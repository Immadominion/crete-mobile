import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';

/// Advanced reaction picker with beautiful design, tabs, and animations
class EnhancedReactionPickerImproved extends StatefulWidget {
  const EnhancedReactionPickerImproved({
    super.key,
    required this.onReactionSelected,
    required this.isDarkMode,
    required this.recentReactions,
    this.customEmojis = const [],
  });

  final void Function(String) onReactionSelected;
  final bool isDarkMode;
  final List<String> recentReactions;
  final List<String> customEmojis;

  @override
  State<EnhancedReactionPickerImproved> createState() =>
      _EnhancedReactionPickerImprovedState();
}

class _EnhancedReactionPickerImprovedState
    extends State<EnhancedReactionPickerImproved>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late TabController _tabController;

  final List<String> _commonReactions = [
    '👍',
    '❤️',
    '😂',
    '😮',
    '😢',
    '😡',
    '👏',
    '🔥',
    '💯',
    '👌',
    '🎉',
    '🤔',
    '😍',
    '🤗',
    '👀',
    '🙌',
  ];

  final List<String> _smileyEmojis = [
    '😀',
    '😃',
    '😄',
    '😁',
    '😆',
    '😅',
    '🤣',
    '😂',
    '🙂',
    '🙃',
    '😉',
    '😊',
    '😇',
    '🥰',
    '😍',
    '🤩',
    '😘',
    '😗',
    '😙',
    '😚',
    '😋',
    '😛',
    '😝',
    '😜',
    '🤪',
    '🤨',
    '🧐',
    '🤓',
    '😎',
    '🥳',
    '😏',
    '😒',
    '😞',
    '😔',
    '😟',
    '😕',
    '🙁',
    '☹️',
    '😣',
    '😖',
    '😫',
    '😩',
    '🥺',
    '😢',
    '😭',
    '😤',
    '😠',
    '😡',
  ];

  final List<String> _gestureEmojis = [
    '👍',
    '👎',
    '👌',
    '🤌',
    '🤏',
    '✌️',
    '🤞',
    '🤟',
    '🤘',
    '🤙',
    '👈',
    '👉',
    '👆',
    '🖕',
    '👇',
    '☝️',
    '👏',
    '🙌',
    '👐',
    '🤲',
    '🤝',
    '🙏',
    '✊',
    '👊',
    '🤛',
    '🤜',
    '💪',
    '🦾',
    '🖐️',
    '✋',
    '🤚',
    '👋',
  ];

  final List<String> _heartEmojis = [
    '❤️',
    '🧡',
    '💛',
    '💚',
    '💙',
    '💜',
    '🖤',
    '🤍',
    '🤎',
    '💔',
    '❣️',
    '💕',
    '💞',
    '💓',
    '💗',
    '💖',
    '💘',
    '💝',
    '💟',
    '♥️',
    '💋',
    '🔥',
    '⭐',
    '✨',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _tabController = TabController(length: 4, vsync: this);

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    _slideController.forward();
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20.w),
              constraints: BoxConstraints(maxWidth: 320.w, maxHeight: 480.h),
              decoration: BoxDecoration(
                color: widget.isDarkMode
                    ? AppColors.darkBackgroundSecondary
                    : AppColors.backgroundPrimary,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: widget.isDarkMode
                      ? AppColors.darkContainerBorder.withValues(alpha: 0.3)
                      : AppColors.gray200.withValues(alpha: 0.5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: widget.isDarkMode ? 0.4 : 0.15,
                    ),
                    offset: Offset(0, 8.h),
                    blurRadius: 24.r,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  _buildTabBar(),
                  Flexible(child: _buildTabBarView()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: widget.isDarkMode
                ? AppColors.darkContainerBorder.withValues(alpha: 0.3)
                : AppColors.gray200.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Add Reaction',
            style: AppTypography.geistSemiBold15.copyWith(
              color: widget.isDarkMode
                  ? AppColors.darkTextPrimary
                  : AppColors.gray900,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: widget.isDarkMode
                    ? AppColors.darkContainerBorder.withValues(alpha: 0.2)
                    : AppColors.gray100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                PhosphorIcons.x(PhosphorIconsStyle.regular),
                size: 16.sp,
                color: widget.isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.primary,
        indicatorWeight: 2.5,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: AppColors.primary,
        unselectedLabelColor: widget.isDarkMode
            ? AppColors.darkTextSecondary
            : AppColors.gray500,
        labelStyle: AppTypography.geistMedium13.copyWith(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: AppTypography.geistRegular12.copyWith(
          fontSize: 11.sp,
        ),
        tabs: const [
          Tab(text: 'Recent'),
          Tab(text: 'Smileys'),
          Tab(text: 'Gestures'),
          Tab(text: 'Hearts'),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildReactionGrid(_getRecentReactions()),
          _buildReactionGrid(_smileyEmojis),
          _buildReactionGrid(_gestureEmojis),
          _buildReactionGrid(_heartEmojis),
        ],
      ),
    );
  }

  List<String> _getRecentReactions() {
    final recent = widget.recentReactions.isEmpty
        ? _commonReactions
        : widget.recentReactions;

    // Ensure we have enough emojis for a good grid
    if (recent.length < 16) {
      final combined = [...recent];
      for (final emoji in _commonReactions) {
        if (!combined.contains(emoji) && combined.length < 24) {
          combined.add(emoji);
        }
      }
      return combined;
    }
    return recent;
  }

  Widget _buildReactionGrid(List<String> reactions) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
          childAspectRatio: 1,
        ),
        itemCount: reactions.length,
        itemBuilder: (context, index) => _buildReactionButton(reactions[index]),
      ),
    );
  }

  Widget _buildReactionButton(String emoji) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: () => _selectReaction(emoji),
        borderRadius: BorderRadius.circular(12.r),
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        highlightColor: AppColors.primary.withValues(alpha: 0.05),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: widget.isDarkMode
                ? AppColors.darkContainerBorder.withValues(alpha: 0.1)
                : AppColors.gray50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.transparent, width: 1.5),
          ),
          child: Center(
            child: Text(
              emoji,
              style: TextStyle(
                fontSize: 26.sp,
                height: 1.0,
                decoration: TextDecoration.none,
                fontFamilyFallback: const [
                  'Apple Color Emoji',
                  'Segoe UI Emoji',
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectReaction(String emoji) {
    // Add haptic feedback
    HapticFeedback.selectionClick();

    // Call the callback
    widget.onReactionSelected(emoji);

    // Close the picker
    if (mounted) {
      Navigator.pop(context);
    }
  }
}
