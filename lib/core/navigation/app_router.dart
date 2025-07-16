import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../presentation/auth/sign_in_screen.dart';
import '../../presentation/dashboard_layout.dart';
import '../config/app_config.dart';
import '../services/deep_link_service.dart';
import '../services/navigation_service.dart';
import '../widgets/language_switcher.dart';
import 'navigation_guards.dart';
import 'route_paths.dart';

/// Production-ready application router with Go Router
/// Handles all navigation, deep linking, and route management
@singleton
class AppRouter {
  AppRouter(this._deepLinkService, this._navigationGuards) {
    _initializeRouter();
  }
  final DeepLinkService _deepLinkService;
  final NavigationGuards _navigationGuards;

  late final GoRouter _router;

  /// Get the configured router instance
  GoRouter get router => _router;

  /// Initialize the Go Router with all routes and configuration
  void _initializeRouter() {
    _router = GoRouter(
      initialLocation: RoutePaths.login,
      // initialLocation: RoutePaths.dashboard,
      debugLogDiagnostics: AppConfig.isDevelopment,
      navigatorKey: NavigationService.navigatorKey,
      onException: _handleRouteException,
      redirect: _handleRedirect,
      routes: [
        // Home Route - redirects to dashboard
        GoRoute(
          path: RoutePaths.home,
          name: RouteNames.home,
          pageBuilder: (context, state) =>
              _buildPage(context, state, const HomeScreen()),
        ),

        // Dashboard Route
        GoRoute(
          path: RoutePaths.dashboard,
          name: RouteNames.dashboard,
          pageBuilder: (context, state) =>
              _buildPage(context, state, const DashboardLayout()),
        ),

        // Onboarding Routes
        GoRoute(
          path: RoutePaths.onboarding,
          name: RouteNames.onboarding,
          pageBuilder: (context, state) =>
              _buildPage(context, state, const OnboardingScreen()),
        ),

        // Authentication Routes
        GoRoute(
          path: RoutePaths.login,
          name: RouteNames.login,
          pageBuilder: (context, state) =>
              _buildPage(context, state, const LoginScreen()),
        ),

        GoRoute(
          path: RoutePaths.signup,
          name: RouteNames.signup,
          pageBuilder: (context, state) =>
              _buildPage(context, state, const SignupScreen()),
        ),

        // DAO Routes
        GoRoute(
          path: RoutePaths.daos,
          name: RouteNames.daos,
          pageBuilder: (context, state) =>
              _buildPage(context, state, const DaoListScreen()),
          routes: [
            GoRoute(
              path: ':daoId',
              name: RouteNames.daoDetail,
              pageBuilder: (context, state) {
                final daoId = state.pathParameters['daoId']!;
                return _buildPage(
                  context,
                  state,
                  DaoDetailScreen(daoId: daoId),
                );
              },
              routes: [
                GoRoute(
                  path: '/join',
                  name: RouteNames.daoJoin,
                  pageBuilder: (context, state) {
                    final daoId = state.pathParameters['daoId']!;
                    return _buildPage(
                      context,
                      state,
                      DaoJoinScreen(daoId: daoId),
                    );
                  },
                ),
                GoRoute(
                  path: '/members',
                  name: RouteNames.daoMembers,
                  pageBuilder: (context, state) {
                    final daoId = state.pathParameters['daoId']!;
                    return _buildPage(
                      context,
                      state,
                      DaoMembersScreen(daoId: daoId),
                    );
                  },
                ),
                GoRoute(
                  path: '/settings',
                  name: RouteNames.daoSettings,
                  pageBuilder: (context, state) {
                    final daoId = state.pathParameters['daoId']!;
                    return _buildPage(
                      context,
                      state,
                      DaoSettingsScreen(daoId: daoId),
                    );
                  },
                ),
                GoRoute(
                  path: '/proposal/:proposalId',
                  name: RouteNames.proposal,
                  pageBuilder: (context, state) {
                    final daoId = state.pathParameters['daoId']!;
                    final proposalId = state.pathParameters['proposalId']!;
                    return _buildPage(
                      context,
                      state,
                      ProposalScreen(daoId: daoId, proposalId: proposalId),
                    );
                  },
                ),
                GoRoute(
                  path: '/chat/:roomId',
                  name: RouteNames.chatRoom,
                  pageBuilder: (context, state) {
                    final daoId = state.pathParameters['daoId']!;
                    final roomId = state.pathParameters['roomId']!;
                    return _buildPage(
                      context,
                      state,
                      ChatRoomScreen(daoId: daoId, roomId: roomId),
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        // Governance Routes
        GoRoute(
          path: RoutePaths.governance,
          name: RouteNames.governance,
          pageBuilder: (context, state) =>
              _buildPage(context, state, const GovernanceScreen()),
        ),

        // Chat Routes
        GoRoute(
          path: RoutePaths.chat,
          name: RouteNames.chat,
          pageBuilder: (context, state) =>
              _buildPage(context, state, const ChatScreen()),
        ),

        // Profile Routes
        GoRoute(
          path: RoutePaths.profile,
          name: RouteNames.profile,
          pageBuilder: (context, state) =>
              _buildPage(context, state, const ProfileScreen()),
        ),

        GoRoute(
          path: '${RoutePaths.profile}/:userId',
          name: RouteNames.userProfile,
          pageBuilder: (context, state) {
            final userId = state.pathParameters['userId']!;
            return _buildPage(
              context,
              state,
              UserProfileScreen(userId: userId),
            );
          },
        ),

        // Wallet Routes
        GoRoute(
          path: RoutePaths.wallet,
          name: RouteNames.wallet,
          pageBuilder: (context, state) =>
              _buildPage(context, state, const WalletScreen()),
          routes: [
            GoRoute(
              path: '/connect',
              name: RouteNames.walletConnect,
              pageBuilder: (context, state) =>
                  _buildPage(context, state, const WalletConnectScreen()),
            ),
          ],
        ),

        // Settings Routes
        GoRoute(
          path: RoutePaths.settings,
          name: RouteNames.settings,
          pageBuilder: (context, state) =>
              _buildPage(context, state, const SettingsScreen()),
        ),

        // Invite Routes
        GoRoute(
          path: '${RoutePaths.invite}/:inviteCode',
          name: RouteNames.invite,
          pageBuilder: (context, state) {
            final inviteCode = state.pathParameters['inviteCode']!;
            return _buildPage(
              context,
              state,
              InviteScreen(inviteCode: inviteCode),
            );
          },
        ),

        // Error Routes
        GoRoute(
          path: RoutePaths.error,
          name: RouteNames.error,
          pageBuilder: (context, state) {
            final error = state.extra as String?;
            return _buildPage(context, state, ErrorScreen(error: error));
          },
        ),
      ],
    );
  }

  /// Handle navigation redirects and route guards
  String? _handleRedirect(BuildContext context, GoRouterState state) =>
      _navigationGuards.checkRedirect(context, state);

  /// Handle route exceptions
  void _handleRouteException(
    BuildContext context,
    GoRouterState state,
    GoRouter router,
  ) {
    if (AppConfig.isDevelopment) {
      debugPrint('🔥 Route exception: ${state.uri}');
    }

    router.go(RoutePaths.error, extra: 'Route not found: ${state.uri}');
  }

  /// Build page with proper transition animations
  Page<T> _buildPage<T extends Object?>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) => CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        ),
  );
}

/// Temporary placeholder screens - will be replaced with actual screens
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.welcome,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Environment: ${AppConfig.appEnvironment}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '${l10n.version}: ${AppConfig.appVersion}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            const Text(
              '🎉 Navigation & Deep Linking Ready!\n'
              'Step 9 Complete - All foundation ready for UI development.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Step 9: Navigation Complete'),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/daos'),
              child: const Text('Test Navigation - Go to DAOs'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.go('/profile'),
              child: Text('Test Navigation - Go to ${l10n.profile}'),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.welcome)),
      body: const Center(child: Text('Onboarding Screen')),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignInScreen();
  }
}

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.signUp)),
      body: const Center(child: Text('Sign Up Screen')),
    );
  }
}

