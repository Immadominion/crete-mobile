// Storage keys for local data persistence
class StorageKeys {
  // Authentication
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String walletAddress = 'wallet_address';
  static const String walletType = 'wallet_type';
  static const String userProfile = 'user_profile';

  // Matrix/Chat
  static const String matrixAccessToken = 'matrix_access_token';
  static const String matrixUserId = 'matrix_user_id';
  static const String matrixDeviceId = 'matrix_device_id';

  // Caching
  static const String cachedDaos = 'cached_daos';
  static const String daosCacheTime = 'daos_cache_time';
  static const String cachedProposals = 'cached_proposals';
  static const String proposalsCacheTime = 'proposals_cache_time';
  static const String cachedMessages = 'cached_messages';

  // App state
  static const String isFirstLaunch = 'is_first_launch';
  static const String hasCompletedOnboarding = 'has_completed_onboarding';
  static const String selectedTheme = 'selected_theme';
  static const String appTheme = 'app_theme';
  static const String notificationSettings = 'notification_settings';

  // DAO data
  static const String joinedDaos = 'joined_daos';
  static const String daoNotificationSettings = 'dao_notification_settings';

  // Cache keys
  static const String cachedDaoList = 'cached_dao_list';
  static const String lastSyncTimestamp = 'last_sync_timestamp';
}
