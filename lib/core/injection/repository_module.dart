import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/data_sources/local_data_source.dart';
import '../../data/data_sources/remote_data_source.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/chat_repository.dart';
import '../../data/repositories/dao_repository.dart';
import '../../data/repositories/proposal_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../services/api_service.dart';

@module
abstract class RepositoryModule {
  /// Data sources
  @singleton
  LocalDataSource localDataSource(SharedPreferences prefs) =>
      LocalDataSource(prefs);

  @singleton
  RemoteDataSource remoteDataSource(ApiService apiService) =>
      RemoteDataSource(apiService);

  /// Repositories
  @singleton
  AuthRepository authRepository(
    RemoteDataSource remoteDataSource,
    LocalDataSource localDataSource,
  ) => AuthRepository(remoteDataSource, localDataSource);

  @singleton
  DaoRepository daoRepository(
    RemoteDataSource remoteDataSource,
    LocalDataSource localDataSource,
  ) => DaoRepository(remoteDataSource, localDataSource);

  @singleton
  ProposalRepository proposalRepository(
    RemoteDataSource remoteDataSource,
    LocalDataSource localDataSource,
  ) => ProposalRepository(remoteDataSource, localDataSource);

  @singleton
  UserRepository userRepository(
    RemoteDataSource remoteDataSource,
    LocalDataSource localDataSource,
  ) => UserRepository(remoteDataSource, localDataSource);

  @singleton
  ChatRepository chatRepository(
    RemoteDataSource remoteDataSource,
    LocalDataSource localDataSource,
  ) => ChatRepository(remoteDataSource, localDataSource);
}
