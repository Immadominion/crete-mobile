import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

/// Quick action chips for common DMS actions
class DMSQuickActions extends StatelessWidget {
  const DMSQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 20.w),
          _buildQuickActionChip(
            'Voice Rooms',
            PhosphorIcons.waveform(),
            AppColors.secondary,
            isDarkMode,
            onTap: () => _showActiveVoiceRooms(),
          ),
          SizedBox(width: 12.w),
          _buildQuickActionChip(
            'Calls',
            PhosphorIcons.phone(),
            Colors.green,
            isDarkMode,
            onTap: () => _showCallHistory(),
          ),
          SizedBox(width: 12.w),
          _buildQuickActionChip(
            'Archived',
            PhosphorIcons.archive(),
            Colors.orange,
            isDarkMode,
            onTap: () => _showArchivedChats(),
          ),
          SizedBox(width: 12.w),
          _buildQuickActionChip(
            'Requests',
            PhosphorIcons.userPlus(),
            Colors.blue,
            isDarkMode,
            badge: 2,
            onTap: () => _showChatRequests(),
          ),
          SizedBox(width: 20.w),
        ],
      ),
    );
  }

  Widget _buildQuickActionChip(
    String label,
    IconData icon,
    Color color,
    bool isDarkMode, {
    VoidCallback? onTap,
    int? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Icon(icon, size: 16.sp, color: color),
                if (badge != null)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12.w,
                        minHeight: 12.h,
                      ),
                      child: Text(
                        badge.toString(),
                        style: AppTypography.geistSemiBold15.copyWith(
                          color: AppColors.white,
                          fontSize: 8.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: AppTypography.geistMedium13.copyWith(
                color: color,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showActiveVoiceRooms() {
    // TODO: Implement voice rooms
    print('Show active voice rooms');
  }

  void _showCallHistory() {
    // TODO: Implement call history
    print('Show call history');
  }

  void _showArchivedChats() {
    // TODO: Implement archived chats
    print('Show archived chats');
  }

  void _showChatRequests() {
    // TODO: Implement chat requests
    print('Show chat requests');
  }
}
