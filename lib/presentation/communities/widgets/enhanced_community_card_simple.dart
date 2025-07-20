import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../domain/entities/community.dart';

/// Enhanced community card with beautiful design and simple animations
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

class _EnhancedCommunityCardState extends State<EnhancedCommunityCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.15 : 0.08),
                offset: Offset(0, _isHovered ? 8.h : 4.h),
                blurRadius: _isHovered ? 20.r : 12.r,
              ),
            ],
          ),
          child: _buildCardContent(),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return Hero(
      tag: widget.heroTag ?? 'community_${widget.community.id}',
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.isDarkMode
                ? [
                    AppColors.darkBackgroundSecondary,
                    AppColors.darkBackgroundSecondary.withOpacity(0.8),
                  ]
                : [Colors.white, Colors.white.withOpacity(0.95)],
          ),
          border: Border.all(
            color: widget.isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildHeader(), _buildContent(), _buildFooter()],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
        ),
      ),
      child: Row(
        children: [
          _buildCommunityIcon(),
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

  Widget _buildCommunityIcon() {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
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
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
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

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMemberInfo(),
          if (widget.community.tags.isNotEmpty) ...[
            SizedBox(height: 12.h),
            _buildTags(),
          ],
        ],
      ),
    );
  }

  Widget _buildMemberInfo() {
    // Generate some example member avatars
    final memberAvatars = List.generate(
      3,
      (index) => 'https://i.pravatar.cc/150?img=${index + 1}',
    );

    return Row(
      children: [
        // Member avatars stack
        SizedBox(
          height: 32.h,
          child: Stack(
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
                        return ColoredBox(
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
        SizedBox(width: 80.w), // Space for stacked avatars
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.community.memberCount} members',
                style: AppTypography.geistSemiBold15.copyWith(
                  color: widget.isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                  fontSize: 13.sp,
                ),
              ),
              Text(
                'Active community',
                style: AppTypography.geistRegular12.copyWith(
                  color: widget.isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.gray600,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 6.w,
      runSpacing: 6.h,
      children: widget.community.tags.take(3).map((tag) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: widget.isDarkMode
                ? AppColors.darkContainerBorder.withOpacity(0.3)
                : AppColors.gray100,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
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
    );
  }

  Widget _buildFooter() {
    if (!widget.showJoinButton) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: widget.isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
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
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
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
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
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
