# Context for Crete Codebase

## Overview of the Codebase

This repository contains the Flutter frontend for the Crete decentralized DAO community app. Below is a detailed breakdown of the key components and features of the codebase:

### Key Features

- **User Interface & Experience**: Handles all UI/UX for mobile and web platforms.
- **Wallet Integration**: Supports Solana wallet connection and transaction signing.
- **State Management**: Manages app state, user sessions, and local caching.
- **Real-time Updates**: Implements WebSocket connections for live data.
- **Local Storage**: Manages user preferences, cache, and offline data.
- **Push Notifications**: Handles local notification display and management.
- **Deep Linking**: Enables app navigation from external links.
- **Blink Integration**: Supports Solana Actions (Blinks) for instant transactions.

### Code Quality and Contribution Guidelines

- **Navigation**:
  - Uses `Go Router` for navigation with nested routes, query parameters, and path parameters.
  - Implements route guards for authentication, onboarding, and biometric checks.
  - Provides type-safe navigation methods via `NavigationService`.
- **Deep Linking**:
  - Secure universal links for iOS and custom URL schemes for Android.
  - Validates and parses deep links with `DeepLinkService` and `DeepLinkUtils`.
  - Tracks deep link events with privacy-compliant analytics.
- **Error Handling**:
  - Comprehensive error handling with fallback navigation and error pages.
- **Security**:
  - Protects against malicious URLs with pattern detection and length limits.
  - Validates parameters comprehensively.
  - Implements biometric authentication for sensitive operations.
- **Dependency Injection**:
  - All services are registered in dependency injection and initialized in `main.dart`.
- **Platform-Specific Configuration**:
  - Configurations for iOS (Info.plist) and Android (AndroidManifest.xml).
- **Logging and Analytics**:
  - Comprehensive logging for debugging and performance monitoring.

### Validation

- Run `dart run scripts/validate_step9.dart` to verify navigation and deep linking features.

## App Flow

### Initialization (main.dart)

1. **BlocObserver**: Sets up for debugging in development mode.
2. **Firebase Initialization**: Initializes Firebase with platform-specific options.
3. **Flavor Configuration**: Loads environment-specific configurations.
4. **App Configuration**: Validates and initializes app settings.
5. **Dependency Injection**: Configures all required services.
6. **Service Initialization**:
   - Firebase Notification Service
   - Solana Network Service
   - Wallet Connection Service
   - Blinks Service
   - Cache Service
   - Connectivity Service
   - Offline Data Service
   - Deep Link Service
7. **Debug Logs**: Logs configuration summary in debug mode.
8. **Run App**: Launches the `CreteApp` widget.

### Navigation

- **AppRouter**: Centralized router with route definitions, guards, and error handling.
- **NavigationService**: Provides high-level navigation methods.
- **NavigationGuards**: Protects routes with authentication and other checks.

### Deep Linking

- **DeepLinkService**: Handles secure deep link routing and validation.
- **DeepLinkUtils**: Provides utility functions for parsing and constructing deep links.
- **Supported Links**:
  - DAO List
  - DAO Join
  - DAO Detail
  - Proposal
  - Chat Room

### Animations

- **AppAnimations**: Centralized animation durations and curves for consistent UI transitions.
  - Durations: `fast`, `normal`, `slow`, `verySlow`
  - Curves: `easeIn`, `easeOut`, `easeInOut`, `bounceIn`, `elasticOut`, etc.
  - Page Transitions: `pageTransition`, `pageTransitionCurve`
  - Modal Animations: `modalEnter`, `modalExit`, `modalCurve`

### Validation Scripts

- **validate_step9.dart**: Validates navigation and deep linking features.
  - Checks navigation structure, deep linking configuration, Go Router implementation, navigation guards, platform-specific configuration, dependency injection, route definitions, navigation service, deep link service, and app integration.

## Navigation Structure

### Bottom Navigation (Community-First Flow)

The app follows a community-first navigation structure with the following tabs:

1. **Home** (`HomePage`): Community Feed & Dashboard
   - Wallet status indicator with connected wallet info
   - Recent activity feed with community updates
   - Active voice channels section showing ongoing voice chats
   - Quick actions for common tasks (join voice, check governance, etc.)
   - Notifications section with unread messages and mentions
   - Fade-in animation on page load

2. **Communities** (`CommunitiesPage`): Community Discovery & Management
   - "My Communities" section with horizontal scroll of joined communities
   - "Discover" section with vertical list of public communities
   - Community detail pages with Discord-like channel structure (text, voice, governance channels)
   - Join/leave community functionality

