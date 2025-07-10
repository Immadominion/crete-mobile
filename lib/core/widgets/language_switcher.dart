import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/generated/app_localizations.dart';
import '../constants/app_constants.dart';
import '../cubit/localization_cubit.dart';

/// A widget that allows users to switch between supported languages
class LanguageSwitcher extends StatelessWidget {

  const LanguageSwitcher({
    super.key,
    this.showTitle = true,
    this.padding,
  });
  final bool showTitle;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return BlocBuilder<LocalizationCubit, LocalizationState>(
      builder: (context, state) => Container(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showTitle) ...[
                Text(
                  l10n.language,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
              ],
              ...AppConstants.supportedLocales.map((locale) {
                final isSelected = state.locale == locale;
                final languageName = _getLanguageName(locale);
                
                return RadioListTile<Locale>(
                  value: locale,
                  groupValue: state.locale,
                  onChanged: (Locale? newLocale) {
                    if (newLocale != null) {
                      context.read<LocalizationCubit>().changeLanguage(newLocale);
                    }
                  },
                  title: Text(
                    languageName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    _getLanguageNativeName(locale),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  contentPadding: const EdgeInsets.symmetric(),
                );
              }),
            ],
          ),
        ),
    );
  }

  /// Get the localized language name
  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Spanish';
      case 'fr':
        return 'French';
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  /// Get the native language name
  String _getLanguageNativeName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      default:
        return locale.languageCode;
    }
  }
}

/// A compact dropdown version of the language switcher
class LanguageDropdown extends StatelessWidget {

  const LanguageDropdown({
    super.key,
    this.showLabel = true,
    this.padding,
  });
  final bool showLabel;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return BlocBuilder<LocalizationCubit, LocalizationState>(
      builder: (context, state) => Container(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLabel) ...[
                Text(
                  l10n.language,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
              ],
              DropdownButtonFormField<Locale>(
                value: state.locale,
                items: AppConstants.supportedLocales.map((locale) => DropdownMenuItem<Locale>(
                    value: locale,
                    child: Row(
                      children: [
                        Text(_getLanguageFlag(locale)),
                        const SizedBox(width: 8),
                        Text(_getLanguageName(locale)),
                      ],
                    ),
                  )).toList(),
                onChanged: (Locale? newLocale) {
                  if (newLocale != null) {
                    context.read<LocalizationCubit>().changeLanguage(newLocale);
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  /// Get the language flag emoji
  String _getLanguageFlag(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return '🇺🇸';
      case 'es':
        return '🇪🇸';
      case 'fr':
        return '🇫🇷';
      default:
        return '🌐';
    }
  }

  /// Get the language name
  String _getLanguageName(Locale locale) {
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
}
