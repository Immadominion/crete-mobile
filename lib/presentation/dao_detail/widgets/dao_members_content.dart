import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/models/ui/dao_governance_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

class DaoMembersContent extends StatelessWidget {
  const DaoMembersContent({super.key, required this.members});

  final List<DaoMemberModel> members;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListView.separated(
      padding: EdgeInsets.all(AppSpacing.md.w),
      itemCount: members.length,
      separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md.h),
      itemBuilder: (context, index) {
        final member = members[index];
        return _buildMemberCard(member, isDarkMode);
      },
    );
  }

  Widget _buildMemberCard(DaoMemberModel member, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
      ),
      child: Row(
        children: [
          // Member avatar
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDarkMode
                    ? AppColors.darkContainerBorder
                    : AppColors.gray200,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: Image.network(
                member.avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return ColoredBox(
                    color: AppColors.primary,
                    child: Icon(
                      Icons.person,
                      color: AppColors.white,
                      size: 20.sp,
                    ),
                  );
                },
              ),
            ),
          ),

          SizedBox(width: AppSpacing.md.w),

          // Member info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.name,
                      style: AppTypography.geistSemiBold15.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextPrimary
                            : AppColors.gray900,
                      ),
                    ),
                    if (member.isVerified) ...[
                      SizedBox(width: AppSpacing.xs.w),
                      Icon(
                        Icons.verified,
                        size: 16.sp,
                        color: AppColors.primary,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  'Joined ${_formatDate(member.joinedAt)}',
                  style: AppTypography.geistRegular12.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return 'Recently';
    }
  }
}
