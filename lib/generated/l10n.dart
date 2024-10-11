// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome to the Lessons App!`
  String get welcome_message {
    return Intl.message(
      'Welcome to the Lessons App!',
      name: 'welcome_message',
      desc: 'Welcome message displayed to users on the home screen',
      args: [],
    );
  }

  /// `Select Language`
  String get select_language {
    return Intl.message(
      'Select Language',
      name: 'select_language',
      desc: 'Label for selecting language',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: 'English language option',
      args: [],
    );
  }

  /// `Swahili`
  String get swahili {
    return Intl.message(
      'Swahili',
      name: 'swahili',
      desc: 'Swahili language option',
      args: [],
    );
  }

  /// `Proceed to Lessons`
  String get proceed {
    return Intl.message(
      'Proceed to Lessons',
      name: 'proceed',
      desc: 'Button label to proceed to lessons',
      args: [],
    );
  }

  /// `Lessons`
  String get lessons_title {
    return Intl.message(
      'Lessons',
      name: 'lessons_title',
      desc: 'Title for the lessons screen',
      args: [],
    );
  }

  /// `Educational`
  String get educational_title {
    return Intl.message(
      'Educational',
      name: 'educational_title',
      desc: 'Title for educational lessons',
      args: [],
    );
  }

  /// `Personal Development`
  String get personal_development_title {
    return Intl.message(
      'Personal Development',
      name: 'personal_development_title',
      desc: 'Title for personal development lessons',
      args: [],
    );
  }

  /// `Cuisine`
  String get cuisine_title {
    return Intl.message(
      'Cuisine',
      name: 'cuisine_title',
      desc: 'Title for cuisine lessons',
      args: [],
    );
  }

  /// `No educational lessons available.`
  String get no_educational_lessons {
    return Intl.message(
      'No educational lessons available.',
      name: 'no_educational_lessons',
      desc: 'Message when there are no educational lessons',
      args: [],
    );
  }

  /// `No personal development lessons available.`
  String get no_personal_development_lessons {
    return Intl.message(
      'No personal development lessons available.',
      name: 'no_personal_development_lessons',
      desc: 'Message when there are no personal development lessons',
      args: [],
    );
  }

  /// `No cuisine lessons available.`
  String get no_cuisine_lessons {
    return Intl.message(
      'No cuisine lessons available.',
      name: 'no_cuisine_lessons',
      desc: 'Message when there are no cuisine lessons',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'sw'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
