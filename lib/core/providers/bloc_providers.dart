import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vdm/features/admin/users/presentation/bloc/users_bloc.dart';

import '../di/injection_container.dart';
import '../theme/theme_bloc.dart';
import '../language/language_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

class BlocProviders {
  static List<BlocProvider> get providers => [
    BlocProvider<AuthBloc>(
      create: (context) => sl<AuthBloc>()..add(AppStarted()),
    ),
    BlocProvider<UsersBloc>(
      create: (context) => sl<UsersBloc>(),
    ),
    BlocProvider<ThemeBloc>(
      create: (context) => sl<ThemeBloc>(),
    ),
    BlocProvider<LanguageBloc>(
      create: (context) => sl<LanguageBloc>(),
    ),
  ];

  static Widget wrapWithProviders({required Widget child}) {
    return MultiBlocProvider(
      providers: providers,
      child: child,
    );
  }
}

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // Log bloc state changes in debug mode
    debugPrint('${bloc.runtimeType} $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // Log bloc errors
    debugPrint('${bloc.runtimeType} $error $stackTrace');
  }
}
