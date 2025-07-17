# Crete UI Design Patterns

## Overview
This document outlines the comprehensive UI design patterns used throughout the Crete DAO application. These patterns ensure consistency, maintainability, and a cohesive user experience across all screens, including authentication, dashboard, and DAO management interfaces.

## Table of Contents
1. [Typography System](#typography-system)
2. [Color Scheme](#color-scheme)
3. [Spacing & Layout](#spacing--layout)
4. [Component Patterns](#component-patterns)
5. [Animation Guidelines](#animation-guidelines)
6. [Icon System](#icon-system)
7. [Navigation Patterns](#navigation-patterns)
8. [Form Design](#form-design)
9. [Card & Container Patterns](#card--container-patterns)
10. [Theming Implementation](#theming-implementation)
11. [Screen Architecture](#screen-architecture)
12. [Best Practices](#best-practices)

---

## Typography System

### Font Families
- **Primary**: Geist (modern, clean sans-serif)
- **Secondary**: DM Sans (for specific use cases)
- **Display**: SF Pro (for headings on auth screens)
- **System**: Inter (fallback/body text)

### Typography Hierarchy
```dart
// Large Headings (32sp)
AppTypography.sfProSemiBold32 // Auth screens, main titles

// Section Headings (18sp)
AppTypography.geistSemiBold15.copyWith(fontSize: 18.sp)

// Body Text (14-16sp)
AppTypography.geistRegular14  // Regular body text
AppTypography.geistMedium15   // Medium emphasis
AppTypography.geistSemiBold15 // Strong emphasis

// Small Text (12-13sp)
AppTypography.geistRegular12  // Secondary text
AppTypography.geistMedium13   // Button text
AppTypography.geistSemiBold13 // Labels

// Micro Text (10-11sp)
AppTypography.geistRegular11  // Captions
AppTypography.geistMedium11   // Small labels
```

### Sign-In Specific Typography
```dart
// Sign-in page specific styles
AppTypography.signInHeading   // Main heading with DM Sans
AppTypography.signInSubtitle  // Subtitle with Inter
AppTypography.signInButtonText // Button text styling
```

### Letter Spacing
- Use `-0.6.sp` for improved readability on larger text (15sp+)
- Standard spacing for smaller text (12sp and below)

### Usage Guidelines
- Use **SemiBold** for primary actions and important information
- Use **Medium** for secondary actions and interactive elements
- Use **Regular** for body text and descriptions
- Maintain consistent line heights (1.2-1.5x font size)
- Apply proper letter spacing (-0.6sp for tighter text)

---

## Color Scheme

### Primary Colors
```dart
AppColors.primary         // #6366F1 - Primary brand color
AppColors.primaryLight    // Lighter variant for active states
AppColors.primaryDark     // Darker variant for pressed states
```

### Semantic Colors
```dart
// Status Colors
AppColors.success         // Green for success states
AppColors.warning         // Yellow for warnings
AppColors.error          // Red for errors
AppColors.info           // Blue for information
```

### Light Theme
```dart
// Backgrounds
AppColors.backgroundPrimary   // #FFFFFF - Main background
AppColors.backgroundSecondary // #F8F9FA - Secondary background

// Text Colors
AppColors.gray900            // Primary text
AppColors.gray600            // Secondary text
AppColors.gray400            // Disabled text

// Borders & Dividers
AppColors.gray200            // Light borders
AppColors.gray300            // Input borders
```

### Dark Theme
```dart
// Backgrounds
AppColors.darkBackgroundPrimary   // #0F0F0F - Main dark background
AppColors.darkBackgroundSecondary // #1A1A1A - Secondary dark background
AppColors.black                   // #000000 - Pure black

// Text Colors
AppColors.darkTextPrimary     // #FFFFFF - Primary text in dark mode
AppColors.darkTextSecondary   // #A0A0A0 - Secondary text in dark mode
AppColors.darkTextHeading     // #E0E0E0 - Heading text in dark mode

// Borders & Dividers
AppColors.darkContainerBorder // #333333 - Dark mode borders
AppColors.chatDivider         // #2A2A2A - Chat dividers
```

---

## Spacing & Layout

### Spacing System
```dart
AppSpacing.xs    // 4.0  - Extra small gaps
AppSpacing.sm    // 8.0  - Small gaps
AppSpacing.md    // 16.0 - Medium gaps (default)
AppSpacing.lg    // 24.0 - Large gaps
AppSpacing.xl    // 32.0 - Extra large gaps
AppSpacing.xxl   // 40.0 - Double extra large gaps
AppSpacing.huge  // 48.0 - Huge gaps
```

### Layout Principles
- **Consistent Margins**: 16.w horizontal padding as default
- **Vertical Rhythm**: Use consistent spacing multiples (8, 16, 24, 32)
- **Content Width**: Maintain readable line lengths
- **Safe Areas**: Always account for device safe areas

### Responsive Design
```dart
// Use ScreenUtil for responsive dimensions
width: 100.w    // 100% screen width
height: 50.h    // 50% screen height
fontSize: 16.sp // Responsive font size
radius: 12.r    // Responsive border radius
```

---

## Component Patterns

### Button System

#### Primary Button (AuthButton)
```dart
AuthButton(
  text: 'Connect your wallet',
  onPressed: onConnect,
  width: 293.w,
  height: 45.h,
  isLoading: isConnecting,
)
```

#### Secondary Button (AuthSecondaryButton)
```dart
AuthSecondaryButton(
  text: 'Import from discord',
  iconPath: 'assets/icons/svgs/discord.svg',
  onPressed: onImport,
  width: 293.w,
  height: 45.h,
)
```

#### Text Button (AuthTextButton)
```dart
AuthTextButton(
  text: 'Browse as guest',
  onPressed: onGuest,
  width: 140.w,
  height: 21.h,
)
```

### Card Patterns

#### Standard Card
```dart
Container(
  padding: EdgeInsets.all(16.w),
  decoration: BoxDecoration(
    color: isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.white,
    borderRadius: BorderRadius.circular(12.r),
    border: Border.all(
      color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
    ),
  ),
  child: content,
)
```

#### Elevated Card (for important content)
```dart
Container(
  padding: EdgeInsets.all(16.w),
  decoration: BoxDecoration(
    color: isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.white,
    borderRadius: BorderRadius.circular(12.r),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: content,
)
```

### DAO Card Pattern
```dart
DaoCard(
  dao: daoModel,
  isMyDao: dao.isMyDao,
  onTap: () => navigateToDetail(dao),
)
```

---

## Animation Guidelines

### Timing & Easing
```dart
// Standard transitions
Duration(milliseconds: 200)  // Quick interactions
Duration(milliseconds: 300)  // Page transitions
Duration(milliseconds: 500)  // Complex animations

// Easing curves
Curves.easeInOut   // Standard UI transitions
Curves.easeOut     // Entrance animations
Curves.easeIn      // Exit animations
Curves.bounceOut   // Playful interactions
```

### Bottom Navigation Animation
```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 200),
  curve: Curves.easeInOut,
  // ... properties
)

AnimatedDefaultTextStyle(
  duration: const Duration(milliseconds: 200),
  curve: Curves.easeInOut,
  style: TextStyle(
    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
    color: isActive ? activeColor : inactiveColor,
  ),
  child: Text(label),
)
```

### Page Transitions
```dart
_pageController.animateToPage(
  index,
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
)
```

---

## Icon System

### Icon Source
- **Primary**: Phosphor Icons (phosphor_flutter package)
- **Custom**: SVG assets in `assets/icons/svgs/`
- **Platform**: Material Icons for system functions

### Icon Sizing
```dart
// Standard icon sizes
16.sp  // Small icons (inline with text)
20.sp  // Medium icons (buttons)
24.sp  // Default icons (navigation, actions)
32.sp  // Large icons (headers, empty states)
48.sp  // Extra large icons (onboarding)
```

### Dashboard Icons
```dart
// Theme-aware icon loading
final iconPath = DashboardIcons.getIconPath(
  isDarkMode: isDarkMode,
  index: index,
  isActive: isActive,
);

// Directory structure
assets/icons/light/dashboard-icons/  // Light theme icons
assets/icons/dark/dashboard-icons/   // Dark theme icons
```

### Icon Usage Guidelines
- Use **SVG** for custom icons (scalable, theme-aware)
- Use **Phosphor Icons** for standard UI elements
- Maintain consistent visual weight across icon sets
- Provide both light and dark variants for theme switching

---

## Navigation Patterns

### Bottom Navigation
```dart
AppBottomNavigationBar(
  currentIndex: _currentIndex,
  onTap: _onNavTap,
)
```

#### Navigation Items
1. **Home** - Dashboard overview
2. **Explore** - Discover new content
3. **Create** - Add new content
4. **Activity** - User activity feed
5. **Profile** - User profile & settings

### Tab Navigation (DAO Details)
```dart
TabController(length: 4, vsync: this)
// Tabs: Overview, Chat, Governance, Members
```

### Navigation Feedback
- **Immediate Response**: Visual feedback on tap
- **Smooth Transitions**: Animated page changes
- **State Persistence**: Maintain scroll position
- **Deep Linking**: Support for direct navigation

---

## Form Design

### Input Fields
```dart
DaoSearchBar(
  onChanged: handleSearch,
  onSubmitted: handleSubmit,
)
```

### Form Layout
- **Consistent Spacing**: 16.h between form elements
- **Label Positioning**: Above input fields
- **Error States**: Red border + error message below
- **Loading States**: Show loading indicator during submission

### Input Validation
- **Real-time Validation**: Immediate feedback
- **Clear Error Messages**: Specific, actionable feedback
- **Success States**: Green checkmark for valid inputs

---

## Card & Container Patterns

### Section Headers
```dart
SectionHeader(
  title: 'My DAOs',
  iconPath: 'assets/icons/svgs/pinned.svg',
  onSeeAll: () => navigateToSection(),
)
```

### Horizontal Scrolling Sections
```dart
DaoSection(
  sectionHeader: header,
  itemCount: items.length,
  itemBuilder: (context, index) => itemWidget,
)
```

### List Items
```dart
// Chat message pattern
_buildChatMessage(message, isDarkMode)

// Proposal card pattern
_buildProposalCard(proposal, isDarkMode)

// Member item pattern
_buildMemberItem(member, isDarkMode)
```

---

## Theming Implementation

### Theme-Aware Components
```dart
@override
Widget build(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final theme = Theme.of(context);
  
  return Container(
    color: isDarkMode ? AppColors.darkBackgroundPrimary : AppColors.backgroundPrimary,
    child: content,
  );
}
```

### Color Scheme Usage
```dart
// Use theme color scheme instead of hardcoded colors
color: theme.colorScheme.primary,
color: theme.bottomNavigationBarTheme.unselectedItemColor,
```

### Dynamic Theming
```dart
// Light theme configuration
ThemeData.light().copyWith(
  colorScheme: AppColors.lightColorScheme,
  // ... other theme properties
)

// Dark theme configuration
ThemeData.dark().copyWith(
  colorScheme: AppColors.darkColorScheme,
  // ... other theme properties
)
```

---

## Best Practices

### Code Organization
1. **Component Separation**: Each UI component in its own file
2. **Theme Consistency**: Use centralized theme values
3. **Responsive Design**: Use ScreenUtil for all dimensions
4. **Performance**: Optimize ListView and animations

### Accessibility
1. **Semantic Labels**: Provide meaningful widget labels
2. **Touch Targets**: Minimum 44pt touch target size
3. **Color Contrast**: Ensure adequate contrast ratios
4. **Focus Management**: Proper focus order and visual indicators

### Performance
1. **Widget Optimization**: Use `const` constructors where possible
2. **Image Optimization**: Use appropriate image formats and sizes
3. **Animation Performance**: Avoid excessive rebuilds
4. **Memory Management**: Dispose controllers and streams

---

## Usage Examples

### Creating a New Screen
```dart
class NewScreen extends StatelessWidget {
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
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverToBoxAdapter(
              child: _buildHeader(isDarkMode),
            ),
          ),
          
          // Content sections
          // ...
        ],
      ),
    );
  }
}
```

### Implementing Theme-Aware Components
```dart
Widget _buildThemeAwareCard(bool isDarkMode, Widget child) {
  return Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: isDarkMode ? AppColors.darkBackgroundSecondary : AppColors.white,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(
        color: isDarkMode ? AppColors.darkContainerBorder : AppColors.gray200,
      ),
    ),
    child: child,
  );
}
```

---

## Conclusion

These design patterns ensure consistency across the Crete application while maintaining flexibility for future enhancements. Always refer to this guide when implementing new features or modifying existing UI components.

For any questions or additions to these patterns, please consult the development team and update this document accordingly.
