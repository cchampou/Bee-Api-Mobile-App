
class Queries {
  static String getLooma = """
    query GetLooma {
      beehive(where: {id: {_eq: "96d446f2-5fa9-4af4-92ec-05b4a103fcfb"}}) {
        name
        weight
        supers
      }
    }
  """;
}