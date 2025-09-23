import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vdm/features/drivers/data/datasources/drivers_datasource.dart';
import 'package:vdm/features/drivers/data/repositories/driver_repository_impl.dart';
import 'package:vdm/features/drivers/domain/repositories/drivers_repository.dart';
import 'package:vdm/features/drivers/presentation/bloc/drivers_bloc.dart';

// Features
import '../../features/auth/data/datasources/auth_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/drivers/domain/usecases/get_drivers.dart';
import '../../features/users/data/datasources/users_datasource.dart';
import '../../features/users/data/repositories/users_repository_impl.dart';
import '../../features/users/domain/repositories/users_repository.dart';
import '../../features/users/domain/usecases/delete_user.dart';
import '../../features/users/domain/usecases/get_users.dart';
import '../../features/users/domain/usecases/toggle_user_status.dart';
import '../../features/users/presentation/bloc/users_bloc.dart';
import '../language/language_bloc.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';
import '../theme/theme_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => GlobalKey<NavigatorState>());

  //! Features - Auth
  // Bloc
  sl.registerFactory(() => AuthBloc(loginUser: sl(), logoutUser: sl(), getCachedUser: sl(), refreshAuthToken: sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => GetCachedUser(sl()));
  sl.registerLazySingleton(() => RefreshAuthToken(sl()));
  sl.registerLazySingleton(() => GetAuthToken(sl()));
  sl.registerLazySingleton(() => GetRefreshToken(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl<ApiClient>().dio));
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(sl()));

  //! Features - Users
  // Bloc
  sl.registerFactory(() => UsersBloc(getUsers: sl(), toggleUserStatus: sl(), deleteUser: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => ToggleUserStatus(sl()));
  sl.registerLazySingleton(() => DeleteUser(sl()));

  // Repository
  sl.registerLazySingleton<UsersRepository>(() => UsersRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<UsersRemoteDataSource>(() => UsersRemoteDataSourceImpl(sl<ApiClient>().dio));

  //! Features - drivers
  // Bloc
  sl.registerFactory(() => DriversBloc(getDrivers: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetDrivers(sl()));

  // Repository
  sl.registerLazySingleton<DriversRepository>(() => DriverRepositoryImpl(datasource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<DriversDatasource>(() => DriversDatasourceImpl(sl<ApiClient>().dio));

  //! Core
  // Blocs
  sl.registerFactory(() => ThemeBloc(sharedPreferences: sl()));
  sl.registerFactory(() => LanguageBloc(sharedPreferences: sl()));

  // Network
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => ApiClient(sl(), sl(), navigatorKey: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
}
