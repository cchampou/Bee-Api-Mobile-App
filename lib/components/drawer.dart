import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(title: Text('Les ruches'), leading: Icon(Icons.archive)),
          ListTile(title: Text('Mes favoris'), leading: Icon(Icons.favorite)),
          ListTile(title: Text('Paramètres'), leading: Icon(Icons.settings)),
          ListTile(title: Text('Quitter'), leading: Icon(Icons.exit_to_app)),
        ],
      ),
    );

  }
}