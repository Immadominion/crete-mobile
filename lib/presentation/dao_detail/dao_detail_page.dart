import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/data/dao_detail_demo_data.dart';
import '../../../core/models/ui/dao_ui_model.dart';
import '../../../core/theme/colors.dart';
import 'widgets/dao_chat_content.dart';
import 'widgets/dao_detail_header.dart';
import 'widgets/dao_detail_tabs.dart';
import 'widgets/dao_governance_content.dart';
import 'widgets/dao_members_content.dart';
import 'widgets/dao_overview_content.dart';

class DaoDetailPage extends StatefulWidget {
  const DaoDetailPage({super.key, required this.dao});

  final DaoUiModel dao;

  @override
  State<DaoDetailPage> createState() => _DaoDetailPageState();
}

class _DaoDetailPageState extends State<DaoDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Overview', 'Chat', 'Governance', 'Members'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundPrimary
          : AppColors.backgroundPrimary,
      body: Column(
        children: [
          // Header with banner and DAO info
          DaoDetailHeader(dao: widget.dao),

          // Tab bar
          DaoDetailTabs(tabs: _tabs, tabController: _tabController),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                DaoOverviewContent(dao: widget.dao),
                DaoChatContent(messages: DaoDetailDemoData.chatMessages),
                DaoGovernanceContent(
                  proposals: DaoDetailDemoData.governanceProposals,
                ),
                DaoMembersContent(members: DaoDetailDemoData.members),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
              onPressed: () {
                // TODO: Implement agentic manager
              },
              backgroundColor: AppColors.primary,
              child: Container(
                width: 56.w,
                height: 56.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDarkMode
                        ? AppColors.darkContainerBorder
                        : AppColors.gray200,
                  ),
                ),
                child: Icon(
                  PhosphorIcons.robot(),
                  color: AppColors.white,
                  size: 24.sp,
                ),
              ),
            )
          : null,
    );
  }
}
