import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../widgets/dms_chat_tabs.dart';
import '../widgets/dms_header.dart';
import '../widgets/dms_quick_actions.dart';
import '../widgets/dms_search_bar.dart';

/// Main DMS page that serves as the entry point for direct messaging
/// and group chat functionality
class DMSHomePage extends StatefulWidget {
  const DMSHomePage({super.key});

  @override
  State<DMSHomePage> createState() => _DMSHomePageState();
}

class _DMSHomePageState extends State<DMSHomePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _searchAnimController;
  late TabController _tabController;

  bool _isSearching = false;
  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _searchAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _tabController = TabController(length: 2, vsync: this);

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchAnimController.dispose();
    _searchTextController.dispose();
    _searchFocusNode.dispose();
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
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // Enhanced header with search
            SliverPadding(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 60.h,
                bottom: 24.h,
              ),
              sliver: SliverToBoxAdapter(
                child: DMSHeader(
                  isSearching: _isSearching,
                  onSearchToggle: _toggleSearch,
                  onNewChatTap: _showNewChatOptions,
                ),
              ),
            ),

            // Search bar with animation
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverToBoxAdapter(
                child: DMSSearchBar(
                  isSearching: _isSearching,
                  searchController: _searchTextController,
                  searchFocusNode: _searchFocusNode,
                ),
              ),
            ),

            // Quick actions
            SliverPadding(
              padding: EdgeInsets.only(bottom: 32.sp),
              sliver: const SliverToBoxAdapter(child: DMSQuickActions()),
            ),

            // Chat tabs (Direct Messages and Group DMs)
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              sliver: SliverToBoxAdapter(
                child: DMSChatTabs(
                  tabController: _tabController,
                  searchQuery: _searchTextController.text,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(isDarkMode),
    );
  }

  Widget _buildFloatingActionButton(bool isDarkMode) {
    return FloatingActionButton(
      onPressed: _showNewChatOptions,
      backgroundColor: AppColors.primary,
      shape: const CircleBorder(),
      elevation: 8,
      child: Transform(
        transform: Matrix4.rotationX(180),
        child: Icon(
          PhosphorIcons.flyingSaucer(),
          color: AppColors.white,
          size: 24.sp,
        ),
      ),
    );
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });

    if (_isSearching) {
      _searchAnimController.forward();
      Future.delayed(const Duration(milliseconds: 300), () {
        _searchFocusNode.requestFocus();
      });
    } else {
      _searchAnimController.reverse();
      _searchFocusNode.unfocus();
      _searchTextController.clear();
    }
  }

  void _showNewChatOptions() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkIconBackground : AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkTextSecondary
                    : AppColors.gray300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 24.h),
            _buildNewChatOption(
              'New Direct Message',
              'Start a private conversation',
              PhosphorIcons.chatCircle(),
              AppColors.primary,
              isDarkMode,
              () => _showNewDMDialog(isDarkMode),
            ),
            SizedBox(height: 16.h),
            _buildNewChatOption(
              'Create Group',
              'Start a group conversation',
              PhosphorIcons.users(),
              AppColors.secondary,
              isDarkMode,
              () => _showNewGroupDialog(isDarkMode),
            ),
            SizedBox(height: 16.h),
            _buildNewChatOption(
              'Join Voice Room',
              'Connect with community members',
              PhosphorIcons.waveform(),
              Colors.purple,
              isDarkMode,
              () => _showActiveVoiceRooms(),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildNewChatOption(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool isDarkMode,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: AppColors.white, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.geistSemiBold15.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextPrimary
                          : AppColors.gray900,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: AppTypography.geistRegular12.copyWith(
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              PhosphorIcons.caretRight(),
              size: 16.sp,
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.gray400,
            ),
          ],
        ),
      ),
    );
  }

  void _showNewDMDialog(bool isDarkMode) {
    // TODO: Implement new DM dialog
    print('Show new DM dialog');
  }

  void _showNewGroupDialog(bool isDarkMode) {
    // TODO: Implement new group dialog
    print('Show new group dialog');
  }

  void _showActiveVoiceRooms() {
    // TODO: Implement voice rooms
    print('Show active voice rooms');
  }
}
