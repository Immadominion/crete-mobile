import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Firebase configuration for Crete DAO app
/// Secure configuration without exposing sensitive data
class FirebaseConfig {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError(
          'Firebase configuration not supported for this platform.',
        );
    }
  }

  // Firebase configuration for different platforms
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'web-api-key', // Replace with your web API key
    appId: 'web-app-id', // Replace with your web app ID
    messagingSenderId: 'sender-id', // Replace with your sender ID
    projectId: 'crete-dao', // Replace with your project ID
    authDomain: 'crete-dao.firebaseapp.com',
    storageBucket: 'crete-dao.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'android-api-key', // Replace with your Android API key
    appId: 'android-app-id', // Replace with your Android app ID
    messagingSenderId: 'sender-id', // Replace with your sender ID
    projectId: 'crete-dao', // Replace with your project ID
    storageBucket: 'crete-dao.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'ios-api-key', // Replace with your iOS API key
    appId: 'ios-app-id', // Replace with your iOS app ID
    messagingSenderId: 'sender-id', // Replace with your sender ID
    projectId: 'crete-dao', // Replace with your project ID
    storageBucket: 'crete-dao.firebasestorage.app',
    iosBundleId: 'com.crete.dao',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'ios-api-key', // Replace with your iOS API key
    appId: 'ios-app-id', // Replace with your iOS app ID
    messagingSenderId: 'sender-id', // Replace with your sender ID
    projectId: 'crete-dao', // Replace with your project ID
    storageBucket: 'crete-dao.firebasestorage.app',
    iosBundleId: 'com.crete.dao',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'web-api-key', // Replace with your web API key
    appId: 'windows-app-id', // Replace with your Windows app ID
    messagingSenderId: 'sender-id', // Replace with your sender ID
    projectId: 'crete-dao', // Replace with your project ID
    authDomain: 'crete-dao.firebaseapp.com',
    storageBucket: 'crete-dao.firebasestorage.app',
  );
}
