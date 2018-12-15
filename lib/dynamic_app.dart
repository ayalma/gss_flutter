

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef Widget DynamicWidgetBuilder(BuildContext context,ThemeData data,Locale locale);
typedef ThemeData ThemeDataWithBrightnessBuilder(Brightness brightness);

class DynamicApp extends StatefulWidget {

  final DynamicWidgetBuilder dynamicWidgetBuilder;
  final ThemeDataWithBrightnessBuilder themeDataWithBrightnessBuilder;
  final Brightness defaultBrightness;
  final Locale defaultLocale;

  const DynamicApp({Key key, this.dynamicWidgetBuilder, this.themeDataWithBrightnessBuilder, this.defaultBrightness, this.defaultLocale}) : super(key: key);

  @override
  _DynamicAppState createState() => _DynamicAppState();

  static _DynamicAppState of(BuildContext context)
  {
   return context.ancestorStateOfType(const TypeMatcher<_DynamicAppState>());
  }
}

class _DynamicAppState extends State<DynamicApp> {

  ThemeData _themeData;
  Locale _locale;
  Brightness _brightness;

  @override
  void initState() {
    super.initState();

    _brightness = widget.defaultBrightness;
    _themeData = widget.themeDataWithBrightnessBuilder(_brightness);
    _locale = widget.defaultLocale;


    _loadConfig().then((config){

        _brightness = config.isDark ? Brightness.dark : Brightness.light;
        _themeData = widget.themeDataWithBrightnessBuilder(_brightness);


        _locale = Locale((config.languageKey == null || config.languageKey == "")? "en" : config.languageKey);

    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeData = widget.themeDataWithBrightnessBuilder(_brightness);
  }

  @override
  void didUpdateWidget(DynamicApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    _themeData = widget.themeDataWithBrightnessBuilder(_brightness);
  }

  @override
  Widget build(BuildContext context) {
    return widget.dynamicWidgetBuilder(context,_themeData,_locale);
  }

  Future<_Config> _loadConfig() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return _Config(
        preferences.getBool(_Config._brightnessKey) ?? false,
        preferences.getString(_Config._localeKey),
    );
  }

  void setBrightness(Brightness brightness) async {
    setState(() {
      this._themeData = widget.themeDataWithBrightnessBuilder(brightness);
      this._brightness = brightness;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_Config._brightnessKey, brightness == Brightness.dark ? true : false);
  }

  void setLanguage(String languageKey) async {
    setState(() {
      this._locale = Locale(languageKey);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_Config._localeKey,languageKey);
  }

}

class _Config {

  static const String _brightnessKey = "app_brightness";
  static const String _localeKey = "app_locale";

  final bool isDark;
  final String languageKey;

  _Config(this.isDark, this.languageKey);



}
