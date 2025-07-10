import 'environment.dart';

class FlavorConfig {

  FlavorConfig._internal({
    required this.environment,
    required this.name,
    required this.values,
  });
  final Environment environment;
  final String name;
  final Map<String, dynamic> values;

  static FlavorConfig? _instance;

  static FlavorConfig get instance => _instance ?? _throwNotInitialized();

  static bool get isProduction =>
      instance.environment == Environment.production;
  static bool get isDevelopment =>
      instance.environment == Environment.development;
  static bool get isStaging => instance.environment == Environment.staging;

  static void initialize({
    Environment? environment,
    String? name,
    Map<String, dynamic> values = const {},
  }) {
    // Try to get environment from String.fromEnvironment first
    const envString = String.fromEnvironment(
      'APP_ENVIRONMENT',
      defaultValue: 'development',
    );
    final env = environment ?? Environment.fromString(envString);

    _instance = FlavorConfig._internal(
      environment: env,
      name: name ?? env.appName,
      values: values,
    );
    Environment.setCurrent(env);
  }

  /// Initialize flavor config automatically based on build configuration
  static void initializeFromBuild() {
    initialize();
  }

  static Never _throwNotInitialized() {
    throw StateError(
      'FlavorConfig not initialized. Call FlavorConfig.initialize() first.',
    );
  }

  T getValue<T>(String key, T defaultValue) => values[key] as T? ?? defaultValue;

  /// Get flavor-specific app name
  String get appName => environment.appName;

  /// Get flavor-specific package suffix
  String get packageSuffix {
    switch (environment) {
      case Environment.development:
        return '.dev';
      case Environment.staging:
        return '.staging';
      case Environment.production:
        return '';
    }
  }

  /// Get flavor-specific bundle identifier
  String getBundleId(String baseId) => baseId + packageSuffix;

  /// Get the base bundle identifier for the app
  static const String baseBundleId = 'com.crete.app';

  /// Get the current bundle identifier
  String get bundleId => getBundleId(baseBundleId);

  /// Get environment-specific app display name with environment suffix
  String get displayName {
    switch (environment) {
      case Environment.development:
        return 'Crete Dev';
      case Environment.staging:
        return 'Crete Staging';
      case Environment.production:
        return 'Crete';
    }
  }
}
