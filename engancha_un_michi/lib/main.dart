import 'package:enganchaunmichi/src/pages/home_page.dart';
import 'package:enganchaunmichi/src/pages/add_cat_page.dart';
import 'package:enganchaunmichi/src/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Material App",
      initialRoute: "login",
      routes: {
        "login" : (BuildContext context) => LoginPage(),
        "home" : (BuildContext context) => HomePage(),
        "add_cat" : (BuildContext context) => AddCatPage(),
      },
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
    );
  }
}