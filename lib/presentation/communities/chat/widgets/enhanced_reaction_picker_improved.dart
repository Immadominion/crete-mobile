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
              margin: EdgeInsets.all(16.w),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: 480.h,
              ),
              decoration: BoxDecoration(
                color: widget.isDarkMode
                    ? AppColors.darkBackgroundSecondary
                    : AppColors.white,
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(
                  color: widget.isDarkMode
                      ? AppColors.darkContainerBorder.withOpacity(0.2)
                      : AppColors.gray200.withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.isDarkMode
                        ? AppColors.black.withOpacity(0.3)
                        : AppColors.gray900.withOpacity(0.1),
                    offset: Offset(0, 16.h),
                    blurRadius: 32.r,
                    spreadRadius: -4,
                  ),
                  BoxShadow(
                    color: widget.isDarkMode
                        ? AppColors.black.withOpacity(0.2)
                        : AppColors.gray600.withOpacity(0.05),
                    offset: Offset(0, 4.h),
                    blurRadius: 8.r,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [_buildHeader(), _buildTabBar(), _buildTabBarView()],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 20.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: widget.isDarkMode
                ? AppColors.darkContainerBorder.withOpacity(0.2)
                : AppColors.gray200.withOpacity(0.4),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  PhosphorIcons.smiley(PhosphorIconsStyle.bold),
                  size: 16.sp,
                  color: AppColors.primary,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Add Reaction',
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: AppColors.primary,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: widget.isDarkMode
                    ? AppColors.darkIconBackground.withOpacity(0.3)
                    : AppColors.gray100,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: widget.isDarkMode
                      ? AppColors.darkContainerBorder.withOpacity(0.2)
                      : AppColors.gray200.withOpacity(0.5),
                ),
              ),
              child: Icon(
                PhosphorIcons.x(PhosphorIconsStyle.bold),
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
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: widget.isDarkMode
              ? AppColors.darkIconBackground.withOpacity(0.2)
              : AppColors.gray100.withOpacity(0.8),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: widget.isDarkMode
                ? AppColors.darkContainerBorder.withOpacity(0.1)
                : AppColors.gray200.withOpacity(0.3),
          ),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: AppColors.white,
          unselectedLabelColor: widget.isDarkMode
              ? AppColors.darkTextSecondary
              : AppColors.gray600,
          labelStyle: AppTypography.geistSemiBold13.copyWith(
            fontSize: 8.sp,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTypography.geistMedium13.copyWith(
            fontSize: 8.sp,
            fontWeight: FontWeight.w500,
          ),
          tabs: [
            Tab(
              icon: Icon(
                PhosphorIcons.clockClockwise(PhosphorIconsStyle.bold),
                size: 18.sp,
              ),
              text: 'Recent',
            ),
            Tab(
              icon: Icon(
                PhosphorIcons.smiley(PhosphorIconsStyle.bold),
                size: 18.sp,
              ),
              text: 'Smileys',
            ),
            Tab(
              icon: Icon(
                PhosphorIcons.handWaving(PhosphorIconsStyle.bold),
                size: 18.sp,
              ),
              text: 'Hands',
            ),
            Tab(
              icon: Icon(
                PhosphorIcons.heart(PhosphorIconsStyle.bold),
                size: 18.sp,
              ),
              text: 'Hearts',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBarView() {
    return SizedBox(
      height: 300.h, // Fixed height instead of Expanded
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
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6, // Reduced from 8 to 6 for better spacing
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
        ),
        itemCount: reactions.length,
        itemBuilder: (context, index) => _buildReactionButton(reactions[index]),
      ),
    );
  }

  Widget _buildReactionButton(String emoji) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: () => _selectReaction(emoji),
        borderRadius: BorderRadius.circular(16.r),
        splashColor: AppColors.primary.withOpacity(0.1),
        highlightColor: AppColors.primary.withOpacity(0.05),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: widget.isDarkMode
                ? AppColors.darkIconBackground.withOpacity(0.3)
                : AppColors.gray50,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: widget.isDarkMode
                  ? AppColors.darkContainerBorder.withOpacity(0.2)
                  : AppColors.gray200.withOpacity(0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: widget.isDarkMode
                    ? AppColors.black.withOpacity(0.1)
                    : AppColors.gray400.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Center(
            child: Text(
              emoji,
              style: TextStyle(
                fontSize: 24.sp,
                height: 1.0,
                decoration: TextDecoration.none,
                fontFamilyFallback: const [
                  'Apple Color Emoji',
                  'Segoe UI Emoji',
                  'Noto Color Emoji',
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
