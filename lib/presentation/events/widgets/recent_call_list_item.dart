import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:crete/core/theme/colors.dart';
import 'package:crete/core/theme/typography.dart';

enum CallType { incoming, outgoing, missed }

class RecentCallListItem extends StatelessWidget {
  final String name;
  final CallType callType;
  final String time;

  const RecentCallListItem({
    super.key,
    required this.name,
    required this.callType,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: CircleAvatar(
        radius: 24.r,
        backgroundColor: AppColors.primary.withOpacity(0.1),
        child: Text(
          name.substring(0, 1),
          style: AppTypography.geistSemiBold15.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
      title: Text(
        name,
        style: AppTypography.geistMedium16.copyWith(
          color: isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900,
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            _getCallTypeIcon(callType),
            size: 16.sp,
            color: _getCallTypeColor(callType, isDarkMode),
          ),
          SizedBox(width: 4.w),
          Text(
            _getCallTypeString(callType),
            style: AppTypography.geistRegular13.copyWith(
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray600,
            ),
          ),
        ],
      ),
      trailing: Text(
        time,
        style: AppTypography.geistRegular13.copyWith(
          color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
        ),
      ),
      onTap: () {
        // Handle call back
      },
    );
  }

  IconData _getCallTypeIcon(CallType type) {
    switch (type) {
      case CallType.incoming:
        return PhosphorIcons.arrowDownLeft(PhosphorIconsStyle.bold);
      case CallType.outgoing:
        return PhosphorIcons.arrowUpRight(PhosphorIconsStyle.bold);
      case CallType.missed:
        return PhosphorIcons.phoneSlash(PhosphorIconsStyle.bold);
    }
  }

  Color _getCallTypeColor(CallType type, bool isDarkMode) {
    switch (type) {
      case CallType.incoming:
        return AppColors.success;
      case CallType.outgoing:
        return AppColors.info;
      case CallType.missed:
        return AppColors.error;
    }
  }

  String _getCallTypeString(CallType type) {
    switch (type) {
      case CallType.incoming:
        return 'Incoming';
      case CallType.outgoing:
        return 'Outgoing';
      case CallType.missed:
        return 'Missed';
    }
  }
}
