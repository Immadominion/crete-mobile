// Core application constants
import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Crete DAO';
  static const String appVersion = '1.0.0';

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('es', 'ES'), // Spanish
    Locale('fr', 'FR'), // French
  ];

  // Matrix/Chat constants
  static const String matrixHomeserver = 'https://matrix.crete.app';
  static const Duration messageTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache durations
  static const Duration daoListCacheDuration = Duration(minutes: 5);
  static const Duration proposalCacheDuration = Duration(minutes: 2);

  // Deep linking
  static const String appScheme = 'crete';
  static const String universalLinkDomain = 'app.crete.dao';
}
