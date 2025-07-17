import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

/// Sticker picker widget for chat
class StickerPickerWidget extends StatefulWidget {
  final void Function(String) onStickerSelected;
  final bool isDarkMode;

  const StickerPickerWidget({
    super.key,
    required this.onStickerSelected,
    required this.isDarkMode,
  });

  @override
  State<StickerPickerWidget> createState() => _StickerPickerWidgetState();
}

class _StickerPickerWidgetState extends State<StickerPickerWidget> {
  int _selectedPack = 0;

  final List<Map<String, dynamic>> _stickerPacks = [
    {
      'name': 'Crypto Vibes',
      'icon': '💎',
      'stickers': ['🚀', '💎', '🔥', '📈', '📉', '💰', '🌙', '⭐', '🎯', '🏆'],
    },
    {
      'name': 'Emotions',
      'icon': '😍',
      'stickers': ['😍', '🥰', '😘', '🤗', '🤩', '😎', '🤯', '😴', '🥳', '😂'],
    },
    {
      'name': 'Animals',
      'icon': '🐶',
      'stickers': ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼', '🐨', '🐯'],
    },
    {
      'name': 'Food',
      'icon': '🍕',
      'stickers': ['🍕', '🍔', '🍟', '🌭', '🥪', '🌮', '🌯', '🍜', '🍱', '🍣'],
    },
    {
      'name': 'Activities',
      'icon': '🎮',
      'stickers': ['🎮', '🎯', '🎲', '🎨', '🎭', '🎪', '🎸', '🎤', '🎧', '📱'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.h,
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
                  'Stickers',
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: widget.isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                    fontSize: 18.sp,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Close sticker picker
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
          // Sticker packs
          Container(
            height: 60.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _stickerPacks.length,
              itemBuilder: (context, index) {
                final pack = _stickerPacks[index];
                final isSelected = _selectedPack == index;

                return GestureDetector(
                  onTap: () => setState(() => _selectedPack = index),
                  child: Container(
                    width: 60.w,
                    margin: EdgeInsets.only(right: 8.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.1)
                          : (widget.isDarkMode
                                ? AppColors.darkContainerBorder.withOpacity(0.3)
                                : AppColors.gray100),
                      borderRadius: BorderRadius.circular(12.r),
                      border: isSelected
                          ? Border.all(color: AppColors.primary, width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          pack['icon'] as String,
                          style: TextStyle(fontSize: 24.sp),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          pack['name'] as String,
                          style: AppTypography.geistMedium11.copyWith(
                            color: isSelected
                                ? AppColors.primary
                                : (widget.isDarkMode
                                      ? AppColors.darkTextSecondary
                                      : AppColors.gray600),
                            fontSize: 8.sp,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
          // Stickers grid
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16.h,
                  crossAxisSpacing: 16.w,
                ),
                itemCount:
                    (_stickerPacks[_selectedPack]['stickers'] as List).length,
                itemBuilder: (context, index) {
                  final sticker =
                      (_stickerPacks[_selectedPack]['stickers'] as List)[index]
                          as String;
                  return GestureDetector(
                    onTap: () => widget.onStickerSelected(sticker),
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.isDarkMode
                            ? AppColors.darkContainerBorder.withOpacity(0.3)
                            : AppColors.gray100,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Text(sticker, style: TextStyle(fontSize: 48.sp)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
