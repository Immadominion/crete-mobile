import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/models/ui/dao_governance_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';

class DaoGovernanceContent extends StatefulWidget {
  const DaoGovernanceContent({super.key, required this.proposals});

  final List<DaoGovernanceProposalModel> proposals;

  @override
  State<DaoGovernanceContent> createState() => _DaoGovernanceContentState();
}

class _DaoGovernanceContentState extends State<DaoGovernanceContent> {
  final List<String> _filterTabs = ['All', 'Active', 'Ended', 'My Votes'];
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter tags
        Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.md.w,
            right: AppSpacing.md.w,
            top: 17.h,
          ),
          child: Row(
            children: _filterTabs
                .map((tab) => _buildFilterTag(tab, isDarkMode))
                .toList(),
          ),
        ),

        SizedBox(height: 16.h),

        // Proposals list
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md.w),
            itemCount: widget.proposals.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final proposal = widget.proposals[index];
              return _buildProposalCard(proposal, isDarkMode);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTag(String tag, bool isDarkMode) {
    final isSelected = _filterTabs[_selectedFilterIndex] == tag;
    final index = _filterTabs.indexOf(tag);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: AppSpacing.sm.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDarkMode ? AppColors.gray800 : AppColors.gray200),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          tag,
          style: AppTypography.geistRegular14.copyWith(
            color: isSelected
                ? AppColors.white
                : (isDarkMode ? AppColors.darkTextPrimary : AppColors.gray900),
          ),
        ),
      ),
    );
  }

  Widget _buildProposalCard(
    DaoGovernanceProposalModel proposal,
    bool isDarkMode,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: _getStatusColor(proposal.status),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getStatusText(proposal.status),
                  style: AppTypography.geistRegular11.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  proposal.timeframe,
                  style: AppTypography.geistRegular11.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.54.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),

                // Title
                Text(
                  proposal.title,
                  style: AppTypography.geistSemiBold13.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                    letterSpacing: -0.6.sp,
                  ),
                ),

                SizedBox(height: 6.h),

                // Description
                Text(
                  proposal.description,
                  style: AppTypography.geistRegular11.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600,
                    letterSpacing: -0.6.sp,
                    height: 1.0.h,
                  ),
                ),

                SizedBox(height: 10.h),

                // Votes and threshold
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${proposal.proposer} votes',
                      style: AppTypography.geistRegular11.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.gray600,
                        letterSpacing: -0.6.sp,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Text(
                        proposal.passThreshold,
                        style: AppTypography.geistRegular11.copyWith(
                          fontSize: 8.sp,
                          color: AppColors.success,
                          letterSpacing: -0.6.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ProposalStatus status) {
    switch (status) {
      case ProposalStatus.inProgress:
        return AppColors.warning;
      case ProposalStatus.completed:
        return AppColors.success;
      case ProposalStatus.failed:
        return AppColors.error;
    }
  }

  String _getStatusText(ProposalStatus status) {
    switch (status) {
      case ProposalStatus.inProgress:
        return 'In Progress';
      case ProposalStatus.completed:
        return 'Completed';
      case ProposalStatus.failed:
        return 'Failed';
    }
  }
}
