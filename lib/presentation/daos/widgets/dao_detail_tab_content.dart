import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/data/dao_detail_demo_data.dart';
import '../../../core/models/ui/dao_chat_message_model.dart';
import '../../../core/models/ui/dao_governance_model.dart';
import '../../../core/models/ui/dao_ui_model.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';

/// Tab content widgets for DAO detail page
class DaoDetailTabContent {
  /// Overview tab content
  static Widget overview(DaoUiModel dao) {
    return Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Long description
              Text(
                dao.longDescription ?? dao.description,
                style: AppTypography.geistMedium15.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                  letterSpacing: -0.6.sp,
                ),
              ),

              SizedBox(height: 21.h),

              // Stats column
              Column(
                children: [
                  _buildStatRow(
                    icon: PhosphorIcons.tray(),
                    text: '${dao.stats?.proposalCount ?? 46} Proposals',
                    isDarkMode: isDarkMode,
                  ),
                  SizedBox(height: 16.h),
                  _buildStatRow(
                    icon: PhosphorIcons.usersFour(),
                    text:
                        '${dao.stats?.memberCount ?? dao.memberCount} Members',
                    isDarkMode: isDarkMode,
                  ),
                  SizedBox(height: 16.h),
                  _buildStatRow(
                    icon: PhosphorIcons.vault(),
                    text: dao.stats?.treasuryValue ?? dao.treasuryAmount,
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Chat tab content
  static Widget chat(DaoUiModel dao, bool isDarkMode) {
    return SingleChildScrollView(
      // padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          ...DaoDetailDemoData.chatMessages.asMap().entries.map((entry) {
            final index = entry.key;
            final message = entry.value;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _buildChatMessage(message, isDarkMode),
                ),
                if (index < DaoDetailDemoData.chatMessages.length - 1) ...[
                  SizedBox(height: 12.h),
                  Container(
                    width: 392.w,
                    height: 1.h,
                    color: AppColors.chatDivider,
                  ),
                  SizedBox(height: 24.h),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  /// Governance tab content
  static Widget governance(DaoUiModel dao, bool isDarkMode) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Filter tags
          Row(
            children: [
              _buildFilterTag('All', true, isDarkMode),
              SizedBox(width: 8.w),
              _buildFilterTag('Active', false, isDarkMode),
              SizedBox(width: 8.w),
              _buildFilterTag('Ended', false, isDarkMode),
              SizedBox(width: 8.w),
              _buildFilterTag('My Votes', false, isDarkMode),
            ],
          ),

          SizedBox(height: 16.h),

          // Proposals
          ...DaoDetailDemoData.governanceProposals.asMap().entries.map((entry) {
            final index = entry.key;
            final proposal = entry.value;

            return Column(
              children: [
                _buildProposalCard(proposal, isDarkMode),
                if (index < DaoDetailDemoData.governanceProposals.length - 1)
                  SizedBox(height: 12.h),
              ],
            );
          }),
        ],
      ),
    );
  }

  /// Members tab content
  static Widget members(DaoUiModel dao) {
    return Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: DaoDetailDemoData.members.map((member) {
              return Container(
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.black : AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isDarkMode
                        ? AppColors.darkContainerBorder
                        : AppColors.gray200,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.r),
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.r),
                        child: Image.network(
                          member.avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                member.name[0],
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        member.name,
                        style: AppTypography.geistMedium13.copyWith(
                          color: isDarkMode
                              ? AppColors.darkTextPrimary
                              : AppColors.gray900,
                        ),
                      ),
                    ),
                    if (member.isVerified)
                      SvgPicture.asset(
                        'assets/icons/svgs/Badge.svg',
                        width: 16.w,
                        height: 16.h,
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // Helper widgets
  static Widget _buildStatRow({
    required IconData icon,
    required String text,
    required bool isDarkMode,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24.sp,
          color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
        ),
        SizedBox(width: 10.w),
        Text(
          text,
          style: AppTypography.geistMedium13.copyWith(
            color: isDarkMode ? AppColors.darkTextSecondary : AppColors.gray600,
          ),
        ),
      ],
    );
  }

  static Widget _buildChatMessage(
    DaoChatMessageModel message,
    bool isDarkMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          children: [
            Container(
              width: 24.28.w,
              height: 24.28.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.r),
                color: AppColors.primary,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: Image.network(
                  message.userAvatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        message.userName[0],
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: const Color(0xFF272727),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Text(
                message.userName,
                style: AppTypography.geistRegular15.copyWith(
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 8.w),
            if (message.isVerified)
              SvgPicture.asset(
                'assets/icons/svgs/Badge.svg',
                width: 12.w,
                height: 11.43.h,
              ),
          ],
        ),

        SizedBox(height: 8.h),

        // Message content
        Container(
          width: 361.w,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: const Color(0xFF151515),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            message.message,
            style: AppTypography.geistRegular12.copyWith(
              color: AppColors.white,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
        ),

        SizedBox(height: 12.h),

        // Reactions
        Row(
          children: message.reactions.map((reaction) {
            IconData icon;
            switch (reaction.type) {
              case ReactionType.heart:
                icon = PhosphorIcons.heart();
                break;
              case ReactionType.chat:
                icon = PhosphorIcons.chatCircleText();
                break;
              case ReactionType.smile:
                icon = PhosphorIcons.smiley();
                break;
            }

            return Container(
              margin: EdgeInsets.only(right: 12.w),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 16.07.sp,
                    color: isDarkMode
                        ? AppColors.darkEmojiColor
                        : AppColors.gray600,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    reaction.count.toString(),
                    style: TextStyle(
                      fontFamily: 'Geist',
                      fontWeight: FontWeight.w400,
                      fontSize: 12.05.sp,
                      height: 17.67 / 12.05,
                      letterSpacing: -0.48,
                      color: isDarkMode
                          ? AppColors.darkEmojiColor
                          : AppColors.gray600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  static Widget _buildFilterTag(String text, bool isActive, bool isDarkMode) {
    final double minWidth = 65.w;

    return Container(
      constraints: BoxConstraints(minWidth: minWidth.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryLight : const Color(0xFF212121),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: AppTypography.geistRegular14.copyWith(
          color: isActive ? AppColors.white : AppColors.darkTextSecondary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  static Widget _buildProposalCard(
    DaoGovernanceProposalModel proposal,
    bool isDarkMode,
  ) {
    Color statusColor = const Color(0xFFDDA900); // Default
    switch (proposal.status) {
      case ProposalStatus.inProgress:
        statusColor = const Color(0xFFDDA900);
        break;
      case ProposalStatus.completed:
        statusColor = const Color(0xFF058D00);
        break;
      case ProposalStatus.failed:
        statusColor = const Color(0xFFD20808);
        break;
    }

    return Container(
      width: 361.w,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.black : AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
        ),
      ),
      child: Column(
        children: [
          // Status header
          Container(
            width: double.maxFinite,
            height: 22.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                topRight: Radius.circular(8.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  proposal.status.name,
                  style: AppTypography.geistMedium13.copyWith(
                    color: AppColors.white,
                  ),
                ),
                Text(
                  proposal.timeframe,
                  style: AppTypography.geistMedium13.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8.54.w,
              vertical: 10.18.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  proposal.title,
                  style: AppTypography.geistSemiBold15.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextPrimary
                        : AppColors.gray900,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  proposal.description,
                  style: AppTypography.geistRegular13.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.gray600,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 8.88.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Proposed by ${proposal.proposer}',
                      style: AppTypography.geistRegular11_22.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextLight
                            : AppColors.gray600,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x1A06C100),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Text(
                        proposal.passThreshold,
                        style: TextStyle(
                          fontFamily: 'Geist',
                          fontWeight: FontWeight.w500,
                          fontSize: 10.sp,
                          letterSpacing: -0.6,
                          color: const Color(0xFF06C100),
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
}
