import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

class AuthTextButton extends StatelessWidget {
  const AuthTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
  });

  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: width ?? 121.w,
      height: height ?? 21.h,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
          style: AppTypography.signInGuestText.copyWith(
            fontSize: 16.sp,
            color: isDarkMode ? AppColors.darkTextPrimary : AppColors.white,
          ),
        ),
      ),
    );
  }
}
