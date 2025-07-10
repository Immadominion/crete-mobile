import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../error/error_handler.dart';
import '../error/exceptions.dart';

/// Base state class for all Cubits
abstract class BaseState extends Equatable {
  const BaseState();
}

/// Base loading state
abstract class BaseLoadingState extends BaseState {
  const BaseLoadingState();
}

/// Base success state
abstract class BaseSuccessState extends BaseState {
  const BaseSuccessState();
}

/// Base error state
abstract class BaseErrorState extends BaseState {

  const BaseErrorState({required this.error, required this.message});
  final AppException error;
  final String message;

  @override
  List<Object> get props => [error, message];
}

/// Base Cubit class with error handling and logging
abstract class BaseCubit<T extends BaseState> extends Cubit<T> {
  BaseCubit({required T initialState}) : super(initialState);

  /// Execute an async operation with error handling
  Future<void> execute<R>(
    Future<R> Function() operation, {
    required void Function(R result) onSuccess,
    void Function(String error)? onError,
    void Function()? onLoading,
  }) async {
    try {
      onLoading?.call();
      final result = await operation();
      onSuccess(result);
    } catch (error) {
      final failure = ErrorHandler.handleException(error as Exception);

      if (kDebugMode) {
        debugPrint('🔴 Error in $runtimeType: ${failure.message}');
      }

      onError?.call(failure.message);
    }
  }

  /// Execute an async operation with automatic state management
  Future<void> executeWithState<R>({
    required Future<R> Function() operation,
    required T Function(R result) onSuccess,
    required T Function(String error) onError,
    T? loadingState,
  }) async {
    if (loadingState != null) {
      emit(loadingState);
    }

    await execute<R>(
      operation,
      onSuccess: (result) => emit(onSuccess(result)),
      onError: (error) => emit(onError(error)),
    );
  }

  /// Log a message with cubit context
  void log(String message) {
    if (kDebugMode) {
      debugPrint('🔵 $runtimeType: $message');
    }
  }
}
