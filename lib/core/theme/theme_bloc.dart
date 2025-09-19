import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences sharedPreferences;
  static const String _themeKey = 'theme_mode';

  ThemeBloc({required this.sharedPreferences}) : super(ThemeInitial()) {
    on<ThemeChanged>(_onThemeChanged);
  }

  void _onThemeChanged(ThemeChanged event, Emitter<ThemeState> emit) async {
    await sharedPreferences.setString(_themeKey, event.themeMode.name);
    emit(ThemeLoaded(themeMode: event.themeMode));
  }

  Future<void> loadTheme() async {
    final themeString = sharedPreferences.getString(_themeKey);
    ThemeMode themeMode;
    
    switch (themeString) {
      case 'dark':
        themeMode = ThemeMode.dark;
        break;
      case 'light':
        themeMode = ThemeMode.light;
        break;
      default:
        themeMode = ThemeMode.system;
    }
    
    add(ThemeChanged(themeMode: themeMode));
  }
}
