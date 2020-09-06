import 'package:enganchaunmichi/src/models/cat_model.dart';
import 'package:enganchaunmichi/src/providers/cats_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  final catsProvider = new CatsProvider();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gatos"),
      ),
      body: _createList(),
      floatingActionButton: _createButton(context),
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
        //onTap: () => Navigator.pushNamed(context, "add_cat"),
        child: Container(
          color: Colors.deepPurple,
          child: Column(
            children: <Widget>[
              FadeInImage(
                  image: NetworkImage(
                      "https://26uepavkh8yx35d834o3oay1-wpengine.netdna-ssl.com/wp-content/uploads/2019/05/GrumpCrop.jpg"),
                  placeholder: NetworkImage(
                      "https://i.pinimg.com/originals/4e/40/dd/4e40ddd11beb9ba671a0b59948861afb.png"),
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

  _createButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, "add_cat"),
    );
  }

}