# Firebase Security Setup Guide

## 🔐 Secure Firebase Configuration

### Step 1: Create Environment-based Firebase Configuration

Create a new file: `lib/config/firebase_env_config.dart`

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseEnvConfig {
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
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_WEB_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_WEB_APP_ID'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
    authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_ANDROID_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_ANDROID_APP_ID'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_IOS_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_IOS_APP_ID'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
    iosBundleId: String.fromEnvironment('IOS_BUNDLE_ID'),
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_IOS_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_IOS_APP_ID'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
    iosBundleId: String.fromEnvironment('IOS_BUNDLE_ID'),
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: String.fromEnvironment('FIREBASE_WEB_API_KEY'),
    appId: String.fromEnvironment('FIREBASE_WINDOWS_APP_ID'),
    messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
    projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
    authDomain: String.fromEnvironment('FIREBASE_AUTH_DOMAIN'),
    storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
  );
}
```

### Step 2: Update Environment Files

Create secure environment files:

**.env.dev**
```
FIREBASE_PROJECT_ID=crete-dao-dev
FIREBASE_MESSAGING_SENDER_ID=your-dev-sender-id
FIREBASE_STORAGE_BUCKET=crete-dao-dev.firebasestorage.app
FIREBASE_AUTH_DOMAIN=crete-dao-dev.firebaseapp.com
FIREBASE_WEB_API_KEY=your-new-web-api-key
FIREBASE_ANDROID_API_KEY=your-new-android-api-key
FIREBASE_IOS_API_KEY=your-new-ios-api-key
FIREBASE_WEB_APP_ID=your-web-app-id
FIREBASE_ANDROID_APP_ID=your-android-app-id
FIREBASE_IOS_APP_ID=your-ios-app-id
FIREBASE_WINDOWS_APP_ID=your-windows-app-id
IOS_BUNDLE_ID=com.crete.dao.dev
```

**.env.prod**
```
FIREBASE_PROJECT_ID=crete-dao-prod
FIREBASE_MESSAGING_SENDER_ID=your-prod-sender-id
FIREBASE_STORAGE_BUCKET=crete-dao-prod.firebasestorage.app
FIREBASE_AUTH_DOMAIN=crete-dao-prod.firebaseapp.com
FIREBASE_WEB_API_KEY=your-new-web-api-key
FIREBASE_ANDROID_API_KEY=your-new-android-api-key
FIREBASE_IOS_API_KEY=your-new-ios-api-key
FIREBASE_WEB_APP_ID=your-web-app-id
FIREBASE_ANDROID_APP_ID=your-android-app-id
FIREBASE_IOS_APP_ID=your-ios-app-id
FIREBASE_WINDOWS_APP_ID=your-windows-app-id
IOS_BUNDLE_ID=com.crete.dao
```

### Step 3: Update Main App Initialization

Update `lib/main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_env_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with environment-based config
  await Firebase.initializeApp(
    options: FirebaseEnvConfig.currentPlatform,
  );
  
  // ... rest of your app initialization
}
```

### Step 4: Add Environment Variables to .gitignore

Update `.gitignore`:
```
# Firebase Configuration
lib/firebase_options.dart
.env.dev
.env.prod
.env.staging

# Environment files
*.env
!.env.example
```

### Step 5: Create Development vs Production Projects

1. **Development**: `crete-dao-dev`
2. **Production**: `crete-dao-prod`

### Step 6: Regenerate Firebase Configuration

After revoking old API keys:

1. Create new Firebase projects for dev/prod
2. Generate new API keys
3. Update your environment files with new keys
4. Test the app with new configuration

### Step 7: Set Up CI/CD Secrets

For GitHub Actions, add secrets:
- `FIREBASE_WEB_API_KEY`
- `FIREBASE_ANDROID_API_KEY`
- `FIREBASE_IOS_API_KEY`
- etc.

### Step 8: Add Pre-commit Hook

Create `.git/hooks/pre-commit`:
```bash
#!/bin/bash
# Check for sensitive files
if git diff --cached --name-only | grep -q "firebase_options.dart"; then
  echo "❌ ERROR: Attempting to commit firebase_options.dart"
  echo "This file contains sensitive Firebase configuration"
  exit 1
fi

if git diff --cached --name-only | grep -q "\.env\.\(dev\|prod\|staging\)$"; then
  echo "❌ ERROR: Attempting to commit environment files"
  echo "These files contain sensitive configuration"
  exit 1
fi
```

Make it executable:
```bash
chmod +x .git/hooks/pre-commit
```

## ✅ Security Checklist

- [ ] Old API keys revoked in Firebase Console
- [ ] New Firebase projects created (dev/prod)
- [ ] New API keys generated
- [ ] Environment-based configuration implemented
- [ ] Sensitive files added to .gitignore
- [ ] Pre-commit hooks installed
- [ ] CI/CD secrets configured
- [ ] Firebase security rules updated
- [ ] App tested with new configuration

## 🔍 What to Monitor

- Firebase Console usage patterns
- Authentication logs
- Storage access patterns
- Database read/write operations
- Any unusual spikes in usage

## 🚨 Emergency Response

If you suspect compromise:
1. Revoke API keys immediately
2. Review Firebase audit logs
3. Check for unauthorized data access
4. Rotate all credentials
5. Review security rules
6. Consider temporary service shutdown if needed

---

**Remember**: Never commit API keys or sensitive configuration to version control!
