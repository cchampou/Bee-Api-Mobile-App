import "package:gql/language.dart" as lang;
import "package:gql/ast.dart" as ast;

class Queries {
  static getHive(String id) {
    return lang.parseString("""
    query GetLooma {
      beehives(where: {id: {_eq: "$id"}}) {
        name
        weight
        supers
        tempIn
        tempOut
        food
      }
    }
  """);
  }

  static ast.DocumentNode getAll = lang.parseString("""
    query GetAll {
      beehives {
        id
        name
      }
    }
  """);
}
