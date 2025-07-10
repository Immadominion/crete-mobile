// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Crete';

  @override
  String get welcome => 'Welcome to Crete';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get search => 'Search';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get wallet => 'Wallet';

  @override
  String get transactions => 'Transactions';

  @override
  String get balance => 'Balance';

  @override
  String get send => 'Send';

  @override
  String get receive => 'Receive';

  @override
  String get amount => 'Amount';

  @override
  String get address => 'Address';

  @override
  String get confirm => 'Confirm';

  @override
  String get transaction => 'Transaction';

  @override
  String get pending => 'Pending';

  @override
  String get completed => 'Completed';

  @override
  String get failed => 'Failed';

  @override
  String get networkError =>
      'Network connection error. Please check your internet connection and try again.';

  @override
  String get invalidAddress => 'Invalid address format';

  @override
  String get insufficientBalance => 'Insufficient balance';

  @override
  String get transactionFailed => 'Transaction failed. Please try again.';

  @override
  String get connectWallet => 'Connect Wallet';

  @override
  String get disconnectWallet => 'Disconnect Wallet';

  @override
  String get walletConnected => 'Wallet Connected';

  @override
  String get walletDisconnected => 'Wallet Disconnected';

  @override
  String get noTransactions => 'No transactions found';

  @override
  String get refresh => 'Refresh';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied to clipboard';

  @override
  String get share => 'Share';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get done => 'Done';

  @override
  String get skip => 'Skip';

  @override
  String get continueButton => 'Continue';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get notifications => 'Notifications';

  @override
  String get security => 'Security';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get enterEmail => 'Enter your email address';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters long';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get accountCreated => 'Account created successfully';

  @override
  String get welcomeBack => 'Welcome back!';

  @override
  String get solanaNetwork => 'Solana Network';

  @override
  String get mainnet => 'Mainnet';

  @override
  String get devnet => 'Devnet';

  @override
  String get testnet => 'Testnet';

  @override
  String get blinks => 'Blinks';

  @override
  String get actionRequired => 'Action Required';

  @override
  String get processingTransaction => 'Processing transaction...';

  @override
  String get transactionSuccess => 'Transaction completed successfully';

  @override
  String get configurationError => 'Configuration Error';

  @override
  String get connectionTimeout => 'Connection timeout. Please try again.';

  @override
  String get unknownError => 'An unknown error occurred. Please try again.';

  @override
  String get noInternetConnection =>
      'No internet connection. Please check your network settings.';

  @override
  String get serverError => 'Server error. Please try again later.';

  @override
  String get maintenance =>
      'The app is currently under maintenance. Please try again later.';

  @override
  String get updateRequired =>
      'App update required. Please update to continue.';

  @override
  String get updateAvailable => 'A new version is available. Update now?';

  @override
  String get later => 'Later';

  @override
  String get update => 'Update';

  @override
  String get justNow => 'Just now';

  @override
  String minuteAgo(int count) {
    return '$count minute ago';
  }

  @override
  String minutesAgo(int count) {
    return '$count minutes ago';
  }

  @override
  String hourAgo(int count) {
    return '$count hour ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String dayAgo(int count) {
    return '$count day ago';
  }

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String weekAgo(int count) {
    return '$count week ago';
  }

  @override
  String weeksAgo(int count) {
    return '$count weeks ago';
  }

  @override
  String monthAgo(int count) {
    return '$count month ago';
  }

  @override
  String monthsAgo(int count) {
    return '$count months ago';
  }

  @override
  String yearAgo(int count) {
    return '$count year ago';
  }

  @override
  String yearsAgo(int count) {
    return '$count years ago';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get ended => 'Ended';

  @override
  String get remaining => 'remaining';

  @override
  String get lessThanMinute => 'Less than 1m remaining';
}
