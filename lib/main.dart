import 'package:flutter/material.dart';
import 'package:flutter\_localizations/flutter\_localizations.dart';
import 'package:gss_flutter/DemoLocalizations.dart';
import 'package:gss_flutter/app.dart';
import 'package:gss_flutter/gss-app.dart';
import 'package:gss_flutter/multipage_drawer.dart';



void main() => runApp(App());


/*
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<_MyAppState>());
  }
}

class _MyAppState extends State<MyApp> {
  bool theme = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale("en"),
      supportedLocales: [
        const Locale('fa', 'IR'),
        const Locale('en', 'US'),

      ],
      localizationsDelegates: [
        const DemoLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        if (locale == null) {
          debugPrint("*language locale is null!!!");
          return supportedLocales.first;
        }

        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode ||
              supportedLocale.countryCode == locale.countryCode) {
            debugPrint("*language ok $supportedLocale");
            return supportedLocale;
          }
        }

        debugPrint("*language to fallback ${supportedLocales.first}");
        return supportedLocales.first;
      },
      title: GssApp.of(context).isDark.toString(),
      theme: _buildTheme(context),
      home: MyHomePage(title: "test"),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Additional code
  }

  void setTheme(bool theme) {
    setState(() {
      this.theme = theme;
    });
  }

  ThemeData _buildTheme(BuildContext context) {
    if (this.theme) {
      return ThemeData.dark().copyWith();
    } else {
      return ThemeData.light().copyWith();
    }
  }
}*/


