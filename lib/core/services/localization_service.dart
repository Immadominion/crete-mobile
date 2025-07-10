import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/generated/app_localizations.dart';
import '../constants/app_constants.dart';

/// Service for managing app localization and language preferences
@singleton
class LocalizationService {
  static const String _languageKey = 'app_language';
  static const String _countryKey = 'app_country';
  
  late SharedPreferences _prefs;
  Locale _currentLocale = const Locale('en', 'US');
  
  /// Initialize the localization service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSavedLocale();
  }
  
  /// Get the current locale
  Locale get currentLocale => _currentLocale;
  
  /// Get supported locales
  List<Locale> get supportedLocales => AppConstants.supportedLocales;
  
  /// Get localization delegates
  static List<LocalizationsDelegate<dynamic>> get delegates => [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
  
  /// Load saved locale from preferences
  Future<void> _loadSavedLocale() async {
    final languageCode = _prefs.getString(_languageKey);
    final countryCode = _prefs.getString(_countryKey);
    
    if (languageCode != null) {
      _currentLocale = Locale(languageCode, countryCode);
    } else {
      // Use system locale as fallback
      _currentLocale = _getSystemLocale();
    }
  }
  
  /// Get system locale
  Locale _getSystemLocale() {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    
    // Check if system locale is supported
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == systemLocale.languageCode) {
        return supportedLocale;
      }
    }
    
    // Fallback to English if system locale is not supported
    return const Locale('en', 'US');
  }
  
  /// Change the app language
  Future<void> changeLanguage(Locale newLocale) async {
    if (_currentLocale == newLocale) return;
    
    // Validate that the locale is supported
    if (!supportedLocales.contains(newLocale)) {
      throw ArgumentError('Unsupported locale: $newLocale');
    }
    
    _currentLocale = newLocale;
    
    // Save to preferences
    await _prefs.setString(_languageKey, newLocale.languageCode);
    if (newLocale.countryCode != null) {
      await _prefs.setString(_countryKey, newLocale.countryCode!);
    } else {
      await _prefs.remove(_countryKey);
    }
  }
  
  /// Get the display name for a locale
  String getLocaleDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      default:
        return locale.languageCode.toUpperCase();
    }
  }
  
  /// Get native display name for a locale
  String getLocaleNativeDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      default:
        return locale.languageCode.toUpperCase();
    }
  }
  
  /// Check if a locale is RTL (Right-to-Left)
  bool isRTL(Locale locale) {
    // Add RTL language codes here
    const rtlLanguages = [
      'ar', // Arabic
      'he', // Hebrew
      'fa', // Persian
      'ur', // Urdu
    ];
    
    return rtlLanguages.contains(locale.languageCode);
  }
  
  /// Get text direction for current locale
  TextDirection get textDirection => isRTL(_currentLocale) ? TextDirection.rtl : TextDirection.ltr;
  
  /// Reset to system locale
  Future<void> resetToSystemLocale() async {
    final systemLocale = _getSystemLocale();
    await changeLanguage(systemLocale);
  }
  
  /// Get locale from language code
  Locale getLocaleFromLanguageCode(String languageCode) {
    for (final locale in supportedLocales) {
      if (locale.languageCode == languageCode) {
        return locale;
      }
    }
    return const Locale('en', 'US');
  }
  
  /// Format locale for display
  String formatLocaleForDisplay(Locale locale) {
    if (locale.countryCode != null) {
      return '${locale.languageCode}_${locale.countryCode}';
    }
    return locale.languageCode;
  }
}
