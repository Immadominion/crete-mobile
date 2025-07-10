import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../constants/storage_keys.dart';

/// Message types for WebSocket communication
enum WebSocketMessageType {
  authenticate,
  ping,
  pong,
  notification,
  chatMessage,
  proposalUpdate,
  voteUpdate,
  userStatus,
  error,
}

/// WebSocket message structure
class WebSocketMessage {

  WebSocketMessage({
    required this.id,
    required this.type,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) => WebSocketMessage(
      id: (json['id'] as String?) ?? '',
      type: WebSocketMessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => WebSocketMessageType.error,
      ),
      data: (json['data'] as Map<String, dynamic>?) ?? {},
      timestamp:
          DateTime.tryParse((json['timestamp'] as String?) ?? '') ??
          DateTime.now(),
    );
  final String id;
  final WebSocketMessageType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
  };
}

/// WebSocket connection state
enum WebSocketState { disconnected, connecting, connected, reconnecting, error }

/// Production-grade WebSocket client with comprehensive features
@singleton
class WebSocketClientService {

  WebSocketClientService(this._prefs);
  static const int _maxReconnectAttempts = 5;
  static const Duration _initialReconnectDelay = Duration(seconds: 2);
  static const Duration _maxReconnectDelay = Duration(seconds: 30);
  static const Duration _pingInterval = Duration(seconds: 30);
  static const Duration _pongTimeout = Duration(seconds: 10);

  WebSocket? _socket;
  final SharedPreferences _prefs;
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  Timer? _pongTimer;
  int _reconnectAttempts = 0;
  String? _lastError;

  // Message queue for offline scenarios
  final List<WebSocketMessage> _messageQueue = [];
  final int _maxQueueSize = 100;

  // State management
  final StreamController<WebSocketState> _stateController =
      StreamController<WebSocketState>.broadcast();
  final StreamController<WebSocketMessage> _messageController =
      StreamController<WebSocketMessage>.broadcast();
  final StreamController<String> _errorController =
      StreamController<String>.broadcast();

  WebSocketState _currentState = WebSocketState.disconnected;

  // Stream getters
  Stream<WebSocketState> get stateStream => _stateController.stream;
  Stream<WebSocketMessage> get messageStream => _messageController.stream;
  Stream<String> get errorStream => _errorController.stream;
  WebSocketState get currentState => _currentState;
  bool get isConnected => _currentState == WebSocketState.connected;
  String? get lastError => _lastError;

  /// Connect to WebSocket server
  Future<void> connect({bool forceReconnect = false}) async {
    if (_currentState == WebSocketState.connected && !forceReconnect) {
      return;
    }

    if (_currentState == WebSocketState.connecting) {
      return;
    }

    _updateState(WebSocketState.connecting);

    try {
      final token = _prefs.getString(StorageKeys.accessToken);
      final wsUrl = _buildWebSocketUrl(token);

      if (kDebugMode && AppConfig.enableNetworkLogging) {
        debugPrint('🔌 Connecting to WebSocket: $wsUrl');
      }

      _socket = await WebSocket.connect(wsUrl, headers: _buildHeaders(token));

      _setupSocketListeners();
      _updateState(WebSocketState.connected);
      _reconnectAttempts = 0;
      _lastError = null;

      // Start ping/pong mechanism
      _startPingPong();

      // Send authentication message if token exists
      if (token != null) {
        await _sendAuthenticationMessage(token);
      }

      // Process queued messages
      await _processMessageQueue();

      if (kDebugMode) {
        debugPrint('✅ WebSocket connected successfully');
      }
    } catch (e) {
      _lastError = e.toString();
      _updateState(WebSocketState.error);
      _errorController.add(_lastError!);

      if (kDebugMode) {
        debugPrint('❌ WebSocket connection failed: $e');
      }

      _scheduleReconnect();
    }
  }

  /// Disconnect from WebSocket server
  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    _pongTimer?.cancel();

