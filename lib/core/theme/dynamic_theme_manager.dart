import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

/// Dynamic Theme Manager for agentic app customization
/// Allows runtime theme modifications through the agentic app manager
class DynamicThemeManager {
  static DynamicThemeManager? _instance;
  static DynamicThemeManager get instance =>
      _instance ??= DynamicThemeManager._internal();

  DynamicThemeManager._internal();

  // Current theme configuration
  String _primaryFont = AppTypography.primaryFontFamily;
  String _secondaryFont = AppTypography.secondaryFontFamily;
  String _tertiaryFont = AppTypography.tertiaryFontFamily;

  // Custom color overrides
  Color? _customPrimaryColor;
  Color? _customSecondaryColor;
  Color? _customBackgroundColor;
  Color? _customTextColor;

  // Theme modification callbacks
  final List<VoidCallback> _themeChangeListeners = [];

  // Getters for current theme values
  String get primaryFont => _primaryFont;
  String get secondaryFont => _secondaryFont;
  String get tertiaryFont => _tertiaryFont;

  Color get primaryColor => _customPrimaryColor ?? AppColors.primary;
  Color get secondaryColor => _customSecondaryColor ?? AppColors.secondary;
  Color get backgroundColor =>
      _customBackgroundColor ?? AppColors.backgroundPrimary;
  Color get textColor => _customTextColor ?? AppColors.gray900;

  /// Update primary font family
  void updatePrimaryFont(String fontFamily) {
    _primaryFont = fontFamily;
    _notifyListeners();
  }

  /// Update secondary font family
  void updateSecondaryFont(String fontFamily) {
    _secondaryFont = fontFamily;
    _notifyListeners();
  }

  /// Update tertiary font family
  void updateTertiaryFont(String fontFamily) {
    _tertiaryFont = fontFamily;
    _notifyListeners();
  }

  /// Update primary color
  void updatePrimaryColor(Color color) {
    _customPrimaryColor = color;
    _notifyListeners();
  }

  /// Update secondary color
  void updateSecondaryColor(Color color) {
    _customSecondaryColor = color;
    _notifyListeners();
  }

  /// Update background color
  void updateBackgroundColor(Color color) {
    _customBackgroundColor = color;
    _notifyListeners();
  }

  /// Update text color
  void updateTextColor(Color color) {
    _customTextColor = color;
    _notifyListeners();
  }

  /// Reset to default theme
  void resetToDefault() {
    _primaryFont = AppTypography.primaryFontFamily;
    _secondaryFont = AppTypography.secondaryFontFamily;
    _tertiaryFont = AppTypography.tertiaryFontFamily;
    _customPrimaryColor = null;
    _customSecondaryColor = null;
    _customBackgroundColor = null;
    _customTextColor = null;
    _notifyListeners();
  }

  /// Apply a complete theme preset
  void applyThemePreset({
    required String primaryFont,
    required String secondaryFont,
    required String tertiaryFont,
    required Color primaryColor,
    required Color secondaryColor,
    required Color backgroundColor,
    required Color textColor,
  }) {
    _primaryFont = primaryFont;
    _secondaryFont = secondaryFont;
    _tertiaryFont = tertiaryFont;
    _customPrimaryColor = primaryColor;
    _customSecondaryColor = secondaryColor;
    _customBackgroundColor = backgroundColor;
    _customTextColor = textColor;
    _notifyListeners();
  }

  /// Add theme change listener
  void addThemeChangeListener(VoidCallback listener) {
    _themeChangeListeners.add(listener);
  }

  /// Remove theme change listener
  void removeThemeChangeListener(VoidCallback listener) {
    _themeChangeListeners.remove(listener);
  }

  /// Notify all listeners of theme changes
  void _notifyListeners() {
    for (final listener in _themeChangeListeners) {
      listener();
    }
  }

  /// Generate dynamic ColorScheme
  ColorScheme generateColorScheme({required bool isDark}) {
    if (isDark) {
      return ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: backgroundColor,
        onPrimary: textColor,
        onSecondary: textColor,
        onSurface: textColor,
      );
    } else {
      return ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: backgroundColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textColor,
      );
    }
  }

  /// Generate dynamic TextTheme
  TextTheme generateTextTheme() {
    return AppTypography.createCustomTextTheme(
      fontFamily: primaryFont,
      textColor: textColor,
    );
  }

  /// Generate dynamic ThemeData
  ThemeData generateThemeData({required bool isDark}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: generateColorScheme(isDark: isDark),
      textTheme: generateTextTheme(),
      fontFamily: primaryFont,
      // Add other theme properties as needed
    );
  }
}

/// Widget that rebuilds when theme changes
class DynamicThemeBuilder extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    ThemeData lightTheme,
    ThemeData darkTheme,
  )
  builder;

  const DynamicThemeBuilder({super.key, required this.builder});

  @override
  State<DynamicThemeBuilder> createState() => _DynamicThemeBuilderState();
}

class _DynamicThemeBuilderState extends State<DynamicThemeBuilder> {
  late VoidCallback _themeChangeListener;

  @override
  void initState() {
    super.initState();
    _themeChangeListener = () {
      if (mounted) {
        setState(() {});
      }
    };
    DynamicThemeManager.instance.addThemeChangeListener(_themeChangeListener);
  }

  @override
  void dispose() {
    DynamicThemeManager.instance.removeThemeChangeListener(
      _themeChangeListener,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = DynamicThemeManager.instance;
    final lightTheme = themeManager.generateThemeData(isDark: false);
    final darkTheme = themeManager.generateThemeData(isDark: true);

    return widget.builder(context, lightTheme, darkTheme);
  }
}

/// Predefined theme presets for quick switching
class ThemePresets {
  static const Map<String, Map<String, dynamic>> presets = {
    'default': {
      'primaryFont': 'Geist',
      'secondaryFont': 'Inter',
      'tertiaryFont': 'DM Sans',
      'primaryColor': 0xFF4A0989,
      'secondaryColor': 0xFF48E5C2,
      'backgroundColor': 0xFFFFFFFF,
      'textColor': 0xFF000000,
    },
    'modern': {
      'primaryFont': 'Inter',
      'secondaryFont': 'Geist',
      'tertiaryFont': 'SF Pro',
      'primaryColor': 0xFF6366F1,
      'secondaryColor': 0xFF10B981,
      'backgroundColor': 0xFFFAFAFA,
      'textColor': 0xFF1F2937,
    },
    'minimal': {
      'primaryFont': 'SF Pro',
      'secondaryFont': 'Inter',
      'tertiaryFont': 'Geist',
      'primaryColor': 0xFF000000,
      'secondaryColor': 0xFF6B7280,
      'backgroundColor': 0xFFFFFFFF,
      'textColor': 0xFF000000,
    },
  };

  /// Apply a predefined theme preset
  static void applyPreset(String presetName) {
    final preset = presets[presetName];
    if (preset != null) {
      DynamicThemeManager.instance.applyThemePreset(
        primaryFont: preset['primaryFont'] as String,
        secondaryFont: preset['secondaryFont'] as String,
        tertiaryFont: preset['tertiaryFont'] as String,
        primaryColor: Color(preset['primaryColor'] as int),
        secondaryColor: Color(preset['secondaryColor'] as int),
        backgroundColor: Color(preset['backgroundColor'] as int),
        textColor: Color(preset['textColor'] as int),
      );
    }
  }
}
