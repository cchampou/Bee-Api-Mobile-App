import 'package:flutter/material.dart';

import 'package:bee_api/graphQl.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:bee_api/queries.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bee API',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: HomePage(title: 'Looma PP'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphQlObject.client,
      child: Query(
          options: QueryOptions(
            document: Queries.getLooma,
            pollInterval: 30,
          ),
          builder: (QueryResult result,
              {VoidCallback refetch, FetchMore fetchMore}) {
            if (result.errors != null) {
              return Scaffold(
                body: Center(child: Text('Oups, impossible de charger les données')),
              );
            }

            if (result.loading) {
              return Scaffold(
                body: Center(child: Text('Chargement')),
              );
            }

            print(result.data);
            final String name = result.data['beehive'][0]['name'];
            final String weight =
                result.data['beehive'][0]['weight'].toString();
            final String supers =
                result.data['beehive'][0]['supers'].toString();

            return Scaffold(
              appBar: AppBar(
                title: Text(name),
              ),
              body: Center(
                  child: Column(children: [
                ListTile(title: Text('Poids de la ruche : $weight kg')),
                ListTile(title: Text('Nombre de hausses : $supers')),
              ])),
            );
          }),
    );
  }
}
