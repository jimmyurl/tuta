// File: lib/l10n/app_localizations.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

class AppLocalizations {
  final String localeName;

  AppLocalizations(this.localeName);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sw'),
  ];

  String get welcomeMessage {
    return intl.Intl.message(
      'Welcome to the Lessons App!',
      name: 'welcomeMessage',
      desc: 'Welcome message on the onboarding screen',
      locale: localeName,
    );
  }

  String get selectLanguage {
    return intl.Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: 'Prompt to select a language',
      locale: localeName,
    );
  }

  String get english {
    return intl.Intl.message(
      'English',
      name: 'english',
      desc: 'English language option',
      locale: localeName,
    );
  }

  String get swahili {
    return intl.Intl.message(
      'Swahili',
      name: 'swahili',
      desc: 'Swahili language option',
      locale: localeName,
    );
  }

  String get proceed {
    return intl.Intl.message(
      'Proceed to Lessons',
      name: 'proceed',
      desc: 'Button text to proceed to lessons',
      locale: localeName,
    );
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
        AppLocalizations(locale.languageCode));
  }

  @override
  bool isSupported(Locale locale) => ['en', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
