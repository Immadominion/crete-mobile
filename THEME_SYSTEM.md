# Crete App Theme System

This document describes the comprehensive theme system implemented in the Crete DAO app, designed to support dynamic theme changes through an agentic app manager.

## Architecture Overview

The theme system consists of several key components:

### 1. Core Theme Components

#### Colors (`lib/core/theme/colors.dart`)
- **Updated Brand Colors**: Uses the specified color palette including:
  - Primary: `#4A0989` (Primary button color)
  - Secondary: `#48E5C2` (Crete logo color)
  - DAO Status Colors: Voting in progress (`#DDA900`), Completed (`#058D00`), Failed (`#D20808`)
  - Navigation Colors: Inactive icons (`#717171`), Secondary container (`#5865F233`)
  - Dark Mode Support: Background (`#313131`), Text headings (`#B5B5B5`), Icon backgrounds (`#353535`)

#### Typography (`lib/core/theme/typography.dart`)
- **Modular Font System**: Supports multiple font families for different contexts:
  - **Geist**: Primary font for dashboard and main app
  - **Inter**: Secondary font for specific screens (e.g., wallet connection)
  - **DM Sans**: Tertiary font for specific use cases
  - **SF Pro**: System font for platform-specific text

- **Predefined Styles**: Based on the design specifications provided:
  - Geist SemiBold 15px with 22px line height
  - Inter SemiBold 32px with 100% line height
  - DM Sans Regular 14px with 100% line height
  - And many more contextual styles

### 2. Dynamic Theme System

#### Dynamic Theme Manager (`lib/core/theme/dynamic_theme_manager.dart`)
- **Runtime Theme Modification**: Allows changing themes without app restart
- **Font Family Switching**: Can switch between different font families dynamically
- **Color Customization**: Support for custom color schemes
- **Theme Presets**: Predefined theme combinations (default, modern, minimal)
- **Listener System**: Notifies components when theme changes

#### Agentic Theme Service (`lib/core/services/agentic_theme_service.dart`)
- **Natural Language Processing**: Processes commands like "Make it blue", "Use modern font"
- **Bulk Theme Changes**: Apply multiple theme changes at once
- **Scheduled Changes**: Support for time-based theme modifications
- **Theme Suggestions**: Context-aware theme recommendations
- **Current State Tracking**: Provides current theme state for AI context

### 3. UI Components

#### Bottom Navigation (`lib/core/widgets/bottom_navigation_bar.dart`)
- **5-Tab Navigation**: Home, Explore, Create, Activity, Profile
- **SVG Icons**: Uses custom SVG icons from `assets/icons/svgs/bottom-navigation/`
- **Responsive Design**: Uses `flutter_screenutil` for proper scaling
- **Theme Integration**: Responds to theme changes with proper colors

#### Dashboard Layout (`lib/presentation/dashboard_layout.dart`)
- **PageView Implementation**: Smooth transitions between tabs
- **Modular Pages**: Each tab has its own dedicated page
- **Theme Responsive**: Adapts to light/dark mode and custom themes

### 4. Dashboard Pages

#### Home Page (`lib/presentation/dashboard/home_page.dart`)
- **DAO Overview**: Shows "My DAOs" and "Featured DAOs" sections
- **Recent Activity**: Displays latest DAO activities
- **Custom Scrolling**: Uses `CustomScrollView` with `SliverAppBar`
- **Theme Integration**: Properly styled with the new color scheme

#### Other Pages
- **Explore Page**: DAO discovery and exploration
- **Create Page**: DAO and proposal creation
- **Activity Page**: User activity tracking
- **Profile Page**: User profile management

### 5. Theme Testing

#### Theme Test Page (`lib/presentation/theme_test_page.dart`)
- **Live Theme Testing**: Real-time theme modification testing
- **Typography Examples**: Shows all font styles in use
- **Color Palette**: Displays all brand colors
- **Quick Actions**: Preset theme switches
- **Command Interface**: Natural language theme commands

## Usage Examples

### Basic Theme Changes
```dart
// Change primary color
DynamicThemeManager.instance.updatePrimaryColor(Colors.blue);

// Change font family
DynamicThemeManager.instance.updatePrimaryFont('Inter');

// Apply preset theme
ThemePresets.applyPreset('modern');
```

### Agentic Theme Commands
```dart
// Natural language commands
AgenticThemeService.instance.processThemeCommand('Make it blue');
AgenticThemeService.instance.processThemeCommand('Use modern font');
AgenticThemeService.instance.processThemeCommand('Apply minimal theme');

// Bulk changes
AgenticThemeService.instance.applyBulkThemeChanges({
  'primaryColor': '#4A0989',
  'primaryFont': 'Geist',
  'backgroundColor': '#313131',
});
```

### Theme Listening
```dart
DynamicThemeManager.instance.addThemeChangeListener(() {
  // React to theme changes
  print('Theme changed!');
});
```

## Integration with Agentic App Manager

The theme system is designed to work seamlessly with an AI-powered app manager:

1. **Natural Language Processing**: The `AgenticThemeService` can process natural language commands
2. **Context Awareness**: Theme suggestions based on time, mood, or usage context
3. **Scheduled Changes**: Support for time-based theme modifications
4. **State Tracking**: AI can query current theme state for context
5. **Bulk Operations**: Efficient application of multiple theme changes

## Font Configuration

The app supports multiple font families configured in `pubspec.yaml`:

```yaml
fonts:
  - family: Geist
    fonts:
      - asset: assets/fonts/Geist-Regular.ttf
        weight: 400
      - asset: assets/fonts/Geist-Medium.ttf
        weight: 500
      - asset: assets/fonts/Geist-SemiBold.ttf
        weight: 600
      - asset: assets/fonts/Geist-Bold.ttf
        weight: 700
  - family: Inter
    # ... similar structure
  - family: DM Sans
    # ... similar structure
  - family: SF Pro
    # ... similar structure
```

## Responsive Design

The app uses `flutter_screenutil` for responsive design:
- **Design Size**: 393x852px (based on the provided design)
- **Adaptive Text**: Automatic text scaling
- **Split Screen Support**: Proper handling of different screen sizes

## Performance Considerations

- **Efficient Updates**: Only rebuilds components that need theme updates
- **Memory Management**: Proper disposal of theme listeners
- **Caching**: Theme configurations are cached for performance
- **Lazy Loading**: Theme presets are loaded on demand

## Future Enhancements

The theme system is designed to be extensible:
- **More Font Families**: Easy addition of new fonts
- **Advanced Color Schemes**: Support for gradient themes
- **Animation Themes**: Different animation styles
- **Context-Aware Themes**: Time-based, location-based, or activity-based themes
- **User Preferences**: Persistent theme preferences
- **Theme Sharing**: Export/import theme configurations

This comprehensive theme system provides a solid foundation for the Crete DAO app while enabling powerful customization capabilities through the agentic app manager.
