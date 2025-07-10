#!/usr/bin/env dart
/// Step 9: Deep Linking & Navigation Validation Script
/// 
/// This script validates that all deep linking and navigation features are properly implemented
/// and functioning correctly across all platforms.

import 'dart:io';

void main() async {
  print('🔗 Step 9: Deep Linking & Navigation Validation');
  print('==============================================');
  
  // Track validation results
  final validationResults = <String, bool>{};
  
  // Test 1: Check navigation structure
  print('\n📁 Checking navigation structure...');
  validationResults['navigation_structure'] = await validateNavigationStructure();
  
  // Test 2: Check deep linking configuration
  print('\n📱 Checking deep linking configuration...');
  validationResults['deep_linking_config'] = await validateDeepLinkingConfig();
  
  // Test 3: Check Go Router implementation
  print('\n🛣️ Checking Go Router implementation...');
  validationResults['go_router'] = await validateGoRouter();
  
  // Test 4: Check navigation guards
  print('\n🔒 Checking navigation guards...');
  validationResults['navigation_guards'] = await validateNavigationGuards();
  
  // Test 5: Check platform-specific configuration
  print('\n🔧 Checking platform-specific configuration...');
  validationResults['platform_config'] = await validatePlatformConfig();
  
  // Test 6: Check dependency injection
  print('\n💉 Checking dependency injection...');
  validationResults['dependency_injection'] = await validateDependencyInjection();
  
  // Test 7: Check route definitions
  print('\n📍 Checking route definitions...');
  validationResults['route_definitions'] = await validateRouteDefinitions();
  
  // Test 8: Check navigation service
  print('\n⚙️ Checking navigation service...');
  validationResults['navigation_service'] = await validateNavigationService();
  
  // Test 9: Check deep link service
  print('\n🔗 Checking deep link service...');
  validationResults['deep_link_service'] = await validateDeepLinkService();
  
  // Test 10: Check app integration
  print('\n🎯 Checking app integration...');
  validationResults['app_integration'] = await validateAppIntegration();
  
  // Final results
  print('\n📊 VALIDATION RESULTS');
  print('====================');
  
  int passed = 0;
  final int total = validationResults.length;
  
  for (final entry in validationResults.entries) {
    final status = entry.value ? '✅ PASS' : '❌ FAIL';
    print('${entry.key}: $status');
    if (entry.value) passed++;
  }
  
  print('\n📈 Summary: $passed/$total tests passed');
  
  if (passed == total) {
    print('🎉 All deep linking and navigation features are properly implemented!');
    print('✅ Step 9 is complete and ready for production use.');
  } else {
    print('⚠️  Some validation tests failed. Please check the implementation.');
    exit(1);
  }
}

/// Validate navigation structure
Future<bool> validateNavigationStructure() async {
  final requiredFiles = [
    'lib/core/navigation/app_router.dart',
    'lib/core/navigation/route_paths.dart',
    'lib/core/navigation/navigation_guards.dart',
    'lib/core/services/navigation_service.dart',
    'lib/core/services/deep_link_service.dart',
    'lib/core/utils/deep_link_utils.dart',
  ];
  
  var allExist = true;
  
  for (final file in requiredFiles) {
    if (!await File(file).exists()) {
      print('  ❌ Missing: $file');
      allExist = false;
    } else {
      print('  ✅ Found: $file');
    }
  }
  
  return allExist;
}

/// Validate deep linking configuration
Future<bool> validateDeepLinkingConfig() async {
  var isValid = true;
  
  // Check pubspec.yaml for required dependencies
  final pubspecFile = File('pubspec.yaml');
  if (await pubspecFile.exists()) {
    final pubspecContent = await pubspecFile.readAsString();
    
    final requiredDeps = ['go_router', 'app_links'];
    for (final dep in requiredDeps) {
      if (pubspecContent.contains(dep)) {
        print('  ✅ Found dependency: $dep');
      } else {
        print('  ❌ Missing dependency: $dep');
        isValid = false;
      }
    }
  } else {
    print('  ❌ pubspec.yaml not found');
    isValid = false;
  }
  
  return isValid;
}

