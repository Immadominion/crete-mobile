import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A widget that creates proper spacing between message groups
/// for a more visually appealing chat interface
class MessageGroupSpacer extends StatelessWidget {
  const MessageGroupSpacer({
    super.key,
    this.isStartOfGroup = false,
    this.isEndOfGroup = false,
    this.isConsecutive = false,
    this.showDateDivider = false,
    this.dateText,
  });

  final bool isStartOfGroup;
  final bool isEndOfGroup;
  final bool isConsecutive;
  final bool showDateDivider;
  final String? dateText;

  @override
  Widget build(BuildContext context) {
    // Determine spacing based on message position in group
    if (showDateDivider && dateText != null) {
      return _buildDateDivider(dateText!);
    }

    // Start of new group after another group
    if (isStartOfGroup && !isConsecutive) {
      return SizedBox(height: 16.h);
    }

    // Consecutive messages within the same group
    if (isConsecutive) {
      return SizedBox(
        height: 1.h,
      ); // Even tighter spacing for consecutive messages
    }

    // Default spacing
    return SizedBox(height: 8.h);
  }

  Widget _buildDateDivider(String date) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: Colors.grey.withOpacity(0.4), thickness: 1.h),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              date,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Divider(color: Colors.grey.withOpacity(0.4), thickness: 1.h),
          ),
        ],
      ),
    );
  }
}
