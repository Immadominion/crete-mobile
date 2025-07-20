import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';

/// Enhanced chat input widget with rich features and beautiful animations
class EnhancedChatInput extends StatefulWidget {
  const EnhancedChatInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSendMessage,
    required this.onAttachmentTap,
    required this.onEmojiTap,
    required this.onStickerTap,
    required this.isDarkMode,
    this.hintText = 'Type a message...',
    this.replyingTo,
    this.onCancelReply,
    this.onMentionTap,
    this.onTagTap,
    this.onRoleTap,
    this.onNftTap,
    this.onTokenTap,
    this.isTyping = false,
    this.typingUsers = const [],
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSendMessage;
  final VoidCallback onAttachmentTap;
  final VoidCallback onEmojiTap;
  final VoidCallback onStickerTap;
  final bool isDarkMode;
  final String hintText;
  final String? replyingTo;
  final VoidCallback? onCancelReply;
  final VoidCallback? onMentionTap;
  final VoidCallback? onTagTap;
  final VoidCallback? onRoleTap;
  final VoidCallback? onNftTap;
  final VoidCallback? onTokenTap;
  final bool isTyping;
  final List<String> typingUsers;

  @override
  State<EnhancedChatInput> createState() => _EnhancedChatInputState();
}

class _EnhancedChatInputState extends State<EnhancedChatInput>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _focusAnimation;

  bool _hasText = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupListeners();
  }

  void _initializeAnimations() {
    // Single animation controller for all animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _focusAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _setupListeners() {
    widget.controller.addListener(_onTextChanged);
    widget.focusNode.addListener(_onFocusChanged);
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
      if (hasText) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _onFocusChanged() {
    final isFocused = widget.focusNode.hasFocus;
    if (isFocused != _isFocused) {
      setState(() {
        _isFocused = isFocused;
      });
      if (isFocused) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void didUpdateWidget(EnhancedChatInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Animation updates would go here in a more complex implementation
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
          // Typing indicator
          _buildTypingIndicator(),

          // Reply bar
          _buildReplyBar(),

          // Main input section
          _buildInputSection(),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    if (widget.typingUsers.isEmpty) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          _buildTypingDots(),
          SizedBox(width: 8.w),
          Text(
            _getTypingText(),
            style: AppTypography.geistRegular12.copyWith(
              color: widget.isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDots() {
    return Row(
      children: List.generate(3, (index) {
        return Container(
          width: 6.w,
          height: 6.w,
          margin: EdgeInsets.only(right: index < 2 ? 2.w : 0),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  String _getTypingText() {
    if (widget.typingUsers.length == 1) {
      return '${widget.typingUsers.first} is typing...';
    } else if (widget.typingUsers.length == 2) {
      return '${widget.typingUsers.first} and ${widget.typingUsers.last} are typing...';
    } else {
      return 'Several people are typing...';
    }
  }

  Widget _buildReplyBar() {
    if (widget.replyingTo == null) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? AppColors.darkContainerBorder.withOpacity(0.3)
            : AppColors.gray100,
        border: Border(
          left: BorderSide(color: AppColors.primary, width: 4.w),
        ),
      ),
      child: Row(
        children: [
          Icon(
            PhosphorIcons.arrowBendUpLeft(PhosphorIconsStyle.bold),
            size: 16.sp,
            color: AppColors.primary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Replying to',
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: AppColors.primary,
                    fontSize: 12.sp,
                  ),
                ),
                Text(
                  widget.replyingTo!,
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
            ),
          ),
          GestureDetector(
            onTap: widget.onCancelReply,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: widget.isDarkMode
                    ? AppColors.darkTextSecondary.withOpacity(0.2)
                    : AppColors.gray300,
                shape: BoxShape.circle,
              ),
              child: Icon(
                PhosphorIcons.x(PhosphorIconsStyle.bold),
                size: 14.sp,
                color: widget.isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return AnimatedBuilder(
      animation: _focusAnimation,
      builder: (context, child) {
        return Container(
          // Reduced padding for more chat space
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Column(
            children: [
              // Quick actions (shown when focused)
              if (_isFocused) _buildQuickActions(),
              if (_isFocused) SizedBox(height: 10.h),

              // Input row
              _buildInputRow(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return FadeTransition(
      opacity: _focusAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, -0.5),
          end: Offset.zero,
        ).animate(_focusAnimation),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildQuickActionButton(
                PhosphorIcons.paperclip(PhosphorIconsStyle.bold),
                'Attach File',
                widget.onAttachmentTap,
              ),
              SizedBox(width: 10.w),
              _buildQuickActionButton(
                PhosphorIcons.smiley(PhosphorIconsStyle.bold),
                'Emoji',
                widget.onEmojiTap,
              ),
              SizedBox(width: 10.w),
              _buildQuickActionButton(
                PhosphorIcons.sticker(PhosphorIconsStyle.bold),
                'Sticker',
                widget.onStickerTap,
              ),
              if (widget.onMentionTap != null) ...[
                SizedBox(width: 10.w),
                _buildQuickActionButton(
                  PhosphorIcons.at(PhosphorIconsStyle.bold),
                  'Mention',
                  widget.onMentionTap!,
                ),
              ],
              if (widget.onTagTap != null) ...[
                SizedBox(width: 10.w),
                _buildQuickActionButton(
                  PhosphorIcons.tag(PhosphorIconsStyle.bold),
                  'Tag',
                  widget.onTagTap!,
                ),
              ],
              if (widget.onRoleTap != null) ...[
                SizedBox(width: 10.w),
                _buildQuickActionButton(
                  PhosphorIcons.user(PhosphorIconsStyle.bold),
                  'Role',
                  widget.onRoleTap!,
                ),
              ],
              if (widget.onNftTap != null) ...[
                SizedBox(width: 10.w),
                _buildQuickActionButton(
                  PhosphorIcons.image(PhosphorIconsStyle.bold),
                  'NFT',
                  widget.onNftTap!,
                ),
              ],
              if (widget.onTokenTap != null) ...[
                SizedBox(width: 10.w),
                _buildQuickActionButton(
                  PhosphorIcons.coins(PhosphorIconsStyle.bold),
                  'Token',
                  widget.onTokenTap!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    PhosphorIconData icon,
    String tooltip,
    VoidCallback onTap,
  ) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: widget.isDarkMode
                ? AppColors.darkContainerBorder.withOpacity(0.3)
                : AppColors.gray100,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            color: widget.isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.gray600,
            size: 20.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow() {
    return Row(
      children: [
        // Text input
        Expanded(child: _buildTextInput()),

        SizedBox(width: 12.w),

        // Send button
        _buildSendButton(),
      ],
    );
  }

  Widget _buildTextInput() {
    return AnimatedBuilder(
      animation: _focusAnimation,
      builder: (context, child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: widget.isDarkMode
                ? AppColors.darkContainerBorder.withOpacity(0.3)
                : AppColors.gray100,
            borderRadius: BorderRadius.circular(_isFocused ? 16.r : 20.r),
            border: Border.all(
              color: _isFocused
                  ? AppColors.primary.withOpacity(0.5)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            style: AppTypography.geistRegular13.copyWith(
              color: widget.isDarkMode
                  ? AppColors.darkTextPrimary
                  : AppColors.gray900,
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTypography.geistRegular13.copyWith(
                color: widget.isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray600,
                fontSize: 14.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                // Reduced horizontal padding
                horizontal: 12.w,
                vertical: 12.h,
              ),
              isDense: true, // Make the input more compact
            ),
            maxLines: _isFocused ? 6 : 1,
            minLines: 1,
            textInputAction: TextInputAction.newline,
            onSubmitted: (_) {
              if (_hasText) {
                widget.onSendMessage();
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildSendButton() {
    return AnimatedScale(
      scale: _hasText ? 1.0 : 0.9,
      duration: const Duration(milliseconds: 150),
      child: GestureDetector(
        onTap: _hasText ? widget.onSendMessage : null,
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            gradient: _hasText
                ? LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: _hasText
                ? null
                : widget.isDarkMode
                ? AppColors.darkContainerBorder
                : AppColors.gray300,
            shape: BoxShape.circle,
            boxShadow: _hasText
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      offset: Offset(0, 4.h),
                      blurRadius: 12.r,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            PhosphorIcons.paperPlaneTilt(PhosphorIconsStyle.bold),
            color: _hasText
                ? Colors.white
                : widget.isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.gray600,
            size: 18.sp,
          ),
        ),
      ),
    );
  }
}
