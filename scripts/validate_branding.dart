#!/usr/bin/env dart

import 'dart:io';

/// App Branding Validation Script
///
/// This script validates that Step 10 (App Identity & Branding) is properly implemented.
/// It checks icon generation, splash screen setup, and app metadata.

class BrandingValidator {
  static const String workingDirectory =
      '/Users/immadominion/codes/projects/crete';

  static void main(List<String> args) {
    print('🔍 Validating Step 10: App Identity & Branding');
    print('=' * 60);

    int passedTests = 0;
    int totalTests = 0;

    // Test 1: Icon Assets Structure
    totalTests++;
    if (validateIconAssets()) {
      print('✅ Test 1: Icon assets structure');
      passedTests++;
    } else {
      print('❌ Test 1: Icon assets structure');
    }

    // Test 2: Flutter Launcher Icons Configuration
    totalTests++;
    if (validateIconConfiguration()) {
      print('✅ Test 2: Flutter launcher icons configuration');
      passedTests++;
    } else {
      print('❌ Test 2: Flutter launcher icons configuration');
    }

    // Test 3: Generated Icon Files
    totalTests++;
    if (validateGeneratedIcons()) {
      print('✅ Test 3: Generated icon files');
      passedTests++;
    } else {
      print('❌ Test 3: Generated icon files');
    }

    // Test 4: Icon Manager Script
    totalTests++;
    if (validateIconManager()) {
      print('✅ Test 4: Icon manager script');
      passedTests++;
    } else {
      print('❌ Test 4: Icon manager script');
    }

    // Test 5: Splash Screen Configuration
    totalTests++;
    if (validateSplashConfiguration()) {
      print('✅ Test 5: Splash screen configuration');
      passedTests++;
    } else {
      print('❌ Test 5: Splash screen configuration');
    }

    // Test 6: Generated Splash Screen Files
    totalTests++;
    if (validateGeneratedSplash()) {
      print('✅ Test 6: Generated splash screen files');
      passedTests++;
    } else {
      print('❌ Test 6: Generated splash screen files');
    }

    // Test 7: App Metadata Setup
    totalTests++;
    if (validateAppMetadata()) {
      print('✅ Test 7: App metadata setup');
      passedTests++;
    } else {
      print('❌ Test 7: App metadata setup');
    }

    // Test 8: Dependencies
    totalTests++;
    if (validateDependencies()) {
      print('✅ Test 8: Required dependencies');
      passedTests++;
    } else {
      print('❌ Test 8: Required dependencies');
    }

    // Test 9: Documentation
    totalTests++;
    if (validateDocumentation()) {
      print('✅ Test 9: Icon system documentation');
      passedTests++;
    } else {
      print('❌ Test 9: Icon system documentation');
    }

    // Test 10: Current Theme Detection
    totalTests++;
    if (validateCurrentTheme()) {
      print('✅ Test 10: Current theme detection');
      passedTests++;
    } else {
      print('❌ Test 10: Current theme detection');
    }

    print('=' * 60);
    print('📊 Results: $passedTests/$totalTests tests passed');

    if (passedTests == totalTests) {
      print('🎉 All branding validation tests passed!');
      print('✅ Step 10 (App Identity & Branding) is properly implemented');
    } else {
      print('⚠️  Some tests failed. Please review the issues above.');
    }
  }

  static bool validateIconAssets() {
    final iconDirs = [
      'assets/icons/transparent',
      'assets/icons/light',
      'assets/icons/dark',
    ];

    for (final dir in iconDirs) {
      final directory = Directory('$workingDirectory/$dir');
      if (!directory.existsSync()) {
        print('   ❌ Missing directory: $dir');
        return false;
      }

      final appstoreIcon = File('$workingDirectory/$dir/appstore.png');
      if (!appstoreIcon.existsSync()) {
        print('   ❌ Missing appstore.png in: $dir');
        return false;
      }
    }

    return true;
  }

  static bool validateIconConfiguration() {
    final pubspecFile = File('$workingDirectory/pubspec.yaml');
    if (!pubspecFile.existsSync()) {
      print('   ❌ pubspec.yaml not found');
      return false;
    }

    final content = pubspecFile.readAsStringSync();

    final requiredConfigs = [
      'flutter_launcher_icons:',
      'image_path: "assets/icons/transparent/splash-transparent.png"',
      'remove_alpha_ios: true',
      'android: "launcher_icon"',
      'ios: true',
    ];

    for (final config in requiredConfigs) {
      if (!content.contains(config)) {
        print('   ❌ Missing configuration: $config');
        return false;
      }
    }

    return true;
  }

  static bool validateGeneratedIcons() {
    final iconPaths = [
      'android/app/src/main/res/mipmap-hdpi/launcher_icon.png',
      'android/app/src/main/res/mipmap-mdpi/launcher_icon.png',
      'android/app/src/main/res/mipmap-xhdpi/launcher_icon.png',
      'android/app/src/main/res/mipmap-xxhdpi/launcher_icon.png',
      'android/app/src/main/res/mipmap-xxxhdpi/launcher_icon.png',
      'ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json',
    ];

    for (final path in iconPaths) {
      final file = File('$workingDirectory/$path');
      if (!file.existsSync()) {
        print('   ❌ Missing generated icon: $path');
        return false;
      }
    }

    return true;
  }

