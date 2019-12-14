import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:bee_api/queries.dart';
import 'package:bee_api/graphQl.dart';

class DetailsPage extends StatefulWidget {
  final String id;

  const DetailsPage(this.id);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphQlObject.client,
      child: Query(
          options: QueryOptions(
            document: Queries.getHive(widget.id),
            pollInterval: 30,
          ),
          builder: (QueryResult result,
              {VoidCallback refetch, FetchMore fetchMore}) {
            if (result.errors != null) {
              return Scaffold(
                body: Center(
                    child: Text('Oups, impossible de charger les données')),
              );
            }

            if (result.loading) {
              return Scaffold(
                body: Center(child: Text('Chargement')),
              );
            }

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
