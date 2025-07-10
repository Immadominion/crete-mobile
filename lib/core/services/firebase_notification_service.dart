import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../config/app_config.dart';

/// Firebase messaging service for handling push notifications
@singleton
class FirebaseNotificationService {
  static const String _notificationChannelId = 'crete_dao_notifications';
  static const String _notificationChannelName = 'Crete DAO Notifications';
  static const String _notificationChannelDescription =
      'Notifications for DAO activities, proposals, and messages';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  String? _fcmToken;

  /// Initialize Firebase messaging and local notifications
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize local notifications
      await _initializeLocalNotifications();

      // Request notification permissions
      await _requestPermissions();

      // Configure Firebase messaging
      await _configureFirebaseMessaging();

      // Get FCM token
      await _getFCMToken();

      _isInitialized = true;

      if (kDebugMode && AppConfig.enableDebugLogs) {
        debugPrint('🔔 Firebase notification service initialized');
        debugPrint('📱 FCM Token: $_fcmToken');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Firebase notification service initialization failed: $e');
      }
      rethrow;
    }
  }

  /// Initialize local notifications platform settings
  Future<void> _initializeLocalNotifications() async {
    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    await _createNotificationChannel();
  }

  /// Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    const androidNotificationChannel = AndroidNotificationChannel(
      _notificationChannelId,
      _notificationChannelName,
      description: _notificationChannelDescription,
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  /// Request notification permissions from user
  Future<void> _requestPermissions() async {
    // Request system notification permission
    final permissionStatus = await Permission.notification.request();

    if (permissionStatus.isDenied) {
      if (kDebugMode) {
        debugPrint('⚠️ Notification permission denied');
      }
      return;
    }

    // Request Firebase messaging permissions
    final notificationSettings = await _firebaseMessaging.requestPermission(
      
    );

    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint(
        '🔔 Notification permission status: ${notificationSettings.authorizationStatus}',
      );
    }
  }

  /// Configure Firebase messaging handlers
  Future<void> _configureFirebaseMessaging() async {
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle message opened from terminated state
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Handle message when app is opened from terminated state
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
  }

  /// Get FCM token for this device
  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        _onTokenRefresh(newToken);
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to get FCM token: $e');
      }
    }
  }

  /// Handle foreground messages by showing local notification
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('📨 Foreground message received: ${message.messageId}');
      debugPrint('📨 Title: ${message.notification?.title}');
      debugPrint('📨 Body: ${message.notification?.body}');
    }

    // Show local notification for foreground messages
    await _showLocalNotification(message);
  }

  /// Handle message opened from background or terminated state
  void _handleMessageOpenedApp(RemoteMessage message) {
    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('📱 Message opened app: ${message.messageId}');
      debugPrint('📱 Data: ${message.data}');
    }

    // Handle deep linking based on message data
    _handleNotificationTap(message.data);
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        _notificationChannelId,
        _notificationChannelName,
        channelDescription: _notificationChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      macOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      notificationDetails,
      payload: message.data.isNotEmpty ? message.data.toString() : null,
    );
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('🔔 Notification tapped: ${response.payload}');
    }

    if (response.payload != null) {
      // Parse payload and handle deep linking
      _handleNotificationTap(_parsePayload(response.payload!));
    }
  }

  /// Handle notification tap for deep linking
  void _handleNotificationTap(Map<String, dynamic> data) {
    // TODO: Implement deep linking logic based on notification data
    // This will be implemented when we add navigation and deep linking

    final type = data['type'] as String?;
    final id = data['id'] as String?;

    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('🔗 Handling notification tap - Type: $type, ID: $id');
    }

    // Example deep link handling:
    // switch (type) {
    //   case 'dao_proposal':
    //     navigateToProposal(id);
    //     break;
    //   case 'chat_message':
    //     navigateToChat(id);
    //     break;
    //   case 'dao_announcement':
    //     navigateToDAO(id);
    //     break;
    // }
  }

  /// Parse notification payload
  Map<String, dynamic> _parsePayload(String payload) {
    try {
      // Simple parsing - in production you might use JSON
      final parts = payload.split(',');
      final Map<String, dynamic> data = {};

      for (final part in parts) {
        final keyValue = part.split(':');
        if (keyValue.length == 2) {
          data[keyValue[0].trim()] = keyValue[1].trim();
        }
      }

      return data;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to parse notification payload: $e');
      }
      return {};
    }
  }

  /// Handle token refresh
  void _onTokenRefresh(String newToken) {
    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('🔄 FCM token refreshed: $newToken');
    }

    // TODO: Send new token to backend
    // Example: apiService.updateFCMToken(newToken);
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);

      if (kDebugMode && AppConfig.enableDebugLogs) {
        debugPrint('✅ Subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to subscribe to topic $topic: $e');
      }
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);

      if (kDebugMode && AppConfig.enableDebugLogs) {
        debugPrint('✅ Unsubscribed from topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to unsubscribe from topic $topic: $e');
      }
    }
  }

  /// Get current FCM token
  String? get fcmToken => _fcmToken;

  /// Check if notification service is initialized
  bool get isInitialized => _isInitialized;

  /// Check if notifications are enabled
  Future<bool> get areNotificationsEnabled async {
    final permission = await Permission.notification.status;
    return permission.isGranted;
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if needed
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (kDebugMode) {
    debugPrint('📨 Background message received: ${message.messageId}');
  }

  // Handle background message processing here
  // Note: You cannot show UI or navigate from background handler
}
