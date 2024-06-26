import 'package:enganchaunmichi/src/models/cat_model.dart';
import 'package:enganchaunmichi/src/providers/cats_provider.dart';
import 'package:enganchaunmichi/src/providers/users_provider.dart';
import 'package:flutter/material.dart';

class GiverHomePage extends StatefulWidget {
  @override
  _GiverHomePageState createState() => _GiverHomePageState();
}

class _GiverHomePageState extends State<GiverHomePage> {

  final catsProvider = new CatsProvider();
  final usersProvider = new UsersProvider();
  String _email = "";
  String _phone = "";
  List<CatModel> _initialData = [];
  List<String> mine = [];

  @override
  Widget build(BuildContext context) {

    _email = ModalRoute.of(context).settings.arguments;
    print("email - " + _email.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("Mis gatos"),
        automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
            ),
          ]
      ),
      body:
      _createList(_myCats()),
      floatingActionButton: _createButton(context),
    );
  }

  Future<String> _readPhone() async {
    var users = await usersProvider.readUsers();
    var usersMap = Map.fromIterable(users, key: (e) => e.email, value: (e) => e.phone);
    _phone = usersMap[_email];
    print("PHONE - " + _phone.toString());
    return _phone;
  }

  Future<List<String>> _myCats() async {
    await _readPhone();
    mine = [];
    var cats = await catsProvider.readCats();
    print("CATS - " + cats.toString());
    var catsMap = Map.fromIterable(cats, key: (e) => e.id, value: (e) => e.phone);
    print("MY CATS - " + catsMap.toString());
    List keys = catsMap.keys.toList();
    print("KEYS - " + keys.toString());
    List values = catsMap.values.toList();
    print("VALUES - " + values.toString());
    for (var i = 0; i < values.length; i++) {
      if (values[i] == _phone) {
        print("ADD - " + keys[i].toString());
        mine.add(keys[i]);
      }
    }
    print("MY CATS ID - " + mine.toString());
    return mine;
  }

  Widget _createList(Future<List<String>> mine) {
    print("MINE - " + mine.toString());
    return FutureBuilder(
      future: catsProvider.searchCatsByIds(mine),
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
        onTap: () => Navigator.pushNamed(context, "add_cat", arguments: <String, dynamic>{
          "cat" : cat,
          "email" : _email},),
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

  _createButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add, color: Colors.white),
      backgroundColor: Color(0xFF957DAD),
      onPressed: () => Navigator.pushNamed(context, "add_cat", arguments: <String, dynamic>{
        "email" : _email}),
    );
  }

  _logout() {
    Navigator.pushReplacementNamed(context, "login");
  }

}