extension SolanaExtensions on String {
  /// Validates if the string is a valid Solana public key
  bool get isValidSolanaPublicKey {
    // Solana public keys are 32 bytes, base58 encoded, typically 32-44 characters
    if (length < 32 || length > 44) {
      return false;
    }

    // Check if it contains only base58 characters
    final base58Regex = RegExp(r'^[1-9A-HJ-NP-Za-km-z]+$');
    return base58Regex.hasMatch(this);
  }

  /// Validates if the string is a valid Solana transaction signature
  bool get isValidSolanaSignature {
    // Solana transaction signatures are 64 bytes, base58 encoded, typically 87-88 characters
    if (length < 87 || length > 88) {
      return false;
    }

    final base58Regex = RegExp(r'^[1-9A-HJ-NP-Za-km-z]+$');
    return base58Regex.hasMatch(this);
  }

  /// Shortens a Solana address for display purposes
  String get shortenedSolanaAddress {
    if (!isValidSolanaPublicKey) return this;
    if (length <= 8) return this;
    return '${substring(0, 4)}...${substring(length - 4)}';
  }

  /// Converts the string to a Solana explorer URL
  String get solanaExplorerUrl {
    if (isValidSolanaPublicKey) {
      return 'https://explorer.solana.com/address/$this';
    } else if (isValidSolanaSignature) {
      return 'https://explorer.solana.com/tx/$this';
    }
    return 'https://explorer.solana.com/';
  }

  /// Converts the string to a Solscan URL
  String get solscanUrl {
    if (isValidSolanaPublicKey) {
      return 'https://solscan.io/account/$this';
    } else if (isValidSolanaSignature) {
      return 'https://solscan.io/tx/$this';
    }
    return 'https://solscan.io/';
  }

  /// Generates a color hash from the Solana address
  int get solanaAddressColor {
    if (!isValidSolanaPublicKey) return 0xFF000000;

    int hash = 0;
    for (int i = 0; i < length; i++) {
      hash = codeUnitAt(i) + ((hash << 5) - hash);
    }

    // Ensure the color is not too dark or too light
    final r = (hash & 0xFF0000) >> 16;
    final g = (hash & 0x00FF00) >> 8;
    final b = hash & 0x0000FF;

    final brightness = (r * 299 + g * 587 + b * 114) / 1000;
    if (brightness < 128) {
      // Too dark, lighten it
      return 0xFF000000 |
          (((r + 128).clamp(0, 255)) << 16) |
          (((g + 128).clamp(0, 255)) << 8) |
          ((b + 128).clamp(0, 255));
    } else if (brightness > 200) {
      // Too light, darken it
      return 0xFF000000 |
          (((r - 64).clamp(0, 255)) << 16) |
          (((g - 64).clamp(0, 255)) << 8) |
          ((b - 64).clamp(0, 255));
    }

    return 0xFF000000 | (hash & 0xFFFFFF);
  }

  /// Generates initials from a Solana address for avatar display
  String get solanaAddressInitials {
    if (!isValidSolanaPublicKey || length < 2) return '??';
    return substring(0, 2).toUpperCase();
  }

  /// Checks if the address is likely a token mint address
  bool get isLikelyTokenMint {
    // This is a heuristic - most token mints start with certain characters
    // This is not foolproof but can be useful for UI hints
    return isValidSolanaPublicKey &&
        (startsWith('So1') || // Common pattern for some tokens
            startsWith('EPj') || // USDC mint
            startsWith('Es9') || // USDT mint
            startsWith('DezX') || // Some DEX tokens
            startsWith('SRM') // Serum tokens
            );
  }

  /// Checks if the address is the native SOL mint
  bool get isNativeSolMint => this == 'So11111111111111111111111111111111111111112';

  /// Converts lamports string to SOL
  double? get lamportsToSol {
    final lamports = int.tryParse(this);
    if (lamports == null) return null;
    return lamports / 1000000000;
  }