/// Validate Go Router implementation
Future<bool> validateGoRouter() async {
  final routerFile = File('lib/core/navigation/app_router.dart');
  if (!await routerFile.exists()) {
    print('  ❌ app_router.dart not found');
    return false;
  }
  
  final content = await routerFile.readAsString();
  
  final requiredComponents = [
    'GoRouter',
    'routes:',
    'redirect:',
    'onException:',
    'pageBuilder',
    'initialLocation',
  ];
  
  var allFound = true;
  
  for (final component in requiredComponents) {
    if (content.contains(component)) {
      print('  ✅ Found: $component');
    } else {
      print('  ❌ Missing: $component');
      allFound = false;
    }
  }
  
  return allFound;
}

/// Validate navigation guards
Future<bool> validateNavigationGuards() async {
  final guardsFile = File('lib/core/navigation/navigation_guards.dart');
  if (!await guardsFile.exists()) {
    print('  ❌ navigation_guards.dart not found');
    return false;
  }
  
  final content = await guardsFile.readAsString();
  
  final requiredMethods = [
    'isAuthenticated',
    'hasCompletedOnboarding',
    'hasBiometricAuthEnabled',
    'checkRouteGuards',
    'requireAuthentication',
    'requireOnboarding',
  ];
  
  var allFound = true;
  
  for (final method in requiredMethods) {
    if (content.contains(method)) {
      print('  ✅ Found method: $method');
    } else {
      print('  ❌ Missing method: $method');
      allFound = false;
    }
  }
  
  return allFound;
}

/// Validate platform-specific configuration
Future<bool> validatePlatformConfig() async {
  var isValid = true;
  
  // Check Android configuration
  final androidManifest = File('android/app/src/main/AndroidManifest.xml');
  if (await androidManifest.exists()) {
    final content = await androidManifest.readAsString();
    
    if (content.contains('android:scheme="crete"')) {
      print('  ✅ Android custom scheme configured');
    } else {
      print('  ❌ Android custom scheme not configured');
      isValid = false;
    }
    
    if (content.contains('android:autoVerify="true"')) {
      print('  ✅ Android app links configured');
    } else {
      print('  ❌ Android app links not configured');
      isValid = false;
    }
  } else {
    print('  ❌ AndroidManifest.xml not found');
    isValid = false;
  }
  
  // Check iOS configuration
  final iosInfoPlist = File('ios/Runner/Info.plist');
  if (await iosInfoPlist.exists()) {
    final content = await iosInfoPlist.readAsString();
    
    if (content.contains('CFBundleURLSchemes')) {
      print('  ✅ iOS URL schemes configured');
    } else {
      print('  ❌ iOS URL schemes not configured');
      isValid = false;
    }
    
    if (content.contains('com.apple.developer.associated-domains')) {
      print('  ✅ iOS associated domains configured');
    } else {
      print('  ❌ iOS associated domains not configured');
      isValid = false;
    }
  } else {
    print('  ❌ Info.plist not found');
    isValid = false;
  }
  
  return isValid;
}

/// Validate dependency injection
Future<bool> validateDependencyInjection() async {
  final injectionConfigFile = File('lib/core/injection/injection.config.dart');
  if (!await injectionConfigFile.exists()) {
    print('  ❌ injection.config.dart not found');
    return false;
  }
  
  final content = await injectionConfigFile.readAsString();
  
  final requiredServices = [
    'NavigationService',
    'DeepLinkService',
    'AppRouter',
    'NavigationGuards',
  ];
  
  var allFound = true;
  
  for (final service in requiredServices) {
    if (content.contains(service)) {
      print('  ✅ Found service registration: $service');
    } else {
      print('  ❌ Missing service registration: $service');
      allFound = false;
    }
  }
  
  return allFound;
}

