import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'Crete'**
  String get appName;

  /// Welcome message on the main screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to Crete'**
  String get welcome;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Add button text
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Search placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Profile screen title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Wallet screen title
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// Transactions screen title
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// Balance label
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// Send button text
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Receive button text
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get receive;

  /// Amount label
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Address label
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Transaction label
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction;

  /// Pending status
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Completed status
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Failed status
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Network connection error. Please check your internet connection and try again.'**
  String get networkError;

  /// Invalid address error message
  ///
  /// In en, this message translates to:
  /// **'Invalid address format'**
  String get invalidAddress;

  /// Insufficient balance error message
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance'**
  String get insufficientBalance;

  /// Transaction failed error message
  ///
  /// In en, this message translates to:
  /// **'Transaction failed. Please try again.'**
  String get transactionFailed;

  /// Connect wallet button text
  ///
  /// In en, this message translates to:
  /// **'Connect Wallet'**
  String get connectWallet;

  /// Disconnect wallet button text
  ///
  /// In en, this message translates to:
  /// **'Disconnect Wallet'**
  String get disconnectWallet;

  /// Wallet connected status message
  ///
  /// In en, this message translates to:
  /// **'Wallet Connected'**
  String get walletConnected;

  /// Wallet disconnected status message
  ///
  /// In en, this message translates to:
  /// **'Wallet Disconnected'**
  String get walletDisconnected;

  /// Empty transactions list message
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get noTransactions;

  /// Refresh button text
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Copy button text
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Copied to clipboard message
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copied;

  /// Share button text
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Back button text
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Previous button text
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Done button text
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Theme setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Notifications setting label
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Security setting label
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// About section label
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Sign out button text
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Sign in button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Confirm password label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Reset password button text
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// Enter email placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterEmail;

  /// Enter password placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// Invalid email error message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// Password too short error message
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get passwordTooShort;

  /// Password mismatch error message
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// Account created success message
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get accountCreated;

  /// Welcome back message
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// Solana network label
  ///
  /// In en, this message translates to:
  /// **'Solana Network'**
  String get solanaNetwork;

  /// Mainnet network option
  ///
  /// In en, this message translates to:
  /// **'Mainnet'**
  String get mainnet;

  /// Devnet network option
  ///
  /// In en, this message translates to:
  /// **'Devnet'**
  String get devnet;

  /// Testnet network option
  ///
  /// In en, this message translates to:
  /// **'Testnet'**
  String get testnet;

  /// Blinks feature label
  ///
  /// In en, this message translates to:
  /// **'Blinks'**
  String get blinks;

  /// Action required message
  ///
  /// In en, this message translates to:
  /// **'Action Required'**
  String get actionRequired;

  /// Processing transaction message
  ///
  /// In en, this message translates to:
  /// **'Processing transaction...'**
  String get processingTransaction;

  /// Transaction success message
  ///
  /// In en, this message translates to:
  /// **'Transaction completed successfully'**
  String get transactionSuccess;

  /// Configuration error title
  ///
  /// In en, this message translates to:
  /// **'Configuration Error'**
  String get configurationError;

  /// Connection timeout error message
  ///
  /// In en, this message translates to:
  /// **'Connection timeout. Please try again.'**
  String get connectionTimeout;

  /// Unknown error message
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred. Please try again.'**
  String get unknownError;

  /// No internet connection error message
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network settings.'**
  String get noInternetConnection;

  /// Server error message
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get serverError;

  /// Maintenance message
  ///
  /// In en, this message translates to:
  /// **'The app is currently under maintenance. Please try again later.'**
  String get maintenance;

  /// Update required message
  ///
  /// In en, this message translates to:
  /// **'App update required. Please update to continue.'**
  String get updateRequired;

  /// Update available message
  ///
  /// In en, this message translates to:
  /// **'A new version is available. Update now?'**
  String get updateAvailable;

  /// Later button text
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// Update button text
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Time indicator for very recent times
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// Time indicator for minutes ago (singular)
  ///
  /// In en, this message translates to:
  /// **'{count} minute ago'**
  String minuteAgo(int count);

  /// Time indicator for minutes ago (plural)
  ///
  /// In en, this message translates to:
  /// **'{count} minutes ago'**
  String minutesAgo(int count);

  /// Time indicator for hours ago (singular)
  ///
  /// In en, this message translates to:
  /// **'{count} hour ago'**
  String hourAgo(int count);

  /// Time indicator for hours ago (plural)
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(int count);

  /// Time indicator for days ago (singular)
  ///
  /// In en, this message translates to:
  /// **'{count} day ago'**
  String dayAgo(int count);

  /// Time indicator for days ago (plural)
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// Time indicator for weeks ago (singular)
  ///
  /// In en, this message translates to:
  /// **'{count} week ago'**
  String weekAgo(int count);

  /// Time indicator for weeks ago (plural)
  ///
  /// In en, this message translates to:
  /// **'{count} weeks ago'**
  String weeksAgo(int count);

  /// Time indicator for months ago (singular)
  ///
  /// In en, this message translates to:
  /// **'{count} month ago'**
  String monthAgo(int count);

  /// Time indicator for months ago (plural)
  ///
  /// In en, this message translates to:
  /// **'{count} months ago'**
  String monthsAgo(int count);

  /// Time indicator for years ago (singular)
  ///
  /// In en, this message translates to:
  /// **'{count} year ago'**
  String yearAgo(int count);

  /// Time indicator for years ago (plural)
  ///
  /// In en, this message translates to:
  /// **'{count} years ago'**
  String yearsAgo(int count);

  /// Yesterday label
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Today label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Tomorrow label
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// Status for ended/expired items
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get ended;

  /// Suffix for time remaining
  ///
  /// In en, this message translates to:
  /// **'remaining'**
  String get remaining;

  /// Very short time remaining
  ///
  /// In en, this message translates to:
  /// **'Less than 1m remaining'**
  String get lessThanMinute;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
