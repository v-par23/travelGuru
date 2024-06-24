//checks if a string is numeric by attempting it to parse it as an int
boolean isNumeric(String str) {
  try {
    Integer.parseInt(str);
    return true;
  } catch (NumberFormatException e) {
    return false;
  }
}

//checks if the user's duration is valid
boolean isValidDuration(String duration) {
  if (isNumeric(duration)) {
    int days = Integer.parseInt(duration);
    return days > 0 && days <= 365;
  }
  return false;
}

//checks if the user's budget is valid
boolean isValidBudget(String budget) {
  if (isNumeric(budget)) {
    int amount = Integer.parseInt(budget);
    return amount > 0;
  }
  return false;
}

//checks if climate string is valid and is one of the 3
boolean isValidClimate(String climate) {
  String[] validClimates = {"warm", "cold", "moderate"};
  return Arrays.asList(validClimates).contains(climate.toLowerCase());
}

boolean isValidActivities() {
  return true;
}

//loads destination data from text file
void loadDestinations() {
  String[] lines = loadStrings("destinations2.txt");
  //iterates through each line in array
  for (String line : lines) {
    //skips the empty lines
    if (line.trim().length() > 0 && !line.startsWith("#")) {
      //splits it by commas
      String[] parts = split(line, ',');
      //extracts the info
      String name = parts[0];
      int budget = int(parts[1].trim());
      String climate = parts[2].trim();
      String[] activities = split(parts[3].trim(), ' ');
      //creates new destination object and adds it to the list
      destinations.add(new Destination(name, budget, climate, activities));
    }
  }
}

//loads users data from text file
void loadUsers() {
  String[] lines = loadStrings("users.txt");
  //iterates through each line in array
  for (String line : lines) {
    //skips the empty lines
    if (line.trim().length() > 0 && !line.startsWith("#")) {
      //splits it by commas
      String[] parts = split(line, ',');
      //extracts the info
      String username = parts[0];
      String password = parts[1];
      //creates new ArrayList for recommendations
      ArrayList<String> recommendations = new ArrayList<String>();
      //iterates over recommendation parts and adds it to the ArrayList
      for (int i = 2; i < parts.length; i++) {
        recommendations.add(parts[i]);
      }
      //creates new user object and adds it to the map
      users.put(username, new User(username, password, recommendations));
    }
  }
}
