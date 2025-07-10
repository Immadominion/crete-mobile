enum Environment {
  development,
  staging,
  production;

  static Environment _current = Environment.development;

  static Environment get current => _current;

  static void setCurrent(Environment env) {
    _current = env;
  }

  static Environment fromString(String env) {
    switch (env.toLowerCase()) {
      case 'development':
      case 'dev':
        return Environment.development;
      case 'staging':
      case 'stage':
        return Environment.staging;
      case 'production':
      case 'prod':
        return Environment.production;
      default:
        return Environment.development;
    }
  }

  String get apiBaseUrl {
    switch (this) {
      case Environment.development:
        return const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://api.dev.crete.dev',
        );
      case Environment.staging:
        return const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://api.staging.crete.dev',
        );
      case Environment.production:
        return const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://api.crete.dev',
        );
    }
  }

  String get websocketUrl {
    switch (this) {
      case Environment.development:
        return const String.fromEnvironment(
          'WEBSOCKET_URL',
          defaultValue: 'wss://ws.dev.crete.dev',
        );
      case Environment.staging:
        return const String.fromEnvironment(
          'WEBSOCKET_URL',
          defaultValue: 'wss://ws.staging.crete.dev',
        );
      case Environment.production:
        return const String.fromEnvironment(
          'WEBSOCKET_URL',
          defaultValue: 'wss://ws.crete.dev',
        );
    }
  }

  String get blinksApiUrl {
    switch (this) {
      case Environment.development:
        return const String.fromEnvironment(
          'BLINKS_API_URL',
          defaultValue: 'https://blinks.dev.crete.dev',
        );
      case Environment.staging:
        return const String.fromEnvironment(
          'BLINKS_API_URL',
          defaultValue: 'https://blinks.staging.crete.dev',
        );
      case Environment.production:
        return const String.fromEnvironment(
          'BLINKS_API_URL',
          defaultValue: 'https://blinks.crete.dev',
        );
    }
  }

  String get notificationServiceUrl {
    switch (this) {
      case Environment.development:
        return const String.fromEnvironment(
          'NOTIFICATION_SERVICE_URL',
          defaultValue: 'https://notifications.dev.crete.dev',
        );
      case Environment.staging:
        return const String.fromEnvironment(
          'NOTIFICATION_SERVICE_URL',
          defaultValue: 'https://notifications.staging.crete.dev',
        );
      case Environment.production:
        return const String.fromEnvironment(
          'NOTIFICATION_SERVICE_URL',
          defaultValue: 'https://notifications.crete.dev',
        );
    }
  }

  String get solanaRpcUrl {
    switch (this) {
      case Environment.development:
      case Environment.staging:
        return const String.fromEnvironment(
          'SOLANA_RPC_URL',
          defaultValue: 'https://api.devnet.solana.com',
        );
      case Environment.production:
        return const String.fromEnvironment(
          'SOLANA_RPC_URL',
          defaultValue: 'https://api.mainnet-beta.solana.com',
        );
    }
  }

  String get solanaCluster {
    switch (this) {
      case Environment.development:
      case Environment.staging:
        return const String.fromEnvironment(
          'SOLANA_CLUSTER',
          defaultValue: 'devnet',
        );
      case Environment.production:
        return const String.fromEnvironment(
          'SOLANA_CLUSTER',
          defaultValue: 'mainnet-beta',
        );
    }
  }

  String get appName {
    switch (this) {
      case Environment.development:
        return const String.fromEnvironment(
          'APP_NAME',
          defaultValue: 'Crete Dev',
        );
      case Environment.staging:
        return const String.fromEnvironment(
          'APP_NAME',
          defaultValue: 'Crete Staging',
        );
      case Environment.production:
        return const String.fromEnvironment('APP_NAME', defaultValue: 'Crete');
    }
  }

  String get appEnvironment {
    switch (this) {
      case Environment.development:
        return 'development';
      case Environment.staging:
        return 'staging';
      case Environment.production:
        return 'production';
    }
  }

  // Feature flags
  bool get enableDiscordImport => const bool.fromEnvironment(
      'ENABLE_DISCORD_IMPORT',
      defaultValue: true,
    );

  bool get enableGuestMode => const bool.fromEnvironment('ENABLE_GUEST_MODE', defaultValue: true);

  bool get enableAnalytics {
    switch (this) {
      case Environment.development:
        return const bool.fromEnvironment(
          'ENABLE_ANALYTICS',
        );
      case Environment.staging:
      case Environment.production:
        return const bool.fromEnvironment(
          'ENABLE_ANALYTICS',
          defaultValue: true,
        );
    }
  }

  bool get enableDebugLogs {
    switch (this) {
      case Environment.development:
      case Environment.staging:
        return const bool.fromEnvironment(
          'ENABLE_DEBUG_LOGS',
          defaultValue: true,
        );
      case Environment.production:
        return const bool.fromEnvironment(
          'ENABLE_DEBUG_LOGS',
        );
    }
  }

  bool get enableNetworkLogging {
    switch (this) {
      case Environment.development:
        return const bool.fromEnvironment(
          'ENABLE_NETWORK_LOGGING',
          defaultValue: true,
        );
      case Environment.staging:
      case Environment.production:
        return const bool.fromEnvironment(
          'ENABLE_NETWORK_LOGGING',
        );
    }
  }

  bool get enableCrashReporting {
    switch (this) {
      case Environment.development:
        return const bool.fromEnvironment(
          'ENABLE_CRASH_REPORTING',
        );
      case Environment.staging:
      case Environment.production:
        return const bool.fromEnvironment(
          'ENABLE_CRASH_REPORTING',
          defaultValue: true,
        );
    }
  }

  // Validation
  void validate() {
    final errors = <String>[];

    // Required URL validations
    if (apiBaseUrl.isEmpty) {
      errors.add('API_BASE_URL is required but not set');
    } else {
      final uri = Uri.tryParse(apiBaseUrl);
      if (uri == null || !uri.hasScheme) {
        errors.add('API_BASE_URL must be a valid URL');
      }
    }

    if (websocketUrl.isEmpty) {
      errors.add('WEBSOCKET_URL is required but not set');
    } else {
      final uri = Uri.tryParse(websocketUrl);
      if (uri == null || !uri.hasScheme) {
        errors.add('WEBSOCKET_URL must be a valid URL');
      }
    }

    if (solanaRpcUrl.isEmpty) {
      errors.add('SOLANA_RPC_URL is required but not set');
    } else {
      final uri = Uri.tryParse(solanaRpcUrl);
      if (uri == null || !uri.hasScheme) {
        errors.add('SOLANA_RPC_URL must be a valid URL');
      }
    }

    if (blinksApiUrl.isEmpty) {
      errors.add('BLINKS_API_URL is required but not set');
    } else {
      final uri = Uri.tryParse(blinksApiUrl);
      if (uri == null || !uri.hasScheme) {
        errors.add('BLINKS_API_URL must be a valid URL');
      }
    }

    if (notificationServiceUrl.isEmpty) {
      errors.add('NOTIFICATION_SERVICE_URL is required but not set');
    } else {
      final uri = Uri.tryParse(notificationServiceUrl);
      if (uri == null || !uri.hasScheme) {
        errors.add('NOTIFICATION_SERVICE_URL must be a valid URL');
      }
    }

    // App configuration validations
    if (appName.isEmpty) {
      errors.add('APP_NAME is required but not set');
    }

    if (appEnvironment.isEmpty) {
      errors.add('APP_ENVIRONMENT is required but not set');
    }

    // Solana cluster validation
    const validClusters = ['devnet', 'testnet', 'mainnet-beta'];
    if (!validClusters.contains(solanaCluster)) {
      errors.add('SOLANA_CLUSTER must be one of: ${validClusters.join(', ')}');
    }

    // Environment-specific validations
    switch (this) {
      case Environment.production:
        if (enableDebugLogs) {
          errors.add('Debug logs should not be enabled in production');
        }
        if (enableNetworkLogging) {
          errors.add('Network logging should not be enabled in production');
        }
        if (solanaCluster != 'mainnet-beta') {
          errors.add('Production environment should use mainnet-beta');
        }
        break;
      case Environment.development:
      case Environment.staging:
        if (solanaCluster == 'mainnet-beta') {
          errors.add('$appEnvironment environment should not use mainnet-beta');
        }
        break;
    }

    if (errors.isNotEmpty) {
      throw StateError(
        'Environment validation failed:\n${errors.map((e) => '  - $e').join('\n')}',
      );
    }
  }

  /// Get environment summary for debugging
  Map<String, dynamic> toMap() => {
      'environment': appEnvironment,
      'apiBaseUrl': apiBaseUrl,
      'websocketUrl': websocketUrl,
      'solanaRpcUrl': solanaRpcUrl,
      'solanaCluster': solanaCluster,
      'appName': appName,
      'blinksApiUrl': blinksApiUrl,
      'notificationServiceUrl': notificationServiceUrl,
      'enableDiscordImport': enableDiscordImport,
      'enableGuestMode': enableGuestMode,
      'enableAnalytics': enableAnalytics,
      'enableDebugLogs': enableDebugLogs,
      'enableNetworkLogging': enableNetworkLogging,
    };
}
