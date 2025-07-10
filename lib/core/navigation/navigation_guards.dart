import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../config/app_config.dart';
import '../services/biometric_auth_service.dart';
import '../services/secure_storage_service.dart';
import 'route_paths.dart';

/// Production-ready navigation guards and middleware
/// Handles authentication, authorization, and route protection
@singleton
class NavigationGuards {

  NavigationGuards(
    this._storageService,
    this._biometricService,
  );
  final SecureStorageService _storageService;
  final BiometricAuthService _biometricService;

  /// Check for navigation redirects based on app state
  String? checkRedirect(BuildContext context, GoRouterState state) {
    final currentPath = state.uri.path;
    
    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('🧭 Navigation guard checking: $currentPath');
    }

    // Skip guard checks for certain routes
    if (_shouldSkipGuards(currentPath)) {
      return null;
    }

    // Check authentication status
    return _checkAuthenticationGuards(context, state);
  }

  /// Check if route guards should be skipped
  bool _shouldSkipGuards(String path) {
    const skipPaths = [
      RoutePaths.error,
      RoutePaths.onboarding,
      RoutePaths.login,
    ];

    return skipPaths.any((skipPath) => path.startsWith(skipPath));
  }

  /// Check authentication and authorization guards
  String? _checkAuthenticationGuards(BuildContext context, GoRouterState state) {
    // For now, allow all routes through
    // This will be implemented when authentication system is ready
    return null;
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final tokens = await _storageService.getAuthTokens();
      return tokens['accessToken'] != null && tokens['accessToken']!.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Authentication check failed: $e');
      }
      return false;
    }
  }

  /// Check if user has completed onboarding
  Future<bool> hasCompletedOnboarding() async {
    try {
      final completed = await _storageService.getSecure('onboarding_completed');
      return completed == 'true';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Onboarding check failed: $e');
      }
      return false;
    }
  }

  /// Check if user has biometric authentication enabled
  Future<bool> hasBiometricAuthEnabled() async {
    try {
      final isAvailable = _biometricService.isAvailable;
      if (!isAvailable) {
        return false;
      }
      
      final enabled = await _storageService.getSecure('biometric_auth_enabled');
      return enabled == 'true';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Biometric auth check failed: $e');
      }
      return false;
    }
  }

  /// Check all route guards for a specific route
  Future<bool> checkRouteGuards(BuildContext context, String routeName) async {
    try {
      // Check authentication requirements
      if (_requiresAuthentication(routeName)) {
        if (!await isAuthenticated()) {
          return false;
        }
      }

      // Check onboarding requirements
      if (_requiresOnboarding(routeName)) {
        if (!await hasCompletedOnboarding()) {
          return false;
        }
      }

      // Check biometric requirements
      if (_requiresBiometric(routeName)) {
        if (!await hasBiometricAuthEnabled()) {
          return false;
        }
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Route guard check failed: $e');
      }
      return false;
    }
  }

  /// Check if route requires authentication
  bool _requiresAuthentication(String routeName) {
    const authRequiredRoutes = [
      RouteNames.profile,
      RouteNames.userProfile,
      RouteNames.wallet,
      RouteNames.walletConnect,
      RouteNames.settings,
      RouteNames.governance,
      RouteNames.chat,
      RouteNames.daoDetail,
      RouteNames.daoJoin,
      RouteNames.daoMembers,
      RouteNames.daoSettings,
      RouteNames.proposal,
      RouteNames.chatRoom,
    ];
    
    return authRequiredRoutes.contains(routeName);
  }

  /// Check if route requires onboarding
  bool _requiresOnboarding(String routeName) {
    const onboardingRequiredRoutes = [
      RouteNames.home,
      RouteNames.daos,
      RouteNames.governance,
      RouteNames.chat,
      RouteNames.profile,
      RouteNames.wallet,
    ];
    
    return onboardingRequiredRoutes.contains(routeName);
  }

  /// Check if route requires biometric auth
  bool _requiresBiometric(String routeName) {
    const biometricRequiredRoutes = [
      RouteNames.wallet,
      RouteNames.walletConnect,
    ];
    
    return biometricRequiredRoutes.contains(routeName);
  }

  /// Require authentication for protected routes
  Future<bool> requireAuthentication(BuildContext context) async {
    if (await isAuthenticated()) {
      return true;
    }

    // Redirect to login with return path
    if (context.mounted) {
      final currentUri = GoRouterState.of(context).uri;
      context.go('${RoutePaths.login}?${QueryParams.returnTo}=${Uri.encodeComponent(currentUri.toString())}');
    }
    
    return false;
  }

  /// Require onboarding completion for protected routes
  Future<bool> requireOnboarding(BuildContext context) async {
    if (await hasCompletedOnboarding()) {
      return true;
    }

    // Redirect to onboarding
    if (context.mounted) {
      context.go(RoutePaths.onboarding);
    }
    
    return false;
  }

  /// Require biometric authentication for sensitive operations
  Future<bool> requireBiometricAuth(
    BuildContext context, {
    String? customReason,
  }) async {
    if (!await hasBiometricAuthEnabled()) {
      return true; // Skip if not enabled
    }

    try {
      return await _biometricService.authenticate(
        reason: customReason ?? 'Please authenticate to continue',
        stickyAuth: true,
        sensitiveTransaction: true,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Biometric authentication failed: $e');
      }
      return false;
    }
  }

  /// Check if user can access DAO-specific content
  Future<bool> canAccessDao(String daoId) async {
    // TODO: Implement DAO membership check
    // This will check if user is a member of the specified DAO
    return true;
  }

  /// Check if user can access administrative features
  Future<bool> canAccessAdminFeatures(String daoId) async {
    // TODO: Implement admin permission check
    // This will check if user has admin/moderator permissions in the DAO
    return true;
  }

  /// Check if user can create proposals
  Future<bool> canCreateProposal(String daoId) async {
    // TODO: Implement proposal creation permission check
    // This will check if user meets minimum requirements for proposal creation
    return true;
  }

  /// Check if user can vote on proposals
  Future<bool> canVoteOnProposal(String daoId, String proposalId) async {
    // TODO: Implement voting permission check
    // This will check if user is eligible to vote on the specific proposal
    return true;
  }

  /// Handle route not found
  void handleRouteNotFound(BuildContext context, String path) {
    if (kDebugMode) {
      debugPrint('❌ Route not found: $path');
    }
    
    if (context.mounted) {
      context.go('${RoutePaths.error}?message=${Uri.encodeComponent('Route not found: $path')}');
    }
  }

  /// Handle navigation error
  void handleNavigationError(BuildContext context, Object error) {
    if (kDebugMode) {
      debugPrint('❌ Navigation error: $error');
    }
    
    if (context.mounted) {
      context.go('${RoutePaths.error}?message=${Uri.encodeComponent('Navigation error: $error')}');
    }
  }

  /// Validate deep link parameters
  bool validateDeepLinkParams(Map<String, String> params) {
    // TODO: Implement parameter validation based on route requirements
    // This will validate that required parameters are present and valid
    return true;
  }

  /// Check if route requires secure connection
  bool requiresSecureConnection(String path) {
    const securePaths = [
      RoutePaths.wallet,
      RoutePaths.walletConnect,
      RoutePaths.settings,
    ];

    return securePaths.any((securePath) => path.startsWith(securePath));
  }

  /// Log navigation analytics
  void logNavigation(String from, String to) {
    if (kDebugMode && AppConfig.enableDebugLogs) {
      debugPrint('🧭 Navigation: $from → $to');
    }
    
    // TODO: Send navigation analytics to privacy-compliant analytics service
  }
}
