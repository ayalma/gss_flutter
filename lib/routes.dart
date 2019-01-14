import 'package:flutter/material.dart';
import 'package:gss_flutter/pages/home_page.dart';
import 'package:gss_flutter/pages/login_page.dart';
import 'package:gss_flutter/pages/splash_page.dart';

class Navigation {
  static final Map<String, WidgetBuilder> routes = {
    '/login':(context)=> LoginPage(),
    '/home' : (context) => HomePage(),
    '/sendSuggestion' :(context)=> HomePage()
  };
}

enum Routes {
  splash,
  home,
}
