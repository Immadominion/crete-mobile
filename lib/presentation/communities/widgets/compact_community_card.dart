import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/data/dao_ui_demo_data.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../domain/entities/community.dart';

/// A compact, horizontally scrollable community card for the "My Communities" section
/// Featuring status indicators for unread messages, active voice calls, and ongoing events
class CompactCommunityCard extends StatefulWidget {
  const CompactCommunityCard({
    super.key,
    required this.community,
    required this.onTap,
    required this.isDarkMode,
    this.hasUnreadMessages = false,
    this.hasActiveVoiceCall = false,
    this.hasOngoingEvent = false,
    this.heroTag,
  });

  final Community community;
  final VoidCallback onTap;
  final bool isDarkMode;
  final bool hasUnreadMessages;
  final bool hasActiveVoiceCall;
  final bool hasOngoingEvent;
  final String? heroTag;

  @override
  State<CompactCommunityCard> createState() => _CompactCommunityCardState();
}

class _CompactCommunityCardState extends State<CompactCommunityCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.015).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOutCubic),
      ),
    );

    _pulseAnimation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(begin: 1.0, end: 1.02),
            weight: 1.0,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 1.02, end: 0.98),
            weight: 1.0,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.98, end: 1.015),
            weight: 1.0,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 1.015, end: 1.0),
            weight: 1.0,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    // Just do a single bounce for voice calls instead of continuous animation
    if (widget.hasActiveVoiceCall) {
      // Add post-frame callback to avoid animation during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // Do a single bounce animation
          _animationController.forward().then((_) {
            // Optional: Do a second bounce after a delay
            Future.delayed(const Duration(milliseconds: 1200), () {
              if (mounted) {
                // Second bounce animation
                _animationController.forward(from: 0).then((_) {
                  // Stop after the second bounce
                  _animationController.reset();
                });
              }
            });
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    if (mounted) {
      setState(() {
        _isHovered = isHovered;
      });

      if (isHovered) {
        if (!widget.hasActiveVoiceCall) {
          _animationController.forward();
        }
      } else {
        if (!widget.hasActiveVoiceCall) {
          _animationController.reverse();
        }
      }
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
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: widget.hasActiveVoiceCall
                  ? _pulseAnimation.value
                  : (_isHovered ? _scaleAnimation.value : 1.0),
              child: _buildCard(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard() {
    final Color statusColor = _getStatusColor();

    return Hero(
      tag: widget.heroTag ?? 'community_${widget.community.id}',
      // Outer container with colored border and padding
      child: Container(
        width: 120.w, // Slightly wider to account for padding
        height: 145.h, // Increased height to avoid overflow
        margin: EdgeInsets.only(right: 10.w, top: 4.h, bottom: 4.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: statusColor.withOpacity(0.8), width: 2.5),
          boxShadow: [
            BoxShadow(
              color: statusColor.withOpacity(0.2),
              blurRadius: _isHovered ? 10.r : 6.r,
              spreadRadius: 1.r,
              offset: Offset(0, _isHovered ? 3.h : 1.h),
            ),
          ],
        ),
        // Inner card with padding to create space between card and border
        child: Container(
          margin: EdgeInsets.all(
            4.r,
          ), // Creates the space between card and border
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: widget.isDarkMode
                ? AppColors.darkBackgroundSecondary
                : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.12 : 0.06),
                blurRadius: _isHovered ? 6.r : 3.r,
                offset: Offset(0, _isHovered ? 2.h : 1.h),
              ),
            ],
          ),
          child: Column(
            children: [
              Flexible(flex: 7, child: _buildCommunityImage()),
              Flexible(flex: 2, child: _buildStatusFooter()),
            ],
          ),
        ),
      ),
    );
  }

  // Status color is now only used for the outer border/glow

  Color _getStatusColor() {
    if (widget.hasUnreadMessages) {
      return AppColors.info;
    } else if (widget.hasActiveVoiceCall) {
      return AppColors.success;
    } else if (widget.hasOngoingEvent) {
      return AppColors.warning;
    }
    return AppColors.primary;
  }

  Widget _buildCommunityImage() {
    // Get image URL from DAO UI demo data if community image is null
    String? imageUrl = widget.community.imageUrl;

    // Try to use DAO demo data for image based on community ID
    final int? communityIdInt = int.tryParse(widget.community.id);
    if ((imageUrl == null || imageUrl.isEmpty) && communityIdInt != null) {
      // Use the community ID to find corresponding DAO image (1-based index)
      final int daoIndex = communityIdInt - 1;
      if (daoIndex >= 0 && daoIndex < DaoUiDemoData.myDaos.length) {
        // Use DAO image URL
        imageUrl = DaoUiDemoData.myDaos[daoIndex].imageUrl;
      }
    }

    return DecoratedBox(
      // Let the Flexible parent handle sizing
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
        color: widget.isDarkMode
            ? AppColors.darkBackgroundSecondary
            : Colors.white,
      ),
      child: Stack(
        children: [
          // Square image taking full width
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r),
              topRight: Radius.circular(10.r),
            ),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildFallbackIcon();
                    },
                  )
                : _buildFallbackIcon(),
          ),

          // Online indicator in top right of image - left aligned
          Positioned(
            top: 6.h,
            left: 6.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5.w,
                    height: 5.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    '${widget.community.onlineCount}',
                    style: AppTypography.geistRegular12.copyWith(
                      color: Colors.white,
                      fontSize: 9.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Community name overlay at the bottom - left aligned
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                _getDisplayName(),
                style: AppTypography.geistSemiBold15.copyWith(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackIcon() {
    // Get name from DAO UI demo data if needed
    String displayName = widget.community.name;
    final int? communityIdInt = int.tryParse(widget.community.id);
    if (communityIdInt != null) {
      // Use the community ID to find corresponding DAO name (1-based index)
      final int daoIndex = communityIdInt - 1;
      if (daoIndex >= 0 && daoIndex < DaoUiDemoData.myDaos.length) {
        displayName = DaoUiDemoData.myDaos[daoIndex].name;
      }
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_getStatusColor(), _getStatusColor().withOpacity(0.7)],
        ),
      ),
      child: Center(
        child: Text(
          displayName.isNotEmpty ? displayName[0].toUpperCase() : 'C',
          style: AppTypography.geistSemiBold15.copyWith(
            color: Colors.white,
            fontSize: 24.sp,
          ),
        ),
      ),
    );
  }

  // Community info is now shown directly in the image section

  Widget _buildStatusFooter() {
    Widget statusWidget;
    final Color statusColor = _getStatusColor();

    if (widget.hasUnreadMessages) {
      statusWidget = _buildStatusIndicator(
        PhosphorIcons.chatsCircle(PhosphorIconsStyle.fill),
        '${widget.community.unreadCount}',
        AppColors.info,
      );
    } else if (widget.hasActiveVoiceCall) {
      statusWidget = _buildStatusIndicator(
        PhosphorIcons.speakerHigh(PhosphorIconsStyle.fill),
        'Call',
        AppColors.success,
      );
    } else if (widget.hasOngoingEvent) {
      statusWidget = _buildStatusIndicator(
        PhosphorIcons.calendar(PhosphorIconsStyle.fill),
        'Event',
        AppColors.warning,
      );
    } else {
      statusWidget = _buildStatusIndicator(
        PhosphorIcons.users(PhosphorIconsStyle.fill),
        '${widget.community.memberCount}',
        statusColor,
      );
    }

    return DecoratedBox(
      // Let the Flexible parent handle sizing
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? Colors.black.withOpacity(0.1)
            : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
        ),
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.15)),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: Align(alignment: Alignment.centerLeft, child: statusWidget),
      ),
    );
  }

  Widget _buildStatusIndicator(
    PhosphorIconData icon,
    String label,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PhosphorIcon(icon, size: 18.sp, color: color),
        SizedBox(width: 3.w),
        Text(
          label,
          style: AppTypography.geistMedium13.copyWith(
            color: color,
            fontSize: 13.sp,
          ),
        ),
      ],
    );
  }

  String _getDisplayName() {
    // Get name from DAO UI demo data if needed
    String displayName = widget.community.name;
    final int? communityIdInt = int.tryParse(widget.community.id);
    if (communityIdInt != null) {
      // Use the community ID to find corresponding DAO name (1-based index)
      final int daoIndex = communityIdInt - 1;
      if (daoIndex >= 0 && daoIndex < DaoUiDemoData.myDaos.length) {
        displayName = DaoUiDemoData.myDaos[daoIndex].name;
      }
    }
    return displayName;
  }
}
