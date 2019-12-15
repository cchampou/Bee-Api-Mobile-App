import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQlObject {
  static HttpLink httpLink = HttpLink(
    uri: 'https://beeapi.herokuapp.com/v1/graphql',
  );
  static AuthLink authLink;
  static Link link = authLink.concat(httpLink);
  static ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: link,
    ),
  );
}

GraphQlObject graphQlObject = new GraphQlObject();
