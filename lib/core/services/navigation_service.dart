import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../config/app_config.dart';
import '../navigation/route_paths.dart';

/// Production-ready navigation service
/// Provides high-level navigation methods with error handling and analytics
@singleton
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Get the current build context
  BuildContext? get context => navigatorKey.currentContext;

  /// Navigate to a named route
  void goToNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    Object? extra,
  }) {
    try {
      if (context?.mounted == true) {
        context!.goNamed(
          name,
          pathParameters: pathParameters,
          queryParameters: queryParameters,
          extra: extra,
        );
        
        _logNavigation('go_named', name);
      }
    } catch (e) {
      _handleNavigationError('goToNamed', e);
    }
  }

  /// Navigate to a path
  void goTo(String path, {Object? extra}) {
    try {
      if (context?.mounted == true) {
        context!.go(path, extra: extra);
        _logNavigation('go', path);
      }
    } catch (e) {
      _handleNavigationError('goTo', e);
    }
  }

  /// Push a named route
  void pushNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    Object? extra,
  }) {
    try {
      if (context?.mounted == true) {
        context!.pushNamed(
          name,
          pathParameters: pathParameters,
          queryParameters: queryParameters,
          extra: extra,
        );
        
        _logNavigation('push_named', name);
      }
    } catch (e) {
      _handleNavigationError('pushNamed', e);
    }
  }

  /// Push replacement for a named route
  void pushReplacementNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    Object? extra,
  }) {
    try {
      if (context?.mounted == true) {
        context!.pushReplacementNamed(
          name,
          pathParameters: pathParameters,
          queryParameters: queryParameters,
          extra: extra,
        );
        
        _logNavigation('push_replacement_named', name);
      }
    } catch (e) {
      _handleNavigationError('pushReplacementNamed', e);
    }
  }

  /// Push a path
  void push(String path, {Object? extra}) {
    try {
      if (context?.mounted == true) {
        context!.push(path, extra: extra);
        _logNavigation('push', path);
      }
    } catch (e) {
      _handleNavigationError('push', e);
    }
  }

  /// Pop the current route
  void pop<T extends Object?>([T? result]) {
    try {
      if (context?.mounted == true && canPop()) {
        context!.pop(result);
        _logNavigation('pop', 'back');
      }
    } catch (e) {
      _handleNavigationError('pop', e);
    }
  }

  /// Pop until a specific route
  void popUntil(String routeName) {
    try {
      if (context?.mounted == true) {
        while (canPop() && getCurrentRouteName() != routeName) {
          context!.pop();
        }
        _logNavigation('pop_until', routeName);
      }
    } catch (e) {
      _handleNavigationError('popUntil', e);
    }
  }

  /// Check if we can pop
  bool canPop() => context?.canPop() ?? false;

  /// Replace current route
  void replace(String path, {Object? extra}) {
    try {
      if (context?.mounted == true) {
        context!.pushReplacement(path, extra: extra);
        _logNavigation('replace', path);
      }
    } catch (e) {
      _handleNavigationError('replace', e);
    }
  }

  /// Navigate to home
  void goHome() {
    goTo(RoutePaths.home);
  }

  /// Navigate to DAO list
  void goToDaos() {
    goTo(RoutePaths.daos);
  }

  /// Navigate to specific DAO
  void goToDao(String daoId) {
    goToNamed(RouteNames.daoDetail, pathParameters: {RouteParams.daoId: daoId});
  }

  /// Navigate to DAO join screen
  void goToDaoJoin(String daoId) {
    goToNamed(RouteNames.daoJoin, pathParameters: {RouteParams.daoId: daoId});
  }

  /// Navigate to proposal
  void goToProposal(String daoId, String proposalId) {
    goToNamed(
      RouteNames.proposal,
      pathParameters: {
        RouteParams.daoId: daoId,
        RouteParams.proposalId: proposalId,
      },
    );
  }

  /// Navigate to chat room
  void goToChatRoom(String daoId, String roomId) {
    goToNamed(
      RouteNames.chatRoom,
      pathParameters: {
        RouteParams.daoId: daoId,
        RouteParams.roomId: roomId,
      },
    );
  }

  /// Navigate to user profile
  void goToProfile([String? userId]) {
    if (userId != null) {
      goToNamed(RouteNames.userProfile, pathParameters: {RouteParams.userId: userId});
    } else {
      goTo(RoutePaths.profile);
    }
  }

  /// Navigate to wallet
  void goToWallet() {
    goTo(RoutePaths.wallet);
  }

  /// Navigate to wallet connection
  void goToWalletConnect() {
    goToNamed(RouteNames.walletConnect);
  }

  /// Navigate to settings
  void goToSettings() {
    goTo(RoutePaths.settings);
  }

  /// Navigate to governance
  void goToGovernance() {
    goTo(RoutePaths.governance);
  }

  /// Navigate to chat
  void goToChat() {
    goTo(RoutePaths.chat);
  }

  /// Navigate to invite screen
  void goToInvite(String inviteCode) {
    goToNamed(RouteNames.invite, pathParameters: {RouteParams.inviteCode: inviteCode});
  }

  /// Navigate to onboarding
  void goToOnboarding() {
    goTo(RoutePaths.onboarding);
  }

  /// Navigate to login
  void goToLogin({String? returnTo}) {
    final queryParams = returnTo != null ? {QueryParams.returnTo: returnTo} : <String, String>{};
    goToNamed(RouteNames.login, queryParameters: queryParams);
  }

  /// Navigate to error screen
  void goToError({String? error}) {
    goTo(RoutePaths.error, extra: error);
  }

  /// Navigate back with fallback to home
  void goBackOrHome() {
    if (canPop()) {
      pop();
    } else {
      goHome();
    }
  }

  /// Clear navigation stack and go to route
  void clearAndGoTo(String path, {Object? extra}) {
    try {
      if (context?.mounted == true) {
        // Use pushReplacement to clear the stack
        while (canPop()) {
          pop();
        }
        replace(path, extra: extra);
      }
    } catch (e) {
      _handleNavigationError('clearAndGoTo', e);
    }
  }

  /// Get current route path
  String? getCurrentPath() {
    try {
      return GoRouterState.of(context!).uri.path;
    } catch (e) {
      return null;
    }
  }

  /// Get current route name
  String? getCurrentRouteName() {
    try {
      return GoRouterState.of(context!).name;
    } catch (e) {
      return null;
    }
  }

  /// Check if currently on a specific route
  bool isCurrentRoute(String path) => getCurrentPath() == path;

  /// Check if currently on a specific named route
  bool isCurrentNamedRoute(String name) => getCurrentRouteName() == name;

  /// Navigate with query parameters
  void goWithQuery(String path, Map<String, String> queryParams) {
    final uri = Uri.parse(path);
    final newUri = uri.replace(
      queryParameters: {...uri.queryParameters, ...queryParams},
    );
    goTo(newUri.toString());
  }

  /// Log navigation for debugging and analytics
  void _logNavigation(String action, String destination) {
    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('🧭 Navigation [$action]: $destination');
    }
    
    // TODO: Send to privacy-compliant analytics service
  }

  /// Public method to log navigation events
  void logNavigation(String from, String to, {Map<String, dynamic>? metadata}) {
    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('🧭 Navigation Event: $from → $to');
      if (metadata != null && metadata.isNotEmpty) {
        debugPrint('🧭 Metadata: $metadata');
      }
    }
    
    // TODO: Send to privacy-compliant analytics service
  }

  /// Handle navigation errors
  void _handleNavigationError(String operation, Object error) {
    if (kDebugMode) {
      debugPrint('❌ Navigation error in $operation: $error');
    }
    
    // TODO: Send to error reporting service
    try {
      goToError(error: 'Navigation error: $error');
    } catch (e) {
      // Last resort - try to go home
      try {
        if (context?.mounted == true) {
          context!.go(RoutePaths.home);
        }
      } catch (homeError) {
        if (kDebugMode) {
          debugPrint('❌ Critical navigation error: $homeError');
        }
      }
    }
  }
}
