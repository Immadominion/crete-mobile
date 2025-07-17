import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../domain/entities/community.dart';

enum CommunityCardVariant {
  horizontal, // For My Communities horizontal scrolling
  vertical, // For Discover communities vertical list
  nested, // For sub-communities within a community
}

class CommunityCard extends StatefulWidget {
  final Community community;
  final bool isDarkMode;
  final VoidCallback? onTap;
  final bool showJoinButton;
  final CommunityCardVariant variant;
  final Animation<double>? animation;

  const CommunityCard({
    super.key,
    required this.community,
    required this.isDarkMode,
    this.onTap,
    this.showJoinButton = false,
    this.variant = CommunityCardVariant.horizontal,
    this.animation,
  });

  @override
  State<CommunityCard> createState() => _CommunityCardState();
}

class _CommunityCardState extends State<CommunityCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverAnimationController;
  late Animation<double> _hoverScaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _hoverScaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(
        parent: _hoverAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _hoverAnimationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    if (_isHovered != isHovered) {
      setState(() {
        _isHovered = isHovered;
      });

      if (isHovered) {
        _hoverAnimationController.forward();
      } else {
        _hoverAnimationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _hoverScaleAnimation,
      builder: (context, child) {
        final containerWidget = MouseRegion(
          onEnter: (_) => _onHover(true),
          onExit: (_) => _onHover(false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Transform.scale(
              scale: _hoverScaleAnimation.value,
              child: _buildCardByVariant(),
            ),
          ),
        );

        // Apply external animation if provided
        if (widget.animation != null) {
          return FadeTransition(
            opacity: widget.animation!,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(widget.animation!),
              child: containerWidget,
            ),
          );
        }

        return containerWidget;
      },
    );
  }

  Widget _buildCardByVariant() {
    switch (widget.variant) {
      case CommunityCardVariant.horizontal:
        return _buildHorizontalCard();
      case CommunityCardVariant.vertical:
        return _buildVerticalCard();
      case CommunityCardVariant.nested:
        return _buildNestedCard();
    }
  }

  Widget _buildHorizontalCard() {
    return Container(
      width: 280.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _isHovered && !widget.isDarkMode
              ? AppColors.primary.withOpacity(0.5)
              : widget.isDarkMode
              ? AppColors.darkContainerBorder
              : AppColors.gray200,
          width: _isHovered ? 1.5 : 1,
        ),
        boxShadow: [
          if (_isHovered && !widget.isDarkMode)
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          else if (!widget.isDarkMode)
            BoxShadow(
              color: AppColors.gray900.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildCommunityAvatar(),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.community.name,
                            style: AppTypography.geistSemiBold15.copyWith(
                              color: widget.isDarkMode
                                  ? AppColors.darkTextPrimary
                                  : AppColors.gray900,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.community.unreadCount > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              widget.community.unreadCount.toString(),
                              style: AppTypography.geistMedium11.copyWith(
                                color: AppColors.white,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${widget.community.onlineCount} online • ${widget.community.memberCount} members',
                      style: AppTypography.geistRegular12.copyWith(
                        color: widget.isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: Text(
              widget.community.description,
              style: AppTypography.geistRegular13.copyWith(
                color: widget.isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray700,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 12.h),
          _buildTags(),
        ],
      ),
    );
  }

  Widget _buildVerticalCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _isHovered && !widget.isDarkMode
              ? AppColors.primary.withOpacity(0.5)
              : widget.isDarkMode
              ? AppColors.darkContainerBorder
              : AppColors.gray200,
          width: _isHovered ? 1.5 : 1,
        ),
        boxShadow: [
          if (_isHovered && !widget.isDarkMode)
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          else if (!widget.isDarkMode)
            BoxShadow(
              color: AppColors.gray900.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildCommunityAvatar(),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.community.name,
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: widget.isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.community.description,
                  style: AppTypography.geistRegular13.copyWith(
                    color: widget.isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    _buildSmallTag(
                      '${widget.community.onlineCount} online',
                      PhosphorIcons.circleNotch(PhosphorIconsStyle.regular),
                      Colors.green,
                    ),
                    SizedBox(width: 8.w),
                    _buildSmallTag(
                      '${widget.community.memberCount} members',
                      PhosphorIcons.users(PhosphorIconsStyle.regular),
                      AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (widget.showJoinButton) ...[
            SizedBox(width: 12.w),
            _buildJoinButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildNestedCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: _isHovered && !widget.isDarkMode
              ? AppColors.primary.withOpacity(0.5)
              : widget.isDarkMode
              ? AppColors.darkContainerBorder
              : AppColors.gray200,
          width: _isHovered ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: PhosphorIcon(
                PhosphorIcons.users(PhosphorIconsStyle.regular),
                size: 16.sp,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.community.name,
                  style: AppTypography.geistMedium15.copyWith(
                    color: widget.isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  '${widget.community.onlineCount} online • ${widget.community.memberCount} members',
                  style: AppTypography.geistRegular11.copyWith(
                    color: widget.isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (widget.community.unreadCount > 0)
            Container(
              width: 18.w,
              height: 18.w,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.community.unreadCount.toString(),
                  style: AppTypography.geistMedium11.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommunityAvatar() {
    if (widget.community.imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Image.network(
          widget.community.imageUrl!,
          width: 48.w,
          height: 48.w,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: PhosphorIcon(
          PhosphorIcons.users(PhosphorIconsStyle.bold),
          color: AppColors.white,
          size: 24.sp,
        ),
      ),
    );
  }

  Widget _buildTags() {
    return SizedBox(
      height: 24.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.community.tags.length > 3
            ? 3
            : widget.community.tags.length,
        separatorBuilder: (context, index) => SizedBox(width: 6.w),
        itemBuilder: (context, index) {
          final tag = widget.community.tags[index];
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              '#$tag',
              style: AppTypography.geistMedium11.copyWith(
                color: AppColors.primary,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSmallTag(String text, PhosphorIconData iconData, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PhosphorIcon(iconData, size: 12.sp, color: color),
        SizedBox(width: 4.w),
        Text(
          text,
          style: AppTypography.geistRegular11.copyWith(
            color: widget.isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.gray600,
          ),
        ),
      ],
    );
  }

  Widget _buildJoinButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PhosphorIcon(
            PhosphorIcons.plus(PhosphorIconsStyle.bold),
            size: 14.sp,
            color: AppColors.white,
          ),
          SizedBox(width: 4.w),
          Text(
            'Join',
            style: AppTypography.geistMedium13.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
