class User {
  String username;
  String password;
  ArrayList<String> recommendations;

  User(String username, String password, ArrayList<String> recommendations) {
    this.username = username;
    this.password = password;
    this.recommendations = recommendations;
  }
}
