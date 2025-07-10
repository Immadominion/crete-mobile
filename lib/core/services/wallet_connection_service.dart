import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_config.dart';
import '../constants/wallet_constants.dart';

/// Wallet connection state
enum WalletConnectionState { disconnected, connecting, connected, error }

/// Supported wallet types
enum WalletType { phantom, solflare, backpack, walletConnect }

/// Wallet connection information
class WalletInfo {

  const WalletInfo({
    required this.publicKey,
    required this.type,
    this.name,
    required this.connectedAt,
  });

  factory WalletInfo.fromJson(Map<String, dynamic> json) => WalletInfo(
    publicKey: json['publicKey'] as String,
    type: WalletType.values.firstWhere((e) => e.name == json['type']),
    name: json['name'] as String?,
    connectedAt: DateTime.parse(json['connectedAt'] as String),
  );
  final String publicKey;
  final WalletType type;
  final String? name;
  final DateTime connectedAt;

  Map<String, dynamic> toJson() => {
    'publicKey': publicKey,
    'type': type.name,
    'name': name,
    'connectedAt': connectedAt.toIso8601String(),
  };
}

/// Service for managing wallet connections and transactions
@singleton
class WalletConnectionService {
  final StreamController<WalletConnectionState> _stateController =
      StreamController<WalletConnectionState>.broadcast();
  final StreamController<WalletInfo?> _walletController =
      StreamController<WalletInfo?>.broadcast();

  WalletConnectionState _currentState = WalletConnectionState.disconnected;
  WalletInfo? _currentWallet;
  String? _lastError;

