import 'package:enganchaunmichi/src/models/cat_model.dart';
import 'package:enganchaunmichi/src/providers/cats_provider.dart';
import 'package:flutter/material.dart';

class AdopterHomePage extends StatelessWidget {

  final catsProvider = new CatsProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gatos (adopter)"),
      ),
      body:
      _createList(),
    );
  }

  Widget _createList() {
    return FutureBuilder(
      future: catsProvider.readCats(),
      builder: (BuildContext context, AsyncSnapshot<List<CatModel>> snapshot) {
        if (snapshot.hasData) {
          final cats = snapshot.data;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: cats.length,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            itemBuilder: (context, i) => _createItem(context, cats[i]),
          );
        } else {
          Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }

  Widget _createItem(BuildContext context, CatModel cat) {
    final card = InkWell(
        //onTap: () => Navigator.pushNamed(context, "add_cat", arguments: cat),
        child: Container(
          color: Colors.deepPurple,
          child: Column(
            children: <Widget>[
              (cat.pictureUrl == null)
                  ? Image(image: AssetImage('assets/no-image.png'),
                height: 100.0,
                width: double.infinity,
                fit: BoxFit.cover,)
                  : FadeInImage(
                  image: NetworkImage(cat.pictureUrl),
                  placeholder: AssetImage('assets/loading.gif'),
                  fadeInDuration: Duration(milliseconds: 200),
                  height: 100.0,
                  width: double.infinity,
                  fit: BoxFit.cover
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  children: <Widget>[
                    Text(cat.name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 5.0),
                    Text("${cat.gender}  ·  ${cat.age} años", style: TextStyle(color: Colors.white)),
                  ],
                ),
              )
            ],
          ),
        )
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: card,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                spreadRadius: 2.0,
                offset: Offset(2.0, 10.0)
            )
          ]
      ),
    );

  }

}