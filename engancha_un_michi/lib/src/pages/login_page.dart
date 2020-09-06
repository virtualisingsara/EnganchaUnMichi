import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
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
            margin: EdgeInsets.only(bottom: 30.0),
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
          Text("¿Olvidó la contraseña?"),
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
      color: Colors.deepPurple,
      textColor: Colors.white,
      onPressed: () => Navigator.pushNamed(context, "home"),
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

}