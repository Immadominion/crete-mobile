# Dashboard Icon System

## Overview

The dashboard icon system provides a theme-aware, performance-optimized solution for navigation icons in the Crete app. It automatically handles light/dark mode switching and active/inactive states without requiring runtime color transformations.

## Architecture

### Pre-rendered Icons

- **Performance**: Uses pre-rendered SVG icons instead of programmatic color changes
- **Visual Quality**: Maintains designer-intended appearance and subtle variations
- **Computational Efficiency**: Eliminates runtime color transformations

### Theme Support

- **Light Mode**: `assets/icons/light/dashboard-icons/`
- **Dark Mode**: `assets/icons/dark/dashboard-icons/`

### State Management

- **Active State**: Different icon for selected tab
- **Inactive State**: Different icon for unselected tabs

## File Structure

```
assets/icons/
├── light/dashboard-icons/
│   ├── home-active.svg
│   ├── home-inactive.svg
│   ├── dao-active.svg
│   ├── dao-inactive.svg
│   ├── chat-active.svg
│   ├── chat-inactive.svg
│   ├── governance-active.svg
│   ├── governance-inactive.svg
│   ├── profile-active.svg
│   └── profile-inactive.svg
└── dark/dashboard-icons/
    ├── home-active.svg
    ├── home-inactive.svg
    ├── dao-active.svg
    ├── dao-inactive.svg
    ├── chat-active.svg
    ├── chat-inactive.svg
    ├── governance-active.svg
    ├── governance-inactive.svg
    ├── profile-active.svg
    └── profile-inactive.svg
```

## Usage

### DashboardIcons Class

The `DashboardIcons` class provides a centralized way to manage dashboard navigation icons:

```dart
// Get icon path for current state
final iconPath = DashboardIcons.getIconPath(
  isDarkMode: isDarkMode,
  index: tabIndex,
  isActive: isActive,
);

// Get label for tab
final label = DashboardIcons.labels[tabIndex];
```

### Navigation Mapping

```dart
// Index mapping (matches PageView order in DashboardLayout)
0: HomePage     → home icons
1: ExplorePage  → dao icons (DAO exploration)
2: CreatePage   → chat icons (creation/chat features)
3: ActivityPage → governance icons (governance activities)
4: ProfilePage  → profile icons
```

### AppBottomNavigationBar

The updated bottom navigation bar automatically:

- Detects current theme (light/dark)
- Shows appropriate icon based on active state
- Handles theme changes reactively
- Displays proper labels with active/inactive styling

## Key Benefits

1. **Performance**: No runtime color computations
2. **Design Fidelity**: Preserves designer-intended icon variations
3. **Theme Reactive**: Automatically responds to theme changes
4. **Maintainable**: Centralized icon management
5. **Scalable**: Easy to add new icons or states

## Implementation Details

### Theme Detection

```dart
final isDarkMode = Theme.of(context).brightness == Brightness.dark;
```

### Icon Path Generation

```dart
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
```

### Responsive UI

- Uses `flutter_screenutil` for consistent sizing
- Adapts to different screen sizes
- Maintains proper touch targets

## Future Enhancements

1. **Icon Preloading**: Optional preloading for even better performance
2. **Animation Support**: Smooth transitions between states
3. **Badge Support**: Notification badges on icons
4. **Accessibility**: Enhanced screen reader support

## Best Practices

1. **Icon Design**: Ensure consistent style across all states
2. **Color Contrast**: Maintain proper contrast ratios for accessibility
3. **File Size**: Optimize SVG files for minimal size
4. **Testing**: Test all theme/state combinations
5. **Documentation**: Update this guide when adding new icons

## Troubleshooting

### Missing Icons

- Check file paths match the expected structure
- Verify SVG files are properly formatted
- Ensure all states (active/inactive) exist for both themes

### Performance Issues

- Consider implementing icon preloading for large sets
- Optimize SVG files using tools like SVGO
- Monitor memory usage if adding many icons

### Theme Issues

- Verify theme detection is working correctly
- Check that icons exist for both light and dark modes
- Test theme switching behavior
