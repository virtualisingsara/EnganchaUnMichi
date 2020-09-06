import 'package:enganchaunmichi/src/models/cat_model.dart';
import 'package:enganchaunmichi/src/providers/cats_provider.dart';
import 'package:flutter/material.dart';

class AddCatPage extends StatefulWidget {
  @override
  _AddCatPageState createState() => _AddCatPageState();
}

class _AddCatPageState extends State<AddCatPage> {

  final formKey     = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  CatModel cat = new CatModel();
  final catsProvider = new CatsProvider();

  String _selectedOption = "Macho";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey  ,
      appBar: AppBar(
        title: Text("Añadir gato"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _createName(),
                SizedBox(height: 10.0),
                _createGender(),
                _createAge(),
                _createDesc(),
                SizedBox(height: 30.0),
                _createButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createName() {
    return TextFormField(
      initialValue: cat.name,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Nombre"
      ),
      onSaved: (value) => cat.name = value,
    );
  }

  Widget _createGender() {
    return Row(
      children: <Widget>[
        Text("Sexo", style: TextStyle(fontSize: 16.5, color: Color.fromRGBO(104, 104, 104, 1))),
        SizedBox(width: 30.0),
        Expanded(
            child: DropdownButton(
              value: _selectedOption,
              items: getOptionsDropdown(),
              onChanged: (opt) {
                setState(() {
                  _selectedOption = opt;
                  cat.gender = opt;
                });
              },
            )
        )
      ],
    );
  }

  List<DropdownMenuItem<String>> getOptionsDropdown() {
    List<DropdownMenuItem<String>> list = new List();
      list.add(DropdownMenuItem(
          child: Text("Macho"),
          value: "Macho"
      ));
    list.add(DropdownMenuItem(
        child: Text("Hembra"),
        value: "Hembra"
    ));
    return list;
  }

  Widget _createAge() {
    return TextFormField(
      initialValue: cat.age.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: "Edad"
      ),
      onSaved: (value) => cat.age = int.parse(value),
      validator: (value) {
        if (num.tryParse(value) == null)
          return 'La edad debe ser un número';
        else
          return null;
      },
    );
  }

  Widget _createDesc() {
    return TextFormField(
      initialValue: cat.desc,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: "Descripción"
      ),
      onSaved: (value) => cat.desc = value,
    );
  }

  Widget _createButton() {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
        child: Text("GUARDAR"),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      onPressed: () => _submit(),
    );
  }

  void _submit() {
    if ( !formKey.currentState.validate() ) return;
    formKey.currentState.save();

    print(cat.name);
    print(cat.gender);
    print(cat.age);
    print(cat.desc);

    catsProvider.createCat(cat);

  }

}