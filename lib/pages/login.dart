import 'package:bee_api/pages/homepage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:bee_api/graphQl.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

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
  bool _loading = false;

  Future<FirebaseUser> _handleFacebookSignIn() async {
    _toggleLoading(true);
    try {
      final facebookLogin = FacebookLogin();
      final result = await facebookLogin.logIn(['email']);
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          print('ok${result.accessToken.token}');

          final credentials = FacebookAuthProvider.getCredential(
              accessToken: result.accessToken.token);

          user = (await _auth.signInWithCredential(credentials)).user;
          token = (await user.getIdToken()).token;

          GraphQlObject.authLink = AuthLink(getToken: () => 'Bearer $token');
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));

          return user;
          break;
        case FacebookLoginStatus.cancelledByUser:
          print('cancelled');
          break;
        case FacebookLoginStatus.error:
          print(result.errorMessage);
          break;
      }

      _toggleLoading(false);
      return null;
    } catch (exception) {
      if (this.mounted) {
        setState(() {
          _loading = false;
          _message = exception.toString();
        });
      }
      return null;
    }
  }

  Future<FirebaseUser> _handleSignIn() async {
    _toggleLoading(true);
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
      _toggleLoading(false);
      _setMessage(exception.toString());
      return null;
    }
  }

  _setMessage(target) {
    if (_message != target && this.mounted) {
      setState(() {
        _message = target;
      });
    }
  }

  _toggleLoading(target) {
    if (this.mounted) {
      setState(() {
        _loading = target;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _data = new _LoginData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow,
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
                        _setMessage('');
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
                        _setMessage('');
                      },
                      onSaved: (value) {
                        this._data.password = value;
                      },
                    ),
                    Container(
                      margin: EdgeInsets.all(30),
                      child: FlatButton(
                          child:
                              Text(_loading ? 'Chargement...' : 'Se connecter'),
                          color: Colors.black87,
                          textColor: Colors.white,
                          onPressed: () {
                            if (!_loading &&
                                this._formKey.currentState.validate()) {
                              this._formKey.currentState.save();
                              this._handleSignIn();
                            }
                          }),
                    ),
                    Container(
                      margin: EdgeInsets.all(30),
                      child: FlatButton(
                          child: Text(_loading
                              ? 'Chargement...'
                              : 'Se connecter avec Facebook'),
                          color: Colors.blueAccent,
                          textColor: Colors.white,
                          onPressed: () {
                            if (!_loading) {
                              this._formKey.currentState.save();
                              this._handleFacebookSignIn();
                            }
                          }),
                    ),
                    _message != null ? Text(_message) : null,
                  ].where((o) => o != null).toList())),
        ));
  }
}
