import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../../../../domain/models/chat/chat_message.dart';

/// Widget for replying to messages
class ReplyBarWidget extends StatelessWidget {
  const ReplyBarWidget({
    super.key,
    required this.replyingTo,
    required this.onCancelReply,
    required this.isDarkMode,
  });

  final ChatMessage replyingTo;
  final VoidCallback onCancelReply;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkContainerBorder.withOpacity(0.3)
            : AppColors.gray100,
        border: Border(
          top: BorderSide(
            color: isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            PhosphorIcons.arrowBendUpLeft(PhosphorIconsStyle.bold),
            color: AppColors.primary,
            size: 16.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Replying to ${replyingTo.username}',
                  style: AppTypography.geistMedium13.copyWith(
                    color: AppColors.primary,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  _getPreviewText(),
                  style: AppTypography.geistRegular12.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600,
                    fontSize: 12.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onCancelReply,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkContainerBorder.withOpacity(0.4)
                    : AppColors.gray200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                PhosphorIcons.x(PhosphorIconsStyle.bold),
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
                size: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getPreviewText() {
    switch (replyingTo.type) {
      case MessageType.text:
        return replyingTo.content;
      case MessageType.image:
        return '📷 Image';
      case MessageType.video:
        return '🎥 Video';
      case MessageType.audio:
        return '🎵 Audio';
      case MessageType.file:
        return '📎 File';
      case MessageType.sticker:
        return '🏷️ Sticker';
      case MessageType.system:
        return '🔔 System Message';
      case MessageType.nft:
        return '🖼️ NFT: ${replyingTo.sentAsset?.name ?? ""}';
      case MessageType.token:
        return '💰 ${replyingTo.sentAsset?.value ?? ""} ${replyingTo.sentAsset?.name ?? ""}';
      case MessageType.role:
        return '👤 Role: ${replyingTo.sentAsset?.name ?? ""}';
      case MessageType.tag:
        return '🏷️ Tag: ${replyingTo.sentAsset?.name ?? ""}';
    }
  }
}