3. **Chat** (`ChatPage`): Direct Messages & Group Chats
   - Direct messages list with recent conversations
   - Group DMs with participant avatars and names
   - Search functionality for finding conversations
   - Navigation to ChatDetailPage with message history and real-time input
   - WebSocket-based messaging system (integration ready)

4. **Governance** (`GovernancePage`): Voting & Proposals
   - Proposal list with filtering (Active, Ended, My Votes)
   - Voting interface with wallet integration
   - Proposal creation and discussion

5. **Profile** (`ProfilePage`): User Settings & Preferences
   - User profile management
   - Wallet connection and settings
   - App preferences and theme selection

### Navigation Implementation

- **DashboardLayout**: Main container with PageView for tab switching
- **AppBottomNavigationBar**: Custom bottom navigation with proper theming
- **NavigationService**: Type-safe navigation between pages
- **Route Guards**: Authentication and permission checks

## Architecture & Design Patterns

### State Management

- **BLoC Pattern**: Uses `flutter_bloc` for predictable state management
- **Cubit**: Simplified state management for smaller features
- **Equatable**: Value equality for state objects and entities
- **Service Layer**: Business logic separated into injectable services

### Data Layer Architecture

- **Repository Pattern**: Clean separation between data sources and business logic
- **Data Sources**:
  - `RemoteDataSource`: API calls using Retrofit-generated clients
  - `LocalDataSource`: SharedPreferences-based local storage
- **Models**: JSON serialization with `json_annotation`
- **Caching**: Simple cache invalidation with timestamp-based expiry

### Dependency Injection

- **GetIt**: Service locator pattern for dependency injection
- **Injectable**: Code generation for DI setup
- **Singleton Services**: Most services are registered as singletons
- **Module Organization**: Separate modules for services and repositories

### Error Handling

- **Custom Exceptions**: Structured error types in `lib/core/error/`
- **Fallback Navigation**: Automatic error page navigation
- **Comprehensive Logging**: Debug logging with environment-specific controls
- **Graceful Degradation**: Offline-first approach with cached data

## Theming System

### Color System

- **Primary**: Solana-inspired purple theme (`#8B5CF6`)
- **Secondary**: Emerald accent color (`#10B981`)
- **Semantic Colors**: Success, warning, error, info variants
- **Dark Mode**: Complete dark theme with proper contrast
- **System Theme**: Automatic light/dark mode detection
- **Color Schemes**: Material 3 ColorScheme implementation

### Typography

- **Font Family**: Inter font for all text
- **Scale**: Material 3 typography scale (display, heading, body, label)
- **Font Weights**: Light (300) to ExtraBold (800)
- **Line Heights**: Optimal readability with proper spacing
- **Letter Spacing**: Consistent across all text styles

### Spacing System

- **8dp Grid**: Material Design 8dp grid system
- **Spacing Constants**: `AppSpacing` class with predefined values
- **Responsive Spacing**: Consistent spacing across all screen sizes
- **Component Spacing**: Specific spacing for cards, buttons, inputs, etc.

### Icon System

- **Multi-Theme Support**: Transparent, light, dark, seasonal, brand themes
- **Icon Manager**: Script-based theme switching (`scripts/icon_manager.dart`)
- **Platform Generation**: Automatic icon generation for all platforms
- **App Store Compliance**: Proper alpha channel handling

## Utilities & Helpers

### String Extensions

- **Validation**: Email, URL, Solana address validation
- **Formatting**: Capitalization, title case, address shortening
- **Cleaning**: Whitespace normalization

### Widget Extensions

- **Styling**: Padding, margin, background, shadow helpers
- **Layout**: Centering, alignment, sizing utilities
- **Interactivity**: Tap handlers, tooltips, visibility controls
- **Animation**: Scale, rotate, translate transformations

### Formatters

- **Numbers**: Currency, percentage, compact notation
- **Tokens**: Solana amount formatting (lamports to SOL)
- **Addresses**: Wallet address truncation
- **Dates**: Relative and absolute date formatting

### Validators

- **Form Validation**: Email, required fields, length validation
- **Crypto Validation**: Solana address format validation
- **Custom Validators**: Composable validation functions

### Crypto Utilities

- **Address Generation**: Deterministic color generation from addresses
- **Wallet Helpers**: Address validation and formatting
- **Brightness Adjustment**: Color readability optimization

## Responsiveness Strategy

### Current Approach

- **Flutter's Responsive Nature**: Leverages Flutter's built-in responsive behavior
- **Flexible Layouts**: Uses `Expanded`, `Flexible`, and `Wrap` widgets
- **Safe Area Handling**: Proper safe area implementation
- **Orientation Support**: Handles portrait and landscape modes