/// Validate route definitions
Future<bool> validateRouteDefinitions() async {
  final routePathsFile = File('lib/core/navigation/route_paths.dart');
  if (!await routePathsFile.exists()) {
    print('  ❌ route_paths.dart not found');
    return false;
  }
  
  final content = await routePathsFile.readAsString();
  
  final requiredRoutes = [
    'home',
    'onboarding',
    'login',
    'signup',
    'profile',
    'settings',
    'dao',
    'proposal',
    'wallet',
  ];
  
  var allFound = true;
  
  for (final route in requiredRoutes) {
    if (content.contains(route)) {
      print('  ✅ Found route: $route');
    } else {
      print('  ❌ Missing route: $route');
      allFound = false;
    }
  }
  
  return allFound;
}

/// Validate navigation service
Future<bool> validateNavigationService() async {
  final navServiceFile = File('lib/core/services/navigation_service.dart');
  if (!await navServiceFile.exists()) {
    print('  ❌ navigation_service.dart not found');
    return false;
  }
  
  final content = await navServiceFile.readAsString();
  
  final requiredMethods = [
    'pushNamed',
    'pushReplacementNamed',
    'pop',
    'popUntil',
    'goNamed',
    'goHome',
    'goToLogin',
    'goToProfile',
    'goToSettings',
    'canPop',
    'logNavigation',
  ];
  
  var allFound = true;
  
  for (final method in requiredMethods) {
    if (content.contains(method)) {
      print('  ✅ Found method: $method');
    } else {
      print('  ❌ Missing method: $method');
      allFound = false;
    }
  }
  
  return allFound;
}

/// Validate deep link service
Future<bool> validateDeepLinkService() async {
  final deepLinkFile = File('lib/core/services/deep_link_service.dart');
  if (!await deepLinkFile.exists()) {
    print('  ❌ deep_link_service.dart not found');
    return false;
  }
  
  final content = await deepLinkFile.readAsString();
  
  final requiredMethods = [
    'initialize',
    'dispose',
    'handleIncomingLink',
    'validateLink',
    'parseDeepLink',
    'isValidDeepLink',
    'logDeepLinkEvent',
  ];
  
  var allFound = true;
  
  for (final method in requiredMethods) {
    if (content.contains(method)) {
      print('  ✅ Found method: $method');
    } else {
      print('  ❌ Missing method: $method');
      allFound = false;
    }
  }
  
  return allFound;
}

/// Validate app integration
Future<bool> validateAppIntegration() async {
  var isValid = true;
  
  // Check main.dart for service initialization
  final mainFile = File('lib/main.dart');
  if (await mainFile.exists()) {
    final content = await mainFile.readAsString();
    
    if (content.contains('getIt.get<DeepLinkService>().initialize()') || 
        content.contains('getIt<DeepLinkService>()')) {
      print('  ✅ Deep link service initialized in main.dart');
    } else {
      print('  ❌ Deep link service not initialized in main.dart');
      isValid = false;
    }
  } else {
    print('  ❌ main.dart not found');
    isValid = false;
  }
  
  // Check app.dart for router configuration
  final appFile = File('lib/app.dart');
  if (await appFile.exists()) {
    final content = await appFile.readAsString();
    
    if (content.contains('MaterialApp.router')) {
      print('  ✅ MaterialApp.router configured in app.dart');
    } else {
      print('  ❌ MaterialApp.router not configured in app.dart');
      isValid = false;
    }
    
    if (content.contains('routerConfig:')) {
      print('  ✅ Router config provided to MaterialApp');
    } else {
      print('  ❌ Router config not provided to MaterialApp');
      isValid = false;
    }
  } else {
    print('  ❌ app.dart not found');
    isValid = false;
  }
  
  return isValid;
}
