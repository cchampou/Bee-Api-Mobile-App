import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:bee_api/queries.dart';
import 'package:bee_api/graphQl.dart';

import 'package:bee_api/components/imageCapture.dart';

class DetailsPage extends StatefulWidget {
  final String id;

  const DetailsPage(this.id);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool notNull(Object o) => o != null;

  String imageUrl;

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://bee-api-7e7b5.appspot.com');

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphQlObject.client,
      child: Query(
          options: QueryOptions(
            documentNode: Queries.getHive(widget.id),
            pollInterval: 30,
          ),
          builder: (QueryResult result,
              {VoidCallback refetch, FetchMore fetchMore}) {
            if (result.exception != null) {
              debugPrint(result.exception.toString());
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

            final String name = result.data['beehives'][0]['name'];
            final String image = result.data['beehives'][0]['image']['filename'];
            if (imageUrl == null) {
              _storage.ref().child(image).getDownloadURL().then((url) {
                setState(() {
                  imageUrl = url;
                });
              });
            }

            final String weight =
                result.data['beehives'][0]['weight'].toString();
            final String supers =
                result.data['beehives'][0]['supers'].toString();
            final String tempIn =
                result.data['beehives'][0]['tempIn'].toString();
            final String tempOut =
                result.data['beehives'][0]['tempOut'].toString();
            final String food = result.data['beehives'][0]['food'].toString();

            return Scaffold(
              appBar: AppBar(
                title: Text(name),
                actions: <Widget>[
                  FlatButton(
                    child: Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageCapture(),
                      ));
                },
                child: Icon(Icons.build),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              body: Center(
                  child: ListView(
                      children: [
                if (imageUrl != null)
                  Image.network(imageUrl),
                ListTile(
                  title: Text('$weight kg'),
                  leading: Icon(Icons.archive),
                ),
                (tempIn != 'null')
                    ? ListTile(
                        title: Text('$tempIn ºC'),
                        leading: Icon(Icons.wb_sunny),
                      )
                    : null,
                (tempOut != 'null')
                    ? ListTile(
                        title: Text('$tempOut ºC'),
                        leading: Icon(Icons.whatshot),
                      )
                    : null,
                (tempIn != 'null')
                    ? ListTile(
                        title: Text('position'),
                        leading: Icon(Icons.gps_fixed),
                      )
                    : null,
                ListTile(
                  title: Text(food),
                  leading: Icon(Icons.restaurant),
                ),
                ListTile(
                  title: Text('Nombre de hausses : $supers'),
                  leading: Icon(Icons.layers),
                ),
              ].where(notNull).toList())),
            );
          }),
    );
  }
}
