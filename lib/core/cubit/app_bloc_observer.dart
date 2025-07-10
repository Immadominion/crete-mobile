import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Global BlocObserver for debugging and monitoring
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (kDebugMode) {
      debugPrint('🟢 ${bloc.runtimeType} created');
    }
  }

  @override
  void onEvent(BlocBase bloc, Object? event) {
    super.onEvent(bloc as Bloc, event);
    if (kDebugMode) {
      debugPrint('🔄 ${bloc.runtimeType} event: $event');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      debugPrint('🔄 ${bloc.runtimeType} change: $change');
    }
  }

  @override
  void onTransition(BlocBase bloc, Transition transition) {
    super.onTransition(bloc as Bloc, transition);
    if (kDebugMode) {
      debugPrint('🔄 ${bloc.runtimeType} transition: $transition');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (kDebugMode) {
      debugPrint('🔴 ${bloc.runtimeType} error: $error');
      debugPrint('🔴 Stack trace: $stackTrace');
    }

    // In production, you might want to send this to crash reporting
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (kDebugMode) {
      debugPrint('🔴 ${bloc.runtimeType} closed');
    }
  }
}
