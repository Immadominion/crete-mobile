import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Updated brand colors
  static const Color primary = Color(0xFF4A0989); // Primary button color
  static const Color primaryDark = Color(0xFF3A0668); // Darker shade
  static const Color primaryLight = Color(
    0xFF9D4EDD,
  ); // Some tab in design color
  static const Color primaryExtraLight = Color(0xff9d4edd0d); // With opacity

  // Secondary Colors - Additional brand colors
  static const Color secondary = Color(0xFF48E5C2); // Crete logo color
  static const Color secondaryDark = Color(0xFF159677); // Darker teal
  static const Color secondaryButton = Color(
    0xFFDE0298,
  ); // Secondary button color
  static const Color tertiaryButton = Color(
    0xFFB4E5BC,
  ); // Tertiary button color

  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFE5E5E5);
  static const Color gray300 = Color(0xFFD4D4D4);
  static const Color gray400 = Color(0xFFA3A3A3);
  static const Color gray500 = Color(0xFF737373);
  static const Color gray600 = Color(0xFF2C2C2C);
  static const Color gray700 = Color(0x33626262);
  static const Color gray800 = Color(0xFF262626);
  static const Color gray900 = Color(0xFF171717);

  // Navigation Colors
  static const Color navigationInactive = Color(0xFF717171); // Inactive icons
  static const Color navigationBackground = Color(
    0xFF5865F2,
  ); // Navigation background
  static const Color navigationBackgroundSecondary = Color(
    0xff5865f233,
  ); // Secondary container

  // Semantic Colors
  static const Color success = Color(0xFF058D00); // DAO voting completed
  static const Color warning = Color(0xFFF59E0B); // Amber-500
  static const Color error = Color(0xFFD20808); // DAO failed color
  static const Color info = Color(0xFF3B82F6); // Blue-500

  // DAO Status Colors
  static const Color daoActive = Color(0xFF058D00); // DAO completed
  static const Color daoInactive = Color(0xFF6B7280); // Gray
  static const Color daoPending = Color(0xFFF59E0B); // Amber
  static const Color daoVotingInProgress = Color(
    0xFFDDA900,
  ); // DAO voting in progress

  // Voting Colors
  static const Color voteYes = Color(0xFF058D00); // DAO completed green
  static const Color voteNo = Color(0xFFD20808); // DAO failed red
  static const Color voteAbstain = Color(0xFF6B7280); // Gray

  // Chat Colors
  static const Color chatBubbleMe = Color(0xFF4A0989); // Primary
  static const Color chatBubbleOther = Color(0xFFF3F4F6); // Light gray
  static const Color chatOnline = Color(0xFF058D00); // Green
  static const Color chatAway = Color(0xFFF59E0B); // Amber
  static const Color chatOffline = Color(0xFF6B7280); // Gray
  static const Color chatDivider = Color(0xFF2D2D2D); // Chat divider color

  // Background Colors
  static const Color backgroundPrimary = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF9FAFB);
  static const Color backgroundTertiary = Color(0xFFF3F4F6);

  // Dark Mode Colors
  static const Color darkBackgroundPrimary = Color(
    0xFF111111,
  ); // App background dark mode - 0xFF111111
  static const Color darkBackgroundSecondary = Color(0xFF1F2937);
  static const Color darkBackgroundTertiary = Color(0xFF374151);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextHeader = Color(0xFFB5B5B5);
  static const Color darkTextSecondary = Color(0xFFD1D5DB);
  static const Color darkTextLight = Color(0xFFBDBDBD);
  static const Color darkTextHeading = Color(
    0xFFB5B5B5,
  ); // DAO page headings dark mode
  static const Color darkIconBackground = Color(
    0xFF353535,
  ); // Icon background dark mode #353535
  static const Color darkIconColor = Color(0xFF0B0B0B); //#0B0B0B
  static const Color darkEmojiColor = Color(0xFF2D2D2D); //#2D2D2D
  static const Color darkIconForeground = Color(
    0xFF0B0B0B,
  ); // Icon foreground dark mode
  static const Color darkContainerBorder = Color(0xFF212121); // #212121

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
    secondary: secondary,
    onSecondary: gray900,
    surface: darkBackgroundPrimary,
    error: error,
    onError: gray900,
  );
}
