import '../../core/models/api/user_models.dart';

/// Repository interface for user operations
abstract class IUserRepository {
  /// Get user profile
  Future<UserProfile> getUserProfile(String userId);

  /// Update user profile
  Future<UserProfile> updateUserProfile({
    String? username,
    String? email,
    String? avatarUrl,
    Map<String, dynamic>? metadata,
  });

  /// Get current user profile
  Future<UserProfile?> getCurrentUserProfile();

  /// Get user's DAO memberships
  Future<List<String>> getUserDaoMemberships(String userId);

  /// Get user's voting history
  Future<List<String>> getUserVotingHistory(String userId);

  /// Search users
  Future<List<UserProfile>> searchUsers(String query);

  /// Get cached user profile
  Future<UserProfile?> getCachedUserProfile(String userId);

  /// Cache user profile
  Future<void> cacheUserProfile(UserProfile profile);

  /// Clear user cache
  Future<void> clearUserCache();

  /// Update user avatar
  Future<UserProfile> updateUserAvatar(String avatarUrl);

  /// Delete user account
  Future<void> deleteUserAccount();
}
