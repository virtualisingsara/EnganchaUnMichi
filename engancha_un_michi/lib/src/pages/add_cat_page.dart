import 'dart:io';
import 'package:enganchaunmichi/src/models/cat_model.dart';
import 'package:enganchaunmichi/src/providers/cats_provider.dart';
import 'package:enganchaunmichi/src/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCatPage extends StatefulWidget {
  @override
  _AddCatPageState createState() => _AddCatPageState();
}

class _AddCatPageState extends State<AddCatPage> {

  final formKey     = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  CatModel cat = new CatModel();
  final catsProvider = new CatsProvider();
  final usersProvider = new UsersProvider();
  final _picker = ImagePicker();
  File pic;

  String _email = "";
  String _selectedOption = "Macho";
  String _barTitle = "Añadir gato";
  String _button = "GUARDAR";
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final CatModel catData = args["cat"];
    _email = args["email"];

    if (catData != null) {
      cat = catData;
      _selectedOption = cat.gender;
    }

    if (cat.id != null) {
      _barTitle = "Editar gato";
      _button = "ACTUALIZAR";
      _isVisible = true;
    }

    return Scaffold(
      key: scaffoldKey  ,
      appBar: AppBar(
        title: Text(_barTitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _selectPic,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _takePic,
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
                _showPic(),
                _createName(),
                SizedBox(height: 10.0),
                _createGender(),
                _createAge(),
                _createDesc(),
                SizedBox(height: 30.0),
                _createButton(),
                SizedBox(height: 20.0),
                _createDeleteButton(cat)
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
        child: Text(_button),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      onPressed: () => _submit(),
    );
  }

  Widget _createDeleteButton(CatModel cat) {
    return Visibility(
        visible: _isVisible,
        child: RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 95.0, vertical: 15.0),
            child: Text("BORRAR"),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0)
          ),
          color: Colors.red,
          textColor: Colors.white,
          onPressed: () {
            catsProvider.deleteCat(cat.id);
            showSnackbar("Gato borrado con éxito.");
            Navigator.pushReplacementNamed(context, "giverHome");
          },
        )
    );
  }

  void _submit() async {
    if ( !formKey.currentState.validate() ) return;
    formKey.currentState.save();

    if (pic != null) {
      cat.pictureUrl = await catsProvider.uploadImage(pic);
    }

    print("EMAIL - " + _email.toString());

    var users = await usersProvider.readUsers();
    var usersMap = Map.fromIterable(users, key: (e) => e.email, value: (e) => e.phone);
    cat.phone = await usersMap[_email];

    print("PHONE - " + cat.phone.toString());

    if (cat.id == null) {
      catsProvider.createCat(cat);
    } else {
      catsProvider.updateCat(cat);
    }

    showSnackbar("Gato guardado con éxito.");
    Navigator.pushReplacementNamed(context, "giverHome", arguments: _email);
  }

  void showSnackbar(String msg) {
    final snackbar = SnackBar(
      content: Text(msg),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
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
      if( pic != null ){
        return Image.file(
          pic,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  _selectPic() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    pic = File(pickedFile.path);

    if (pic != null) {
      cat.pictureUrl = null;
    }

    setState(() {});
  }

  _takePic() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    pic = File(pickedFile.path);

    if (pic != null) {
      cat.pictureUrl = null;
    }

    setState(() {});
  }

}