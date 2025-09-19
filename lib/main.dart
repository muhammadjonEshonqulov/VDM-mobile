import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/language/language_bloc.dart';
import 'core/network/api_client.dart';
import 'core/network/network_info.dart';
// Core
import 'core/theme/app_theme.dart';
import 'core/theme/theme_bloc.dart';
import 'features/auth/data/datasources/auth_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/auth_usecases.dart';
// Auth
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/main/presentation/pages/main_navigation_page.dart';
import 'features/users/data/datasources/users_datasource.dart';
import 'features/users/data/repositories/users_repository_impl.dart';
import 'features/users/domain/usecases/delete_user.dart';
import 'features/users/domain/usecases/get_users.dart';
import 'features/users/domain/usecases/toggle_user_status.dart';
import 'features/users/presentation/bloc/users_bloc.dart';
import 'generated/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  final dio = Dio();
  final connectivity = Connectivity();

  final apiClient = ApiClient(dio, sharedPreferences);
  final networkInfo = NetworkInfoImpl(connectivity);

  // Auth dependencies
  final authRemoteDataSource = AuthRemoteDataSourceImpl(apiClient.dio);
  final authLocalDataSource = AuthLocalDataSourceImpl(sharedPreferences);
  final authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource, localDataSource: authLocalDataSource, networkInfo: networkInfo);

  final loginUser = LoginUser(authRepository);
  final logoutUser = LogoutUser(authRepository);
  final getCachedUser = GetCachedUser(authRepository);

  final authBloc = AuthBloc(loginUser: loginUser, logoutUser: logoutUser, getCachedUser: getCachedUser);

  // Users dependencies
  final usersRemoteDataSource = UsersRemoteDataSourceImpl(apiClient.dio);
  final usersRepository = UsersRepositoryImpl(remoteDataSource: usersRemoteDataSource, networkInfo: networkInfo);
  final getUsers = GetUsers(usersRepository);
  final toggleUserStatus = ToggleUserStatus(usersRepository);
  final deleteUser = DeleteUser(usersRepository);
  final usersBloc = UsersBloc(getUsers: getUsers, toggleUserStatus: toggleUserStatus, deleteUser: deleteUser);

  final themeBloc = ThemeBloc(sharedPreferences: sharedPreferences);
  final languageBloc = LanguageBloc(sharedPreferences: sharedPreferences);

  // Load saved preferences
  await themeBloc.loadTheme();
  await languageBloc.loadLanguage();

  runApp(VDMApp(authBloc: authBloc, usersBloc: usersBloc, themeBloc: themeBloc, languageBloc: languageBloc));
}

class VDMApp extends StatelessWidget {
  final AuthBloc authBloc;
  final UsersBloc usersBloc;
  final ThemeBloc themeBloc;
  final LanguageBloc languageBloc;

  const VDMApp({super.key, required this.authBloc, required this.usersBloc, required this.themeBloc, required this.languageBloc});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => authBloc..add(AppStarted())),
        BlocProvider<UsersBloc>(create: (context) => usersBloc),
        BlocProvider<ThemeBloc>(create: (context) => themeBloc),
        BlocProvider<LanguageBloc>(create: (context) => languageBloc),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              ThemeMode themeMode = ThemeMode.system;
              if (themeState is ThemeLoaded) {
                themeMode = themeState.themeMode;
              }

              Locale locale = const Locale('en', 'US');
              if (languageState is LanguageLoaded) {
                locale = languageState.locale;
              }

              return MaterialApp(
                title: 'VDM Mobile',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                locale: locale,
                localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
                supportedLocales: const [Locale('en', 'US'), Locale('uz', 'UZ'), Locale('ru', 'RU')],
                debugShowCheckedModeBanner: false,
                home: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthInitial || state is AuthLoading) {
                      return const SplashPage();
                    } else if (state is AuthAuthenticated) {
                      return const MainNavigationPage();
                    } else if (state is AuthUnauthenticated) {
                      return const LoginPage();
                    } else if (state is AuthError) {
                      return const LoginPage();
                    }
                    return const SplashPage();
                  },
                ),
                routes: {'/login': (context) => const LoginPage(), '/main': (context) => const MainNavigationPage()},
              );
            },
          );
        },
      ),
    );
  }
}
