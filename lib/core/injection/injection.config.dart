// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../data/data_sources/local_data_source.dart' as _i466;
import '../../data/data_sources/remote_data_source.dart' as _i264;
import '../../data/repositories/auth_repository.dart' as _i481;
import '../../data/repositories/chat_repository.dart' as _i415;
import '../../data/repositories/dao_repository.dart' as _i963;
import '../../data/repositories/proposal_repository.dart' as _i599;
import '../../data/repositories/user_repository.dart' as _i517;
import '../api/auth_api_client.dart' as _i681;
import '../api/dao_api_client.dart' as _i323;
import '../api/proposal_api_client.dart' as _i354;
import '../cubit/localization_cubit.dart' as _i317;
import '../navigation/app_router.dart' as _i630;
import '../navigation/navigation_guards.dart' as _i73;
import '../services/api_service.dart' as _i137;
import '../services/biometric_auth_service.dart' as _i919;
import '../services/blinks_service.dart' as _i327;
import '../services/cache_service.dart' as _i717;
import '../services/certificate_pinning_service.dart' as _i957;
import '../services/connectivity_service.dart' as _i47;
import '../services/deep_link_service.dart' as _i391;
import '../services/firebase_notification_service.dart' as _i37;
import '../services/http_client_service.dart' as _i624;
import '../services/localization_service.dart' as _i999;
import '../services/navigation_service.dart' as _i31;
import '../services/offline_data_service.dart' as _i161;
import '../services/privacy_analytics_service.dart' as _i865;
import '../services/privacy_service.dart' as _i155;
import '../services/secure_storage_service.dart' as _i535;
import '../services/solana_network_service.dart' as _i377;
import '../services/wallet_connection_service.dart' as _i561;
import '../services/websocket_client_service.dart' as _i231;
import 'repository_module.dart' as _i130;
import 'service_module.dart' as _i180;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final serviceModule = _$ServiceModule();
    final repositoryModule = _$RepositoryModule();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => serviceModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i361.Dio>(() => serviceModule.dio);
    gh.singleton<_i895.Connectivity>(() => serviceModule.connectivity);
    gh.singleton<_i37.FirebaseNotificationService>(
        () => _i37.FirebaseNotificationService());
    gh.singleton<_i31.NavigationService>(() => _i31.NavigationService());
    gh.singleton<_i377.SolanaNetworkService>(
        () => _i377.SolanaNetworkService());
    gh.singleton<_i999.LocalizationService>(() => _i999.LocalizationService());
    gh.singleton<_i327.BlinksService>(() => _i327.BlinksService());
    gh.singleton<_i919.BiometricAuthService>(
        () => _i919.BiometricAuthService());
    gh.singleton<_i535.SecureStorageService>(
        () => _i535.SecureStorageService());
    gh.singleton<_i561.WalletConnectionService>(
        () => _i561.WalletConnectionService());
    gh.singleton<_i957.CertificatePinningService>(
        () => _i957.CertificatePinningService());
    gh.singleton<_i466.LocalDataSource>(
        () => repositoryModule.localDataSource(gh<_i460.SharedPreferences>()));
    gh.singleton<_i231.WebSocketClientService>(
        () => _i231.WebSocketClientService(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i717.CacheService>(
        () => _i717.CacheService(gh<_i460.SharedPreferences>()));
    gh.singleton<_i73.NavigationGuards>(() => _i73.NavigationGuards(
          gh<_i535.SecureStorageService>(),
          gh<_i919.BiometricAuthService>(),
        ));
    gh.singleton<_i155.PrivacyService>(() => _i155.PrivacyService(
          gh<_i460.SharedPreferences>(),
          gh<_i535.SecureStorageService>(),
        ));
    gh.singleton<_i624.HttpClientService>(() => _i624.HttpClientService(
          gh<_i460.SharedPreferences>(),
          gh<_i957.CertificatePinningService>(),
        ));
    gh.singleton<_i47.ConnectivityService>(
        () => _i47.ConnectivityService(gh<_i895.Connectivity>()));
    gh.factory<_i317.LocalizationCubit>(
        () => _i317.LocalizationCubit(gh<_i999.LocalizationService>()));
    gh.lazySingleton<_i161.OfflineDataService>(() => _i161.OfflineDataService(
          gh<_i460.SharedPreferences>(),
          gh<_i47.ConnectivityService>(),
          gh<_i717.CacheService>(),
        ));
    gh.singleton<_i865.PrivacyAnalyticsService>(
        () => _i865.PrivacyAnalyticsService(
              gh<_i460.SharedPreferences>(),
              gh<_i155.PrivacyService>(),
            ));
    gh.singleton<_i137.ApiService>(
        () => _i137.ApiService(gh<_i624.HttpClientService>()));
    gh.singleton<_i681.AuthApiClient>(
        () => serviceModule.authApiClient(gh<_i624.HttpClientService>()));
    gh.singleton<_i323.DaoApiClient>(
        () => serviceModule.daoApiClient(gh<_i624.HttpClientService>()));
    gh.singleton<_i354.ProposalApiClient>(
        () => serviceModule.proposalApiClient(gh<_i624.HttpClientService>()));
    gh.singleton<_i264.RemoteDataSource>(
        () => repositoryModule.remoteDataSource(gh<_i137.ApiService>()));
    gh.singleton<_i481.AuthRepository>(() => repositoryModule.authRepository(
          gh<_i264.RemoteDataSource>(),
          gh<_i466.LocalDataSource>(),
        ));
    gh.singleton<_i963.DaoRepository>(() => repositoryModule.daoRepository(
          gh<_i264.RemoteDataSource>(),
          gh<_i466.LocalDataSource>(),
        ));
    gh.singleton<_i599.ProposalRepository>(
        () => repositoryModule.proposalRepository(
              gh<_i264.RemoteDataSource>(),
              gh<_i466.LocalDataSource>(),
            ));
    gh.singleton<_i517.UserRepository>(() => repositoryModule.userRepository(
          gh<_i264.RemoteDataSource>(),
          gh<_i466.LocalDataSource>(),
        ));
    gh.singleton<_i415.ChatRepository>(() => repositoryModule.chatRepository(
          gh<_i264.RemoteDataSource>(),
          gh<_i466.LocalDataSource>(),
        ));
    gh.singleton<_i391.DeepLinkService>(() => _i391.DeepLinkService(
          gh<_i31.NavigationService>(),
          gh<_i865.PrivacyAnalyticsService>(),
        ));
    gh.singleton<_i630.AppRouter>(() => _i630.AppRouter(
          gh<_i391.DeepLinkService>(),
          gh<_i73.NavigationGuards>(),
        ));
    return this;
  }
}

class _$ServiceModule extends _i180.ServiceModule {}

class _$RepositoryModule extends _i130.RepositoryModule {}