  /// Initialize the wallet connection service
  Future<void> initialize() async {
    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('🔑 Wallet Connection Service initialized');
    }
  }

  /// Connect to a specific wallet
  Future<bool> connectWallet(WalletType walletType) async {
    _updateState(WalletConnectionState.connecting);

    try {
      switch (walletType) {
        case WalletType.phantom:
          return await _connectPhantom();
        case WalletType.solflare:
          return await _connectSolflare();
        case WalletType.backpack:
          return await _connectBackpack();
        case WalletType.walletConnect:
          return await _connectWalletConnect();
      }
    } catch (e) {
      _lastError = e.toString();
      _updateState(WalletConnectionState.error);

      if (kDebugMode) {
        debugPrint('❌ Wallet connection error: $e');
      }

      return false;
    }
  }

  /// Connect to Phantom wallet
  Future<bool> _connectPhantom() async {
    try {
      // For mobile: Use deep linking to Phantom app
      if (!kIsWeb) {
        return await _connectMobileWallet(WalletType.phantom);
      }

      // For web: Use Phantom browser extension
      return await _connectWebWallet(WalletType.phantom);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Phantom connection error: $e');
      }
      return false;
    }
  }

  /// Connect to Solflare wallet
  Future<bool> _connectSolflare() async {
    try {
      // For mobile: Use deep linking to Solflare app
      if (!kIsWeb) {
        return await _connectMobileWallet(WalletType.solflare);
      }

      // For web: Use Solflare browser extension
      return await _connectWebWallet(WalletType.solflare);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Solflare connection error: $e');
      }
      return false;
    }
  }

  /// Connect to Backpack wallet
  Future<bool> _connectBackpack() async {
    try {
      // For mobile: Use deep linking to Backpack app
      if (!kIsWeb) {
        return await _connectMobileWallet(WalletType.backpack);
      }

      // For web: Use Backpack browser extension
      return await _connectWebWallet(WalletType.backpack);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Backpack connection error: $e');
      }
      return false;
    }
  }

  /// Connect via WalletConnect for other wallets
  Future<bool> _connectWalletConnect() async {
    try {
      // TODO: Implement WalletConnect integration
      // This would use the WalletConnect protocol to connect to various wallets

      if (kDebugMode) {
        debugPrint('🔗 WalletConnect integration not yet implemented');
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ WalletConnect connection error: $e');
      }
      return false;
    }
  }

  /// Connect to mobile wallet via deep linking
  Future<bool> _connectMobileWallet(WalletType walletType) async {
    try {
      final scheme = WalletConstants.walletSchemes[walletType.name];
      if (scheme == null) return false;

      // Create connection URL with app-specific parameters
      final connectUrl = Uri.parse(
        '${scheme}connect?app_name=${AppConfig.appName}',
      );

      // Launch wallet app
      final launched = await launchUrl(
        connectUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        // If wallet app is not installed, redirect to app store
        await _redirectToWalletInstall(walletType);
        return false;
      }

      // TODO: Implement deep link response handling
      // The wallet app should return with connection result

      // For now, simulate connection for development
      if (AppConfig.appEnvironment == 'development') {
        return await _simulateWalletConnection(walletType);
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Mobile wallet connection error: $e');
      }
      return false;
    }
  }

  /// Connect to web wallet via browser extension
  Future<bool> _connectWebWallet(WalletType walletType) async {
    try {
      // TODO: Implement browser extension integration
      // This would use JavaScript interop to communicate with wallet extensions

      if (kDebugMode) {
        debugPrint(
          '🌐 Web wallet integration not yet implemented for ${walletType.name}',
        );
      }

      // For now, simulate connection for development
      if (AppConfig.appEnvironment == 'development') {
        return await _simulateWalletConnection(walletType);
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Web wallet connection error: $e');
      }
      return false;
    }
  }

  /// Redirect user to install wallet app
  Future<void> _redirectToWalletInstall(WalletType walletType) async {
    String? storeUrl;

    switch (walletType) {
      case WalletType.phantom:
        storeUrl = 'https://phantom.app/download';
        break;
      case WalletType.solflare:
        storeUrl = 'https://solflare.com/download';
        break;
      case WalletType.backpack:
        storeUrl = 'https://backpack.app/download';
        break;
      case WalletType.walletConnect:
        // No specific install URL for WalletConnect
        break;
    }

    if (storeUrl != null) {
      await launchUrl(
        Uri.parse(storeUrl),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  /// Simulate wallet connection for development
  Future<bool> _simulateWalletConnection(WalletType walletType) async {
    // Generate a mock public key for development
    const mockPublicKey =
        '11111111111111111111111111111112'; // System program ID

    final walletInfo = WalletInfo(
      publicKey: mockPublicKey,
      type: walletType,
      name: WalletConstants.walletNames[walletType.name],
      connectedAt: DateTime.now(),
    );

    _currentWallet = walletInfo;
    _updateState(WalletConnectionState.connected);
    _walletController.add(_currentWallet);

    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('🔑 Mock wallet connected: ${walletType.name}');
      debugPrint('Public Key: $mockPublicKey');
    }

    return true;
  }

  /// Disconnect current wallet
  Future<void> disconnectWallet() async {
    try {
      _currentWallet = null;
      _lastError = null;
      _updateState(WalletConnectionState.disconnected);
      _walletController.add(null);

      if (kDebugMode && AppConfig.enableDebugLogs) {
        debugPrint('🔑 Wallet disconnected');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error disconnecting wallet: $e');
      }
    }
  }

  /// Sign transaction with connected wallet
  Future<String?> signTransaction(String transaction) async {
    if (_currentWallet == null ||
        _currentState != WalletConnectionState.connected) {
      throw StateError('No wallet connected');
    }

    try {
      // TODO: Implement actual transaction signing with connected wallet
      // This would communicate with the wallet app/extension to sign the transaction

      if (kDebugMode) {
        debugPrint('📝 Transaction signing not yet implemented');
        debugPrint('Wallet: ${_currentWallet!.type.name}');
        debugPrint('Transaction: $transaction');
      }

      // For development, return a mock signature
      if (AppConfig.appEnvironment == 'development') {
        return 'mock_signature_${DateTime.now().millisecondsSinceEpoch}';
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Transaction signing error: $e');
      }
      return null;
    }
  }

  /// Sign message with connected wallet
  Future<String?> signMessage(String message) async {
    if (_currentWallet == null ||
        _currentState != WalletConnectionState.connected) {
      throw StateError('No wallet connected');
    }

    try {
      // TODO: Implement actual message signing with connected wallet

      if (kDebugMode) {
        debugPrint('📝 Message signing not yet implemented');
        debugPrint('Wallet: ${_currentWallet!.type.name}');
        debugPrint('Message: $message');
      }

      // For development, return a mock signature
      if (AppConfig.appEnvironment == 'development') {
        return 'mock_message_signature_${DateTime.now().millisecondsSinceEpoch}';
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Message signing error: $e');
      }
      return null;
    }
  }

  /// Check if a specific wallet is installed
  Future<bool> isWalletInstalled(WalletType walletType) async {
    try {
      if (kIsWeb) {
        // TODO: Check for browser extension
        return false;
      } else {
        // For mobile, try to launch the app scheme
        final scheme = WalletConstants.walletSchemes[walletType.name];
        if (scheme == null) return false;

        return await canLaunchUrl(Uri.parse(scheme));
      }
    } catch (e) {
      return false;
    }
  }

  /// Get list of available wallets
  Future<List<WalletType>> getAvailableWallets() async {
    final availableWallets = <WalletType>[];

    for (final walletType in WalletType.values) {
      if (await isWalletInstalled(walletType)) {
        availableWallets.add(walletType);
      }
    }

    // Always include WalletConnect as an option
    if (!availableWallets.contains(WalletType.walletConnect)) {
      availableWallets.add(WalletType.walletConnect);
    }

    return availableWallets;
  }

  /// Update connection state
  void _updateState(WalletConnectionState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }

  // Getters
  WalletConnectionState get currentState => _currentState;
  WalletInfo? get currentWallet => _currentWallet;
  String? get lastError => _lastError;

  // Streams
  Stream<WalletConnectionState> get stateStream => _stateController.stream;
  Stream<WalletInfo?> get walletStream => _walletController.stream;

  /// Dispose resources
  void dispose() {
    _stateController.close();
    _walletController.close();
  }
}
