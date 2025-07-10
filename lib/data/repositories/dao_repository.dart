import '../../core/models/api/dao_models.dart';
import '../../domain/repositories/dao_repository.dart';
import '../data_sources/local_data_source.dart';
import '../data_sources/remote_data_source.dart';

/// Concrete implementation of DaoRepository
class DaoRepository implements IDaoRepository {

  DaoRepository(this._remoteDataSource, this._localDataSource);
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  @override
  Future<List<DaoInfo>> getMyDaos() async => _remoteDataSource.getMyDaos();

  @override
  Future<List<DaoInfo>> getPublicDaos({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      // For first page, try cache first
      if (page == 1 && search == null) {
        final isCacheValid = await _localDataSource.isDaosCacheValid();
        if (isCacheValid) {
          final cachedDaos = await _localDataSource.getCachedDaos();
          if (cachedDaos.isNotEmpty) {
            return cachedDaos;
          }
        }
      }

      // Fetch from remote
      final daos = await _remoteDataSource.getPublicDaos(
        page: page,
        limit: limit,
        search: search,
      );

      // Cache first page results
      if (page == 1 && search == null) {
        await _localDataSource.cacheDaos(daos);
      }

      return daos;
    } catch (e) {
      // Return cached results if remote fails
      if (page == 1 && search == null) {
        return _localDataSource.getCachedDaos();
      }
      rethrow;
    }
  }

  @override
  Future<DaoInfo> getDaoById(String daoId) async => _remoteDataSource.getDaoById(daoId);

  @override
  Future<void> joinDao(String daoId) async {
    await _remoteDataSource.joinDao(daoId);
    // Clear cache to force refresh
    await _localDataSource.clearAllCaches();
  }

  @override
  Future<void> leaveDao(String daoId) async {
    await _remoteDataSource.leaveDao(daoId);
    // Clear cache to force refresh
    await _localDataSource.clearAllCaches();
  }

  @override
  Future<List<DaoMember>> getDaoMembers(String daoId) async => _remoteDataSource.getDaoMembers(daoId);

  @override
  Future<DaoMember?> getDaoMember(String daoId, String userId) async {
    final members = await getDaoMembers(daoId);
    try {
      return members.firstWhere((member) => member.userId == userId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isMemberOfDao(String daoId) async {
    final userId = await _localDataSource.getUserId();
    if (userId == null) return false;

    final member = await getDaoMember(daoId, userId);
    return member != null;
  }

  @override
  Future<String?> getUserRoleInDao(String daoId) async {
    final userId = await _localDataSource.getUserId();
    if (userId == null) return null;

    final member = await getDaoMember(daoId, userId);
    return member?.role;
  }

  @override
  Future<List<DaoInfo>> searchDaos(String query) async => _remoteDataSource.getPublicDaos(
      limit: 50,
      search: query,
    );

  @override
  Future<List<DaoInfo>> getTrendingDaos() async {
    // For now, return public DAOs as trending
    // In the future, this could be a separate endpoint
    return _remoteDataSource.getPublicDaos(limit: 10);
  }

  @override
  Future<List<DaoInfo>> getCachedDaos() async => _localDataSource.getCachedDaos();

  @override
  Future<void> cacheDaos(List<DaoInfo> daos) async {
    await _localDataSource.cacheDaos(daos);
  }

  @override
  Future<void> clearDaoCache() async {
    await _localDataSource.clearAllCaches();
  }
}
