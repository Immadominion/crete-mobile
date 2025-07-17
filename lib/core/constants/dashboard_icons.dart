/// Dashboard navigation icon configuration
/// This follows the existing icon system pattern with theme-based organization
class DashboardIcons {
  static const String _lightPath = 'assets/icons/light/dashboard-icons';
  static const String _darkPath = 'assets/icons/dark/dashboard-icons';

  /// Dashboard navigation items with their corresponding icon names
  /// Order matches the PageView children in DashboardLayout:
  /// 0: HomePage (Your communities, recent activity), 1: Communities (Server list, discover), 2: Chat (Direct messages), 3: Voice (Active voice channels), 4: Profile (Settings, wallet, AI manager)
  static const Map<int, String> _iconNames = {
    0: 'home', // HomePage (Your communities, recent activity)
    1: 'dao', // Communities (Server list, discover new ones)
    2: 'chat', // Chat (Direct messages)
    3: 'governance', // Voice (Active voice channels, calls)
    4: 'profile', // Profile (Settings, wallet, AI manager)
  };

  /// Get the appropriate icon path based on theme, index, and active state
  static String getIconPath({
    required bool isDarkMode,
    required int index,
    required bool isActive,
  }) {
    final themePath = isDarkMode ? _darkPath : _lightPath;
    final iconName = _iconNames[index];
    final state = isActive ? 'active' : 'inactive';

    return '$themePath/$iconName-$state.svg';
  }

  /// Get all icon paths for preloading (optional optimization)
  static List<String> getAllIconPaths() {
    final List<String> paths = [];

    for (final theme in [_lightPath, _darkPath]) {
      for (final iconName in _iconNames.values) {
        for (final state in ['active', 'inactive']) {
          paths.add('$theme/$iconName-$state.svg');
        }
      }
    }

    return paths;
  }

  /// Navigation item labels
  static const Map<int, String> labels = {
    0: 'Home',
    1: 'Communities', // Server list, discover new ones
    2: 'Chat', // Direct messages
    3: 'Voice', // Active voice channels, calls
    4: 'Profile', // Settings, wallet, AI manager
  };
}
