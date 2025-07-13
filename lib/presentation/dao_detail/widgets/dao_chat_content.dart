import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/models/ui/dao_chat_message_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

class DaoChatContent extends StatelessWidget {
  const DaoChatContent({super.key, required this.messages});

  final List<DaoChatMessageModel> messages;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListView.separated(
      padding: EdgeInsets.only(
        left: AppSpacing.md.w,
        right: AppSpacing.md.w,
        top: 20.h,
      ),
      itemCount: messages.length,
      separatorBuilder: (context, index) => SizedBox(height: 24.h),
      itemBuilder: (context, index) {
        final message = messages[index];
        return _buildMessageCard(message, isDarkMode);
      },
    );
  }

  Widget _buildMessageCard(DaoChatMessageModel message, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          children: [
            // User avatar
            Container(
              width: 24.28.w,
              height: 24.28.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDarkMode
                      ? AppColors.darkContainerBorder
                      : AppColors.gray200,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: Image.network(
                  message.userAvatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: AppColors.primary);
                  },
                ),
              ),
            ),

            SizedBox(width: AppSpacing.sm.w),

            // Username container
            Container(
              height: 25.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.gray800 : AppColors.gray200,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Center(
                child: Text(
                  message.userName,
                  style: AppTypography.geistRegular15.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                    letterSpacing: -0.6.sp,
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Verification badge
            if (message.isVerified)
              SvgPicture.asset(
                'assets/icons/svgs/Badge.svg',
                width: 12.w,
                height: 11.43.h,
              ),
          ],
        ),

        SizedBox(height: AppSpacing.sm.h),

        // Message container
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.gray800 : AppColors.gray100,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            message.message,
            style: AppTypography.geistRegular11.copyWith(
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
              letterSpacing: -0.5.sp,
              height: 1.0.h,
            ),
          ),
        ),

        SizedBox(height: AppSpacing.sm.h),

        // Reactions row
        Row(
          children: message.reactions.map((reaction) {
            return Padding(
              padding: EdgeInsets.only(right: AppSpacing.sm.w),
              child: Row(
                children: [
                  Icon(
                    _getReactionIcon(reaction.type),
                    size: 16.07.sp,
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    _formatReactionCount(reaction.count),
                    style: AppTypography.geistRegular12.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray600,
                      letterSpacing: -0.48.sp,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),

        SizedBox(height: 12.h),

        // Divider
        Container(
          height: 1.h,
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
      ],
    );
  }

  IconData _getReactionIcon(ReactionType type) {
    switch (type) {
      case ReactionType.heart:
        return PhosphorIcons.heart();
      case ReactionType.chat:
        return PhosphorIcons.chatCircleText();
      case ReactionType.smile:
        return PhosphorIcons.smiley();
    }
  }

  String _formatReactionCount(int count) {
    if (count < 1000) {
      return count.toString();
    } else if (count < 1000000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    } else {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
  }
}
