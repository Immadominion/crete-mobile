import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../domain/entities/community.dart';

/// Enhanced community card with beautiful design and fluid animations
class EnhancedCommunityCard extends StatefulWidget {
  const EnhancedCommunityCard({
    super.key,
    required this.community,
    required this.onTap,
    required this.isDarkMode,
    this.isJoined = false,
    this.showJoinButton = true,
    this.onJoin,
    this.heroTag,
  });

  final Community community;
  final VoidCallback onTap;
  final bool isDarkMode;
  final bool isJoined;
  final bool showJoinButton;
  final VoidCallback? onJoin;
  final String? heroTag;

  @override
  State<EnhancedCommunityCard> createState() => _EnhancedCommunityCardState();
}

class _EnhancedCommunityCardState extends State<EnhancedCommunityCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });

    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: _buildCardContainer(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardContainer() {
    // Determine if this is "My Community" card (already joined community displayed in grid)
    final bool isMyCommunity = widget.isJoined && !widget.showJoinButton;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: isMyCommunity
                ? AppColors.primary.withOpacity(_isHovered ? 0.2 : 0.1)
                : Colors.black.withOpacity(_isHovered ? 0.15 : 0.08),
            offset: Offset(0, _isHovered ? 8.h : 4.h),
            blurRadius: _isHovered ? 20.r : 12.r,
          ),
        ],
      ),
      child: _buildCardContent(isMyCommunity),
    );
  }

  Widget _buildCardContent(bool isMyCommunity) {
    return Hero(
      tag: widget.heroTag ?? 'community_${widget.community.id}',
      child: Container(
        // Fixed constraints to prevent overflow
        constraints: BoxConstraints(minHeight: isMyCommunity ? 160.h : 180.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: isMyCommunity
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.15),
                    AppColors.primaryLight.withOpacity(0.1),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.isDarkMode
                      ? [AppColors.black, AppColors.black.withOpacity(0.8)]
                      : [Colors.white, Colors.white.withOpacity(0.95)],
                ),
          border: Border.all(
            color: isMyCommunity
                ? AppColors.primary.withOpacity(0.3)
                : (widget.isDarkMode
                      ? AppColors.darkContainerBorder
                      : AppColors.gray200),
            width: isMyCommunity ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Prevent overflow
          children: [
            _buildHeader(isMyCommunity),
            Flexible(
              fit: FlexFit.loose, // Prevent overflow with flexible sizing
              child: _buildContent(isMyCommunity),
            ),
            _buildFooter(isMyCommunity),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMyCommunity) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
        gradient: isMyCommunity
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.25),
                  AppColors.primary.withOpacity(0.15),
                ],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
      ),
      child: Row(
        children: [
          _buildCommunityIcon(isMyCommunity),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.community.name,
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: isMyCommunity
                        ? AppColors.primary
                        : (widget.isDarkMode
                              ? AppColors.darkTextPrimary
                              : AppColors.gray900),
                    fontSize: 16.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.community.description.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    widget.community.description,
                    style: AppTypography.geistRegular12.copyWith(
                      color: widget.isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray600,
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          _buildOnlineIndicator(),
        ],
      ),
    );
  }

  Widget _buildCommunityIcon(bool isMyCommunity) {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isMyCommunity
              ? [AppColors.primary, AppColors.primaryLight]
              : [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(isMyCommunity ? 0.4 : 0.3),
            offset: Offset(0, 4.h),
            blurRadius: 8.r,
          ),
        ],
      ),
      child: widget.community.imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                widget.community.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackIcon();
                },
              ),
            )
          : _buildFallbackIcon(),
    );
  }

  Widget _buildFallbackIcon() {
    return Center(
      child: Text(
        widget.community.name[0].toUpperCase(),
        style: AppTypography.geistSemiBold15.copyWith(
          color: Colors.white,
          fontSize: 20.sp,
        ),
      ),
    );
  }

  Widget _buildOnlineIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.success.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            '${widget.community.onlineCount}',
            style: AppTypography.geistSemiBold15.copyWith(
              color: AppColors.success,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isMyCommunity) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevent overflow
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMemberInfo(isMyCommunity),
          if (widget.community.tags.isNotEmpty && !isMyCommunity) ...[
            SizedBox(height: 12.h),
            _buildTags(),
          ],
          // For My Communities, show a more compact layout
          if (isMyCommunity && widget.community.tags.isNotEmpty) ...[
            SizedBox(height: 8.h),
            _buildCompactTags(),
          ],
        ],
      ),
    );
  }

  Widget _buildMemberInfo(bool isMyCommunity) {
    // Generate some example member avatars
    final memberAvatars = List.generate(
      3,
      (index) => 'https://i.pravatar.cc/150?img=${index + 1}',
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Member avatars stack with fixed width
        Container(
          width: 70.w, // Fixed width container for stack
          height: 32.h,
          child: Stack(
            clipBehavior: Clip.none,
            children: memberAvatars.asMap().entries.map((entry) {
              final index = entry.key;
              final avatar = entry.value;

              return Positioned(
                left: index * 20.w,
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.isDarkMode
                          ? AppColors.darkBackgroundSecondary
                          : Colors.white,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      avatar,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.primary,
                          child: Icon(
                            PhosphorIcons.user(PhosphorIconsStyle.bold),
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Member count with icon
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PhosphorIcon(
              PhosphorIcons.users(),
              size: 14.sp,
              color: isMyCommunity
                  ? AppColors.primary.withOpacity(0.8)
                  : (widget.isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600),
            ),
            SizedBox(width: 4.w),
            Text(
              '${widget.community.memberCount}',
              style: AppTypography.geistSemiBold15.copyWith(
                color: isMyCommunity
                    ? AppColors.primary.withOpacity(0.8)
                    : (widget.isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray600),
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Compact tags for My Communities cards
  Widget _buildCompactTags() {
    return SizedBox(
      height: 22.h, // Smaller height
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widget.community.tags.take(2).map((tag) {
          // Show fewer tags
          return Container(
            margin: EdgeInsets.only(right: 6.w),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              tag,
              style: AppTypography.geistRegular12.copyWith(
                color: AppColors.primary,
                fontSize: 10.sp,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTags() {
    return SizedBox(
      height: 26.h, // Fixed height to prevent layout issues
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widget.community.tags.take(3).map((tag) {
          return Container(
            margin: EdgeInsets.only(right: 6.w),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? AppColors.darkContainerBorder.withOpacity(0.3)
                  : AppColors.gray100,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              tag,
              style: AppTypography.geistRegular12.copyWith(
                color: AppColors.primary,
                fontSize: 10.sp,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMyCommunityContent() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.success.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You are a member of this community',
            style: AppTypography.geistRegular12.copyWith(
              color: AppColors.success,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                PhosphorIcons.check(PhosphorIconsStyle.bold),
                color: AppColors.success,
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                'Active member',
                style: AppTypography.geistSemiBold15.copyWith(
                  color: AppColors.success,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isMyCommunity) {
    if (!widget.showJoinButton) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isMyCommunity ? AppColors.success.withOpacity(0.05) : null,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
          ),
          border: Border(
            top: BorderSide(
              color: isMyCommunity
                  ? AppColors.primary.withOpacity(0.2)
                  : (widget.isDarkMode
                        ? AppColors.darkContainerBorder
                        : AppColors.gray200),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Activity status with different icon for My Communities
            Row(
              children: [
                PhosphorIcon(
                  isMyCommunity
                      ? PhosphorIcons.star(PhosphorIconsStyle.bold)
                      : PhosphorIcons.chartLine(PhosphorIconsStyle.bold),
                  size: 14.sp,
                  color: isMyCommunity
                      ? AppColors.primary
                      : (widget.isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600),
                ),
                SizedBox(width: 4.w),
                Text(
                  isMyCommunity ? 'Featured community' : 'Active community',
                  style: AppTypography.geistRegular12.copyWith(
                    color: isMyCommunity
                        ? AppColors.primary
                        : (widget.isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.gray600),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            // Joined indicator for "My Communities"
            if (widget.isJoined)
              Row(
                children: [
                  Icon(
                    PhosphorIcons.check(PhosphorIconsStyle.bold),
                    color: AppColors.success,
                    size: 14.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Joined',
                    style: AppTypography.geistMedium13.copyWith(
                      color: AppColors.success,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: widget.isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
            width: 1,
          ),
        ),
      ),
      child: widget.isJoined ? _buildJoinedStatus() : _buildJoinButton(),
    );
  }

  Widget _buildJoinButton() {
    return GestureDetector(
      onTap: widget.onJoin,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
          ),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              offset: Offset(0, 2.h),
              blurRadius: 4.r,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIcons.plus(PhosphorIconsStyle.bold),
              color: Colors.white,
              size: 16.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Join Community',
              style: AppTypography.geistSemiBold15.copyWith(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJoinedStatus() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.success.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            PhosphorIcons.check(PhosphorIconsStyle.bold),
            color: AppColors.success,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Text(
            'Joined',
            style: AppTypography.geistSemiBold15.copyWith(
              color: AppColors.success,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
