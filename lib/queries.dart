class Queries {
  static getHive(String id) {
  return """
    query GetLooma {
      beehive(where: {id: {_eq: "$id"}}) {
        name
        weight
        supers
      }
    }
  """;
  }
  static String getAll = """
    query GetAll {
      beehive {
        id
        name
      }
    }
  """;
}

