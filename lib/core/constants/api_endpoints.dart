// API endpoints for Crete DAO backend services
class ApiEndpoints {
  static const String baseUrl = 'https://api.crete.app';
  static const String blinkBaseUrl = 'https://blinks.crete.app';

  // Authentication endpoints
  static const String auth = '/auth';
  static const String walletConnect = '$auth/wallet/connect';
  static const String discordAuth = '$auth/discord';
  static const String guestSession = '$auth/guest';

  // DAO endpoints
  static const String daos = '/daos';
  static const String publicDaos = '$daos/public';
  static const String myDaos = '$daos/me';
  static const String joinDao = '$daos/{id}/join';
  static const String leaveDao = '$daos/{id}/leave';
  static const String daoMembers = '$daos/{id}/members';

  // Governance endpoints
  static const String proposals = '/proposals';
  static const String createProposal = '$proposals/create';
  static const String voteProposal = '$proposals/{id}/vote';
  static const String proposalResults = '$proposals/{id}/results';

  // Chat/Matrix endpoints
  static const String matrix = '/matrix';
  static const String matrixLogin = '$matrix/login';
  static const String rooms = '$matrix/rooms';

  // Notifications
  static const String notifications = '/notifications';
  static const String markRead = '$notifications/{id}/read';
  static const String notificationSettings = '$notifications/settings';

  // Blink endpoints (Solana transactions)
  static const String blinks = '/blinks';
  static const String createTransaction = '$blinks/transaction';
  static const String signTransaction = '$blinks/sign';
}
