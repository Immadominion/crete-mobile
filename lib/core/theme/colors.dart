import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Solana-inspired purple theme
  static const Color primary = Color(0xFF8B5CF6); // Purple-500
  static const Color primaryDark = Color(0xFF7C3AED); // Purple-600
  static const Color primaryLight = Color(0xFFA78BFA); // Purple-400
  static const Color primaryExtraLight = Color(0xFFC4B5FD); // Purple-300

  // Secondary Colors - Accent colors for highlights
  static const Color secondary = Color(0xFF10B981); // Emerald-500
  static const Color secondaryDark = Color(0xFF059669); // Emerald-600
  static const Color secondaryLight = Color(0xFF34D399); // Emerald-400

  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFE5E5E5);
  static const Color gray300 = Color(0xFFD4D4D4);
  static const Color gray400 = Color(0xFFA3A3A3);
  static const Color gray500 = Color(0xFF737373);
  static const Color gray600 = Color(0xFF525252);
  static const Color gray700 = Color(0xFF404040);
  static const Color gray800 = Color(0xFF262626);
  static const Color gray900 = Color(0xFF171717);

  // Semantic Colors
  static const Color success = Color(0xFF10B981); // Green-500
  static const Color warning = Color(0xFFF59E0B); // Amber-500
  static const Color error = Color(0xFFEF4444); // Red-500
  static const Color info = Color(0xFF3B82F6); // Blue-500

  // DAO Status Colors
  static const Color daoActive = Color(0xFF10B981); // Green
  static const Color daoInactive = Color(0xFF6B7280); // Gray
  static const Color daoPending = Color(0xFFF59E0B); // Amber

  // Voting Colors
  static const Color voteYes = Color(0xFF10B981); // Green
  static const Color voteNo = Color(0xFFEF4444); // Red
  static const Color voteAbstain = Color(0xFF6B7280); // Gray

  // Chat Colors
  static const Color chatBubbleMe = Color(0xFF8B5CF6); // Primary
  static const Color chatBubbleOther = Color(0xFFF3F4F6); // Light gray
  static const Color chatOnline = Color(0xFF10B981); // Green
  static const Color chatAway = Color(0xFFF59E0B); // Amber
  static const Color chatOffline = Color(0xFF6B7280); // Gray

  // Background Colors
  static const Color backgroundPrimary = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF9FAFB);
  static const Color backgroundTertiary = Color(0xFFF3F4F6);

  // Dark Mode Colors
  static const Color darkBackgroundPrimary = Color(0xFF111827);
  static const Color darkBackgroundSecondary = Color(0xFF1F2937);
  static const Color darkBackgroundTertiary = Color(0xFF374151);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFD1D5DB);

  // Wallet Colors
  static const Color phantom = Color(0xFF4C1D95); // Deep purple
  static const Color solflare = Color(0xFFFC9F00); // Orange
  static const Color backpack = Color(0xFF1C1C1C); // Dark
  static const Color walletConnect = Color(0xFF3B99FC); // Blue

  // ColorScheme methods
  static ColorScheme get lightColorScheme => const ColorScheme.light(
    primary: primary,
    secondary: secondary,
    onSecondary: white,
    onSurface: gray900,
    error: error,
  );

  static ColorScheme get darkColorScheme => const ColorScheme.dark(
    primary: primaryLight,
    onPrimary: gray900,
    secondary: secondaryLight,
    onSecondary: gray900,
    surface: darkBackgroundSecondary,
    error: error,
    onError: gray900,
  );
}
