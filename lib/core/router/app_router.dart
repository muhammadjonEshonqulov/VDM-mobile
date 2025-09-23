import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vdm/features/drivers/presentation/bloc/drivers_bloc.dart';

import '../di/injection_container.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/main/presentation/pages/main_navigation_page.dart';
import '../../features/users/presentation/bloc/users_bloc.dart';
import '../constants/app_constants.dart';

class AppRouter {

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    navigatorKey: sl<GlobalKey<NavigatorState>>(),
    initialLocation: AppConstants.routeSplash,
    routes: [
      GoRoute(
        path: AppConstants.routeSplash,
        name: AppConstants.routeSplash.replaceAll('/', ''),
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AuthBloc>()..add(AppStarted()),
          child: const SplashPage(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeLogin,
        name: AppConstants.routeLogin.replaceAll('/', ''),
        builder: (context, state) => BlocProvider(
          create: (context) => sl<AuthBloc>(),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeHome,
        name: AppConstants.routeHome.replaceAll('/', ''),
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<AuthBloc>()),
            BlocProvider(create: (context) => sl<UsersBloc>()),
            BlocProvider(create: (context) => sl<DriversBloc>()),
          ],
          child: const MainNavigationPage(),
        ),
      ),
    ],
    redirect: (context, state) {
      // Navigation logic can be added here if needed
      return null;
    },
  );
}

// Navigation helper methods
class AppNavigation {
  static void goToSplash(BuildContext context) {
    context.go(AppConstants.routeSplash);
  }

  static void goToLogin(BuildContext context) {
    context.go(AppConstants.routeLogin);
  }

  static void goToHome(BuildContext context) {
    context.go(AppConstants.routeHome);
  }

  static void pushLogin(BuildContext context) {
    context.push(AppConstants.routeLogin);
  }

  static void pushHome(BuildContext context) {
    context.push(AppConstants.routeHome);
  }
  
  static void goToUsers(BuildContext context) {
    context.go(AppConstants.routeUsers);
  }
  
  static void goToUserDetail(BuildContext context, {required int userId}) {
    context.go(AppConstants.getUserDetailPath(userId));
  }
}
