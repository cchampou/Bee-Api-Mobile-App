import "package:gql/language.dart" as lang;
import "package:gql/ast.dart" as ast;

class Queries {
  static getHive(String id) {
    return lang.parseString("""
    query getHive {
      beehives(where: {id: {_eq: "$id"}}) {
        name
        image {
          filename
        }
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
