// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/config/flavor_config.dart';
import 'core/cubit/app_bloc_observer.dart';
import 'core/injection/injection.dart';
import 'core/services/blinks_service.dart';
import 'core/services/cache_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/deep_link_service.dart';
import 'core/services/firebase_notification_service.dart';
import 'core/services/offline_data_service.dart';
import 'core/services/solana_network_service.dart';
import 'core/services/wallet_connection_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Set up BlocObserver for debugging
    if (kDebugMode) {
      Bloc.observer = AppBlocObserver();
    }

    // Initialize flavor configuration from build environment
    FlavorConfig.initializeFromBuild();

    // Initialize and validate app configuration
    AppConfig.initialize();

    // Initialize Firebase BEFORE dependency injection
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Setup dependency injection (after Firebase is initialized)
    await configureDependencies();

    // Initialize Firebase Notification Service
    final notificationService = getIt<FirebaseNotificationService>();
    await notificationService.initialize();

    // Initialize Solana services
    final solanaNetworkService = getIt<SolanaNetworkService>();
    await solanaNetworkService.initialize();

    final walletConnectionService = getIt<WalletConnectionService>();
    await walletConnectionService.initialize();

    final blinksService = getIt<BlinksService>();
    await blinksService.initialize();

    // Initialize storage and connectivity services
    final cacheService = getIt<CacheService>();
    await cacheService.initialize();

    final connectivityService = getIt<ConnectivityService>();
    await connectivityService.initialize();

    final offlineDataService = getIt<OfflineDataService>();
    await offlineDataService.initialize();

    // Initialize deep link service
    final deepLinkService = getIt<DeepLinkService>();
    await deepLinkService.initialize();

    // Log configuration summary in debug mode
    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('🚀 Crete App Started');
      debugPrint('🔥 Firebase initialized successfully');
      debugPrint('🔔 Firebase Notification Service initialized');
      debugPrint('🌐 Solana Network Service initialized');
      debugPrint('🔑 Wallet Connection Service initialized');
      debugPrint('⚡ Blinks Service initialized');
      debugPrint('💾 Cache Service initialized');
      debugPrint('📡 Connectivity Service initialized');
      debugPrint('🔄 Offline Data Service initialized');
      debugPrint('🔗 Deep Link Service initialized');
      debugPrint('Environment: ${AppConfig.appEnvironment}');
      debugPrint('App Name: ${AppConfig.appName}');
      debugPrint('Bundle ID: ${FlavorConfig.instance.bundleId}');
      debugPrint('API Base URL: ${AppConfig.apiBaseUrl}');
      debugPrint('Solana Cluster: ${AppConfig.solanaCluster}');
      debugPrint('Solana RPC URL: ${AppConfig.solanaRpcUrl}');
      debugPrint('Blinks API URL: ${AppConfig.blinksApiUrl}');
      debugPrint('Configuration Summary: ${AppConfig.getConfigSummary()}');
      debugPrint('🔧 Dependency injection configured');
    }

    runApp(
      ScreenUtilInit(
        designSize: const Size(393, 852), // Design dimensions as specified
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => const CreteApp(),
      ),
    );
  } catch (error, stackTrace) {
    debugPrint('❌ Failed to initialize app: $error');
    debugPrint('Stack trace: $stackTrace');

    // Show error screen in case of configuration failure
    runApp(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('es', ''),
            Locale('fr', ''),
          ],
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Configuration Error',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
