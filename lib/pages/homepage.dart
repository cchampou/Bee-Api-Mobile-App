import 'package:bee_api/pages/details.dart';
import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:bee_api/queries.dart';
import 'package:bee_api/graphQl.dart';

class HomePage extends StatefulWidget {
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
              document: Queries.getAll,
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

              final beehives = result.data['beehive'];

              return Scaffold(
                  appBar: AppBar(
                    title: Text('Les ruches'),
                    centerTitle: true,
                  ),
                  body: Column(
                    children: beehives
                        .map<Widget>((beehive) => ListTile(
                              title: Text(beehive['name']),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailsPage(beehive['id'])
                                  )
                                );
                              },
                            ))
                        .toList(),
                  ));
            }));
  }
}
