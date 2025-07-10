import 'package:flutter/material.dart';

import 'colors.dart';
import 'spacing.dart';
import 'typography.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: AppColors.lightColorScheme,
    textTheme: AppTypography.textTheme,
    appBarTheme: _appBarTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    textButtonTheme: _textButtonTheme,
    inputDecorationTheme: _inputDecorationTheme,
    cardTheme: _cardTheme,
    bottomNavigationBarTheme: _bottomNavigationBarTheme,
    navigationBarTheme: _navigationBarTheme,
    dividerTheme: _dividerTheme,
    chipTheme: _chipTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: AppColors.darkColorScheme,
    textTheme: AppTypography.textTheme,
    appBarTheme: _appBarTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    textButtonTheme: _textButtonTheme,
    inputDecorationTheme: _inputDecorationTheme,
    cardTheme: _cardTheme,
    bottomNavigationBarTheme: _bottomNavigationBarTheme,
    navigationBarTheme: _navigationBarTheme,
    dividerTheme: _dividerTheme,
    chipTheme: _chipTheme,
  );

  static AppBarTheme get _appBarTheme =>
      const AppBarTheme(elevation: 0, centerTitle: true, titleSpacing: AppSpacing.md);

  static ElevatedButtonThemeData get _elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
        ),
      );

  static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      minimumSize: const Size(88, 48),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    ),
  );

  static InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.sm),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.sm),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.sm),
    ),
    contentPadding: const EdgeInsets.all(AppSpacing.md),
  );

  static CardThemeData get _cardTheme => const CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(AppSpacing.md)),
    ),
    margin: EdgeInsets.all(AppSpacing.sm),
  );

  static BottomNavigationBarThemeData get _bottomNavigationBarTheme =>
      const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      );

  static NavigationBarThemeData get _navigationBarTheme =>
      const NavigationBarThemeData(
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      );

  static DividerThemeData get _dividerTheme =>
      const DividerThemeData(thickness: 1, space: 1);

  static ChipThemeData get _chipTheme => ChipThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSpacing.xs),
    ),
  );
}
