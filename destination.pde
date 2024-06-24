class Destination {
  String name;
  int budget;
  String climate;
  String[] activities;

  Destination(String name, int budget, String climate, String[] activities) {
    this.name = name;
    this.budget = budget;
    this.climate = climate;
    this.activities = activities;
  }
}

void addDestination(Destination d) {
    destinations.add(d);
  }
