import 'dart:io';
import 'package:enganchaunmichi/src/models/cat_model.dart';
import 'package:enganchaunmichi/src/user_preferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

import 'adopter_home_page.dart';

class CatDetailsPage extends StatefulWidget {
  @override
  _CatDetailsPageState createState() => _CatDetailsPageState();
}

class _CatDetailsPageState extends State<CatDetailsPage> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  CatModel cat = new CatModel();
  File pic;

  IconData _faved = Icons.favorite_border;

  List<dynamic> myFavs = [];
  List<String> favList = [];
  String id = "";
  List<dynamic> args = [];
  String lastPage = "adopterHome";

  final prefs = new UserPreferences();

  @override
  Widget build(BuildContext context) {

    final Arguments args = ModalRoute.of(context).settings.arguments;

    final CatModel catData = args.cat;
    final String lastPage = args.id;
    if (catData != null) {
      cat = catData;
    }

    //TODO: change _faved if the cat is listed as a favourite of the user in the ddbb.

    print("CAT - " + cat.name + cat.age.toString() + cat.gender);
    id = cat.id;

    _isFaved(id);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          title: Text(cat.name),
          leading:
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if (lastPage == "adopterHome") {
                  Navigator.pushReplacementNamed(context, "adopterHome");
                } else {
                  Navigator.pushReplacementNamed(context, "favorites");
                }
              },
            ),
          actions: <Widget>[
            IconButton(
              icon: Icon(_faved),
              onPressed: () {
                _addFav(id);
              },
            ),
          ]
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _showPic(),
                SizedBox(height: 20.0),
                _createPhone(),
                SizedBox(height: 20.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(cat.gender, style: TextStyle(fontSize: 16.5)),
                      SizedBox(width: 50.0),
                      Text("Edad:   " + cat.age.toString(), style: TextStyle(fontSize: 16.5)),
                    ]
                ),
                SizedBox(height: 20.0),
                Container(
                  child: Text(cat.desc),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showPic() {
    if (cat.pictureUrl != null) {
      return FadeInImage(
        image: NetworkImage(cat.pictureUrl),
        placeholder: AssetImage('assets/loading.gif'),
        fit: BoxFit.cover,
        height: 300.0,
      );
    } else {
      if (pic != null) {
        return Image.file(
          pic,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  Widget _createPhone() {
    if ( cat.phone != null ) {
      return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(cat.phone, style: TextStyle(fontSize: 16.5)),
            SizedBox(width: 10.0),
            InkWell(
              onTap: () {
                FlutterOpenWhatsapp.sendSingleMessage("+34" + cat.phone,
                    "¡Hola! Me interesa el gato ${cat
                        .name} que tienes en adopción.");
              },
              child:
              Image(image: AssetImage('assets/whatsapp-icon.png'),
                height: 20.0,
              ),
            )
          ]
      );
    } else {
      return Container();
    }
  }

  _isFaved(String id) {
    myFavs = prefs.favs;
    if (myFavs.contains(id)) {
      _faved = Icons.favorite;
    }
  }

  _addFav(String id) {
    if (_faved == Icons.favorite_border) {
      myFavs = prefs.favs;
      print("1FAVS " + myFavs.toString());
      myFavs.add(id);
      favList = myFavs.cast<String>().toList();
      print("2FAVS " + favList.toString());
      prefs.favs = favList;
      _faved = Icons.favorite;
      setState(() {});
    } else {
      print("NO FAVS");
      myFavs = prefs.favs;
      print("1FAVS " + myFavs.toString());
      myFavs.remove(id);
      print("2FAVS " + myFavs.toString());
      prefs.favs = myFavs;
      _faved = Icons.favorite_border;
      setState(() {});
    }
  }

}