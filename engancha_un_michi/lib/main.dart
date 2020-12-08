import 'package:enganchaunmichi/src/pages/adopter_home_page.dart';
import 'package:enganchaunmichi/src/pages/cat_details_page.dart';
import 'package:enganchaunmichi/src/pages/favorites_page.dart';
import 'package:enganchaunmichi/src/pages/giver_home_page.dart';
import 'package:enganchaunmichi/src/pages/add_cat_page.dart';
import 'package:enganchaunmichi/src/pages/login_page.dart';
import 'package:enganchaunmichi/src/pages/register_page.dart';
import 'package:enganchaunmichi/src/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
  final prefs = new UserPreferences();
  await prefs.initPrefs();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Engancha un Michi",
      initialRoute: "login",
      routes: {
        "login" : (BuildContext context) => LoginPage(),
        "register" : (BuildContext context) => RegisterPage(),
        "adopterHome" : (BuildContext context) => AdopterHomePage(),
        "giverHome" : (BuildContext context) => GiverHomePage(),
        "favorites" : (BuildContext context) => FavoritesPage(),
        "cat_details" : (BuildContext context) => CatDetailsPage(),
        "add_cat" : (BuildContext context) => AddCatPage(),
      },
      theme: ThemeData(
        primaryColor: Color(0xFF957DAD),
        accentColor: Color(0xFF957DAD),
        //accentColor: Color(0xFF95aD7D),
      ),
    );
  }
}