import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors.dart';
import '../../shared/widgets/floating_header_card.dart';
import '../widgets/ai_manager_section_card.dart';
import '../widgets/settings_section_card.dart';
import '../widgets/wallet_section_card.dart';

/// Profile page - Settings, wallet, AI manager
/// Shows user profile, wallet management, settings, and AI manager with clean UI
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundPrimary
          : AppColors.backgroundPrimary,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverPadding(
            padding: EdgeInsets.only(
              left: 15.8.w,
              right: 15.8.w,
              top: 60.h,
              bottom: 24.h,
            ),
            sliver: SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: FloatingHeaderCard(
                  title: 'John Doe',
                  subtitle: 'Settings, wallet, AI management',
                  isDarkMode: isDarkMode,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),

          // Wallet Section
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 15.8.w),
            sliver: SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: WalletSectionCard(isDarkMode: isDarkMode),
              ),
            ),
          ),

          // Settings Section
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 15.8.w),
            sliver: SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SettingsSectionCard(isDarkMode: isDarkMode),
              ),
            ),
          ),

          // AI Manager Section
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 15.8.w),
            sliver: SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: AiManagerSectionCard(isDarkMode: isDarkMode),
              ),
            ),
          ),

          // Bottom padding
          SliverPadding(
            padding: EdgeInsets.only(bottom: 100.h),
            sliver: const SliverToBoxAdapter(child: SizedBox()),
          ),
        ],
      ),
    );
  }
}
