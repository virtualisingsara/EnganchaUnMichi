import 'package:enganchaunmichi/src/models/user_model.dart';
import 'package:enganchaunmichi/src/providers/users_provider.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  UserModel user = new UserModel();
  final usersProvider = new UsersProvider();
  String _email;
  String _password;
  String _phone;
  String _selectedOption = "adopter";
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _createBackground(context),
          _loginForm(context),
        ],
      )
    );
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: size.height * 0.3,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.only(bottom: 10.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Text("Registrarse", style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 10.0),
                _createEmail(),
                SizedBox(height: 10.0),
                _createPassword(),
                SizedBox(height: 10.0),
                _createPhone(),
                SizedBox(height: 30.0),
                _createTypeAccount(),
                SizedBox(height: 30.0),
                _createButton(context)
              ],
            ),
          ),
          FlatButton(
            child: Text("Volver a iniciar sesión", style: TextStyle(color: Colors.deepPurple)),
            onPressed: () => Navigator.pushReplacementNamed(context, "login"),
          ),
          SizedBox(height: 100.0)
        ],
      ),
    );
  }

  Widget _createEmail() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          icon: Icon(Icons.alternate_email, color: Colors.deepPurple,),
          hintText: "ejemplo@email.com",
          labelText: "Email"
        ),
          onChanged: (value) => setState(() {
            _email = value;
          })
      ),
    );
  }

  Widget _createPassword() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        obscureText: true,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            icon: Icon(Icons.lock_outline, color: Colors.deepPurple,),
            labelText: "Contraseña"
        ),
          onChanged: (value) => setState(() {
            _password = value;
          })
      ),
    );
  }

  Widget _createPhone() {
    return Visibility(
        visible: _isVisible,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Colors.deepPurple,),
              labelText: "Teléfono"
            ),
            onChanged: (value) => setState(() {
               _phone = value;
            })
          ),
        )
    );
  }

  Widget _createTypeAccount() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      height: 70.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Tipo de cuenta", style: TextStyle(fontSize: 16.5, color: Color.fromRGBO(104, 104, 104, 1))),
          SizedBox(width: 30.0),
          Expanded(
              child: DropdownButton(
                value: _selectedOption,
                items: getOptionsDropdown(),
                onChanged: (opt) {
                  setState(() {
                    _selectedOption = opt;
                    if ( _selectedOption == "giver" ) {
                      _isVisible = true;
                    } else {
                      _isVisible = false;
                    }
                  });
                },
              )
          )
        ],
      )
    );
  }

  List<DropdownMenuItem<String>> getOptionsDropdown() {
    List<DropdownMenuItem<String>> list = new List();
    list.add(DropdownMenuItem(
        child: Text("Quiero adoptar"),
        value: "adopter"
    ));
    list.add(DropdownMenuItem(
        child: Text("Quiero dar en adopción"),
        value: "giver"
    ));
    return list;
  }

  Widget _createButton(BuildContext context) {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
        child: Text("Entrar"),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      onPressed: () => _register(context),
    );
  }

  Widget _createBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final background = Container(
      height: size.height * 0.4,
      width: double.infinity,
      color: Colors.deepPurple,
    );

    return Stack(
      children: <Widget>[
        background,
        Align(
          alignment: Alignment.topCenter,
          child: Image(
            image: NetworkImage("https://i.pinimg.com/originals/4e/40/dd/4e40ddd11beb9ba671a0b59948861afb.png"),
            width: size.width * 0.6,
          ),
        )
      ],
    );
  }

  _register(BuildContext context) async {
    if ( _phone == null || _phone == "" || int.tryParse(_phone) == false) {
      _showAlert(context, "Introduzca el teléfono");
    } else {
      Map info = await usersProvider.register(_email, _password);
      if (info['ok']) {
        user.email = _email;
        user.accountType = _selectedOption;
        user.phone = _phone;
        usersProvider.createUser(user);
        if (_selectedOption == "giver") {
          Navigator.pushReplacementNamed(context, "giverHome");
        } else {
          Navigator.pushReplacementNamed(context, "adopterHome");
        }
      } else {
        _showAlert(context, info['message']);
      }
    }
  }

  _showAlert(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error", style: TextStyle(color: Colors.red)),
            content: Text(message, style: TextStyle(color: Colors.red)),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          );
        }
    );
  }

}