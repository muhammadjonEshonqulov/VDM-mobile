import 'package:flutter/material.dart';
import 'package:vdm/generated/l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  /// Easy access to localization strings
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  
  // Most commonly used strings can have direct accessors
  String get appTitle => l10n.appTitle;
  
  // Add other frequently used strings here as needed
  // Example:
  // String get loginButton => l10n.loginButton;
  // String get usernameHint => l10n.usernameHint;
}

extension TextThemeExtension on BuildContext {
  /// Easy access to text theme
  TextTheme get textTheme => Theme.of(this).textTheme;
  
  /// Predefined text styles for consistency
  TextStyle? get headlineBold => textTheme.headlineMedium?.copyWith(
    fontWeight: FontWeight.bold,
  );
  
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  
  // Add other common text styles as needed
}
