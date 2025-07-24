import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

/// Enhanced chat card widget for displaying individual conversations
class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.username,
    required this.message,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
    required this.isTyping,
    required this.onTap,
    this.isGroup = false,
    this.memberCount,
    this.hasReaction = false,
    this.hasAttachment = false,
    this.isPinned = false,
    this.hasNftGift = false,
  });
  final String username;
  final String message;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final bool isTyping;
  final bool isGroup;
  final int? memberCount;
  final bool hasReaction;
  final bool hasAttachment;
  final bool isPinned;
  final bool hasNftGift;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 12.h),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkIconBackground : AppColors.white,
          borderRadius: isGroup
              ? BorderRadius.circular(16.r)
              : BorderRadius.circular(24.r),
          border: Border.all(
            color: isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
          ),
        ),
        child: Row(
          children: [
            _buildAvatar(isDarkMode),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderRow(isDarkMode),
                  SizedBox(height: 6.h),
                  _buildMessageRow(isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(bool isDarkMode) {
    return Stack(
      children: [
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.secondary, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: isGroup ? BoxShape.rectangle : BoxShape.circle,
            borderRadius: isGroup ? BorderRadius.circular(8.r) : null,
          ),
          child: Center(
            child: isGroup
                ? Icon(
                    Icons.group_outlined,
                    color: AppColors.white,
                    size: 20.sp,
                  )
                : Text(
                    username[0].toUpperCase(),
                    style: AppTypography.geistSemiBold15.copyWith(
                      color: AppColors.white,
                      fontSize: 18.sp,
                    ),
                  ),
          ),
        ),
        if (isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 14.w,
              height: 14.h,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: !isDarkMode
                      ? AppColors.darkIconBackground
                      : AppColors.white,
                  width: 2.w,
                ),
              ),
            ),
          ),
        if (isPinned)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: const BoxDecoration(
                color: Colors.amber,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.push_pin, size: 10.sp, color: AppColors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildHeaderRow(bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  username,
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                    fontSize: 16.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (memberCount != null) ...[
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$memberCount',
                    style: AppTypography.geistMedium11.copyWith(
                      color: AppColors.secondary,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Text(
          time,
          style: AppTypography.geistRegular11.copyWith(
            color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray500,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageRow(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              if (hasAttachment)
                Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: Icon(
                    Icons.attach_file,
                    size: 12.sp,
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray500,
                  ),
                ),
              if (hasNftGift)
                Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: Icon(
                    Icons.card_giftcard,
                    size: 12.sp,
                    color: Colors.purple,
                  ),
                ),
              Flexible(
                child: Text(
                  isTyping ? '$username is typing...' : message,
                  style: AppTypography.geistRegular12.copyWith(
                    color: isTyping
                        ? AppColors.primary
                        : (isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.gray600),
                    fontSize: 13.sp,
                    fontStyle: isTyping ? FontStyle.italic : FontStyle.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 3.w),
        Row(
          children: [
            if (hasReaction)
              Container(
                margin: EdgeInsets.only(right: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text('👍', style: TextStyle(fontSize: 10.sp)),
              ),
            if (unreadCount > 0)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(50.r),
                ),
                constraints: BoxConstraints(minWidth: 20.w),
                child: Text(
                  unreadCount > 99 ? '99+' : unreadCount.toString(),
                  style: AppTypography.geistMedium11.copyWith(
                    color: AppColors.white,
                    fontSize: 10.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
