import 'dart:io';

/// Validation script to check if Step 2 (Dependencies & Code Generation) is complete
void main() async {
  print('🔍 Validating Step 2: Dependencies & Code Generation');
  print('=' * 60);

  final results = <String, bool>{};

  // Check 2.1: Package Management
  print('\n📦 2.1 Package Management');
  results['dependencies_installed'] = await _checkDependenciesInstalled();
  results['pubspec_valid'] = await _checkPubspecValid();
  results['injectable_setup'] = await _checkInjectableSetup();
  results['json_serialization'] = await _checkJsonSerialization();

  // Check 2.2: Code Generation Setup
  print('\n🏗️ 2.2 Code Generation Setup');
  results['build_runner'] = await _checkBuildRunner();
  results['injectable_generator'] = await _checkInjectableGenerator();
  results['retrofit_generator'] = await _checkRetrofitGenerator();
  results['build_yaml'] = await _checkFileExists('build.yaml');

  // Check 2.3: Development Tools
  print('\n🔧 2.3 Development Tools');
  results['vscode_launch'] = await _checkFileExists('.vscode/launch.json');
  results['analysis_options'] = await _checkFileExists('analysis_options.yaml');
  results['build_scripts'] = await _checkBuildScripts();
  results['pre_commit_hooks'] = await _checkPreCommitHooks();

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
    print('🎉 Step 2: Dependencies & Code Generation is COMPLETE!');
    print('✨ Ready to proceed to Step 3: Firebase Integration');
  } else {
    print('⚠️ Step 2 needs attention. Please complete the failing checks.');
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

Future<bool> _checkDependenciesInstalled() async {
  // Check if .dart_tool exists (indicates dependencies are installed)
  final dartTool = Directory('.dart_tool');
  final pubspecLock = File('pubspec.lock');

  final installed = await dartTool.exists() && await pubspecLock.exists();
  final status = installed ? '✅' : '❌';
  print('  $status Flutter dependencies installed');
  return installed;
}

Future<bool> _checkPubspecValid() async {
  final pubspec = File('pubspec.yaml');
  if (!await pubspec.exists()) {
    print('  ❌ pubspec.yaml not found');
    return false;
  }

  final content = await pubspec.readAsString();
  final requiredDeps = [
    'get_it',
    'injectable',
    'json_annotation',
    'build_runner',
    'injectable_generator',
    'retrofit_generator',
  ];

  final allPresent = requiredDeps.every((dep) => content.contains(dep));
  final status = allPresent ? '✅' : '❌';
  print('  $status Required dependencies in pubspec.yaml');

  return allPresent;
}

Future<bool> _checkInjectableSetup() async {
  final injectionFile = File('lib/core/injection/injection.dart');
  final serviceModule = File('lib/core/injection/service_module.dart');
  final configFile = File('lib/core/injection/injection.config.dart');

  final injectionExists = await injectionFile.exists();
  final moduleExists = await serviceModule.exists();
  final configExists = await configFile.exists();

  final allExist = injectionExists && moduleExists && configExists;
  final status = allExist ? '✅' : '❌';
  print('  $status Injectable dependency injection setup');

  return allExist;
}

Future<bool> _checkJsonSerialization() async {
  final pubspec = File('pubspec.yaml');
  if (!await pubspec.exists()) return false;

  final content = await pubspec.readAsString();
  final hasJsonAnnotation = content.contains('json_annotation');
  final hasJsonSerializable = content.contains('json_serializable');

  final setup = hasJsonAnnotation && hasJsonSerializable;
  final status = setup ? '✅' : '❌';
  print('  $status JSON serialization packages configured');

  return setup;
}

Future<bool> _checkBuildRunner() async {
  // Check if build_runner can be executed
  try {
    final result = await Process.run('dart', ['run', 'build_runner', '--help']);
    final working = result.exitCode == 0;
    final status = working ? '✅' : '❌';
    print('  $status build_runner executable');
    return working;
  } catch (e) {
    print('  ❌ build_runner not working: $e');
    return false;
  }
}

Future<bool> _checkInjectableGenerator() async {
  final buildYaml = File('build.yaml');
  if (!await buildYaml.exists()) {
    print('  ❌ build.yaml not found');
    return false;
  }

  final content = await buildYaml.readAsString();
  final hasInjectable = content.contains('injectable_generator');
  final status = hasInjectable ? '✅' : '❌';
  print('  $status Injectable generator configured');

  return hasInjectable;
}

Future<bool> _checkRetrofitGenerator() async {
  final buildYaml = File('build.yaml');
  if (!await buildYaml.exists()) {
    print('  ❌ build.yaml not found');
    return false;
  }

  final content = await buildYaml.readAsString();
  final hasRetrofit = content.contains('retrofit_generator');
  final status = hasRetrofit ? '✅' : '❌';
  print('  $status Retrofit generator configured');

  return hasRetrofit;
}

Future<bool> _checkBuildScripts() async {
  final buildScript = File('scripts/build.sh');
  final watchScript = File('scripts/watch.sh');

  final buildExists = await buildScript.exists();
  final watchExists = await watchScript.exists();

  final allExist = buildExists && watchExists;
  final status = allExist ? '✅' : '❌';
  print('  $status Build scripts (build.sh, watch.sh)');

  return allExist;
}

Future<bool> _checkPreCommitHooks() async {
  final preCommitScript = File('scripts/pre-commit.sh');
  final setupScript = File('scripts/setup-hooks.sh');

  final preCommitExists = await preCommitScript.exists();
  final setupExists = await setupScript.exists();

  final allExist = preCommitExists && setupExists;
  final status = allExist ? '✅' : '❌';
  print('  $status Pre-commit hook scripts');

  return allExist;
}

String _getCheckDescription(String key) {
  switch (key) {
    case 'dependencies_installed':
      return 'Flutter dependencies installed';
    case 'pubspec_valid':
      return 'Required dependencies in pubspec.yaml';
    case 'injectable_setup':
      return 'Injectable dependency injection setup';
    case 'json_serialization':
      return 'JSON serialization packages';
    case 'build_runner':
      return 'build_runner executable';
    case 'injectable_generator':
      return 'Injectable generator configuration';
    case 'retrofit_generator':
      return 'Retrofit generator configuration';
    case 'build_yaml':
      return 'Build configuration (build.yaml)';
    case 'vscode_launch':
      return 'VS Code debug configurations';
    case 'analysis_options':
      return 'Flutter analysis options';
    case 'build_scripts':
      return 'Automated build scripts';
    case 'pre_commit_hooks':
      return 'Pre-commit hook scripts';
    default:
      return key;
  }
}
