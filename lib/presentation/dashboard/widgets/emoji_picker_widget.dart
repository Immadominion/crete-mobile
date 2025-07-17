import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

/// Emoji picker widget for chat
class EmojiPickerWidget extends StatefulWidget {

  const EmojiPickerWidget({
    super.key,
    required this.onEmojiSelected,
    required this.isDarkMode,
  });
  final void Function(String) onEmojiSelected;
  final bool isDarkMode;

  @override
  State<EmojiPickerWidget> createState() => _EmojiPickerWidgetState();
}

class _EmojiPickerWidgetState extends State<EmojiPickerWidget> {
  int _selectedCategory = 0;

  final List<Map<String, dynamic>> _emojiCategories = [
    {
      'name': 'Recent',
      'icon': PhosphorIcons.clockClockwise(PhosphorIconsStyle.bold),
      'emojis': ['😀', '😂', '🥰', '😊', '🤔', '👍', '❤️', '🔥', '🎉', '👏'],
    },
    {
      'name': 'Smileys',
      'icon': PhosphorIcons.smiley(PhosphorIconsStyle.bold),
      'emojis': [
        '😀',
        '😃',
        '😄',
        '😁',
        '😆',
        '😅',
        '😂',
        '🤣',
        '🥲',
        '😊',
        '😇',
        '🙂',
        '🙃',
        '😉',
        '😌',
        '😍',
        '🥰',
        '😘',
        '😗',
        '😙',
        '😚',
        '😋',
        '😛',
        '😝',
        '😜',
        '🤪',
        '🤨',
        '🧐',
        '🤓',
        '😎',
        '🥸',
        '🤩',
        '🥳',
        '😏',
        '😒',
        '😞',
        '😔',
        '😟',
        '😕',
        '🙁',
      ],
    },
    {
      'name': 'Gestures',
      'icon': PhosphorIcons.handWaving(PhosphorIconsStyle.bold),
      'emojis': [
        '👋',
        '🤚',
        '🖐️',
        '✋',
        '🖖',
        '👌',
        '🤌',
        '🤏',
        '✌️',
        '🤞',
        '🤟',
        '🤘',
        '🤙',
        '👈',
        '👉',
        '👆',
        '🖕',
        '👇',
        '☝️',
        '👍',
        '👎',
        '👊',
        '✊',
        '🤛',
        '🤜',
        '👏',
        '🙌',
        '👐',
        '🤲',
        '🤝',
        '🙏',
        '✍️',
        '💅',
        '🤳',
        '💪',
        '🦾',
        '🦿',
        '🦵',
        '🦶',
        '👂',
      ],
    },
    {
      'name': 'Objects',
      'icon': PhosphorIcons.lightbulb(PhosphorIconsStyle.bold),
      'emojis': [
        '🔥',
        '💧',
        '🌟',
        '⭐',
        '💫',
        '✨',
        '⚡',
        '💥',
        '💢',
        '💨',
        '💤',
        '🕳️',
        '🎉',
        '🎊',
        '🎈',
        '🎁',
        '🎀',
        '🎗️',
        '🎟️',
        '🎫',
        '🔮',
        '🎭',
        '🎨',
        '🎬',
        '🎤',
        '🎧',
        '🎼',
        '🎵',
        '🎶',
        '🎺',
        '🎸',
        '🎹',
        '🥁',
        '🎲',
        '🎯',
        '🎳',
        '🎮',
        '🕹️',
        '🎰',
        '🧩',
      ],
    },
    {
      'name': 'Symbols',
      'icon': PhosphorIcons.heart(PhosphorIconsStyle.bold),
      'emojis': [
        '❤️',
        '🧡',
        '💛',
        '💚',
        '💙',
        '💜',
        '🖤',
        '🤍',
        '🤎',
        '💔',
        '❣️',
        '💕',
        '💞',
        '💓',
        '💗',
        '💖',
        '💘',
        '💝',
        '💟',
        '☮️',
        '✝️',
        '☪️',
        '🕉️',
        '☸️',
        '✡️',
        '🔯',
        '🕎',
        '☯️',
        '☦️',
        '🛐',
        '⛎',
        '♈',
        '♉',
        '♊',
        '♋',
        '♌',
        '♍',
        '♎',
        '♏',
        '♐',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      decoration: BoxDecoration(
        color: widget.isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        border: Border.all(
          color: widget.isDarkMode
              ? AppColors.darkContainerBorder
              : AppColors.gray200,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Emoji',
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: widget.isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                    fontSize: 18.sp,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Close emoji picker
                  },
                  child: Icon(
                    PhosphorIcons.x(PhosphorIconsStyle.bold),
                    color: widget.isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600,
                    size: 20.sp,
                  ),
                ),
              ],
            ),
          ),
          // Category tabs
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: _emojiCategories.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                final isSelected = _selectedCategory == index;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCategory = index),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        category['icon'] as PhosphorIconData,
                        color: isSelected
                            ? AppColors.primary
                            : (widget.isDarkMode
                                  ? AppColors.darkTextSecondary
                                  : AppColors.gray600),
                        size: 20.sp,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Emoji grid
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  mainAxisSpacing: 8.h,
                  crossAxisSpacing: 8.w,
                ),
                itemCount:
                    (_emojiCategories[_selectedCategory]['emojis'] as List)
                        .length,
                itemBuilder: (context, index) {
                  final emoji =
                      (_emojiCategories[_selectedCategory]['emojis']
                              as List)[index]
                          as String;
                  return GestureDetector(
                    onTap: () => widget.onEmojiSelected(emoji),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: widget.isDarkMode
                            ? AppColors.darkContainerBorder.withOpacity(0.3)
                            : AppColors.gray100,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(emoji, style: TextStyle(fontSize: 24.sp)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