  static bool validateIconManager() {
    final scriptFile = File('$workingDirectory/scripts/icon_manager.dart');
    if (!scriptFile.existsSync()) {
      print('   ❌ Icon manager script not found');
      return false;
    }

    final content = scriptFile.readAsStringSync();

    final requiredFeatures = [
      'class IconManager',
      'availableThemes',
      'switchTheme',
      'showCurrentTheme',
      'listThemes',
    ];

    for (final feature in requiredFeatures) {
      if (!content.contains(feature)) {
        print('   ❌ Missing feature in icon manager: $feature');
        return false;
      }
    }

    return true;
  }

  static bool validateSplashConfiguration() {
    final pubspecFile = File('$workingDirectory/pubspec.yaml');
    if (!pubspecFile.existsSync()) {
      print('   ❌ pubspec.yaml not found');
      return false;
    }

    final content = pubspecFile.readAsStringSync();

    final requiredConfigs = [
      'flutter_native_splash:',
      'color: "#FFFFFF"',
      'image: "assets/icons/transparent/splash-transparent.png"',
      'color_dark: "#000000"',
      'image_dark: "assets/icons/dark/appstore.png"',
    ];

    for (final config in requiredConfigs) {
      if (!content.contains(config)) {
        print('   ❌ Missing splash configuration: $config');
        return false;
      }
    }

    return true;
  }

  static bool validateGeneratedSplash() {
    final splashPaths = [
      'android/app/src/main/res/drawable/launch_background.xml',
      'android/app/src/main/res/drawable-night/launch_background.xml',
      'android/app/src/main/res/values-v31/styles.xml',
      'android/app/src/main/res/values-night-v31/styles.xml',
    ];

    for (final path in splashPaths) {
      final file = File('$workingDirectory/$path');
      if (!file.existsSync()) {
        print('   ❌ Missing generated splash file: $path');
        return false;
      }
    }

    return true;
  }

  static bool validateAppMetadata() {
    // Check Android metadata
    final androidManifest = File(
      '$workingDirectory/android/app/src/main/AndroidManifest.xml',
    );
    if (!androidManifest.existsSync()) {
      print('   ❌ AndroidManifest.xml not found');
      return false;
    }

    final androidContent = androidManifest.readAsStringSync();
    if (!androidContent.contains('android:label="@string/app_name"')) {
      print('   ❌ App label not using string resource in AndroidManifest.xml');
      return false;
    }

    // Check Android strings.xml
    final androidStrings = File(
      '$workingDirectory/android/app/src/main/res/values/strings.xml',
    );
    if (!androidStrings.existsSync()) {
      print('   ❌ Android strings.xml not found');
      return false;
    }

    final androidStringsContent = androidStrings.readAsStringSync();
    if (!androidStringsContent.contains(
      '<string name="app_name">Crete</string>',
    )) {
      print('   ❌ App name not set in strings.xml');
      return false;
    }

    // Check iOS metadata
    final iosPlist = File('$workingDirectory/ios/Runner/Info.plist');
    if (!iosPlist.existsSync()) {
      print('   ❌ iOS Info.plist not found');
      return false;
    }

    final iosContent = iosPlist.readAsStringSync();
    if (!iosContent.contains('CFBundleDisplayName')) {
      print('   ❌ Bundle display name not set in Info.plist');
      return false;
    }

    if (!iosContent.contains('<string>Crete</string>')) {
      print('   ❌ App display name not set to Crete in Info.plist');
      return false;
    }

    return true;
  }

  static bool validateDependencies() {
    final pubspecFile = File('$workingDirectory/pubspec.yaml');
    if (!pubspecFile.existsSync()) {
      print('   ❌ pubspec.yaml not found');
      return false;
    }

    final content = pubspecFile.readAsStringSync();

    final requiredDeps = ['flutter_launcher_icons:', 'flutter_native_splash:'];

    for (final dep in requiredDeps) {
      if (!content.contains(dep)) {
        print('   ❌ Missing dependency: $dep');
        return false;
      }
    }

    return true;
  }

  static bool validateDocumentation() {
    final docFile = File('$workingDirectory/docs/ICON_SYSTEM.md');
    if (!docFile.existsSync()) {
      print('   ❌ Icon system documentation not found');
      return false;
    }

    final content = docFile.readAsStringSync();

    final requiredSections = [
      '# App Icon System Documentation',
      '## Overview',
      '## Icon Themes',
      '## Usage',
      '## Best Practices',
    ];

    for (final section in requiredSections) {
      if (!content.contains(section)) {
        print('   ❌ Missing documentation section: $section');
        return false;
      }
    }

    return true;
  }

  static bool validateCurrentTheme() {
    try {
      final result = Process.runSync('dart', [
        'scripts/icon_manager.dart',
        'current',
      ], workingDirectory: workingDirectory);

      if (result.exitCode != 0) {
        print('   ❌ Icon manager script failed');
        return false;
      }

      final output = result.stdout.toString();
      if (!output.contains('Current theme:')) {
        print('   ❌ Current theme not detected');
        return false;
      }

      return true;
    } catch (e) {
      print('   ❌ Error running icon manager: $e');
      return false;
    }
  }
}

void main(List<String> args) {
  BrandingValidator.main(args);
}
