import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

class CommunitiesSearchBar extends StatefulWidget {
  const CommunitiesSearchBar({
    super.key,
    this.hintText,
    this.onChanged,
    this.onTap,
    this.onFilterTap,
    this.enabled = true,
  });
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;
  final bool enabled;

  @override
  State<CommunitiesSearchBar> createState() => _CommunitiesSearchBarState();
}

class _CommunitiesSearchBarState extends State<CommunitiesSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: AppColors.gray900.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: widget.enabled,
              onChanged: widget.onChanged,
              onTap: widget.onTap,
              style: AppTypography.geistRegular14.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'Search communities...',
                hintStyle: AppTypography.geistRegular14.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.gray500,
                ),
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: PhosphorIcon(
                    PhosphorIcons.magnifyingGlass(),
                    size: 20.sp,
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray500,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
              ),
            ),
          ),
          if (widget.onFilterTap != null)
            GestureDetector(
              onTap: widget.onFilterTap,
              child: Container(
                margin: EdgeInsets.only(right: 8.w),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: PhosphorIcon(
                  PhosphorIcons.funnelSimple(),
                  size: 16.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
