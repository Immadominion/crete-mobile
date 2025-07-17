import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/typography.dart';



/// Attachment options dialog for chat
class AttachmentOptionsDialog extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onFile;
  final VoidCallback onVideo;
  final VoidCallback onAudio;

  const AttachmentOptionsDialog({
    super.key,
    required this.isDarkMode,
    required this.onCamera,
    required this.onGallery,
    required this.onFile,
    required this.onVideo,
    required this.onAudio,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            width: 32.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray400,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Share Content',
            style: AppTypography.geistSemiBold15.copyWith(
              color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 24.h),
          // Options grid
          GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildOption(
                icon: PhosphorIcons.camera(PhosphorIconsStyle.bold),
                label: 'Camera',
                color: Colors.blue,
                onTap: onCamera,
              ),
              _buildOption(
                icon: PhosphorIcons.image(PhosphorIconsStyle.bold),
                label: 'Gallery',
                color: Colors.purple,
                onTap: onGallery,
              ),
              _buildOption(
                icon: PhosphorIcons.file(PhosphorIconsStyle.bold),
                label: 'File',
                color: Colors.orange,
                onTap: onFile,
              ),
              _buildOption(
                icon: PhosphorIcons.videoCamera(PhosphorIconsStyle.bold),
                label: 'Video',
                color: Colors.red,
                onTap: onVideo,
              ),
              _buildOption(
                icon: PhosphorIcons.microphone(PhosphorIconsStyle.bold),
                label: 'Audio',
                color: Colors.green,
                onTap: onAudio,
              ),
              _buildOption(
                icon: PhosphorIcons.mapPin(PhosphorIconsStyle.bold),
                label: 'Location',
                color: Colors.teal,
                onTap: () {
                  // Handle location sharing
                },
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildOption({
    required PhosphorIconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: AppTypography.geistMedium13.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray700,
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
