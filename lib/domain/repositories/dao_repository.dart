import '../../core/models/api/dao_models.dart';

/// Repository interface for DAO operations
abstract class IDaoRepository {
  /// Get all DAOs for the current user
  Future<List<DaoInfo>> getMyDaos();

  /// Get public DAOs
  Future<List<DaoInfo>> getPublicDaos({
    int page = 1,
    int limit = 20,
    String? search,
  });

  /// Get DAO by ID
  Future<DaoInfo> getDaoById(String daoId);

  /// Join a DAO
  Future<void> joinDao(String daoId);

  /// Leave a DAO
  Future<void> leaveDao(String daoId);

  /// Get DAO members
  Future<List<DaoMember>> getDaoMembers(String daoId);

  /// Get DAO member by user ID
  Future<DaoMember?> getDaoMember(String daoId, String userId);

  /// Check if user is member of DAO
  Future<bool> isMemberOfDao(String daoId);

  /// Get user's role in DAO
  Future<String?> getUserRoleInDao(String daoId);

  /// Search DAOs
  Future<List<DaoInfo>> searchDaos(String query);

  /// Get trending DAOs
  Future<List<DaoInfo>> getTrendingDaos();

  /// Get cached DAOs
  Future<List<DaoInfo>> getCachedDaos();

  /// Cache DAOs
  Future<void> cacheDaos(List<DaoInfo> daos);

  /// Clear DAO cache
  Future<void> clearDaoCache();
}
