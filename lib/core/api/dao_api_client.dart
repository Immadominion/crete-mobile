import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/api/dao_models.dart';

part 'dao_api_client.g.dart';

/// DAO API client
@RestApi()
abstract class DaoApiClient {
  factory DaoApiClient(Dio dio, {String baseUrl}) = _DaoApiClient;

  /// Get public DAOs
  @GET('/daos/public')
  Future<List<DaoInfo>> getPublicDaos(
    @Query('page') int page,
    @Query('limit') int limit,
    @Query('search') String? search,
  );

  /// Get user's DAOs
  @GET('/daos/me')
  Future<List<DaoInfo>> getUserDaos();

  /// Get DAO details
  @GET('/daos/{id}')
  Future<DaoInfo> getDaoDetails(@Path('id') String daoId);

  /// Join a DAO
  @POST('/daos/{id}/join')
  Future<void> joinDao(@Path('id') String daoId);

  /// Leave a DAO
  @DELETE('/daos/{id}/leave')
  Future<void> leaveDao(@Path('id') String daoId);

  /// Get DAO members
  @GET('/daos/{id}/members')
  Future<List<DaoMember>> getDaoMembers(
    @Path('id') String daoId,
    @Query('page') int page,
    @Query('limit') int limit,
  );

  /// Update member role
  @PUT('/daos/{id}/members/{userId}/role')
  Future<DaoMember> updateMemberRole(
    @Path('id') String daoId,
    @Path('userId') String userId,
    @Body() Map<String, String> roleData,
  );
}
