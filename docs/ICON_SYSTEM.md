# App Icon System Documentation

## Overview

The Crete app uses a flexible icon system that supports multiple themes and easy switching between different icon styles. This system is designed to accommodate current needs and future branding requirements.

## Icon Themes

### Available Themes

1. **Transparent** (Default)

   - Path: `assets/icons/transparent/appstore.png`
   - Usage: Default app icon with transparent background
   - Best for: Universal compatibility across all platforms

2. **Light**

   - Path: `assets/icons/light/appstore.png`
   - Usage: Optimized for light backgrounds and light mode
   - Best for: iOS light mode, Android light theme

3. **Dark**

   - Path: `assets/icons/dark/appstore.png`
   - Usage: Optimized for dark backgrounds and dark mode
   - Best for: iOS dark mode, Android dark theme

4. **Seasonal** (Future)

   - Path: `assets/icons/seasonal/appstore.png`
   - Usage: Holiday or seasonal themed icons
   - Best for: Special events, holidays, seasonal promotions

5. **Brand** (Future)
   - Path: `assets/icons/brand/appstore.png`
   - Usage: Special branding or partnership icons
   - Best for: Brand partnerships, special campaigns

## Directory Structure

```
assets/icons/
├── transparent/
│   ├── appstore.png      # 1024x1024 for App Store
│   ├── playstore.png     # 512x512 for Play Store
│   ├── android/          # Android-specific icons
│   └── Assets.xcassets/  # iOS-specific icons
├── light/
│   ├── appstore.png
│   ├── playstore.png
│   ├── android/
│   └── Assets.xcassets/
├── dark/
│   ├── appstore.png
│   ├── playstore.png
│   ├── android/
│   └── Assets.xcassets/
├── seasonal/             # Future implementation
└── brand/                # Future implementation
```

## Icon Requirements

### General Requirements

- **App Store**: 1024x1024px PNG (no transparency for App Store)
- **Play Store**: 512x512px PNG
- **Transparent background**: Recommended for maximum compatibility
- **High resolution**: Vector-based or high-DPI sources preferred

### Platform-Specific Requirements

#### iOS

- Multiple sizes generated automatically
- Supports both light and dark mode variants
- Transparent background recommended

#### Android

- Adaptive icons supported
- Multiple densities generated automatically
- Supports themed icons (Android 13+)

#### Web

- PWA manifest icons
- Favicon support
- Multiple sizes for different contexts

## Usage

### Switching Icon Themes

Use the icon manager script to switch between themes:

```bash
# Switch to transparent theme (default)
dart scripts/icon_manager.dart transparent --generate

# Switch to light theme
dart scripts/icon_manager.dart light --generate

# Switch to dark theme
dart scripts/icon_manager.dart dark --generate

# List available themes
dart scripts/icon_manager.dart list

# Show current theme
dart scripts/icon_manager.dart current
```

### Manual Icon Generation

After switching themes or updating icon files:

```bash
# Install dependencies
flutter pub get

# Generate icons
dart run flutter_launcher_icons
```

### Configuration

The icon configuration is in `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icons/transparent/appstore.png"
  min_sdk_android: 21
  web:
    generate: true
    image_path: "assets/icons/transparent/appstore.png"
  windows:
    generate: true
    image_path: "assets/icons/transparent/appstore.png"
  macos:
    generate: true
    image_path: "assets/icons/transparent/appstore.png"
  linux:
    generate: true
    image_path: "assets/icons/transparent/appstore.png"
```

## Dynamic Icon Switching (Future Feature)

### Planned Implementation

The system is designed to support dynamic icon switching in the future:

1. **Theme-based switching**: Automatically switch icons based on app theme
2. **User preference**: Allow users to choose their preferred icon
3. **Seasonal updates**: Automatically switch to seasonal icons during holidays
4. **Brand campaigns**: Switch to brand icons during special campaigns

### Technical Considerations

- **iOS**: Supports alternate app icons via `UIApplication.shared.setAlternateIconName()`
- **Android**: Supports dynamic icons via activity alias and PackageManager
- **Platform limitations**: Some platforms may require app restart
- **User permissions**: May require user confirmation on some platforms

## Best Practices

### Icon Design

1. **Consistency**: Maintain consistent style across all themes
2. **Scalability**: Use vector graphics or high-resolution sources
3. **Simplicity**: Keep icons simple and recognizable at small sizes
4. **Brand alignment**: Ensure all variants align with brand guidelines

### Theme Management

1. **Fallback**: Always ensure transparent theme works as fallback
2. **Testing**: Test all themes on different devices and platforms
3. **Accessibility**: Ensure icons are accessible in all themes
4. **Performance**: Consider file sizes and loading times

### Development Workflow

1. **Version control**: Track icon changes in git
2. **Documentation**: Document changes and reasons for theme switches
3. **Testing**: Test icon generation on all target platforms
4. **Automation**: Use scripts for consistent icon management

## Troubleshooting

### Common Issues

1. **Icon not updating**: Clear app cache and rebuild
2. **Generation errors**: Check file paths and permissions
3. **Platform-specific issues**: Verify platform-specific requirements
4. **Size issues**: Ensure source images meet minimum requirements

### Support

For issues with the icon system:

1. Check this documentation
2. Review `scripts/icon_manager.dart` for implementation details
3. Verify `pubspec.yaml` configuration
4. Test with `flutter clean` and `flutter pub get`

## Future Enhancements

1. **Automatic theme detection**: Switch icons based on system theme
2. **User customization**: Allow users to upload custom icons
3. **A/B testing**: Support for icon A/B testing
4. **Analytics**: Track icon performance and user preferences
5. **Localization**: Support for region-specific icons
