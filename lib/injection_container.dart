import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:lucis/authentication/auth_repository_impl.dart';
import 'package:lucis/authentication/auth_service.dart';
import 'package:lucis/data/data_sources/remote_data_sources/feed_remote_data_source.dart';
import 'package:lucis/data/data_sources/remote_data_sources/user_remote_data_source.dart';
import 'package:lucis/data/repositories/feed_repository_impl.dart';
import 'package:lucis/data/repositories/image_repository_impl.dart';
import 'package:lucis/data/repositories/marker_repository_impl.dart';
import 'package:lucis/data/repositories/session_repository_impl.dart';
import 'package:lucis/data/repositories/user_repository_impl.dart';
import 'package:lucis/domain/repositories/auth_repository.dart';
import 'package:lucis/domain/repositories/feed_repository.dart';
import 'package:lucis/domain/repositories/image_repository.dart';
import 'package:lucis/domain/repositories/location_repository.dart';
import 'package:lucis/domain/repositories/marker_repository.dart';
import 'package:lucis/domain/repositories/session_repository.dart';
import 'package:lucis/domain/repositories/user_repository.dart';
import 'package:lucis/domain/usecases/get_camera_image_usecase.dart';
import 'package:lucis/domain/usecases/get_feed_usecase.dart';
import 'package:lucis/domain/usecases/get_gallery_image_usecase.dart';
import 'package:lucis/domain/usecases/get_location_usecase.dart';
import 'package:lucis/domain/usecases/get_markers_usecase.dart';
import 'package:lucis/domain/usecases/get_session_usecase.dart';
import 'package:lucis/domain/usecases/get_user_page_usecase.dart';
import 'package:lucis/domain/usecases/get_user_usecase.dart';
import 'package:lucis/domain/usecases/init_session_usecase.dart';
import 'package:lucis/domain/usecases/login_usecase.dart';
import 'package:lucis/domain/usecases/new_favorite_usecase.dart';
import 'package:lucis/domain/usecases/new_pin_usecase.dart';
import 'package:lucis/domain/usecases/register_usecase.dart';
import 'package:lucis/domain/usecases/upload_feed_usecase.dart';
import 'package:lucis/infrastructure/location/location_repository_impl.dart';
import 'package:lucis/infrastructure/location/location_service.dart';
import 'package:lucis/presentation/viewmodels/feed_viewmodel.dart';
import 'package:lucis/presentation/viewmodels/home_viewmodel.dart';
import 'package:lucis/presentation/viewmodels/image_import_viewmodel.dart';
import 'package:lucis/presentation/viewmodels/image_upload_viewmodel.dart';
import 'package:lucis/presentation/viewmodels/login_viewmodel.dart';
import 'package:lucis/presentation/viewmodels/map_viewmodel.dart';
import 'package:lucis/presentation/viewmodels/registration_viewmodel.dart';
import 'package:lucis/presentation/viewmodels/splash_viewmodel.dart';
import 'package:lucis/presentation/viewmodels/user_viewmodel.dart';
import 'domain/usecases/logout_usecase.dart';
import 'infrastructure/network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // viewmodels
  sl.registerFactory(
    () => FeedViewModel(
      sl(),
      sl(),
    ),
  );
  sl.registerFactory(
    () => HomeViewModel(
      sl(),
      sl(),
    ),
  );
  sl.registerFactory(
    () => ImageImportViewModel(
      sl(),
      sl(),
    ),
  );
  sl.registerFactory(
    () => ImageUploadViewModel(
      sl(),
      sl(),
    ),
  );
  sl.registerFactory(() => LoginViewModel(sl()));
  sl.registerFactory(
    () => MapViewModel(
      sl(),
      sl(),
    ),
  );
  sl.registerFactory(() => RegistrationViewModel(sl()));
  sl.registerFactory(
    () => SplashViewModel(
      sl(),
      sl(),
    ),
  );
  sl.registerFactory(
    () => UserViewModel(
      sl(),
      sl(),
    ),
  );

  // usecases
  sl.registerLazySingleton(
    () => GetCameraImageUseCase(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetFeedUseCase(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetGalleryImageUseCase(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetLocationUseCase(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetMarkerUseCase(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetSessionUseCase(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetUserPageUseCase(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetUserUseCase(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => InitSessionUseCase(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => LoginUseCase(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => LogoutUseCase(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => NewFavoriteUseCase(
      sl(),
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => NewPinUseCase(
      sl(),
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => RegisterUseCase(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UploadFeedUseCase(
      sl(),
    ),
  );

  // repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl(),
      sl(),
      sl(),
    ),
  );
  sl.registerLazySingleton<FeedRepository>(
    () => FeedRepositoryImpl(
      sl(),
      sl(),
    ),
  );
  sl.registerLazySingleton<ImageRepository>(
    () => ImageRepositoryImpl(),
  );
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(
      sl(),
    ),
  );
  sl.registerLazySingleton<MarkerRepository>(
    () => MarkerRepositoryImpl(
      sl(),
      sl(),
    ),
  );
  sl.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(
      sl(),
      sl(),
      sl(),
    ),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      sl(),
      sl(),
    ),
  );

  // data sources
  sl.registerLazySingleton<FeedRemoteDataSource>(
    () => FeedRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(),
  );

  // services
  sl.registerLazySingleton<LocationService>(
    () => LocationServiceImpl(),
  );
  sl.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(),
  );

  // network info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      DataConnectionChecker(),
    ),
  );
}
