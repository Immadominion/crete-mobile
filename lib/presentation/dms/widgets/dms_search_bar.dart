import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

/// Animated search bar for DMS with enhanced functionality
class DMSSearchBar extends StatelessWidget {
  const DMSSearchBar({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.searchFocusNode,
  });
  final bool isSearching;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isSearching ? 46.h : 0,
      margin: EdgeInsets.only(bottom: isSearching ? 20.h : 0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isSearching ? 1.0 : 0.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.darkIconBackground : AppColors.gray50,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isDarkMode
                  ? AppColors.darkContainerBorder
                  : AppColors.gray200,
            ),
          ),
          child: Row(
            children: [
              Icon(
                PhosphorIcons.magnifyingGlass(),
                size: 20.sp,
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray500,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  // Vertically center the text when borders are removed
                  textAlignVertical: TextAlignVertical.center,
                  controller: searchController,
                  focusNode: searchFocusNode,
                  style: AppTypography.geistRegular14.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search conversations, people...',
                    hintStyle: AppTypography.geistRegular14.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray500,
                    ),
                    border: InputBorder.none,
                    isDense: true, // reduce default padding
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              if (searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: () => searchController.clear(),
                  child: Icon(
                    PhosphorIcons.x(),
                    size: 18.sp,
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray500,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
