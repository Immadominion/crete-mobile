# Firebase Notification Integration Guide

## Overview

The Crete app uses Firebase Cloud Messaging (FCM) for push notifications along with local notifications for a complete notification experience. This document outlines the notification implementation and provides guidance for extending functionality.

## Architecture

### Core Components

1. **FirebaseNotificationService** (`lib/core/services/firebase_notification_service.dart`)

   - Injectable singleton service
   - Handles FCM token management
   - Manages notification permissions
   - Processes foreground, background, and terminated notifications
   - Provides local notification capabilities

2. **Dependency Injection**

   - Registered in `lib/core/injection/service_module.dart`
   - Available throughout the app via GetIt

3. **Initialization**
   - Automatically initialized in `main.dart` during app startup
   - Runs after Firebase core and dependency injection setup

## Notification Flow

### App States and Handling

1. **Foreground** - App is open and active

   - Displays local notification
   - Can update UI immediately
   - Calls `_handleForegroundMessage()`

2. **Background** - App is running but not active

   - Handled by `_firebaseMessagingBackgroundHandler()`
   - Limited processing capabilities
   - Cannot show UI or navigate

3. **Terminated** - App is completely closed
   - Handled when user taps notification
   - Triggers `_handleMessageOpenedApp()`
   - Can navigate to specific screens

### Notification Types

#### Data-Only Messages

```json
{
  "data": {
    "type": "announcement",
    "id": "12345",
    "title": "DAO Update",
    "body": "New proposal available for voting"
  }
}
```

#### Notification Messages (Display + Data)

```json
{
  "notification": {
    "title": "DAO Update",
    "body": "New proposal available for voting"
  },
  "data": {
    "type": "announcement",
    "id": "12345"
  }
}
```

## Implementation Details

### Key Methods

- `initialize()` - Main setup method called at app start
- `getToken()` - Retrieves current FCM token
- `_requestPermissions()` - Handles notification permissions
- `_configureFirebaseMessaging()` - Sets up message handlers
- `_handleNotificationTap()` - Processes notification interactions

### Platform Configuration

#### Android

- Notification channel: "crete_notifications"
- Importance: High
- Sound enabled
- Requires `android/app/google-services.json`

#### iOS

- Requires `ios/Runner/GoogleService-Info.plist`
- APNs key configured in Firebase Console
- Permission request includes alert, badge, and sound

## Usage Examples

### Getting FCM Token

```dart
final notificationService = getIt<FirebaseNotificationService>();
final token = await notificationService.getToken();
// Send token to your backend server
```

### Listening for Notifications (Future Implementation)

```dart
// Subscribe to notification events
notificationService.onNotificationReceived.listen((notification) {
  // Handle notification data
  final type = notification['type'];
  final id = notification['id'];

  // Navigate or update UI based on notification
});
```

## Deep Linking Integration

The notification service includes stub methods for deep linking:

```dart
void _handleNotificationTap(Map<String, dynamic> data) {
  final type = data['type'];
  final id = data['id'];

  // TODO: Implement deep linking based on notification type
  switch (type) {
    case 'announcement':
      // Navigate to announcement details
      break;
    case 'proposal':
      // Navigate to proposal voting
      break;
    // Add more cases as needed
  }
}
```

## Testing

### Validation

Run the Step 3 validation script:

```bash
dart scripts/validate_step3.dart
```

### Manual Testing

1. **FCM Token Generation**: Check logs for token output
2. **Permission Handling**: Test on fresh install
3. **Foreground Notifications**: Send test message while app is open
4. **Background Handling**: Send message when app is backgrounded
5. **Tap Handling**: Verify notification tap actions

### Test Message Example (Firebase Console)

```json
{
  "to": "FCM_TOKEN_HERE",
  "data": {
    "type": "test",
    "id": "test123",
    "title": "Test Notification",
    "body": "Testing notification handling"
  }
}
```

## Future Enhancements

### Planned Features

1. **UI Integration**

   - Notification permission request dialog
   - Notification settings screen
   - In-app notification display

2. **Advanced Notification Types**

   - Rich media notifications (images, actions)
   - Scheduled local notifications
   - Notification categories and grouping

3. **Deep Linking**
   - Complete route-based navigation
   - Notification analytics tracking
   - Dynamic link integration

### Extension Points

#### Custom Notification Handlers

```dart
// Extend the service to add custom handlers
class ExtendedNotificationService extends FirebaseNotificationService {
  @override
  void _handleNotificationTap(Map<String, dynamic> data) {
    // Custom handling logic
    super._handleNotificationTap(data);
  }
}
```

#### Notification Analytics

```dart
// Track notification events
void _trackNotificationEvent(String action, Map<String, dynamic> data) {
  // Send analytics event
  // Log to crash reporting
}
```

## Troubleshooting

### Common Issues

1. **Token Not Generated**

   - Check Google Services configuration
   - Verify internet connectivity
   - Ensure proper Firebase project setup

2. **Permissions Denied**

   - Handle gracefully in UI
   - Provide manual permission request
   - Guide users to system settings

3. **Background Handling**
   - Ensure background handler is top-level function
   - Limit processing in background context
   - Test on actual devices (not simulator)

### Debug Information

Enable debug logging in `AppConfig.enableDebugLogs` to see:

- FCM token generation
- Permission status
- Notification received events
- Message processing flow

## Resources

- [Firebase Cloud Messaging Documentation](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- [Permission Handler](https://pub.dev/packages/permission_handler)
