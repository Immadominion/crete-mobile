// ignore_for_file: prefer_final_locals

import 'dart:convert';
import 'dart:typed_data';

class CryptoUtils {
  /// Validates a Solana public key format
  static bool isValidSolanaAddress(String address) {
    if (address.length < 32 || address.length > 44) {
      return false;
    }

    // Basic base58 character check
    final base58Regex = RegExp(r'^[1-9A-HJ-NP-Za-km-z]+$');
    return base58Regex.hasMatch(address);
  }

  /// Shortens a wallet address for display
  static String shortenAddress(
    String address, {
    int startChars = 4,
    int endChars = 4,
  }) {
    if (address.length <= startChars + endChars) {
      return address;
    }
    return '${address.substring(0, startChars)}...${address.substring(address.length - endChars)}';
  }

  /// Converts lamports to SOL
  static double lamportsToSol(int lamports) => lamports / 1000000000;

  /// Converts SOL to lamports
  static int solToLamports(double sol) => (sol * 1000000000).round();

  /// Formats a token amount with proper decimals
  static String formatTokenAmount(int amount, int decimals) {
    final divisor = BigInt.from(10).pow(decimals);
    final result = amount / divisor.toDouble();
    return result.toStringAsFixed(decimals).replaceAll(RegExp(r'\.?0*$'), '');
  }

  /// Validates a transaction signature
  static bool isValidSignature(String signature) {
    // Solana transaction signatures are typically 64 characters long (base64)
    if (signature.length != 88) {
      return false;
    }

    // Basic base64 character check
    final base64Regex = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
    return base64Regex.hasMatch(signature);
  }

  /// Generates a deterministic color from a wallet address
  static int getColorFromAddress(String address) {
    int hash = address.hashCode;

    // Ensure we get a valid color (not too dark or too light)
    final r = (hash & 0xFF0000) >> 16;
    final g = (hash & 0x00FF00) >> 8;
    final b = hash & 0x0000FF;

    // Adjust brightness to ensure readability
    final brightness = (r * 299 + g * 587 + b * 114) / 1000;
    if (brightness < 128) {
      // Too dark, lighten it
      return 0xFF000000 |
          (((r + 128) & 0xFF) << 16) |
          (((g + 128) & 0xFF) << 8) |
          ((b + 128) & 0xFF);
    } else if (brightness > 200) {
      // Too light, darken it
      return 0xFF000000 |
          (((r - 64) & 0xFF) << 16) |
          (((g - 64) & 0xFF) << 8) |
          ((b - 64) & 0xFF);
    }

    return 0xFF000000 | hash;
  }

  /// Generates initials from a wallet address for avatar
  static String getInitialsFromAddress(String address) {
    if (address.length < 2) {
      return '??';
    }
    return address.substring(0, 2).toUpperCase();
  }

  /// Validates a token mint address
  static bool isValidMintAddress(String mintAddress) =>
      isValidSolanaAddress(mintAddress);

  /// Encodes a string to base64
  static String encodeBase64(String input) => base64Encode(utf8.encode(input));

  /// Decodes a base64 string
  static String decodeBase64(String encoded) {
    try {
      return utf8.decode(base64Decode(encoded));
    } catch (e) {
      throw FormatException('Invalid base64 string: $encoded');
    }
  }

  /// Converts bytes to hex string
  static String bytesToHex(Uint8List bytes) =>
      bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

  /// Converts hex string to bytes
  static Uint8List hexToBytes(String hex) {
    if (hex.length % 2 != 0) {
      throw const FormatException('Hex string must have even length');
    }

    final bytes = <int>[];
    for (int i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }

    return Uint8List.fromList(bytes);
  }

  /// Validates a transaction amount
  static bool isValidAmount(String amount) {
    final regex = RegExp(r'^\d+(\.\d+)?$');
    if (!regex.hasMatch(amount)) {
      return false;
    }

    final value = double.tryParse(amount);
    return value != null && value > 0;
  }

  /// Formats a large number with appropriate suffix (K, M, B)
  static String formatLargeNumber(num value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }

  /// Validates a governance token amount
  static bool isValidGovernanceAmount(String amount, int decimals) {
    if (!isValidAmount(amount)) {
      return false;
    }

    final maxDecimals = amount.split('.').length > 1
        ? amount.split('.')[1].length
        : 0;

    return maxDecimals <= decimals;
  }

  /// Generates a unique identifier from a string
  static String generateId(String input) => input.hashCode.abs().toString();

  /// Checks if a string is a valid JSON
  static bool isValidJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Calculates percentage change between two values
  static double calculatePercentageChange(double oldValue, double newValue) {
    if (oldValue == 0) {
      return 0;
    }
    return ((newValue - oldValue) / oldValue) * 100;
  }

  /// Formats percentage with sign
  static String formatPercentageChange(double percentage) {
    final sign = percentage >= 0 ? '+' : '';
    return '$sign${percentage.toStringAsFixed(2)}%';
  }

  /// Validates a Discord user ID
  static bool isValidDiscordId(String id) {
    // Discord snowflakes are 17-19 digits
    final regex = RegExp(r'^\d{17,19}$');
    return regex.hasMatch(id);
  }

  /// Extracts domain from URL
  static String? extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return null;
    }
  }

  /// Validates a blink URL format
  static bool isValidBlinkUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme &&
          (uri.scheme == 'https' || uri.scheme == 'http') &&
          uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
