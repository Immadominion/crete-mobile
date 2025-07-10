import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:solana/solana.dart';
import '../config/app_config.dart';

/// Service for managing Solana network connections and RPC operations
@singleton
class SolanaNetworkService {
  late SolanaClient _client;
  late RpcClient _rpcClient;

  bool _isInitialized = false;
  String? _currentNetwork;
  String? _currentRpcUrl;

  /// Initialize the Solana network service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Get current network configuration
      _currentNetwork = AppConfig.solanaCluster;
      _currentRpcUrl = AppConfig.solanaRpcUrl;

      // Initialize RPC client
      _rpcClient = RpcClient(_currentRpcUrl!);

      // Initialize Solana client
      _client = SolanaClient(
        rpcUrl: Uri.parse(_currentRpcUrl!),
        websocketUrl: Uri.parse(_currentRpcUrl!.replaceFirst('https://', 'wss://').replaceFirst('http://', 'ws://')),
      );

      // Test connection
      await _testConnection();

      _isInitialized = true;

      if (kDebugMode && AppConfig.enableDebugLogs) {
        debugPrint('🌐 Solana Network Service initialized');
        debugPrint('Network: $_currentNetwork');
        debugPrint('RPC URL: $_currentRpcUrl');
      }

      // Perform initial health check
      await _checkNetworkHealth();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to initialize Solana Network Service: $e');
      }
      rethrow;
    }
  }

  /// Test the connection to the Solana network
  Future<void> _testConnection() async {
    try {
      // Test with a simple getVersion call
      await _rpcClient.getVersion();
      if (kDebugMode) {
        debugPrint('✅ Solana network connection test successful');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Solana network connection test failed: $e');
      }
      throw Exception('Failed to connect to Solana network: $e');
    }
  }

  /// Check network health
  Future<void> _checkNetworkHealth() async {
    try {
      // Check if we can get the latest slot
      final slot = await _rpcClient.getSlot();
      if (kDebugMode) {
        debugPrint('🔍 Current slot: $slot');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Solana network health check failed: $e');
      }
      // Don't throw here - the network might be temporarily unavailable
    }
  }

  /// Get balance for a public key
  Future<double?> getBalance(String publicKey) async {
    _ensureInitialized();

    try {
      final pubKey = Ed25519HDPublicKey.fromBase58(publicKey);
      final balance = await _rpcClient.getBalance(pubKey.toBase58());
      return balance.value / lamportsPerSol;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting balance for $publicKey: $e');
      }
      return null;
    }
  }

  /// Send a transaction
  Future<String?> sendTransaction(String signedTransactionBase64) async {
    _ensureInitialized();

    try {
      final signature = await _rpcClient.sendTransaction(signedTransactionBase64);
      if (kDebugMode) {
        debugPrint('✅ Transaction sent: $signature');
      }
      return signature;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error sending transaction: $e');
      }
      return null;
    }
  }

  /// Get transaction status
  Future<bool> getTransactionStatus(String signature) async {
    _ensureInitialized();

    try {
      final status = await _rpcClient.getSignatureStatuses([signature]);
      return status.value.first?.confirmationStatus != null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting transaction status for $signature: $e');
      }
      return false;
    }
  }

  /// Get recent blockhash
  Future<String?> getRecentBlockhash() async {
    _ensureInitialized();

    try {
      final blockhash = await _rpcClient.getLatestBlockhash();
      return blockhash.value.blockhash;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting recent blockhash: $e');
      }
      return null;
    }
  }

  /// Switch to a different network
  Future<void> switchNetwork(String network, String rpcUrl) async {
    if (_currentNetwork == network && _currentRpcUrl == rpcUrl) return;

    try {
      _currentNetwork = network;
      _currentRpcUrl = rpcUrl;

      // Reinitialize with new network
      _rpcClient = RpcClient(rpcUrl);
      _client = SolanaClient(
        rpcUrl: Uri.parse(rpcUrl),
        websocketUrl: Uri.parse(rpcUrl.replaceFirst('https://', 'wss://').replaceFirst('http://', 'ws://')),
      );

      await _testConnection();

      if (kDebugMode) {
        debugPrint('🔄 Switched to network: $network');
        debugPrint('RPC URL: $rpcUrl');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to switch network: $e');
      }
      rethrow;
    }
  }

  /// Check if the service is initialized
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw Exception('SolanaNetworkService not initialized. Call initialize() first.');
    }
  }

  /// Getters for accessing clients
  SolanaClient get client => _client;
  RpcClient get rpcClient => _rpcClient;
  String? get currentNetwork => _currentNetwork;
  String? get currentRpcUrl => _currentRpcUrl;
  bool get isInitialized => _isInitialized;

  /// Dispose resources
  void dispose() {
    if (_isInitialized) {
      _isInitialized = false;
    }
  }
}
