import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';

/// Advanced reaction picker with beautiful design and animations
class EnhancedReactionPicker extends StatefulWidget {
  const EnhancedReactionPicker({
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
  State<EnhancedReactionPicker> createState() => _EnhancedReactionPickerState();
}

class _EnhancedReactionPickerState extends State<EnhancedReactionPicker>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

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

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Start animations
    _slideController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _scaleController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5)),
        child: Center(
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                constraints: BoxConstraints(maxWidth: 360.w, maxHeight: 450.h),
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: widget.isDarkMode
                      ? AppColors.darkBackgroundPrimary
                      : AppColors.backgroundPrimary,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: widget.isDarkMode
                        ? AppColors.darkContainerBorder.withValues(alpha: 0.3)
                        : AppColors.gray200.withValues(alpha: 0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: widget.isDarkMode ? 0.4 : 0.15,
                      ),
                      offset: Offset(0, 8.h),
                      blurRadius: 24.r,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    Flexible(child: _buildReactionGrid()),
                  ],
                ),
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
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
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

  Widget _buildReactionGrid() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent reactions section
          if (widget.recentReactions.isNotEmpty) ...[
            _buildSectionHeader('Recent'),
            SizedBox(height: 12.h),
            _buildReactionRow(widget.recentReactions.take(6).toList()),
            SizedBox(height: 20.h),
          ],

          // Common reactions section
          _buildSectionHeader('Popular'),
          SizedBox(height: 12.h),
          _buildReactionGridWithData(_commonReactions),

          // Custom emojis section
          if (widget.customEmojis.isNotEmpty) ...[
            SizedBox(height: 20.h),
            _buildSectionHeader('Custom'),
            SizedBox(height: 12.h),
            _buildReactionGridWithData(widget.customEmojis),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.geistSemiBold13.copyWith(
        color: widget.isDarkMode
            ? AppColors.darkTextHeading
            : AppColors.gray700,
        fontSize: 13.sp,
        letterSpacing: 0.5,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildReactionRow(List<String> reactions) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: reactions
            .map((reaction) => _buildReactionButton(reaction))
            .toList(),
      ),
    );
  }

  Widget _buildReactionGridWithData(List<String> reactions) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: reactions.length,
      itemBuilder: (context, index) => _buildReactionButton(reactions[index]),
    );
  }

  Widget _buildReactionButton(String emoji) {
    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 150),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: () => _selectReaction(emoji),
          borderRadius: BorderRadius.circular(12.r),
          splashColor: AppColors.primary.withValues(alpha: 0.1),
          highlightColor: AppColors.primary.withValues(alpha: 0.05),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? AppColors.darkContainerBorder.withValues(alpha: 0.15)
                  : AppColors.gray50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.transparent, width: 1.5),
            ),
            child: Center(
              child: Text(
                emoji,
                style: TextStyle(
                  fontSize: 28.sp,
                  height: 1.0,
                  decoration: TextDecoration.none,
                ),
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