### Missing Responsive Features

- **No Breakpoint System**: Currently lacks formal breakpoint definitions
- **No MediaQuery Utilities**: No centralized screen size utilities
- **No Responsive Typography**: Fixed font sizes across all screens
- **No Adaptive Components**: Components don't adapt to screen size

### Recommended Responsive Additions

```dart
// If responsive utilities are needed, add:
// - lib/core/utils/responsive_utils.dart
// - lib/core/theme/breakpoints.dart
// - Adaptive components for different screen sizes
```

## Performance Considerations

### Optimizations in Place

- **Image Caching**: `cached_network_image` for optimized loading
- **Lazy Loading**: Implemented where appropriate
- **Efficient State Management**: BLoC pattern prevents unnecessary rebuilds
- **Asset Optimization**: Compressed images and icons

### Animation Performance

- **Centralized Animations**: `AppAnimations` class for consistent timing
- **Optimized Transitions**: 60 FPS smooth animations
- **Reduced Overdraw**: Efficient widget composition

## Testing Strategy

### Current Testing Setup

- **Unit Tests**: Focus on business logic and utilities
- **Widget Tests**: Component-level testing
- **Integration Tests**: Complete user flow testing
- **Validation Scripts**: Automated feature validation

### Testing Patterns

- **Mockito**: Service mocking for isolated testing
- **BLoC Testing**: State management testing utilities
- **Golden Tests**: Visual regression testing capability

## Security Measures

### Data Security

- **Biometric Authentication**: Local authentication for sensitive operations
- **Secure Storage**: Encrypted storage for sensitive data
- **Certificate Pinning**: Network security for API calls
- **Input Validation**: Comprehensive validation at all entry points

### URL Security

- **Deep Link Validation**: Malicious URL protection
- **Parameter Sanitization**: Safe parameter handling
- **Pattern Detection**: Suspicious URL pattern detection

## Contribution Guidelines

### Code Quality Standards

- **Clean Architecture**: Strict separation of concerns
- **SOLID Principles**: Dependency inversion and single responsibility
- **Consistent Naming**: Clear, descriptive naming conventions
- **Documentation**: Comprehensive code documentation

### Development Workflow

- **Feature Branches**: Isolated feature development
- **Code Reviews**: Mandatory review process
- **Testing**: All features must include tests
- **Validation**: Use provided validation scripts

### Patterns to Follow

- **Navigation**: Use `NavigationService` for type-safe navigation
- **State Management**: BLoC/Cubit pattern for all state
- **Dependency Injection**: Register all services in DI container
- **Error Handling**: Comprehensive error boundaries
- **Logging**: Structured logging with appropriate levels

### What to Avoid

- **Direct API Calls**: Always use repository pattern
- **Hardcoded Values**: Use constants and configuration
- **Inline Styles**: Use theme system and spacing constants
- **Unhandled Exceptions**: Always provide fallback behavior

## Development Tools

### Scripts Available

- **Build Scripts**: `scripts/build.sh` for complete builds
- **Validation Scripts**: Multiple validation scripts for different features
- **Icon Management**: `scripts/icon_manager.dart` for theme switching
- **Code Generation**: `scripts/watch.sh` for development mode

### VS Code Tasks

- **Flutter Run**: Environment-specific run configurations
- **Code Generation**: Automatic code generation tasks
- **Testing**: Comprehensive test running tasks
- **Analysis**: Code quality and lint checking

## Additional Notes

### Assets Organization

- **Icons**: `assets/icons/` with theme-based organization
- **Images**: `assets/images/` with README for guidelines
- **Animations**: `assets/animations/` for Lottie files

### Platform-Specific Configuration

- **Android**: Proper manifest configuration with deep linking
- **iOS**: Info.plist configuration with universal links
- **Web**: PWA manifest and service worker ready

### Environment Management

- **Flavor Configuration**: Development, staging, production environments
- **Environment Variables**: Secure configuration management
- **Build Variants**: Platform-specific build configurations

### Documentation

- **README.md**: Complete project overview and setup
- **SETUP_GUIDE.md**: Detailed setup instructions
- **docs/**: Feature-specific documentation
- **Inline Comments**: Comprehensive code documentation

This context file serves as a comprehensive guide to the Crete codebase. **Always refer to this file before starting work on any screen** to ensure alignment with the existing architecture, patterns, and standards. The app is built modularly with clean separation of concerns, making it easy to add new features without breaking existing functionality.
