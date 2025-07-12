import 'package:flutter/material.dart';

import 'colors.dart';
import 'spacing.dart';
import 'typography.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: AppColors.lightColorScheme,
    textTheme: AppTypography.textTheme,
    scaffoldBackgroundColor: AppColors.backgroundPrimary,
    appBarTheme: _lightAppBarTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    textButtonTheme: _textButtonTheme,
    inputDecorationTheme: _inputDecorationTheme,
    cardTheme: _lightCardTheme,
    bottomNavigationBarTheme: _lightBottomNavigationBarTheme,
    navigationBarTheme: _navigationBarTheme,
    dividerTheme: _lightDividerTheme,
    chipTheme: _chipTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: AppColors.darkColorScheme,
    textTheme: AppTypography.textTheme,
    scaffoldBackgroundColor: AppColors.darkBackgroundPrimary,
    appBarTheme: _darkAppBarTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    textButtonTheme: _textButtonTheme,
    inputDecorationTheme: _inputDecorationTheme,
    cardTheme: _darkCardTheme,
    bottomNavigationBarTheme: _darkBottomNavigationBarTheme,
    navigationBarTheme: _navigationBarTheme,
    dividerTheme: _darkDividerTheme,
    chipTheme: _chipTheme,
  );

  // Light Theme Components
  static AppBarTheme get _lightAppBarTheme => const AppBarTheme(
    elevation: 0,
    centerTitle: true,
    titleSpacing: AppSpacing.md,
    backgroundColor: AppColors.backgroundPrimary,
    foregroundColor: AppColors.gray900,
    surfaceTintColor: Colors.transparent,
  );

  // Dark Theme Components
  static AppBarTheme get _darkAppBarTheme => const AppBarTheme(
    elevation: 0,
    centerTitle: true,
    titleSpacing: AppSpacing.md,
    backgroundColor: AppColors.darkBackgroundPrimary,
    foregroundColor: AppColors.darkTextPrimary,
    surfaceTintColor: Colors.transparent,
  );

  static ElevatedButtonThemeData get _elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
        ),
      );

  static OutlinedButtonThemeData get _outlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
        ),
      );

  static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      minimumSize: const Size(88, 48),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      foregroundColor: AppColors.primary,
    ),
  );

  static InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.sm),
      borderSide: const BorderSide(color: AppColors.gray300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.sm),
      borderSide: const BorderSide(color: AppColors.gray300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.sm),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
    contentPadding: const EdgeInsets.all(AppSpacing.md),
  );

  // Light Card Theme
  static CardThemeData get _lightCardTheme => const CardThemeData(
    elevation: 2,
    color: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppSpacing.md)),
    ),
    margin: EdgeInsets.all(AppSpacing.sm),
  );

  // Dark Card Theme
  static CardThemeData get _darkCardTheme => const CardThemeData(
    elevation: 2,
    color: AppColors.darkBackgroundSecondary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppSpacing.md)),
    ),
    margin: EdgeInsets.all(AppSpacing.sm),
  );

  // Light Bottom Navigation
  static BottomNavigationBarThemeData get _lightBottomNavigationBarTheme =>
      const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        backgroundColor: AppColors.backgroundPrimary,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.gray500,
      );

  // Dark Bottom Navigation
  static BottomNavigationBarThemeData get _darkBottomNavigationBarTheme =>
      const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        backgroundColor: AppColors.darkBackgroundPrimary,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.navigationInactive,
      );

  static NavigationBarThemeData get _navigationBarTheme =>
      const NavigationBarThemeData(
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      );

  // Light Divider Theme
  static DividerThemeData get _lightDividerTheme =>
      const DividerThemeData(
        thickness: 1,
        space: 1,
        color: AppColors.gray200,
      );

  // Dark Divider Theme
  static DividerThemeData get _darkDividerTheme =>
      const DividerThemeData(
        thickness: 1,
        space: 1,
        color: AppColors.chatDivider,
      );

  static ChipThemeData get _chipTheme => ChipThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.xs),
    ),
  );
}
