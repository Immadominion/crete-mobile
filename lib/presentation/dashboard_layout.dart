import 'package:flutter/material.dart';

import '../core/theme/colors.dart';
import '../core/widgets/bottom_navigation_bar.dart';
import 'communities/communities_page.dart';
import 'dashboard/chat_page.dart';
import 'dashboard/home_page.dart';
import 'dashboard/profile_page.dart';
import 'dashboard/voice_page.dart';

class DashboardLayout extends StatefulWidget {
  const DashboardLayout({super.key});

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _pageTransitionController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageTransitionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageTransitionController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (_currentIndex == index) return;

    // Prevent semantic conflicts by adding proper frame scheduling
    setState(() {
      _currentIndex = index;
    });

    // Use post-frame callback to ensure semantic updates complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackgroundPrimary
          : AppColors.backgroundPrimary,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _pageTransitionController,
          builder: (context, child) {
            return PageView(
              controller: _pageController,
              physics:
                  const NeverScrollableScrollPhysics(), // Disable swipe to prevent animation conflicts
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: const [
                // Wrap each page in RepaintBoundary to isolate rendering
                RepaintBoundary(
                  child: HomePage(),
                ), // Your communities, recent activity
                RepaintBoundary(
                  child: CommunitiesPage(),
                ), // Server list, discover new ones
                RepaintBoundary(child: ChatPage()), // Direct messages
                RepaintBoundary(
                  child: VoicePage(),
                ), // Active voice channels, calls
                RepaintBoundary(
                  child: ProfilePage(),
                ), // Settings, wallet, AI manager
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
