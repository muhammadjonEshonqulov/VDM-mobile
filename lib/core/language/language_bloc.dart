import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final SharedPreferences sharedPreferences;
  static const String _languageKey = 'language_code';

  LanguageBloc({required this.sharedPreferences}) : super(LanguageInitial()) {
    on<LanguageChanged>(_onLanguageChanged);
  }

  void _onLanguageChanged(LanguageChanged event, Emitter<LanguageState> emit) async {
    await sharedPreferences.setString(_languageKey, event.locale.languageCode);
    emit(LanguageLoaded(locale: event.locale));
  }

  Future<void> loadLanguage() async {
    final languageCode = sharedPreferences.getString(_languageKey) ?? 'en';
    Locale locale;
    
    switch (languageCode) {
      case 'uz':
        locale = const Locale('uz', 'UZ');
        break;
      case 'ru':
        locale = const Locale('ru', 'RU');
        break;
      case 'en':
      default:
        locale = const Locale('ru', 'RU');
    }
    
    add(LanguageChanged(locale: locale));
  }
}
