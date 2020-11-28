import 'package:enganchaunmichi/src/providers/users_provider.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final usersProvider = new UsersProvider();
  String _email;
  String _password;

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
                Text("Iniciar sesión", style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 10.0),
                _createEmail(),
                SizedBox(height: 10.0),
                _createPassword(),
                SizedBox(height: 30.0),
                _createButton(context)
              ],
            ),
          ),
          FlatButton(
            child: Text("Registrarse", style: TextStyle(color: Color(0xFF957DAD))),
            onPressed: () => Navigator.pushReplacementNamed(context, "register"),
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
              icon: Icon(Icons.alternate_email, color: Color(0xFF957DAD)),
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
              icon: Icon(Icons.lock_outline, color: Color(0xFF957DAD)),
              labelText: "Contraseña"
          ),
          onChanged: (value) => setState(() {
            _password = value;
          })
      ),
    );
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
      color: Color(0xFF957DAD),
      textColor: Colors.white,
      onPressed: () => _login(context),
    );
  }

  Widget _createBackground(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final background = Container(
      height: size.height * 0.4,
      width: double.infinity,
      color: Color(0xFF957DAD),
    );

    return Stack(
      children: <Widget>[
        background,
        SizedBox(height: size.height * 0.2),
        Align(
          alignment: Alignment.topCenter,
          child:
          Image(
            image: AssetImage('assets/logo.png'),
            height: size.height * 0.35,
          ),
        )
      ],
    );
  }

  _login(BuildContext context) async {
    Map info = await usersProvider.login(_email, _password);
    if ( info['ok'] ) {
      var users = await usersProvider.readUsers();
      var usersMap = Map.fromIterable(users, key: (e) => e.email, value: (e) => e.accountType);
      var accountType = usersMap[_email];
      if ( accountType == "giver" ) {
        Navigator.pushReplacementNamed(context, "giverHome", arguments: _email);
      } else {
        Navigator.pushReplacementNamed(context, "adopterHome", arguments: _email);
      }
    } else {
      _showAlert(context);
    }
  }

  _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error", style: TextStyle(color: Colors.red)),
            content: Text("El usuario y/o la contraseña son incorrectos", style: TextStyle(color: Colors.red)),
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