import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cache_service.dart';
import 'connectivity_service.dart';

/// Enumeration for sync operation types
enum SyncOperationType { create, update, delete }

/// Enumeration for sync operation status
enum SyncOperationStatus { pending, syncing, completed, failed }

/// Model for pending sync operations
class SyncOperation {

  const SyncOperation({
    required this.id,
    required this.type,
    required this.endpoint,
    required this.data,
    required this.timestamp,
    this.status = SyncOperationStatus.pending,
    this.retryCount = 0,
    this.error,
  });

  factory SyncOperation.fromJson(Map<String, dynamic> json) => SyncOperation(
    id: json['id'] as String,
    type: SyncOperationType.values.byName(json['type'] as String),
    endpoint: json['endpoint'] as String,
    data: json['data'] as Map<String, dynamic>,
    timestamp: DateTime.parse(json['timestamp'] as String),
    status: SyncOperationStatus.values.byName(json['status'] as String),
    retryCount: json['retryCount'] as int? ?? 0,
    error: json['error'] as String?,
  );
  final String id;
  final SyncOperationType type;
  final String endpoint;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final SyncOperationStatus status;
  final int retryCount;
  final String? error;

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'endpoint': endpoint,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
    'status': status.name,
    'retryCount': retryCount,
    'error': error,
  };

  SyncOperation copyWith({
    String? id,
    SyncOperationType? type,
    String? endpoint,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    SyncOperationStatus? status,
    int? retryCount,
    String? error,
  }) => SyncOperation(
    id: id ?? this.id,
    type: type ?? this.type,
    endpoint: endpoint ?? this.endpoint,
    data: data ?? this.data,
    timestamp: timestamp ?? this.timestamp,
    status: status ?? this.status,
    retryCount: retryCount ?? this.retryCount,
    error: error ?? this.error,
  );
}

/// Service for handling offline data strategies, optimistic updates, and sync mechanisms
@lazySingleton
class OfflineDataService {

  OfflineDataService(
    this._prefs,
    this._connectivityService,
    this._cacheService,
  );
  static const String _syncOperationsKey = 'sync_operations';
  static const int _maxRetryCount = 3;
  static const Duration _retryDelay = Duration(seconds: 30);

  final SharedPreferences _prefs;
  final ConnectivityService _connectivityService;
  final CacheService _cacheService;

  Timer? _syncTimer;
  final List<SyncOperation> _pendingOperations = [];
  final StreamController<List<SyncOperation>> _syncOperationsController =
      StreamController<List<SyncOperation>>.broadcast();

  /// Initialize offline data service
  Future<void> initialize() async {
    await _loadPendingOperations();

    // Listen to connectivity changes and sync when online
    _connectivityService.onlineStatusStream.listen((bool isConnected) {
      if (isConnected) {
        _startSyncTimer();
      } else {
        _stopSyncTimer();
      }
    });

    // Start sync timer if currently online
    if (_connectivityService.isOnline) {
      _startSyncTimer();
    }
  }

  /// Dispose resources
  void dispose() {
    _stopSyncTimer();
    _syncOperationsController.close();
  }

  /// Stream of pending sync operations
  Stream<List<SyncOperation>> get syncOperationsStream =>
      _syncOperationsController.stream;

  /// Get list of pending sync operations
  List<SyncOperation> get pendingOperations =>
      List.unmodifiable(_pendingOperations);

  /// Add an optimistic update operation
  Future<void> addOptimisticUpdate({
    required String id,
    required SyncOperationType type,
    required String endpoint,
    required Map<String, dynamic> data,
    required String cacheKey,
    Map<String, dynamic>? optimisticData,
  }) async {
    try {
      // Apply optimistic update to cache if provided
      if (optimisticData != null) {
        await _cacheService.cacheData(
          key: cacheKey,
          data: optimisticData,
          duration: const Duration(
            hours: 1,
          ), // Short duration for optimistic updates
        );
      }

      // Add to pending operations
      final operation = SyncOperation(
        id: id,
        type: type,
        endpoint: endpoint,
        data: data,
        timestamp: DateTime.now(),
      );

      _pendingOperations.add(operation);
      await _savePendingOperations();
      _syncOperationsController.add(_pendingOperations);

      // Try to sync immediately if online
      if (_connectivityService.isOnline) {
        await _syncOperation(operation);
      }
    } catch (e) {
      debugPrint('Failed to add optimistic update: $e');
    }
  }

  /// Manually trigger sync of pending operations
  Future<void> syncPendingOperations() async {
    if (!_connectivityService.isOnline) {
      debugPrint('Cannot sync: device is offline');
      return;
    }

    final pendingOps = _pendingOperations
        .where((op) => op.status == SyncOperationStatus.pending)
        .toList();

    for (final operation in pendingOps) {
      await _syncOperation(operation);
    }
  }

