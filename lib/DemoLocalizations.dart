import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DemoLocalizations {


  DemoLocalizations(this.locale);

  final Locale locale;
  static DemoLocalizations of(BuildContext context) {
    DemoLocalizations test =  Localizations.of<DemoLocalizations>(context, DemoLocalizations);

    return test;
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Hello World',
    },
    'fa': {
      'title': 'سلام دنیا',
    },
  };

  String trans(String key) {
    return _localizedValues[locale.languageCode][key];
  }
}

class DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalizations> {

  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['fa', 'en'].contains(locale.languageCode);
  }

/*  @override
  Future<DemoLocalizations> load(Locale locale) async {
    DemoLocalizations localizations = new DemoLocalizations(locale);
    print("Load ${locale.languageCode}");
    return localizations;
  }*/

  @override
  Future<DemoLocalizations> load(Locale locale) {
    return SynchronousFuture<DemoLocalizations>(DemoLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<DemoLocalizations> old) {
    return false;
  }
}
