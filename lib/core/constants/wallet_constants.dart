// Wallet-related constants for Solana integration
class WalletConstants {
  // Supported wallet types
  static const String phantom = 'phantom';
  static const String solflare = 'solflare';
  static const String backpack = 'backpack';
  static const String walletConnect = 'wallet_connect';

  // Wallet app schemes for deep linking
  static const Map<String, String> walletSchemes = {
    phantom: 'phantom://',
    solflare: 'solflare://',
    backpack: 'backpack://',
  };

  // Wallet display names
  static const Map<String, String> walletNames = {
    phantom: 'Phantom',
    solflare: 'Solflare',
    backpack: 'Backpack',
    walletConnect: 'Other Wallets',
  };

  // Solana network configuration
  static const String mainnetRpc = 'https://api.mainnet-beta.solana.com';
  static const String devnetRpc = 'https://api.devnet.solana.com';
  static const String testnetRpc = 'https://api.testnet.solana.com';

  // Transaction settings
  static const Duration transactionTimeout = Duration(seconds: 60);
  static const int maxRetries = 3;

  // Token standards
  static const String splTokenProgram =
      'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA';
  static const String associatedTokenProgram =
      'ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL';
}