  /// Converts SOL string to lamports
  int? get solToLamports {
    final sol = double.tryParse(this);
    if (sol == null) return null;
    return (sol * 1000000000).round();
  }

  /// Validates if the string is a valid SPL token amount
  bool get isValidTokenAmount {
    final amount = double.tryParse(this);
    return amount != null && amount >= 0;
  }

  /// Formats token amount with appropriate decimals
  String formatTokenAmount(int decimals) {
    final amount = double.tryParse(this);
    if (amount == null) return this;

    if (amount == 0) return '0';

    final formatted = amount.toStringAsFixed(decimals);
    // Remove trailing zeros
    return formatted.replaceAll(RegExp(r'\.?0*$'), '');
  }

  /// Checks if the string could be a Solana program ID
  bool get isLikelySolanaProgramId {
    if (!isValidSolanaPublicKey) return false;

    // Common program IDs
    const commonPrograms = [
      'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA', // Token program
      'ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL', // Associated token program
      'Memo1UhkJRfHyvLMcVucJwxXeuD728EqVDDwQDxFMNo', // Memo program
      'ComputeBudget111111111111111111111111111111', // Compute budget program
      'AddressLookupTab1e1111111111111111111111111', // Address lookup table program
    ];

    return commonPrograms.contains(this);
  }

  /// Generates a deterministic avatar pattern from the address
  Map<String, dynamic> get addressPattern {
    if (!isValidSolanaPublicKey) {
      return {'pattern': 'none', 'colors': []};
    }

    final hash = hashCode;
    final patternType = ['grid', 'rings', 'triangles'][hash.abs() % 3];
    final colorCount = 3 + (hash.abs() % 3); // 3-5 colors

    final colors = <int>[];
    for (int i = 0; i < colorCount; i++) {
      final colorHash = hash + (i * 1000);
      colors.add(0xFF000000 | (colorHash.abs() & 0xFFFFFF));
    }

    return {'pattern': patternType, 'colors': colors, 'seed': hash.abs()};
  }

  /// Gets the network for the address (mainnet, devnet, testnet)
  String get inferredNetwork {
    // This is a heuristic based on common patterns
    // In reality, the same address can exist on multiple networks
    if (isValidSolanaPublicKey) {
      // Some patterns that might indicate devnet/testnet
      if (startsWith('Dev') || startsWith('Test')) {
        return 'devnet';
      }
      // Default to mainnet for most addresses
      return 'mainnet-beta';
    }
    return 'unknown';
  }

  /// Checks if the address might be a burner wallet (newly created, low activity)
  bool get isLikelyBurnerWallet {
    if (!isValidSolanaPublicKey) return false;

    // Heuristics for burner wallets:
    // - Addresses with repeating patterns
    final repeatingPattern = RegExp(r'(.)\1{4,}');
    if (repeatingPattern.hasMatch(this)) return true;

    // - Very simple patterns
    if (RegExp('^1{10,}').hasMatch(this)) return true;

    return false;
  }

  /// Gets the estimated rarity of the address pattern
  String get addressRarity {
    if (!isValidSolanaPublicKey) return 'invalid';

    // Count repeating characters
    int maxRepeats = 0;
    int currentRepeats = 1;

    for (int i = 1; i < length; i++) {
      if (this[i] == this[i - 1]) {
        currentRepeats++;
      } else {
        maxRepeats = maxRepeats > currentRepeats ? maxRepeats : currentRepeats;
        currentRepeats = 1;
      }
    }
    maxRepeats = maxRepeats > currentRepeats ? maxRepeats : currentRepeats;

    if (maxRepeats >= 8) return 'legendary';
    if (maxRepeats >= 6) return 'epic';
    if (maxRepeats >= 4) return 'rare';
    if (maxRepeats >= 3) return 'uncommon';
    return 'common';
  }
}
