import 'package:flutter/material.dart';
import 'colors.dart';

class AppTypography {
  // Font Families - Modular system for different contexts
  static const String primaryFontFamily = 'Geist'; // Main app font
  static const String secondaryFontFamily = 'Inter'; // Secondary screens
  static const String tertiaryFontFamily = 'DM Sans'; // Specific use cases
  static const String systemFontFamily = 'SF Pro'; // System-specific text

  // Legacy support
  static const String fontFamily = primaryFontFamily;
  static const String headingFontFamily = primaryFontFamily;
  static const String sfProFontFamily = systemFontFamily;

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Geist Typography Styles (Primary - for dashboard and main app)
  static const TextStyle geistSemiBold15 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 15,
    fontWeight: semiBold,
    letterSpacing: -0.6,
    height: 22/15, // 22px line height
  );

  static const TextStyle geistMedium13 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 13,
    fontWeight: medium,
    letterSpacing: -0.6,
    height: 22/13, // 22px line height
  );

  static const TextStyle geistRegular14 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: regular,
    letterSpacing: 0,
    height: 22/14, // 22px line height
  );

  static const TextStyle geistMedium11 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 11,
    fontWeight: medium,
    letterSpacing: -0.6,
    height: 22/11, // 22px line height
  );

  static const TextStyle geistSemiBold13 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 13,
    fontWeight: semiBold,
    letterSpacing: -0.6,
    height: 22/13, // 22px line height
  );

  static const TextStyle geistRegular11 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 11,
    fontWeight: regular,
    letterSpacing: -0.6,
    height: 1.0, // 100% line height
  );

  static const TextStyle geistRegular11_22 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 11,
    fontWeight: regular,
    letterSpacing: -0.6,
    height: 22/11, // 22px line height
  );

  static const TextStyle geistRegular12 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12,
    fontWeight: regular,
    letterSpacing: 0,
    height: 22/12, // 22px line height
  );

  // Inter Typography Styles (Secondary - for specific screens)
  static const TextStyle interSemiBold32 = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 32,
    fontWeight: semiBold,
    letterSpacing: -32 * 0.03, // -3% letter spacing
    height: 1.0, // 100% line height
  );

  static const TextStyle interMedium16 = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 16,
    fontWeight: medium,
    letterSpacing: -16 * 0.02, // -2% letter spacing
    height: 1.0, // 100% line height
  );

  static const TextStyle interRegular14 = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 14,
    fontWeight: regular,
    letterSpacing: -14 * 0.03, // -3% letter spacing
    height: 1.0, // 100% line height
  );

  // DM Sans Typography Styles (Tertiary - for specific use cases)
  static const TextStyle dmSansRegular14 = TextStyle(
    fontFamily: tertiaryFontFamily,
    fontSize: 14,
    fontWeight: regular,
    letterSpacing: -14 * 0.03, // -3% letter spacing
    height: 1.0, // 100% line height
  );

  static const TextStyle dmSansMedium16 = TextStyle(
    fontFamily: tertiaryFontFamily,
    fontSize: 16,
    fontWeight: medium,
    letterSpacing: -16 * 0.02, // -2% letter spacing
    height: 1.0, // 100% line height
  );

  // SF Pro Typography Styles (System)
  static const TextStyle sfProSemiBold32 = TextStyle(
    fontFamily: systemFontFamily,
    fontSize: 32,
    fontWeight: semiBold, // Using semiBold instead of w590
    letterSpacing: 0,
    height: 22/32, // 22px line height
  );

  // Display Styles (Large headings) - Using primary font
  static const TextStyle display1 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 96,
    fontWeight: extraBold,
    letterSpacing: -1.5,
    height: 1.12,
  );

  static const TextStyle display2 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 60,
    fontWeight: extraBold,
    letterSpacing: -0.5,
    height: 1.16,
  );

  static const TextStyle display3 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 48,
    fontWeight: bold,
    letterSpacing: 0,
    height: 1.17,
  );

  // Heading Styles - Using primary font
  static const TextStyle heading1 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 36,
    fontWeight: bold,
    letterSpacing: -0.25,
    height: 1.22,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 32,
    fontWeight: bold,
    letterSpacing: 0,
    height: 1.25,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 28,
    fontWeight: semiBold,
    letterSpacing: 0,
    height: 1.29,
  );

  static const TextStyle heading4 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 24,
    fontWeight: semiBold,
    letterSpacing: 0.25,
    height: 1.33,
  );

  static const TextStyle heading5 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 20,
    fontWeight: semiBold,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle heading6 = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 18,
    fontWeight: semiBold,
    letterSpacing: 0.15,
    height: 1.44,
  );

  // Body Text Styles - Using primary font
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 16,
    fontWeight: regular,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: regular,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12,
    fontWeight: regular,
    letterSpacing: 0.4,
    height: 1.33,
  );

  // Label Styles - Using primary font
  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: 1.33,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 11,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: 1.45,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: semiBold,
    letterSpacing: 0.25,
    height: 1.29,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12,
    fontWeight: semiBold,
    letterSpacing: 0.5,
    height: 1.33,
  );

  // Caption and Overline
  static const TextStyle caption = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12,
    fontWeight: regular,
    letterSpacing: 0.4,
    height: 1.33,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 10,
    fontWeight: regular,
    letterSpacing: 1.5,
    height: 1.6,
  );

  // Dynamic Theme Helper - For agentic app manager
  static TextStyle createCustomStyle({
    required String fontFamily,
    required double fontSize,
    required FontWeight fontWeight,
    required double letterSpacing,
    required double height,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
      color: color,
    );
  }

  // Helper method to apply color to text styles
  static TextStyle withColor(TextStyle style, Color color) => style.copyWith(color: color);

  // Helper method to apply font family to text styles
  static TextStyle withFontFamily(TextStyle style, String fontFamily) => style.copyWith(fontFamily: fontFamily);

  // Helper method to apply font size to text styles
  static TextStyle withFontSize(TextStyle style, double fontSize) => style.copyWith(fontSize: fontSize);

  // Common color combinations for light mode
  static TextStyle get primaryHeading => withColor(heading2, AppColors.gray900);
  static TextStyle get secondaryHeading => withColor(heading4, AppColors.gray700);
  static TextStyle get primaryBody => withColor(bodyMedium, AppColors.gray800);
  static TextStyle get secondaryBody => withColor(bodySmall, AppColors.gray600);
  static TextStyle get mutedText => withColor(caption, AppColors.gray500);

  // Common color combinations for dark mode
  static TextStyle get darkPrimaryHeading => withColor(heading2, AppColors.darkTextPrimary);
  static TextStyle get darkSecondaryHeading => withColor(heading4, AppColors.darkTextHeading);
  static TextStyle get darkPrimaryBody => withColor(bodyMedium, AppColors.darkTextSecondary);
  static TextStyle get darkSecondaryBody => withColor(bodySmall, AppColors.darkTextSecondary);
  static TextStyle get darkMutedText => withColor(caption, AppColors.darkTextHeading);

  // Context-specific styles - Dashboard/Main app (Geist)
  static TextStyle get daoPageHeading => withColor(geistSemiBold15, AppColors.darkTextHeading);
  static TextStyle get tabLabel => withColor(geistMedium13, AppColors.primary);
  static TextStyle get buttonText => withColor(geistSemiBold13, AppColors.white);
  static TextStyle get bodyText => withColor(geistRegular14, AppColors.gray800);
  static TextStyle get smallLabel => withColor(geistMedium11, AppColors.gray600);

  // Context-specific styles - Connect Wallet screen (Inter + DM Sans)
  static TextStyle get walletTitle => withColor(interSemiBold32, AppColors.gray900);
  static TextStyle get walletDescription => withColor(dmSansRegular14, AppColors.gray600);
  static TextStyle get walletButton => withColor(dmSansMedium16, AppColors.white);
  static TextStyle get walletSecondaryText => withColor(interRegular14, AppColors.gray500);

  // Font family getters for dynamic theme switching
  static String get currentPrimaryFont => primaryFontFamily;
  static String get currentSecondaryFont => secondaryFontFamily;
  static String get currentTertiaryFont => tertiaryFontFamily;

  // TextTheme for Material 3 - Uses primary font family
  static TextTheme get textTheme => const TextTheme(
    displayLarge: display1,
    displayMedium: display2,
    displaySmall: display3,
    headlineLarge: heading1,
    headlineMedium: heading2,
    headlineSmall: heading3,
    titleLarge: heading4,
    titleMedium: heading5,
    titleSmall: heading6,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: caption,
    labelSmall: overline,
  );

  // Dynamic TextTheme generator for agentic app manager
  static TextTheme createCustomTextTheme({
    required String fontFamily,
    Color? textColor,
  }) {
    return TextTheme(
      displayLarge: withFontFamily(display1, fontFamily),
      displayMedium: withFontFamily(display2, fontFamily),
      displaySmall: withFontFamily(display3, fontFamily),
      headlineLarge: withFontFamily(heading1, fontFamily),
      headlineMedium: withFontFamily(heading2, fontFamily),
      headlineSmall: withFontFamily(heading3, fontFamily),
      titleLarge: withFontFamily(heading4, fontFamily),
      titleMedium: withFontFamily(heading5, fontFamily),
      titleSmall: withFontFamily(heading6, fontFamily),
      bodyLarge: withFontFamily(bodyLarge, fontFamily),
      bodyMedium: withFontFamily(bodyMedium, fontFamily),
      bodySmall: withFontFamily(bodySmall, fontFamily),
      labelLarge: withFontFamily(labelLarge, fontFamily),
      labelMedium: withFontFamily(caption, fontFamily),
      labelSmall: withFontFamily(overline, fontFamily),
    ).apply(bodyColor: textColor, displayColor: textColor);
  }
}
