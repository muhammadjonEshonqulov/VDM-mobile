import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/di/injection_container.dart' as di;
import 'core/language/language_bloc.dart';
import 'core/providers/bloc_providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_bloc.dart';
import 'generated/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  // Set up BLoC observer for debugging
  Bloc.observer = AppBlocObserver();

  // Load saved preferences
  final themeBloc = di.sl<ThemeBloc>();
  final languageBloc = di.sl<LanguageBloc>();

  await themeBloc.loadTheme();
  await languageBloc.loadLanguage();

  runApp(const VDMApp());
}

class VDMApp extends StatelessWidget {
  const VDMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProviders.wrapWithProviders(
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

              return MaterialApp.router(
                title: 'VDM Mobile',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                locale: locale,
                localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
                supportedLocales: const [Locale('en', 'US'), Locale('uz', 'UZ'), Locale('ru', 'RU')],
                debugShowCheckedModeBanner: false,
                routerConfig: AppRouter.router,
              );
            },
          );
        },
      ),
    );
  }
}
