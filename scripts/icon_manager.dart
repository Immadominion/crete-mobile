#!/usr/bin/env dart

import 'dart:io';

/// App Icon Manager
///
/// This script manages different icon themes for the Crete app.
/// It can switch between transparent, light, dark, and future seasonal/brand themes.
///
/// Usage:
/// dart scripts/icon_manager.dart [theme] [--generate]
///
/// Themes:
/// - transparent (default)
/// - light
/// - dark
/// - seasonal (future)
/// - brand (future)
///
/// Options:
/// --generate: Generate icons after switching theme
/// --list: List available themes
/// --current: Show current theme
/// --help: Show this help

class IconManager {
  static const String pubspecPath = 'pubspec.yaml';
  static const String iconsBasePath = 'assets/icons';
  static const String iconConfigKey = 'flutter_launcher_icons:';

  static const Map<String, String> availableThemes = {
    'transparent': 'assets/icons/transparent/splash-transparent.png',
    'light': 'assets/icons/light/appstore.png',
    'dark': 'assets/icons/dark/appstore.png',
    // Future themes
    'seasonal': 'assets/icons/seasonal/appstore.png',
    'brand': 'assets/icons/brand/appstore.png',
  };

  static void main(List<String> args) {
    if (args.isEmpty) {
      showHelp();
      return;
    }

    final command = args.first;
    final options = args.skip(1).toList();

    switch (command) {
      case '--help':
      case 'help':
        showHelp();
        break;
      case '--list':
      case 'list':
        listThemes();
        break;
      case '--current':
      case 'current':
        showCurrentTheme();
        break;
      case 'transparent':
      case 'light':
      case 'dark':
      case 'seasonal':
      case 'brand':
        switchTheme(command, options.contains('--generate'));
        break;
      default:
        print('Unknown command: $command');
        showHelp();
    }
  }

  static void showHelp() {
    print('''
Crete App Icon Manager

Usage: dart scripts/icon_manager.dart [command] [options]

Commands:
  transparent    Switch to transparent icon theme
  light          Switch to light icon theme
  dark           Switch to dark icon theme
  seasonal       Switch to seasonal icon theme (future)
  brand          Switch to brand icon theme (future)
  
  list           List available themes
  current        Show current theme
  help           Show this help

Options:
  --generate     Generate icons after switching theme

Examples:
  dart scripts/icon_manager.dart transparent --generate
  dart scripts/icon_manager.dart list
  dart scripts/icon_manager.dart current
''');
  }

  static void listThemes() {
    print('Available icon themes:');
    availableThemes.forEach((theme, path) {
      final exists = File(path).existsSync();
      final status = exists ? '✓' : '✗';
      print('  $status $theme: $path');
    });
  }

  static void showCurrentTheme() {
    final pubspecContent = File(pubspecPath).readAsStringSync();
    final lines = pubspecContent.split('\n');

    String? currentImagePath;
    bool inIconConfig = false;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (line.trim() == 'flutter_launcher_icons:') {
        inIconConfig = true;
        continue;
      }

      if (inIconConfig && line.trim().startsWith('image_path:')) {
        currentImagePath = line.split(':')[1].trim().replaceAll('"', '');
        break;
      }

      // Stop if we hit another top-level section (no indentation)
      if (inIconConfig &&
          line.isNotEmpty &&
          !line.startsWith('  ') &&
          !line.startsWith('\t')) {
        break;
      }
    }

    if (currentImagePath != null) {
      final currentTheme = availableThemes.entries
          .firstWhere(
            (entry) => entry.value == currentImagePath,
            orElse: () => const MapEntry('custom', ''),
          )
          .key;

      if (currentTheme == 'custom') {
        print('Current theme: custom');
        print('Image path: $currentImagePath');
      } else {
        print('Current theme: $currentTheme');
        print('Image path: $currentImagePath');
      }
    } else {
      print('No icon configuration found');
    }
  }

  static void switchTheme(String theme, bool generate) {
    if (!availableThemes.containsKey(theme)) {
      print('Unknown theme: $theme');
      return;
    }

    final imagePath = availableThemes[theme]!;

    // Check if the icon file exists
    if (!File(imagePath).existsSync()) {
      print('Warning: Icon file not found: $imagePath');
      if (theme == 'seasonal' || theme == 'brand') {
        print('This theme is planned for future implementation.');
        return;
      }
    }

    // Update pubspec.yaml
    final pubspecContent = File(pubspecPath).readAsStringSync();
    final lines = pubspecContent.split('\n');
    final updatedLines = <String>[];

    bool inIconConfig = false;
    bool imagePathUpdated = false;

    for (final line in lines) {
      if (line.trim().startsWith('flutter_launcher_icons:')) {
        inIconConfig = true;
        updatedLines.add(line);
        continue;
      }

      if (inIconConfig && line.trim().startsWith('image_path:')) {
        updatedLines.add('  image_path: "$imagePath"');
        imagePathUpdated = true;
        continue;
      }

      if (inIconConfig && line.trim().isEmpty) {
        inIconConfig = false;
      }

      updatedLines.add(line);
    }

    if (imagePathUpdated) {
      File(pubspecPath).writeAsStringSync(updatedLines.join('\n'));
      print('✓ Switched to $theme theme');
      print('  Image path: $imagePath');

      if (generate) {
        print('\nGenerating icons...');
        final result = Process.runSync('dart', [
          'run',
          'flutter_launcher_icons',
        ]);
        if (result.exitCode == 0) {
          print('✓ Icons generated successfully');
        } else {
          print('✗ Icon generation failed:');
          print(result.stderr);
        }
      } else {
        print('\nTo generate icons, run:');
        print('  dart run flutter_launcher_icons');
      }
    } else {
      print('✗ Failed to update pubspec.yaml');
    }
  }
}

void main(List<String> args) {
  IconManager.main(args);
}
