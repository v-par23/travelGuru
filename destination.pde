//destination class with name, budget, climate, and activities 
class Destination {
  String name;
  int budget;
  String climate;
  String[] activities;

  //constructor to create new destination object 
  Destination(String name, int budget, String climate, String[] activities) {
    this.name = name;
    this.budget = budget;
    this.climate = climate;
    this.activities = activities;
  }
}
