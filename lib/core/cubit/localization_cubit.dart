import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../services/localization_service.dart';


/// Cubit for managing localization state
@injectable
class LocalizationCubit extends Cubit<LocalizationState> {

  LocalizationCubit(this._localizationService) 
      : super(LocalizationState(locale: _localizationService.currentLocale));
  final LocalizationService _localizationService;

  /// Initialize the cubit
  Future<void> initialize() async {
    await _localizationService.initialize();
    emit(LocalizationState(locale: _localizationService.currentLocale));
  }

  /// Change the app language
  Future<void> changeLanguage(Locale newLocale) async {
    if (state.locale == newLocale) return;

    try {
      await _localizationService.changeLanguage(newLocale);
      emit(LocalizationState(locale: newLocale));
    } catch (e) {
      emit(LocalizationState(
        locale: state.locale,
        error: e.toString(),
      ));
    }
  }

  /// Reset to system locale
  Future<void> resetToSystemLocale() async {
    try {
      await _localizationService.resetToSystemLocale();
      emit(LocalizationState(locale: _localizationService.currentLocale));
    } catch (e) {
      emit(LocalizationState(
        locale: state.locale,
        error: e.toString(),
      ));
    }
  }

  /// Get supported locales
  List<Locale> get supportedLocales => _localizationService.supportedLocales;

  /// Get locale display name
  String getLocaleDisplayName(Locale locale) => _localizationService.getLocaleDisplayName(locale);

  /// Get native display name
  String getLocaleNativeDisplayName(Locale locale) => _localizationService.getLocaleNativeDisplayName(locale);

  /// Check if locale is RTL
  bool isRTL(Locale locale) => _localizationService.isRTL(locale);

  /// Get text direction
  TextDirection get textDirection => _localizationService.textDirection;

  /// Clear any errors
  void clearError() {
    if (state.error != null) {
      emit(LocalizationState(locale: state.locale));
    }
  }
}

/// State for localization
class LocalizationState extends Equatable {

  const LocalizationState({
    required this.locale,
    this.error,
  });
  final Locale locale;
  final String? error;

  @override
  List<Object?> get props => [locale, error];

  LocalizationState copyWith({
    Locale? locale,
    String? error,
  }) => LocalizationState(
      locale: locale ?? this.locale,
      error: error,
    );
}
