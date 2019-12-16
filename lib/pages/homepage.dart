import 'package:bee_api/components/drawer.dart';
import 'package:bee_api/pages/details.dart';
import 'package:bee_api/pages/login.dart';
import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:bee_api/queries.dart';
import 'package:bee_api/graphQl.dart';

class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  _logoutHandler() {
    GraphQlObject.authLink = AuthLink(getToken: () => null);
    Navigator.pushReplacement(
    context, MaterialPageRoute(builder: (context) => LoginPage()));
  }


  @override
  Widget build(BuildContext context) {
    if (GraphQlObject.authLink.getToken() == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }

    return GraphQLProvider(
        client: GraphQlObject.client,
        child: Query(
            options: QueryOptions(
              documentNode: Queries.getAll,
              pollInterval: 30,
            ),
            builder: (QueryResult result,
                {VoidCallback refetch, FetchMore fetchMore}) {
              if (result.exception != null) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Bienvenue'),
                    centerTitle: true,
                  ),
                  body: Center(
                      child: Text('Oups, impossible de charger les données')),
                );
              }

              if (result.loading) {
                return Scaffold(
                  body: Center(child: Text('Chargement')),
                );
              }

              final beehives = result.data['beehives'];

              return Scaffold(
                  drawer: MainDrawer(),
                  appBar: AppBar(
                    title: Text('Les ruches'),
                    centerTitle: true,
                    actions: <Widget>[
                      FlatButton(
                        child: Icon(Icons.exit_to_app),
                        onPressed: _logoutHandler,
                      )
                    ],
                  ),
                  body: Column(
                    children: beehives
                        .map<Widget>((beehive) =>
                        ListTile(
                          title: Text(beehive['name']),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailsPage(beehive['id'])
                                )
                            );
                          },
                        ))
                        .toList(),
                  ));
            }));
  }
}