  /// Clear all pending operations
  Future<void> clearPendingOperations() async {
    _pendingOperations.clear();
    await _savePendingOperations();
    _syncOperationsController.add(_pendingOperations);
  }

  /// Remove a specific operation by ID
  Future<void> removeOperation(String operationId) async {
    _pendingOperations.removeWhere((op) => op.id == operationId);
    await _savePendingOperations();
    _syncOperationsController.add(_pendingOperations);
  }

  /// Check if device is in offline mode
  Future<bool> isOfflineMode() async => !_connectivityService.isOnline;

  /// Get offline-friendly data with fallback to cache
  Future<T?> getOfflineData<T>({
    required String cacheKey,
    required T Function(Map<String, dynamic>) fromJson,
    required Future<T?> Function() onlineDataFetcher,
  }) async {
    try {
      // Try to get fresh data if online
      if (_connectivityService.isOnline) {
        final onlineData = await onlineDataFetcher();
        if (onlineData != null) {
          // Cache the fresh data
          await _cacheService.cacheData(
            key: cacheKey,
            data: onlineData,
            duration: const Duration(hours: 1),
          );
          return onlineData;
        }
      }

      // Fallback to cached data
      return await _cacheService.getCachedData<T>(
        key: cacheKey,
        fromJson: fromJson,
      );
    } catch (e) {
      debugPrint('Failed to get offline data: $e');
      // Try cached data as last resort
      return _cacheService.getCachedData<T>(
        key: cacheKey,
        fromJson: fromJson,
      );
    }
  }

  /// Store data for offline access
  Future<void> storeOfflineData<T>({
    required String key,
    required T data,
    Duration? duration,
  }) async {
    await _cacheService.cacheData(
      key: key,
      data: data,
      duration: duration ?? const Duration(hours: 24),
    );
  }

  /// Get sync operation statistics
  Map<String, int> getSyncStats() {
    final stats = <String, int>{
      'total': _pendingOperations.length,
      'pending': 0,
      'syncing': 0,
      'completed': 0,
      'failed': 0,
    };

    for (final operation in _pendingOperations) {
      stats[operation.status.name] = (stats[operation.status.name] ?? 0) + 1;
    }

    return stats;
  }

  // Private methods

  Future<void> _loadPendingOperations() async {
    try {
      final operationsJson = _prefs.getString(_syncOperationsKey);
      if (operationsJson != null) {
        final operationsList = jsonDecode(operationsJson) as List;
        _pendingOperations.clear();
        _pendingOperations.addAll(
          operationsList.map(
            (json) => SyncOperation.fromJson(json as Map<String, dynamic>),
          ),
        );
      }
    } catch (e) {
      debugPrint('Failed to load pending operations: $e');
    }
  }

  Future<void> _savePendingOperations() async {
    try {
      final operationsJson = jsonEncode(
        _pendingOperations.map((op) => op.toJson()).toList(),
      );
      await _prefs.setString(_syncOperationsKey, operationsJson);
    } catch (e) {
      debugPrint('Failed to save pending operations: $e');
    }
  }

  Future<void> _syncOperation(SyncOperation operation) async {
    if (operation.status == SyncOperationStatus.syncing) {
      return; // Already syncing
    }

    // Update operation status to syncing
    final index = _pendingOperations.indexWhere((op) => op.id == operation.id);
    if (index == -1) return;

    _pendingOperations[index] = operation.copyWith(
      status: SyncOperationStatus.syncing,
    );
    await _savePendingOperations();
    _syncOperationsController.add(_pendingOperations);

    try {
      // Simulate API call based on operation type
      await Future<void>.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // TODO: Implement actual API calls based on operation.endpoint and operation.type
      // For now, we'll simulate success

      // Mark as completed
      _pendingOperations[index] = operation.copyWith(
        status: SyncOperationStatus.completed,
      );
    } catch (e) {
      final newRetryCount = operation.retryCount + 1;

      if (newRetryCount >= _maxRetryCount) {
        // Mark as failed after max retries
        _pendingOperations[index] = operation.copyWith(
          status: SyncOperationStatus.failed,
          retryCount: newRetryCount,
          error: e.toString(),
        );
      } else {
        // Schedule retry
        _pendingOperations[index] = operation.copyWith(
          status: SyncOperationStatus.pending,
          retryCount: newRetryCount,
          error: e.toString(),
        );
      }
    }

    await _savePendingOperations();
    _syncOperationsController.add(_pendingOperations);
  }

  void _startSyncTimer() {
    _stopSyncTimer();
    _syncTimer = Timer.periodic(_retryDelay, (timer) {
      syncPendingOperations();
    });
  }

  void _stopSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }
}
