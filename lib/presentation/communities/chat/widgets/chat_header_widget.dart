import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../models/chat_models.dart';

/// Production-level chat header widget with online status, member avatars, and actions
class ChatHeaderWidget extends StatefulWidget {
  final String channelName;
  final String? channelDescription;
  final int onlineCount;
  final List<ChatParticipant> onlineMembers;
  final VoidCallback? onVoiceCall;
  final VoidCallback? onVideoCall;
  final VoidCallback? onShowMembers;
  final VoidCallback? onSearch;
  final VoidCallback? onMoreOptions;
  final bool? isDarkMode;

  const ChatHeaderWidget({
    super.key,
    required this.channelName,
    this.channelDescription,
    required this.onlineCount,
    required this.onlineMembers,
    this.onVoiceCall,
    this.onVideoCall,
    this.onShowMembers,
    this.onSearch,
    this.onMoreOptions,
    this.isDarkMode,
  });

  @override
  State<ChatHeaderWidget> createState() => _ChatHeaderWidgetState();
}

class _ChatHeaderWidgetState extends State<ChatHeaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        widget.isDarkMode ?? Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.white,
        border: Border(
          bottom: BorderSide(
            color: isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: (isDarkMode ? AppColors.black : AppColors.gray900)
                .withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Row(
          children: [
            // Back button
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                PhosphorIcons.arrowLeft(PhosphorIconsStyle.bold),
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
                size: 20.sp,
              ),
            ),

            SizedBox(width: 8.w),

            // Channel info
            Expanded(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Channel type icon
                        Container(
                          width: 18.w,
                          height: 18.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Icon(
                            PhosphorIcons.hash(PhosphorIconsStyle.bold),
                            color: AppColors.primary,
                            size: 12.sp,
                          ),
                        ),

                        SizedBox(width: 8.w),

                        // Channel name
                        Expanded(
                          child: Text(
                            widget.channelName,
                            style: AppTypography.geistMedium16.copyWith(
                              color: isDarkMode
                                  ? AppColors.darkTextPrimary
                                  : AppColors.gray900,
                              fontSize: 16.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Online count and description
                    Row(
                      children: [
                        // Online indicator
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),

                        SizedBox(width: 6.w),

                        // Online count
                        Text(
                          '${widget.onlineCount} online',
                          style: AppTypography.geistRegular12.copyWith(
                            color: isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.gray600,
                            fontSize: 12.sp,
                          ),
                        ),

                        if (widget.channelDescription != null &&
                            widget.channelDescription!.isNotEmpty) ...[
                          SizedBox(width: 8.w),

                          // Separator
                          Container(
                            width: 2.w,
                            height: 2.w,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : AppColors.gray400,
                              borderRadius: BorderRadius.circular(1.r),
                            ),
                          ),

                          SizedBox(width: 8.w),

                          // Description
                          Expanded(
                            child: Text(
                              widget.channelDescription!,
                              style: AppTypography.geistRegular12.copyWith(
                                color: isDarkMode
                                    ? AppColors.darkTextSecondary
                                    : AppColors.gray600,
                                fontSize: 12.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Online member avatars
            if (widget.onlineMembers.isNotEmpty) ...[
              SizedBox(width: 12.w),
              _buildMemberAvatars(isDarkMode),
            ],

            SizedBox(width: 12.w),

            // Action buttons
            _buildActionButtons(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberAvatars(bool isDarkMode) {
    final displayMembers = widget.onlineMembers.take(3).toList();

    return Row(
      children: [
        // Member avatars stack
        SizedBox(
          width: (displayMembers.length * 16.w) + 8.w,
          height: 24.h,
          child: Stack(
            children: displayMembers.asMap().entries.map((entry) {
              final index = entry.key;
              final member = entry.value;

              return Positioned(
                left: index * 16.w,
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isDarkMode
                          ? AppColors.darkBackgroundSecondary
                          : AppColors.white,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Stack(
                      children: [
                        // Avatar image
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: member.avatar.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Image.network(
                                    member.avatar,
                                    width: 20.w,
                                    height: 20.w,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            _buildDefaultAvatar(
                                              member.displayName,
                                            ),
                                  ),
                                )
                              : _buildDefaultAvatar(member.displayName),
                        ),

                        // Online status indicator
                        if (member.status == UserStatus.online)
                          Positioned(
                            right: -1,
                            bottom: -1,
                            child: Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(4.r),
                                border: Border.all(
                                  color: isDarkMode
                                      ? AppColors.darkBackgroundSecondary
                                      : AppColors.white,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // More members indicator
        if (widget.onlineMembers.length > 3) ...[
          SizedBox(width: 4.w),
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.darkContainerBorder
                  : AppColors.gray200,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                '+${widget.onlineMembers.length - 3}',
                style: AppTypography.geistRegular12.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.gray600,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDefaultAvatar(String name) {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: AppTypography.geistRegular12.copyWith(
            color: AppColors.primary,
            fontSize: 10.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isDarkMode) {
    return Row(
      children: [
        // Voice call button
        _buildActionButton(
          icon: PhosphorIcons.phone(PhosphorIconsStyle.bold),
          onPressed: widget.onVoiceCall,
          tooltip: 'Voice call',
          isDarkMode: isDarkMode,
        ),

        SizedBox(width: 4.w),

        // Video call button
        _buildActionButton(
          icon: PhosphorIcons.videoCamera(PhosphorIconsStyle.bold),
          onPressed: widget.onVideoCall,
          tooltip: 'Video call',
          isDarkMode: isDarkMode,
        ),

        SizedBox(width: 4.w),

        // Members button
        _buildActionButton(
          icon: PhosphorIcons.users(PhosphorIconsStyle.bold),
          onPressed: widget.onShowMembers,
          tooltip: 'Show members',
          isDarkMode: isDarkMode,
        ),

        SizedBox(width: 4.w),

        // Search button
        _buildActionButton(
          icon: PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.bold),
          onPressed: widget.onSearch,
          tooltip: 'Search messages',
          isDarkMode: isDarkMode,
        ),

        SizedBox(width: 4.w),

        // More options button
        _buildActionButton(
          icon: PhosphorIcons.dotsThreeVertical(PhosphorIconsStyle.bold),
          onPressed: widget.onMoreOptions,
          tooltip: 'More options',
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
    required bool isDarkMode,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6.r),
          onTap: onPressed,
          child: Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.r)),
            child: Icon(
              icon,
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
              size: 18.sp,
            ),
          ),
        ),
      ),
    );
  }
}
