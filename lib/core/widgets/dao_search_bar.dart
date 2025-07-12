import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// Modular search bar widget for DAO search functionality
class DaoSearchBar extends StatefulWidget {
  const DaoSearchBar({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.hintText = 'Search DAOs by name or SNS...',
  });

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;

  @override
  State<DaoSearchBar> createState() => _DaoSearchBarState();
}

class _DaoSearchBarState extends State<DaoSearchBar> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define border colors based on focus state
    final borderColor = _isFocused
        ? AppColors.primary
        : isDarkMode
        ? AppColors.gray600
        : AppColors.gray200;

    return Container(
      height: 42.55.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: borderColor, width: 1.sp),
      ),
      child: Row(
        children: [
          SizedBox(width: AppSpacing.md.w),
          Icon(
            PhosphorIcons.magnifyingGlass(),
            color: isDarkMode ? AppColors.darkTextHeading : AppColors.gray400,
            size: 22.5.sp,
          ),
          SizedBox(width: AppSpacing.tn.w),
          Expanded(
            child: TextField(
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              style: AppTypography.geistRegular14.copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.gray900,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTypography.geistRegular14.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextHeading
                      : AppColors.gray400,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
        ],
      ),
    );
  }
}
