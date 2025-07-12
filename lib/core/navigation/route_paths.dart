/// Route paths for the application
class RoutePaths {
  // Core Routes
  static const String home = '/';
  static const String dashboard = '/dashboard';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  
  // DAO Routes
  static const String daos = '/daos';
  static const String daoDetail = '/daos/:daoId';
  static const String daoJoin = '/daos/:daoId/join';
  static const String daoMembers = '/daos/:daoId/members';
  static const String daoSettings = '/daos/:daoId/settings';
  
  // Content Routes
  static const String proposal = '/daos/:daoId/proposal/:proposalId';
  static const String chatRoom = '/daos/:daoId/chat/:roomId';
  
  // Main Navigation Routes
  static const String governance = '/governance';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String userProfile = '/profile/:userId';
  
  // Wallet Routes
  static const String wallet = '/wallet';
  static const String walletConnect = '/wallet/connect';
  
  // Utility Routes
  static const String settings = '/settings';
  static const String invite = '/invite';
  static const String error = '/error';
}

/// Route names for named navigation
class RouteNames {
  // Core Routes
  static const String home = 'home';
  static const String dashboard = 'dashboard';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String signup = 'signup';
  
  // DAO Routes
  static const String daos = 'daos';
  static const String daoDetail = 'dao-detail';
  static const String daoJoin = 'dao-join';
  static const String daoMembers = 'dao-members';
  static const String daoSettings = 'dao-settings';
  
  // Content Routes
  static const String proposal = 'proposal';
  static const String chatRoom = 'chat-room';
  
  // Main Navigation Routes
  static const String governance = 'governance';
  static const String chat = 'chat';
  static const String profile = 'profile';
  static const String userProfile = 'user-profile';
  
  // Wallet Routes
  static const String wallet = 'wallet';
  static const String walletConnect = 'wallet-connect';
  
  // Utility Routes
  static const String settings = 'settings';
  static const String invite = 'invite';
  static const String error = 'error';
}

/// Route parameter keys
class RouteParams {
  static const String daoId = 'daoId';
  static const String proposalId = 'proposalId';
  static const String roomId = 'roomId';
  static const String userId = 'userId';
  static const String inviteCode = 'inviteCode';
}

/// Query parameter keys
class QueryParams {
  static const String returnTo = 'returnTo';
  static const String tab = 'tab';
  static const String filter = 'filter';
  static const String search = 'search';
  static const String page = 'page';
  static const String limit = 'limit';
  static const String source = 'source';
  static const String campaign = 'campaign';
}
