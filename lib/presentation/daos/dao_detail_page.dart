import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/models/ui/dao_ui_model.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import 'widgets/dao_detail_tab_content.dart';

/// DAO Detail Page showing comprehensive DAO information
class DaoDetailPage extends StatefulWidget {
  const DaoDetailPage({super.key, required this.dao});

  final DaoUiModel dao;

  @override
  State<DaoDetailPage> createState() => _DaoDetailPageState();
}

class _DaoDetailPageState extends State<DaoDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
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
          // Banner Section
          _buildBanner(context),

          // DAO Info Section
          _buildDaoInfo(context, isDarkMode),

          // Tab Bar
          _buildTabBar(context, isDarkMode),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                DaoDetailTabContent.overview(widget.dao),
                DaoDetailTabContent.chat(widget.dao, isDarkMode),
                DaoDetailTabContent.governance(widget.dao, isDarkMode),
                DaoDetailTabContent.members(widget.dao),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _currentTabIndex == 1
          ? _buildFAB(isDarkMode)
          : null,
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      width: 393.w,
      height: 112.h,
      margin: EdgeInsets.only(bottom: 6.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12.r),
              bottomRight: Radius.circular(12.r),
            ),
            child: Image.network(
              widget.dao.bannerImageUrl ?? widget.dao.imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const ColoredBox(
                  color: AppColors.primary,
                  child: Center(
                    child: Icon(Icons.image, color: AppColors.white, size: 48),
                  ),
                );
              },
            ),
          ),

          // Subtle gradient overlay for better contrast
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),

          // Navigation back overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 12.h,
            left: 16.w,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(
                  PhosphorIcons.caretLeft(),
                  color: AppColors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ),

          // search bar overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 12.h,
            right: 16.w,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(
                  PhosphorIcons.magnifyingGlass(),
                  color: AppColors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaoInfo(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          // DAO Icon and Name Row
          Row(
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
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.r),
                  child: Image.network(
                    widget.dao.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        PhosphorIcons.circleNotch(),
                        color: AppColors.white,
                        size: 20.sp,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                widget.dao.name,
                style: AppTypography.geistSemiBold15.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextPrimary
                      : AppColors.gray900,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Member Avatars and Count
          Row(
            children: [
              // Overlapping member avatars
              SizedBox(
                width: 60.w,
                height: 21.75.h,
                child: Stack(
                  children: List.generate(
                    widget.dao.members?.take(4).length ?? 0,
                    (index) => Positioned(
                      left: index * 12.w,
                      child: Container(
                        width: 21.75.w,
                        height: 21.75.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.r),
                          border: Border.all(color: AppColors.white),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.r),
                          child: Image.network(
                            widget.dao.members?[index].avatarUrl ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return ColoredBox(
                                color: AppColors.primary,
                                child: Center(
                                  child: Text(
                                    widget.dao.members?[index].name[0] ?? '?',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 8.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 6.5.w),
              Text(
                '${widget.dao.memberCount} members',
                style: AppTypography.geistMedium13.copyWith(
                  color: isDarkMode
                      ? AppColors.darkTextSecondary
                      : AppColors.gray600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, bool isDarkMode) {
    const tabs = ['Overview', 'Chat', 'Governance', 'Members'];

    return Column(
      children: [
        SizedBox(height: 20.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tab = entry.value;
              final isActive = _currentTabIndex == index;

              return GestureDetector(
                onTap: () => _tabController.animateTo(index),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 10.h,
                  ),
                  margin: EdgeInsets.only(
                    right: index == tabs.length - 1 ? 0 : 20.w,
                  ),
                  decoration: BoxDecoration(
                    border: isActive
                        ? const Border(
                            bottom: BorderSide(color: AppColors.primaryLight),
                          )
                        : null,
                  ),
                  child: Text(
                    tab,
                    style: AppTypography.geistMedium15.copyWith(
                      color: isActive
                          ? AppColors.primaryLight
                          : (isDarkMode
                                ? AppColors.darkTextSecondary
                                : AppColors.gray600),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Container(width: 393.w, height: 1.h, color: AppColors.chatDivider),
      ],
    );
  }

  Widget _buildFAB(bool isDarkMode) {
    return Container(
      width: 52.52.w,
      height: 52.52.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: !isDarkMode
              ? AppColors.darkContainerBorder
              : AppColors.gray200,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.r),
        child: Image.asset(
          'assets/images/radiants.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              PhosphorIcons.alien(),
              color: AppColors.white,
              size: 24.sp,
            );
          },
        ),
      ),
    );
  }
}
