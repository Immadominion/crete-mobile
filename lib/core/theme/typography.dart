import 'package:flutter/material.dart';
import 'colors.dart';

class AppTypography {
  // Font Family - Updated to Geist
  static const String fontFamily = 'Geist';
  static const String headingFontFamily = 'Geist';
  static const String sfProFontFamily = 'SF Pro';

  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Geist Typography Styles based on provided specs
  static const TextStyle geistSemiBold15 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: semiBold,
    letterSpacing: -0.6,
    height: 22/15, // 22px line height
  );

  static const TextStyle geistMedium13 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: medium,
    letterSpacing: -0.6,
    height: 22/13, // 22px line height
  );

  static const TextStyle geistRegular14 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: regular,
    letterSpacing: 0,
    height: 22/14, // 22px line height
  );

  static const TextStyle geistMedium11 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: medium,
    letterSpacing: -0.6,
    height: 22/11, // 22px line height
  );

  static const TextStyle geistSemiBold13 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: semiBold,
    letterSpacing: -0.6,
    height: 22/13, // 22px line height
  );

  static const TextStyle geistRegular11 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: regular,
    letterSpacing: -0.6,
    height: 1.0, // 100% line height
  );

  static const TextStyle geistRegular11_22 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: regular,
    letterSpacing: -0.6,
    height: 22/11, // 22px line height
  );

  static const TextStyle geistRegular12 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: regular,
    letterSpacing: 0,
    height: 22/12, // 22px line height
  );

  static const TextStyle sfProSemiBold32 = TextStyle(
    fontFamily: sfProFontFamily,
    fontSize: 32,
    fontWeight: semiBold, // Using semiBold instead of w590
    letterSpacing: 0,
    height: 22/32, // 22px line height
  );

  // Display Styles (Large headings)
  static const TextStyle display1 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 96,
    fontWeight: extraBold,
    letterSpacing: -1.5,
    height: 1.12,
  );

  static const TextStyle display2 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 60,
    fontWeight: extraBold,
    letterSpacing: -0.5,
    height: 1.16,
  );

  static const TextStyle display3 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 48,
    fontWeight: bold,
    letterSpacing: 0,
    height: 1.17,
  );

  // Heading Styles
  static const TextStyle heading1 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 36,
    fontWeight: bold,
    letterSpacing: -0.25,
    height: 1.22,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 32,
    fontWeight: bold,
    letterSpacing: 0,
    height: 1.25,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 28,
    fontWeight: semiBold,
    letterSpacing: 0,
    height: 1.29,
  );

  static const TextStyle heading4 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 24,
    fontWeight: semiBold,
    letterSpacing: 0.25,
    height: 1.33,
  );

  static const TextStyle heading5 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 20,
    fontWeight: semiBold,
    letterSpacing: 0,
    height: 1.4,
  );

  static const TextStyle heading6 = TextStyle(
    fontFamily: headingFontFamily,
    fontSize: 18,
    fontWeight: semiBold,
    letterSpacing: 0.15,
    height: 1.44,
  );

  // Body Text Styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: regular,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: regular,
    letterSpacing: 0.25,
    height: 1.43,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: regular,
    letterSpacing: 0.4,
    height: 1.33,
  );

  // Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: 0.1,
    height: 1.43,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: 1.33,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: 1.45,
  );

  // Button Text Styles
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: semiBold,
    letterSpacing: 0.5,
    height: 1.25,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: semiBold,
    letterSpacing: 0.25,
    height: 1.29,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: semiBold,
    letterSpacing: 0.5,
    height: 1.33,
  );

  // Caption and Overline
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: regular,
    letterSpacing: 0.4,
    height: 1.33,
  );

  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: regular,
    letterSpacing: 1.5,
    height: 1.6,
  );

  // Helper method to apply color to text styles
  static TextStyle withColor(TextStyle style, Color color) => style.copyWith(color: color);

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

  // Geist-based common styles
  static TextStyle get daoPageHeading => withColor(geistSemiBold15, AppColors.darkTextHeading);
  static TextStyle get tabLabel => withColor(geistMedium13, AppColors.primary);
  static TextStyle get buttonText => withColor(geistSemiBold13, AppColors.white);
  static TextStyle get bodyText => withColor(geistRegular14, AppColors.gray800);
  static TextStyle get smallLabel => withColor(geistMedium11, AppColors.gray600);

  // TextTheme for Material 3
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
    labelLarge: buttonLarge,
    labelMedium: caption,
    labelSmall: overline,
  );
}
