import 'package:flutter/material.dart';
import '../theme/dynamic_theme_manager.dart';

/// Agentic Theme Management Service
/// Allows AI to modify app themes through natural language commands
class AgenticThemeService {
  static AgenticThemeService? _instance;
  static AgenticThemeService get instance =>
      _instance ??= AgenticThemeService._internal();

  AgenticThemeService._internal();

  /// Process natural language theme modification commands
  /// Examples:
  /// - "Change the app color to blue"
  /// - "Make the text bigger"
  /// - "Use a modern font"
  /// - "Switch to dark mode colors"
  void processThemeCommand(String command) {
    final lowerCommand = command.toLowerCase();

    // Color changes
    if (lowerCommand.contains('blue')) {
      DynamicThemeManager.instance.updatePrimaryColor(Colors.blue);
    } else if (lowerCommand.contains('red')) {
      DynamicThemeManager.instance.updatePrimaryColor(Colors.red);
    } else if (lowerCommand.contains('green')) {
      DynamicThemeManager.instance.updatePrimaryColor(Colors.green);
    } else if (lowerCommand.contains('purple')) {
      DynamicThemeManager.instance.updatePrimaryColor(Colors.purple);
    } else if (lowerCommand.contains('orange')) {
      DynamicThemeManager.instance.updatePrimaryColor(Colors.orange);
    }

    // Font changes
    if (lowerCommand.contains('modern') || lowerCommand.contains('inter')) {
      DynamicThemeManager.instance.updatePrimaryFont('Inter');
    } else if (lowerCommand.contains('clean') ||
        lowerCommand.contains('sf pro')) {
      DynamicThemeManager.instance.updatePrimaryFont('SF Pro');
    } else if (lowerCommand.contains('sleek') ||
        lowerCommand.contains('dm sans')) {
      DynamicThemeManager.instance.updatePrimaryFont('DM Sans');
    } else if (lowerCommand.contains('default') ||
        lowerCommand.contains('geist')) {
      DynamicThemeManager.instance.updatePrimaryFont('Geist');
    }

    // Preset applications
    if (lowerCommand.contains('minimal')) {
      ThemePresets.applyPreset('minimal');
    } else if (lowerCommand.contains('modern')) {
      ThemePresets.applyPreset('modern');
    } else if (lowerCommand.contains('default') ||
        lowerCommand.contains('reset')) {
      ThemePresets.applyPreset('default');
    }
  }

  /// Apply a specific color hex value
  void applyCustomColor(String hexColor, {String colorType = 'primary'}) {
    try {
      final color = Color(int.parse(hexColor.replaceAll('#', '0xFF')));

      switch (colorType.toLowerCase()) {
        case 'primary':
          DynamicThemeManager.instance.updatePrimaryColor(color);
          break;
        case 'secondary':
          DynamicThemeManager.instance.updateSecondaryColor(color);
          break;
        case 'background':
          DynamicThemeManager.instance.updateBackgroundColor(color);
          break;
        case 'text':
          DynamicThemeManager.instance.updateTextColor(color);
          break;
      }
    } catch (e) {
      debugPrint('Invalid color format: $hexColor');
    }
  }

  /// Apply multiple theme changes at once
  void applyBulkThemeChanges(Map<String, dynamic> changes) {
    if (changes.containsKey('primaryColor')) {
      applyCustomColor(changes['primaryColor'] as String, colorType: 'primary');
    }

    if (changes.containsKey('secondaryColor')) {
      applyCustomColor(
        changes['secondaryColor'] as String,
        colorType: 'secondary',
      );
    }

    if (changes.containsKey('backgroundColor')) {
      applyCustomColor(
        changes['backgroundColor'] as String,
        colorType: 'background',
      );
    }

    if (changes.containsKey('textColor')) {
      applyCustomColor(changes['textColor'] as String, colorType: 'text');
    }

    if (changes.containsKey('primaryFont')) {
      DynamicThemeManager.instance.updatePrimaryFont(
        changes['primaryFont'] as String,
      );
    }

    if (changes.containsKey('secondaryFont')) {
      DynamicThemeManager.instance.updateSecondaryFont(
        changes['secondaryFont'] as String,
      );
    }
  }

  /// Get current theme state for AI context
  Map<String, dynamic> getCurrentThemeState() {
    final themeManager = DynamicThemeManager.instance;

    return {
      'primaryFont': themeManager.primaryFont,
      'secondaryFont': themeManager.secondaryFont,
      'tertiaryFont': themeManager.tertiaryFont,
      'primaryColor':
          '#${themeManager.primaryColor.value.toRadixString(16).padLeft(8, '0')}',
      'secondaryColor':
          '#${themeManager.secondaryColor.value.toRadixString(16).padLeft(8, '0')}',
      'backgroundColor':
          '#${themeManager.backgroundColor.value.toRadixString(16).padLeft(8, '0')}',
      'textColor':
          '#${themeManager.textColor.value.toRadixString(16).padLeft(8, '0')}',
    };
  }

  /// Schedule a theme change for a specific time (for reminders)
  void scheduleThemeChange({
    required DateTime when,
    required Map<String, dynamic> themeChanges,
    String? reminderMessage,
  }) {
    // This would integrate with a scheduling service
    // For now, just apply immediately as a demo
    debugPrint('Scheduled theme change for $when: $themeChanges');
    if (reminderMessage != null) {
      debugPrint('Reminder: $reminderMessage');
    }

    // In a real implementation, this would use a background scheduler
    applyBulkThemeChanges(themeChanges);
  }

  /// Get available fonts for AI to choose from
  List<String> getAvailableFonts() {
    return ['Geist', 'Inter', 'DM Sans', 'SF Pro'];
  }

  /// Get available theme presets for AI to choose from
  List<String> getAvailablePresets() {
    return ThemePresets.presets.keys.toList();
  }

  /// Generate theme suggestions based on context
  List<Map<String, dynamic>> generateThemeSuggestions({
    String? context,
    String? mood,
    String? timeOfDay,
  }) {
    final suggestions = <Map<String, dynamic>>[];

    if (timeOfDay == 'morning') {
      suggestions.add({
        'name': 'Morning Fresh',
        'description': 'Light and energizing colors for a fresh start',
        'changes': {
          'primaryColor': '#10B981',
          'backgroundColor': '#F0FDF4',
          'primaryFont': 'Inter',
        },
      });
    }

    if (timeOfDay == 'evening') {
      suggestions.add({
        'name': 'Evening Calm',
        'description': 'Warm colors for a relaxing evening',
        'changes': {
          'primaryColor': '#F59E0B',
          'backgroundColor': '#FFFBEB',
          'primaryFont': 'Geist',
        },
      });
    }

    if (mood == 'focused') {
      suggestions.add({
        'name': 'Focus Mode',
        'description': 'Minimal distractions for better concentration',
        'changes': {
          'primaryColor': '#6B7280',
          'backgroundColor': '#F9FAFB',
          'primaryFont': 'SF Pro',
        },
      });
    }

    return suggestions;
  }
}
