import 'package:flutter/material.dart';
import 'package:flutter\_localizations/flutter\_localizations.dart';
import 'package:gss_flutter/DemoLocalizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(GssApp(child: MyApp()));

class GssApp extends InheritedWidget {
  bool isDark = false;

  GssApp({
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static GssApp of(BuildContext context) {
    //return context.ancestorStateOfType(const TypeMatcher<GssApp>()) as GssApp;
    return context.inheritFromWidgetOfExactType(GssApp) as GssApp;
  }

  @override
  bool updateShouldNotify(GssApp old) {
    return true;
  }
}

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
      supportedLocales: [
        const Locale('fa', 'IR'),
        const Locale('en', 'US'),

      ],
      localizationsDelegates: [
        const DemoLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      /*localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {
        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode || supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }

        return supportedLocales.first;
      },*/
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
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 4.0,
              margin: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.network(
                    "https://cdn.yjc.ir/files/fa/news/1397/9/21/9087430_823.jpeg",
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      DemoLocalizations.of(context).trans("title"),
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "This is subtitle",
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Et netus et malesuada fames ac turpis egestas integer eget. Quisque egestas diam in arcu. Facilisis mauris sit amet massa. Tortor id aliquet lectus proin nibh nisl condimentum id.",
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                  ShowTest(),
                  Text(GssApp.of(context).isDark.toString()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                        child: Text("show date picker"),
                        onPressed: () {
                          showDatePicker(
                              context: context,
                              initialDate: DateTime.now().toLocal(),
                              firstDate: DateTime(1999).toLocal(),
                              lastDate: DateTime(2225).toLocal(),
                              textDirection: TextDirection.rtl);
                        }),
                  )
                ],
              ),
            ),
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class ShowTest extends StatefulWidget {
  @override
  _ShowTestState createState() => _ShowTestState();
}

class _ShowTestState extends State<ShowTest> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Checkbox(
            value: MyApp.of(context).theme,
            onChanged: (isChecked) async {
              setState(() {
                MyApp.of(context).setTheme(isChecked);
              });
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('app_theme', isChecked);
            }),
      ],
    );
    //return Text(GssApp.of(context).isDark.toString());
  }
}
