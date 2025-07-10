import 'environment.dart';

class AppConfig {
  static Environment get environment => Environment.current;

  // API Configuration
  static String get apiBaseUrl => environment.apiBaseUrl;
  static String get websocketUrl => environment.websocketUrl;
  static String get blinksApiUrl => environment.blinksApiUrl;
  static String get notificationServiceUrl =>
      environment.notificationServiceUrl;

  // Solana Configuration
  static String get solanaRpcUrl => environment.solanaRpcUrl;
  static String get solanaCluster => environment.solanaCluster;

  // App Configuration
  static String get appName => environment.appName;
  static String get appEnvironment => environment.appEnvironment;
  static String get appVersion =>
      const String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0');

  // Environment checks
  static bool get isProduction => environment == Environment.production;
  static bool get isDevelopment => environment == Environment.development;
  static bool get isStaging => environment == Environment.staging;

  // Feature flags
  static bool get enableDiscordImport => environment.enableDiscordImport;
  static bool get enableGuestMode => environment.enableGuestMode;
  static bool get enableAnalytics => environment.enableAnalytics;
  static bool get enableBiometricAuth => !isDevelopment;
  static bool get enablePushNotifications => true;
  static bool get enableDeepLinking => true;

  // Debug flags
  static bool get enableDebugLogs => environment.enableDebugLogs;
  static bool get enableNetworkLogging => environment.enableNetworkLogging;
  static bool get enableCrashReporting => isProduction || isStaging;

  /// Initialize and validate the app configuration
  static void initialize() {
    try {
      environment.validate();
    } catch (e) {
      throw StateError('AppConfig validation failed: $e');
    }
  }

  /// Get configuration summary for debugging
  static Map<String, dynamic> getConfigSummary() => {
      'environment': appEnvironment,
      'appName': appName,
      'appVersion': appVersion,
      'apiBaseUrl': apiBaseUrl,
      'websocketUrl': websocketUrl,
      'solanaCluster': solanaCluster,
      'enableDebugLogs': enableDebugLogs,
      'enableNetworkLogging': enableNetworkLogging,
      'enableAnalytics': enableAnalytics,
    };
}
