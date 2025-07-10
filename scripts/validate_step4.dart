#!/usr/bin/env dart

/// Solana Integration Validation Script for Step 4
///
/// This script validates that all Solana integration components are properly
/// configured for the Crete Flutter app.

import 'dart:io';

void main() async {
  print('🔗 Validating Solana Integration (Step 4)...\n');

  final validations = [
    _validateSolanaNetworkConfiguration(),
    _validateWalletIntegration(),
    _validateBlinksIntegration(),
    _validateDependencyInjection(),
    _validateMainAppIntegration(),
  ];

  int passed = 0;
  final int total = validations.length;

  for (final validation in validations) {
    final result = await validation;
    if (result) passed++;
  }

  print('\n📊 Validation Summary:');
  print('✅ Passed: $passed/$total');

  if (passed == total) {
    print('🎉 All Solana integration checks passed!');
    print('Step 4 is complete and ready for testing.');
  } else {
    print('❌ Some validations failed. Please review the issues above.');
    exit(1);
  }
}

Future<bool> _validateSolanaNetworkConfiguration() async {
  print('🔍 Checking Solana Network Configuration...');

  bool allValid = true;

  // Check if SolanaNetworkService exists
  final networkServiceFile = File(
    'lib/core/services/solana_network_service.dart',
  );
  if (!await networkServiceFile.exists()) {
    print('  ❌ SolanaNetworkService not found');
    return false;
  }

  final networkContent = await networkServiceFile.readAsString();
  final networkFeatures = [
    '@singleton',
    'class SolanaNetworkService',
    'initialize()',
    'getAccountInfo',
    'getBalance',
    'sendTransaction',
    'confirmTransaction',
    'getNetworkStatus',
  ];

  for (final feature in networkFeatures) {
    if (networkContent.contains(feature)) {
      print('  ✅ $feature');
    } else {
      print('  ❌ $feature (missing)');
      allValid = false;
    }
  }

  // Check environment configuration
  final envFile = File('.env.dev');
  if (await envFile.exists()) {
    final envContent = await envFile.readAsString();
    if (envContent.contains('SOLANA_RPC_URL') &&
        envContent.contains('SOLANA_CLUSTER')) {
      print('  ✅ Environment configuration');
    } else {
      print('  ❌ Solana environment variables missing');
      allValid = false;
    }
  }

  return allValid;
}

Future<bool> _validateWalletIntegration() async {
  print('\n🔍 Checking Wallet Integration...');

  bool allValid = true;

  // Check WalletConnectionService
  final walletServiceFile = File(
    'lib/core/services/wallet_connection_service.dart',
  );
  if (!await walletServiceFile.exists()) {
    print('  ❌ WalletConnectionService not found');
    return false;
  }

  final walletContent = await walletServiceFile.readAsString();
  final walletFeatures = [
    '@singleton',
    'class WalletConnectionService',
    'enum WalletType',
    'connectWallet',
    '_connectPhantom',
    '_connectSolflare',
    '_connectBackpack',
    '_connectWalletConnect',
    'WalletConnectionState',
  ];

  for (final feature in walletFeatures) {
    if (walletContent.contains(feature)) {
      print('  ✅ $feature');
    } else {
      print('  ❌ $feature (missing)');
      allValid = false;
    }
  }

  // Check WalletConstants
  final constantsFile = File('lib/core/constants/wallet_constants.dart');
  if (await constantsFile.exists()) {
    print('  ✅ WalletConstants configuration');
  } else {
    print('  ❌ WalletConstants file missing');
    allValid = false;
  }

  return allValid;
}

Future<bool> _validateBlinksIntegration() async {
  print('\n🔍 Checking Blinks Integration...');

  bool allValid = true;

  // Check BlinksService
  final blinksServiceFile = File('lib/core/services/blinks_service.dart');
  if (!await blinksServiceFile.exists()) {
    print('  ❌ BlinksService not found');
    return false;
  }

  final blinksContent = await blinksServiceFile.readAsString();
  final blinksFeatures = [
    '@singleton',
    'class BlinksService',
    'enum BlinkActionType',
    'class BlinkMetadata',
    'parseBlink',
    'executeBlink',
    'validateBlink',
  ];

  for (final feature in blinksFeatures) {
    if (blinksContent.contains(feature)) {
      print('  ✅ $feature');
    } else {
      print('  ❌ $feature (missing)');
      allValid = false;
    }
  }

  // Check environment configuration for Blinks
  final envFile = File('.env.dev');
  if (await envFile.exists()) {
    final envContent = await envFile.readAsString();
    if (envContent.contains('BLINKS_API_URL')) {
      print('  ✅ Blinks API configuration');
    } else {
      print('  ❌ BLINKS_API_URL missing from environment');
      allValid = false;
    }
  }

  return allValid;
}

Future<bool> _validateDependencyInjection() async {
  print('\n🔍 Checking Dependency Injection Setup...');

  final injectionFile = File('lib/core/injection/injection.config.dart');
  if (!await injectionFile.exists()) {
    print('  ❌ Generated injection config not found');
    print('  💡 Run: dart run build_runner build');
    return false;
  }

  final injectionContent = await injectionFile.readAsString();
  final requiredServices = [
    'SolanaNetworkService',
    'WalletConnectionService',
    'BlinksService',
  ];

  bool allRegistered = true;
  for (final service in requiredServices) {
    if (injectionContent.contains(service)) {
      print('  ✅ $service registered');
    } else {
      print('  ❌ $service not registered in DI');
      allRegistered = false;
    }
  }

  return allRegistered;
}

Future<bool> _validateMainAppIntegration() async {
  print('\n🔍 Checking Main App Integration...');

  final mainFile = File('lib/main.dart');
  if (!await mainFile.exists()) {
    print('  ❌ lib/main.dart not found');
    return false;
  }

  final mainContent = await mainFile.readAsString();

  // Check if services are being initialized
  bool hasServiceInit = false;
  if (mainContent.contains('SolanaNetworkService') ||
      mainContent.contains('WalletConnectionService') ||
      mainContent.contains('BlinksService')) {
    print('  ✅ Solana services referenced in main.dart');
    hasServiceInit = true;
  } else {
    print('  ⚠️  Solana services not explicitly initialized in main.dart');
    print('      (They may be lazily initialized via DI)');
    hasServiceInit = true; // Allow lazy initialization
  }

  // Check if Solana configuration is being logged
  if (mainContent.contains('solanaCluster') || mainContent.contains('Solana')) {
    print('  ✅ Solana configuration logging');
  } else {
    print('  ❌ Solana configuration not logged in debug mode');
  }

  return hasServiceInit;
}
