import 'package:enganchaunmichi/src/models/cat_model.dart';
import 'package:enganchaunmichi/src/providers/cats_provider.dart';
import 'package:enganchaunmichi/src/providers/users_provider.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {

  final catsProvider = new CatsProvider();
  final usersProvider = new UsersProvider();
  String _email = "";
  List<CatModel> _initialData = [];
  List<String> favs = [];
  List<CatModel> cats = [];

  @override
  Widget build(BuildContext context) {

    _email = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Favoritos"),
      ),
      body:
      _createList(_readFavs()),
      bottomNavigationBar: _createBottomBar(),
    );
  }

  Future<List<String>> _readFavs() async {
    var users = await usersProvider.readUsers();
    var usersMap = Map.fromIterable(users, key: (e) => e.email, value: (e) => e.favs);
    favs = usersMap[_email];
    print("FAVS - " + favs.toString());
    return favs;
  }

  Widget _createList(Future<List<String>> favs) {
    _readFavs();
    return FutureBuilder(
      future: catsProvider.searchCatsByIds(favs),
      initialData: _initialData,
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
        onTap: () => Navigator.pushNamed(context, "cat_details", arguments: cat),
        child: Container(
          color: Color(0xFF957DAD),
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

  Widget _createBottomBar() {
    return BottomAppBar(
      color: Color(0xFF957DAD),
      shape: CircularNotchedRectangle(),
      notchMargin: 4.0,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(icon: Icon(Icons.home, color: Colors.white), onPressed: () => Navigator.pushReplacementNamed(context, "adopterHome", arguments: _email)),
          Text("|", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w100)),
          IconButton(icon: Icon(Icons.favorite, color: Colors.white)),
        ],
      ),
    );
  }

}