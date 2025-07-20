import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';

/// Enhanced online members sidebar with rich animations and user status
class EnhancedOnlineMembersSidebar extends StatefulWidget {
  const EnhancedOnlineMembersSidebar({
    super.key,
    required this.onlineMembers,
    required this.isDarkMode,
    required this.onMemberTap,
    this.isVisible = false,
  });

  final List<OnlineMember> onlineMembers;
  final bool isDarkMode;
  final bool isVisible;
  final void Function(OnlineMember) onMemberTap;

  @override
  State<EnhancedOnlineMembersSidebar> createState() =>
      _EnhancedOnlineMembersSidebarState();
}

class _EnhancedOnlineMembersSidebarState
    extends State<EnhancedOnlineMembersSidebar>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

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

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(EnhancedOnlineMembersSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _slideController.forward();
        _fadeController.forward();
      } else {
        _slideController.reverse();
        _fadeController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: 280.w,
          height: double.infinity,
          decoration: BoxDecoration(
            color: widget.isDarkMode
                ? AppColors.darkBackgroundSecondary
                : AppColors.backgroundSecondary,
            border: Border(
              left: BorderSide(
                color: widget.isDarkMode
                    ? AppColors.darkContainerBorder
                    : AppColors.gray200,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: Offset(-2.w, 0),
                blurRadius: 8.r,
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildMembersList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final onlineCount = widget.onlineMembers.where((m) => m.isOnline).length;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: widget.isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  '$onlineCount Online',
                  style: AppTypography.geistMedium13.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // Close sidebar
              setState(() {
                // Trigger close animation
              });
            },
            icon: Icon(
              PhosphorIcons.x(PhosphorIconsStyle.bold),
              size: 20.sp,
              color: widget.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersList() {
    // Group members by status
    final onlineMembers = widget.onlineMembers
        .where((m) => m.isOnline)
        .toList();
    final offlineMembers = widget.onlineMembers
        .where((m) => !m.isOnline)
        .toList();

    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      children: [
        if (onlineMembers.isNotEmpty) ...[
          _buildStatusSection('Online', onlineMembers),
          SizedBox(height: 16.h),
        ],
        if (offlineMembers.isNotEmpty)
          _buildStatusSection('Offline', offlineMembers),
      ],
    );
  }

  Widget _buildStatusSection(String title, List<OnlineMember> members) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            '$title — ${members.length}',
            style: AppTypography.geistSemiBold13.copyWith(
              color: widget.isDarkMode
                  ? AppColors.darkTextHeading
                  : AppColors.gray700,
              fontSize: 11.sp,
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        ...members.map((member) => _buildMemberItem(member)),
      ],
    );
  }

  Widget _buildMemberItem(OnlineMember member) {
    return InkWell(
      onTap: () => widget.onMemberTap(member),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            // Avatar with status indicator
            Stack(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.isDarkMode
                          ? AppColors.darkContainerBorder
                          : AppColors.gray200,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: member.avatar.isNotEmpty
                        ? Image.network(
                            member.avatar,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildAvatarFallback(member);
                            },
                          )
                        : _buildAvatarFallback(member),
                  ),
                ),
                // Status indicator
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: _getStatusColor(member.status),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isDarkMode
                            ? AppColors.black
                            : Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(width: 12.w),

            // Member info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          member.displayName,
                          style: AppTypography.geistMedium13.copyWith(
                            color: widget.isDarkMode
                                ? AppColors.darkTextPrimary
                                : AppColors.gray900,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (member.role.isNotEmpty) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: _getRoleColor(member.role).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            member.role,
                            style: AppTypography.geistMedium11.copyWith(
                              color: _getRoleColor(member.role),
                              fontSize: 9.sp,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (member.customStatus.isNotEmpty)
                    Text(
                      member.customStatus,
                      style: AppTypography.geistRegular11.copyWith(
                        color: widget.isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600,
                        fontSize: 10.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            // Activity indicator
            if (member.activity.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  _getActivityIcon(member.activity),
                  size: 12.sp,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarFallback(OnlineMember member) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          member.displayName[0].toUpperCase(),
          style: AppTypography.geistSemiBold15.copyWith(
            color: Colors.white,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(MemberStatus status) {
    switch (status) {
      case MemberStatus.online:
        return AppColors.secondary;
      case MemberStatus.idle:
        return AppColors.warning;
      case MemberStatus.doNotDisturb:
        return AppColors.error;
      case MemberStatus.offline:
        return AppColors.gray400;
    }
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return AppColors.error;
      case 'moderator':
        return AppColors.primary;
      case 'member':
        return AppColors.secondary;
      default:
        return AppColors.gray600;
    }
  }

  PhosphorIconData _getActivityIcon(String activity) {
    switch (activity.toLowerCase()) {
      case 'voice':
        return PhosphorIcons.microphone(PhosphorIconsStyle.fill);
      case 'streaming':
        return PhosphorIcons.monitor(PhosphorIconsStyle.fill);
      case 'gaming':
        return PhosphorIcons.gameController(PhosphorIconsStyle.fill);
      default:
        return PhosphorIcons.pulse(PhosphorIconsStyle.fill);
    }
  }
}

// Data models for online members
class OnlineMember {
  const OnlineMember({
    required this.id,
    required this.displayName,
    required this.avatar,
    required this.status,
    required this.isOnline,
    this.role = '',
    this.customStatus = '',
    this.activity = '',
  });

  final String id;
  final String displayName;
  final String avatar;
  final MemberStatus status;
  final bool isOnline;
  final String role;
  final String customStatus;
  final String activity;
}

enum MemberStatus { online, idle, doNotDisturb, offline }
