import 'dart:io';
import 'package:crete/core/config/environment.dart';

/// Validation script to check if Step 1 (Environment & Configuration) is complete
void main() async {
  print('🔍 Validating Step 1: Environment & Configuration');
  print('=' * 60);

  final results = <String, bool>{};

  // Check 1.1: Environment Files
  print('\n📁 1.1 Environment Files');
  results['env_dev'] = await _checkFileExists('.env.dev');
  results['env_staging'] = await _checkFileExists('.env.staging');
  results['env_prod'] = await _checkFileExists('.env.prod');
  results['env_example'] = await _checkFileExists('.env.example');

  // Check 1.2: App Configuration Classes
  print('\n⚙️ 1.2 App Configuration');
  results['environment_class'] = await _checkFileExists(
    'lib/core/config/environment.dart',
  );
  results['app_config_class'] = await _checkFileExists(
    'lib/core/config/app_config.dart',
  );
  results['flavor_config_class'] = await _checkFileExists(
    'lib/core/config/flavor_config.dart',
  );

  // Check 1.3: Build Flavors
  print('\n🏗️ 1.3 Build Flavors');
  results['android_build_gradle'] = await _checkAndroidBuildFlavors();
  results['ios_development_config'] = await _checkFileExists(
    'ios/Flutter/Development.xcconfig',
  );
  results['ios_staging_config'] = await _checkFileExists(
    'ios/Flutter/Staging.xcconfig',
  );
  results['ios_production_config'] = await _checkFileExists(
    'ios/Flutter/Production.xcconfig',
  );

  // Test environment validation
  print('\n🧪 Environment Validation Test');
  results['env_validation'] = await _testEnvironmentValidation();

  // Check VS Code tasks
  print('\n🔧 VS Code Tasks');
  results['vscode_tasks'] = await _checkFileExists('.vscode/tasks.json');

  // Summary
  print('\n📊 Summary');
  print('=' * 60);

  final passed = results.values.where((v) => v).length;
  final total = results.length;

  results.forEach((key, value) {
    final status = value ? '✅' : '❌';
    final description = _getCheckDescription(key);
    print('$status $description');
  });

  print('\n📈 Results: $passed/$total checks passed');

  if (passed == total) {
    print('🎉 Step 1: Environment & Configuration is COMPLETE!');
    print('✨ Ready to proceed to Step 2: Dependencies & Code Generation');
  } else {
    print('⚠️ Step 1 needs attention. Please complete the failing checks.');
    exit(1);
  }
}

Future<bool> _checkFileExists(String path) async {
  final file = File(path);
  final exists = await file.exists();
  final status = exists ? '✅' : '❌';
  print('  $status $path');
  return exists;
}

Future<bool> _checkAndroidBuildFlavors() async {
  final file = File('android/app/build.gradle.kts');
  if (!await file.exists()) {
    print('  ❌ android/app/build.gradle.kts');
    return false;
  }

  final content = await file.readAsString();
  final hasDevFlavor = content.contains('create("dev")');
  final hasStagingFlavor = content.contains('create("staging")');
  final hasProdFlavor = content.contains('create("prod")');

  final allFlavors = hasDevFlavor && hasStagingFlavor && hasProdFlavor;
  final status = allFlavors ? '✅' : '❌';
  print('  $status Android build flavors (dev, staging, prod)');

  return allFlavors;
}

Future<bool> _testEnvironmentValidation() async {
  try {
    // Test each environment
    for (final env in Environment.values) {
      Environment.setCurrent(env);
      final current = Environment.current;
      current.validate();
      print('  ✅ ${env.name} environment validation passed');
    }
    return true;
  } catch (e) {
    print('  ❌ Environment validation failed: $e');
    return false;
  }
}

String _getCheckDescription(String key) {
  switch (key) {
    case 'env_dev':
      return 'Development environment file (.env.dev)';
    case 'env_staging':
      return 'Staging environment file (.env.staging)';
    case 'env_prod':
      return 'Production environment file (.env.prod)';
    case 'env_example':
      return 'Example environment file (.env.example)';
    case 'environment_class':
      return 'Environment class implementation';
    case 'app_config_class':
      return 'AppConfig class implementation';
    case 'flavor_config_class':
      return 'FlavorConfig class implementation';
    case 'android_build_gradle':
      return 'Android build flavors configuration';
    case 'ios_development_config':
      return 'iOS Development configuration';
    case 'ios_staging_config':
      return 'iOS Staging configuration';
    case 'ios_production_config':
      return 'iOS Production configuration';
    case 'env_validation':
      return 'Environment validation logic';
    case 'vscode_tasks':
      return 'VS Code tasks configuration';
    default:
      return key;
  }
}
