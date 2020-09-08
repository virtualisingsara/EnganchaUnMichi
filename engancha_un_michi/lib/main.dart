import 'package:enganchaunmichi/src/pages/adopter_home_page.dart';
import 'package:enganchaunmichi/src/pages/giver_home_page.dart';
import 'package:enganchaunmichi/src/pages/add_cat_page.dart';
import 'package:enganchaunmichi/src/pages/login_page.dart';
import 'package:enganchaunmichi/src/pages/register_page.dart';
import 'package:enganchaunmichi/src/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
  final prefs = new UserPreferences();
  await prefs.initPrefs();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Material App",
      initialRoute: "login",
      routes: {
        "login" : (BuildContext context) => LoginPage(),
        "register" : (BuildContext context) => RegisterPage(),
        "adopterHome" : (BuildContext context) => AdopterHomePage(),
        "giverHome" : (BuildContext context) => GiverHomePage(),
        "add_cat" : (BuildContext context) => AddCatPage(),
      },
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
    );
  }
}