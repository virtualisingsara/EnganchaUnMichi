import 'dart:io';
import 'package:enganchaunmichi/src/models/cat_model.dart';
import 'package:flutter/material.dart';

class CatDetailsPage extends StatelessWidget {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  CatModel cat = new CatModel();
  File pic;

  IconData _faved = Icons.favorite_border;

  @override
  Widget build(BuildContext context) {

    final CatModel catData = ModalRoute.of(context).settings.arguments;
    if (catData != null) {
      cat = catData;
    }

    //TODO: change _faved if the cat is listed as a favourite of the user in the ddbb.

    print("CAT - " + cat.name + cat.age.toString() + cat.gender);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
          title: Text(cat.name),
          actions: <Widget>[
            IconButton(
              icon: Icon(_faved),
              onPressed: () {},
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(cat.phone, style: TextStyle(fontSize: 16.5)),
                      SizedBox(width: 10.0),
                      InkWell(
                        onTap: () {
                          //TODO: launch WhatsApp
                        },
                        child:
                          Image(image: AssetImage('assets/whatsapp-icon.png'),
                          height: 20.0,
                        ),
                      )
                    ]
                ),
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

}