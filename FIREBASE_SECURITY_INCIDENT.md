# 🚨 Firebase Security Incident Response

## What Happened
Firebase API keys and configuration have been exposed in the public repository.

## Immediate Actions Required

### 1. **Revoke Firebase API Keys** (CRITICAL - Do this NOW)
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `crete-dao`
3. Go to **Project Settings** (gear icon)
4. Click on **General** tab
5. Under **Your apps** section, find each app and:
   - Click on the app
   - Go to **API Keys** section
   - **Revoke** the exposed API keys:
     - Web: `AIzaSyBZBeyRlSnl7wP2qScMjZxVRTEFDB8fIoM`
     - Android: `AIzaSyARnCUCHv0JJVdfxB2VuI0nLFG1ihemEN4`
     - iOS/macOS: `AIzaSyCaqAqwAA47y5MYgl_cdRtsvkoBv08wrdk`
   - **Generate new API keys**

### 2. **Remove File from Git History**
The file exists in your Git history and needs to be completely removed:

```bash
# Remove the file from current commit
git rm lib/firebase_options.dart

# Remove from Git history completely
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch lib/firebase_options.dart' \
  --prune-empty --tag-name-filter cat -- --all

# Force push to overwrite remote history
git push origin --force --all
git push origin --force --tags
```

### 3. **Add to .gitignore**
```bash
# Add to .gitignore
echo "lib/firebase_options.dart" >> .gitignore
git add .gitignore
git commit -m "Add firebase_options.dart to .gitignore"
```

### 4. **Update Firebase Security Rules**
Check your Firebase security rules to ensure they're restrictive:

#### Firestore Rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Only authenticated users can read/write
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

#### Storage Rules:
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 5. **Monitor Firebase Usage**
- Check Firebase Console for unusual activity
- Monitor authentication logs
- Review storage and database usage

## Prevention for Future

### 1. **Use Environment Variables**
Create a secure firebase configuration:

```dart
// lib/config/firebase_config.dart
class FirebaseConfig {
  static const String _apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const String _appId = String.fromEnvironment('FIREBASE_APP_ID');
  static const String _projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  
  static FirebaseOptions get currentPlatform {
    // Use environment variables instead of hardcoded values
    return FirebaseOptions(
      apiKey: _apiKey,
      appId: _appId,
      projectId: _projectId,
      // ... other config
    );
  }
}
```

### 2. **Use Different Projects for Dev/Prod**
- Development: `crete-dao-dev`
- Production: `crete-dao-prod`

### 3. **Implement Proper Git Hooks**
```bash
# Add to .git/hooks/pre-commit
#!/bin/bash
if git diff --cached --name-only | grep -q "firebase_options.dart"; then
  echo "❌ ERROR: Attempting to commit firebase_options.dart"
  echo "This file contains sensitive Firebase configuration"
  exit 1
fi
```

## Security Checklist
- [ ] API keys revoked and regenerated
- [ ] File removed from Git history
- [ ] New Firebase configuration generated
- [ ] Security rules updated
- [ ] Usage monitoring enabled
- [ ] .gitignore updated
- [ ] Environment variables configured
- [ ] Git hooks installed

## Recovery Steps
1. **Regenerate firebase_options.dart** with new keys:
   ```bash
   flutter packages pub run flutterfire_cli:flutterfire configure
   ```

2. **Test the app** with new configuration

3. **Monitor** for any suspicious activity

## Timeline
- **Discovery**: [Current timestamp]
- **API Keys Revoked**: [To be completed]
- **Git History Cleaned**: [To be completed]
- **New Configuration**: [To be completed]
- **Security Verified**: [To be completed]

---
**⚠️ PRIORITY**: Complete steps 1-3 immediately to minimize security risk.
