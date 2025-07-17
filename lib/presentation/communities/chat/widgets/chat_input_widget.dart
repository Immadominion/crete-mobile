import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';
import '../models/chat_models.dart';

/// Advanced chat input widget with multiple features
class ChatInputWidget extends StatefulWidget {

  const ChatInputWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.replyingTo,
    required this.onSendMessage,
    required this.onSendVoiceMessage,
    required this.onAttachmentTap,
    required this.onEmojiTap,
    required this.onStickerTap,
    required this.onGifTap,
    required this.onGameTap,
    required this.onThreadTap,
    required this.onCancelReply,
    required this.isDarkMode,
  });
  final TextEditingController controller;
  final FocusNode focusNode;
  final ChatMessage? replyingTo;
  final void Function(String) onSendMessage;
  final void Function(String) onSendVoiceMessage;
  final VoidCallback onAttachmentTap;
  final VoidCallback onEmojiTap;
  final VoidCallback onStickerTap;
  final VoidCallback onGifTap;
  final VoidCallback onGameTap;
  final VoidCallback onThreadTap;
  final VoidCallback onCancelReply;
  final bool isDarkMode;

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  bool _isRecording = false;
  bool _showQuickActions = false;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? AppColors.darkBackgroundPrimary
            : AppColors.backgroundPrimary,
        border: Border(
          top: BorderSide(
            color: widget.isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray200,
          ),
        ),
      ),
      child: Column(
        children: [
          // Reply indicator
          if (widget.replyingTo != null)
            _buildReplyIndicator(),
          // Quick actions
          if (_showQuickActions)
            _buildQuickActions(),
          // Main input area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildReplyIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? AppColors.darkBackgroundSecondary
            : AppColors.gray100,
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
          Icon(
            PhosphorIcons.arrowBendUpLeft(),
            size: 16.sp,
            color: widget.isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.gray600,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Replying to ${widget.replyingTo!.displayName}',
                  style: AppTypography.geistMedium13.copyWith(
                    color: widget.isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                  ),
                ),
                Text(
                  widget.replyingTo!.content,
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
          GestureDetector(
            onTap: widget.onCancelReply,
            child: Icon(
              PhosphorIcons.x(),
              size: 16.sp,
              color: widget.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? AppColors.darkBackgroundSecondary
            : AppColors.gray50,
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
          _buildQuickActionButton(
            PhosphorIcons.paperclip(),
            'Attach',
            widget.onAttachmentTap,
          ),
          SizedBox(width: 16.w),
          _buildQuickActionButton(
            PhosphorIcons.smiley(),
            'Emoji',
            widget.onEmojiTap,
          ),
          SizedBox(width: 16.w),
          _buildQuickActionButton(
            PhosphorIcons.sticker(),
            'Sticker',
            widget.onStickerTap,
          ),
          SizedBox(width: 16.w),
          _buildQuickActionButton(
            PhosphorIcons.gameController(),
            'Game',
            widget.onGameTap,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    PhosphorIconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: widget.isDarkMode
                  ? AppColors.darkBackgroundPrimary
                  : AppColors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: widget.isDarkMode
                    ? AppColors.darkContainerBorder
                    : AppColors.gray200,
              ),
            ),
            child: Icon(
              icon,
              size: 20.sp,
              color: widget.isDarkMode
                  ? AppColors.darkTextPrimary
                  : AppColors.gray700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTypography.geistRegular11.copyWith(
              color: widget.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          // Quick actions toggle
          GestureDetector(
            onTap: () => setState(() => _showQuickActions = !_showQuickActions),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: _showQuickActions
                    ? AppColors.primary.withOpacity(0.1)
                    : (widget.isDarkMode
                        ? AppColors.darkBackgroundSecondary
                        : AppColors.gray100),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                _showQuickActions ? PhosphorIcons.minus() : PhosphorIcons.plus(),
                size: 20.sp,
                color: _showQuickActions
                    ? AppColors.primary
                    : (widget.isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray700),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Text input
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: widget.isDarkMode
                    ? AppColors.darkBackgroundSecondary
                    : AppColors.white,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: widget.isDarkMode
                      ? AppColors.darkContainerBorder
                      : AppColors.gray200,
                ),
              ),
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                style: AppTypography.geistRegular14.copyWith(
                  color: widget.isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: AppTypography.geistRegular14.copyWith(
                    color: widget.isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray500,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                maxLines: 3,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // Voice/Send button
          GestureDetector(
            onTap: () {
              if (widget.controller.text.trim().isNotEmpty) {
                widget.onSendMessage(widget.controller.text.trim());
              }
            },
            onLongPress: () {
              setState(() => _isRecording = true);
              // Handle voice recording
            },
            onLongPressUp: () {
              setState(() => _isRecording = false);
              // Handle voice recording end
            },
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: _isRecording
                    ? AppColors.error
                    : (widget.controller.text.trim().isNotEmpty
                        ? AppColors.primary
                        : (widget.isDarkMode
                            ? AppColors.darkBackgroundSecondary
                            : AppColors.gray100)),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Icon(
                _isRecording
                    ? PhosphorIcons.stop()
                    : (widget.controller.text.trim().isNotEmpty
                        ? PhosphorIcons.paperPlaneTilt()
                        : PhosphorIcons.microphone()),
                size: 20.sp,
                color: _isRecording || widget.controller.text.trim().isNotEmpty
                    ? AppColors.white
                    : (widget.isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
