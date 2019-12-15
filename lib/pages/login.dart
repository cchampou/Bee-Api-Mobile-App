import 'package:bee_api/pages/homepage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:bee_api/graphQl.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _LoginData {
  String email = '';
  String password = '';
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user;

  String token;

  String _message = '';

  Future<FirebaseUser> _handleSignIn() async {
    try {
      user = (await _auth.signInWithEmailAndPassword(
              email: _data.email, password: _data.password))
          .user;
      token = (await user.getIdToken()).token;
      GraphQlObject.authLink = AuthLink(getToken: () => 'Bearer $token');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      return user;
    } catch (exception) {
      print('fail: $exception');
      _message = exception.toString();
      return null;
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _data = new _LoginData();

  @override
  Widget build(BuildContext context) {
    debugPrint(this._message);
    return Scaffold(
        appBar: AppBar(
          title: Text(this._message),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.all(30),
          child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Email...'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ce champs doit être renseigné';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        this._message = '';
                      },
                      onSaved: (value) {
                        this._data.email = value;
                      },
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'Mot de passe...'),
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Ce champs doit être renseigné';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        this._message = '';
                      },
                      onSaved: (value) {
                        this._data.password = value;
                      },
                    ),
                    FlatButton(
                        child: Text('Se connecter'),
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {
                          if (this._formKey.currentState.validate()) {
                            this._formKey.currentState.save();
                            this._handleSignIn();
                          }
                        }),
                    _message != null ? Text(_message) : null,
                  ].where((o) => o != null).toList())),
        ));
  }
}
