import 'package:flutter/material.dart';
import 'package:gss_flutter/pages/home_page.dart';
import 'package:gss_flutter/pages/login_page.dart';
import 'package:gss_flutter/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: Navigation.routes,
      theme: ThemeData.light(),
      home: _buildHome(context),
    );
  }

  Widget _buildHome(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          String token = snapshot.data.getString("access_token");
          if (token != null)
            return HomePage();
          else
            return LoginPage();
        }
        else return Container();
      },
      future: SharedPreferences.getInstance(),
    );

  }
}