class DaoListScreen extends StatelessWidget {
  const DaoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('DAOs')),
      body: const Center(child: Text('DAO List Screen')),
    );
  }
}

class DaoDetailScreen extends StatelessWidget {
  const DaoDetailScreen({super.key, required this.daoId});
  final String daoId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('DAO: $daoId')),
    body: Center(child: Text('DAO Detail Screen: $daoId')),
  );
}

class DaoJoinScreen extends StatelessWidget {
  const DaoJoinScreen({super.key, required this.daoId});
  final String daoId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Join DAO: $daoId')),
    body: Center(child: Text('Join DAO Screen: $daoId')),
  );
}

class DaoMembersScreen extends StatelessWidget {
  const DaoMembersScreen({super.key, required this.daoId});
  final String daoId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Members: $daoId')),
    body: Center(child: Text('DAO Members Screen: $daoId')),
  );
}

class DaoSettingsScreen extends StatelessWidget {
  const DaoSettingsScreen({super.key, required this.daoId});
  final String daoId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Settings: $daoId')),
    body: Center(child: Text('DAO Settings Screen: $daoId')),
  );
}

class ProposalScreen extends StatelessWidget {
  const ProposalScreen({
    super.key,
    required this.daoId,
    required this.proposalId,
  });
  final String daoId;
  final String proposalId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Proposal: $proposalId')),
    body: Center(child: Text('Proposal Screen: $daoId/$proposalId')),
  );
}

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({super.key, required this.daoId, required this.roomId});
  final String daoId;
  final String roomId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('Chat: $roomId')),
    body: Center(child: Text('Chat Room Screen: $daoId/$roomId')),
  );
}

class GovernanceScreen extends StatelessWidget {
  const GovernanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Governance')),
      body: const Center(child: Text('Governance Screen')),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: const Center(child: Text('Chat Screen')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: const Center(child: Text('Profile Screen')),
    );
  }
}

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('User: $userId')),
    body: Center(child: Text('User Profile Screen: $userId')),
  );
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.wallet)),
      body: const Center(child: Text('Wallet Screen')),
    );
  }
}

class WalletConnectScreen extends StatelessWidget {
  const WalletConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.connectWallet)),
      body: const Center(child: Text('Wallet Connect Screen')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    l10n.language,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const LanguageSwitcher(
                  showTitle: false,
                  padding: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.palette),
              title: Text(l10n.theme),
              subtitle: const Text('System Default'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Implement theme switching
              },
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.notifications),
              title: Text(l10n.notifications),
              subtitle: const Text('Enabled'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Implement notification settings
              },
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.security),
              title: Text(l10n.security),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Implement security settings
              },
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info),
              title: Text(l10n.about),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Implement about screen
              },
            ),
          ),
        ],
      ),
    );
  }
}

class InviteScreen extends StatelessWidget {
  const InviteScreen({super.key, required this.inviteCode});
  final String inviteCode;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Invite')),
    body: Center(child: Text('Invite Screen: $inviteCode')),
  );
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, this.error});
  final String? error;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.error)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(error ?? l10n.unknownError),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RoutePaths.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