    if (_socket != null) {
      await _socket!.close();
      _socket = null;
    }

    _updateState(WebSocketState.disconnected);

    if (kDebugMode) {
      debugPrint('🔌 WebSocket disconnected');
    }
  }

  /// Send message through WebSocket
  Future<void> sendMessage(WebSocketMessage message) async {
    if (!isConnected) {
      _queueMessage(message);
      return;
    }

    try {
      final jsonData = jsonEncode(message.toJson());
      _socket!.add(jsonData);

      if (kDebugMode && AppConfig.enableNetworkLogging) {
        debugPrint('📤 WebSocket message sent: ${message.type.name}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to send WebSocket message: $e');
      }
      _queueMessage(message);
      _handleConnectionError(e);
    }
  }

  /// Send typed messages
  Future<void> sendNotification(Map<String, dynamic> data) async {
    await sendMessage(
      WebSocketMessage(
        id: _generateMessageId(),
        type: WebSocketMessageType.notification,
        data: data,
      ),
    );
  }

  Future<void> sendChatMessage(String roomId, String content) async {
    await sendMessage(
      WebSocketMessage(
        id: _generateMessageId(),
        type: WebSocketMessageType.chatMessage,
        data: {'roomId': roomId, 'content': content},
      ),
    );
  }

  Future<void> sendUserStatus(String status) async {
    await sendMessage(
      WebSocketMessage(
        id: _generateMessageId(),
        type: WebSocketMessageType.userStatus,
        data: {'status': status},
      ),
    );
  }

  /// Update authentication token
  Future<void> updateAuthToken(String token) async {
    await _prefs.setString(StorageKeys.accessToken, token);

    if (isConnected) {
      await _sendAuthenticationMessage(token);
    }
  }

  /// Clear authentication and reconnect
  Future<void> clearAuth() async {
    await _prefs.remove(StorageKeys.accessToken);
    await disconnect();
  }

  String _buildWebSocketUrl(String? token) {
    final uri = Uri.parse(AppConfig.websocketUrl);
    final queryParams = <String, String>{
      'version': AppConfig.appVersion,
      'platform': Platform.operatingSystem,
    };

    if (token != null) {
      queryParams['token'] = token;
    }

    return uri.replace(queryParameters: queryParams).toString();
  }

  Map<String, String> _buildHeaders(String? token) {
    final headers = <String, String>{
      'User-Agent':
          'Crete/${AppConfig.appVersion} (${Platform.operatingSystem})',
      'X-App-Version': AppConfig.appVersion,
      'X-Platform': Platform.operatingSystem,
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  void _setupSocketListeners() {
    _socket!.listen(
      (data) => _handleMessage(data),
      onError: (Object error) => _handleConnectionError(error),
      onDone: () => _handleConnectionClosed(),
    );
  }

  void _handleMessage(dynamic data) {
    try {
      final Map<String, dynamic> json =
          jsonDecode(data.toString()) as Map<String, dynamic>;
      final message = WebSocketMessage.fromJson(json);

      if (kDebugMode && AppConfig.enableNetworkLogging) {
        debugPrint('📥 WebSocket message received: ${message.type.name}');
      }

      // Handle special message types
      switch (message.type) {
        case WebSocketMessageType.ping:
          _handlePing(message);
          break;
        case WebSocketMessageType.pong:
          _handlePong();
          break;
        case WebSocketMessageType.error:
          _handleServerError(message);
          break;
        default:
          _messageController.add(message);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to parse WebSocket message: $e');
      }
    }
  }

  void _handleConnectionError(dynamic error) {
    _lastError = error.toString();
    _updateState(WebSocketState.error);
    _errorController.add(_lastError!);

    if (kDebugMode) {
      debugPrint('❌ WebSocket error: $error');
    }

    _scheduleReconnect();
  }

  void _handleConnectionClosed() {
    _updateState(WebSocketState.disconnected);

    if (kDebugMode) {
      debugPrint('🔌 WebSocket connection closed');
    }

    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      if (kDebugMode) {
        debugPrint('❌ Max reconnection attempts reached');
      }
      return;
    }

    _reconnectAttempts++;
    final delay = Duration(
      seconds: (_initialReconnectDelay.inSeconds * _reconnectAttempts).clamp(
        1,
        _maxReconnectDelay.inSeconds,
      ),
    );

    _updateState(WebSocketState.reconnecting);

    if (kDebugMode) {
      debugPrint(
        '🔄 Scheduling reconnect in ${delay.inSeconds}s (attempt $_reconnectAttempts)',
      );
    }

    _reconnectTimer = Timer(delay, () => connect());
  }

  void _startPingPong() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(_pingInterval, (_) => _sendPing());
  }

  void _sendPing() {
    if (!isConnected) return;

    sendMessage(
      WebSocketMessage(
        id: _generateMessageId(),
        type: WebSocketMessageType.ping,
        data: {'timestamp': DateTime.now().toIso8601String()},
      ),
    );

    // Start pong timeout
    _pongTimer?.cancel();
    _pongTimer = Timer(_pongTimeout, () {
      if (kDebugMode) {
        debugPrint('⚠️ Pong timeout - connection may be lost');
      }
      _handleConnectionError('Pong timeout');
    });
  }

  void _handlePing(WebSocketMessage message) {
    // Respond to server ping with pong
    sendMessage(
      WebSocketMessage(
        id: message.id,
        type: WebSocketMessageType.pong,
        data: message.data,
      ),
    );
  }

  void _handlePong() {
    _pongTimer?.cancel();
    if (kDebugMode && AppConfig.enableNetworkLogging) {
      debugPrint('🏓 Pong received');
    }
  }

  void _handleServerError(WebSocketMessage message) {
    final error = (message.data['error'] as String?) ?? 'Unknown server error';
    _lastError = error;
    _errorController.add(error);

    if (kDebugMode) {
      debugPrint('❌ Server error: $error');
    }
  }

  Future<void> _sendAuthenticationMessage(String token) async {
    await sendMessage(
      WebSocketMessage(
        id: _generateMessageId(),
        type: WebSocketMessageType.authenticate,
        data: {'token': token},
      ),
    );
  }

  void _queueMessage(WebSocketMessage message) {
    if (_messageQueue.length >= _maxQueueSize) {
      _messageQueue.removeAt(0); // Remove oldest message
    }
    _messageQueue.add(message);

    if (kDebugMode) {
      debugPrint('📋 Message queued (${_messageQueue.length}/$_maxQueueSize)');
    }
  }

  Future<void> _processMessageQueue() async {
    if (_messageQueue.isEmpty) return;

    if (kDebugMode) {
      debugPrint('📤 Processing ${_messageQueue.length} queued messages');
    }

    final messages = List<WebSocketMessage>.from(_messageQueue);
    _messageQueue.clear();

    for (final message in messages) {
      await sendMessage(message);
    }
  }

  void _updateState(WebSocketState newState) {
    if (_currentState != newState) {
      _currentState = newState;
      _stateController.add(newState);

      if (kDebugMode) {
        debugPrint('🔄 WebSocket state: ${newState.name}');
      }
    }
  }

  String _generateMessageId() => DateTime.now().millisecondsSinceEpoch.toString() +
        (DateTime.now().microsecond % 1000).toString().padLeft(3, '0');

  /// Get connection statistics
  Map<String, dynamic> getConnectionStats() => {
      'state': _currentState.name,
      'reconnectAttempts': _reconnectAttempts,
      'queuedMessages': _messageQueue.length,
      'lastError': _lastError,
      'isConnected': isConnected,
    };

  /// Dispose resources
  void dispose() {
    disconnect();
    _stateController.close();
    _messageController.close();
    _errorController.close();
  }
}
