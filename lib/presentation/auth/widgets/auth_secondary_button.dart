import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

class AuthSecondaryButton extends StatelessWidget {
  const AuthSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.iconPath,
    this.isLoading = false,
    this.width,
    this.height,
  });

  final String text;
  final VoidCallback? onPressed;
  final String? iconPath;
  final bool isLoading;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 293.w,
      height: height ?? 45.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.discordButtonBackground,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 12.h),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (iconPath != null) ...[
                    SvgPicture.asset(iconPath!, width: 20.w, height: 20.h),
                    SizedBox(width: 8.w),
                  ],
                  Text(
                    text,
                    style: AppTypography.geistMedium16.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
