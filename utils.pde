boolean isNumeric(String str) {
  try {
    Integer.parseInt(str);
    return true;
  } catch (NumberFormatException e) {
    return false;
  }
}

boolean isValidDuration(String duration) {
  if (isNumeric(duration)) {
    int days = Integer.parseInt(duration);
    return days > 0 && days <= 365;
  }
  return false;
}

boolean isValidBudget(String budget) {
  if (isNumeric(budget)) {
    int amount = Integer.parseInt(budget);
    return amount > 0;
  }
  return false;
}

boolean isValidClimate(String climate) {
  String[] validClimates = {"warm", "cold", "moderate"};
  return Arrays.asList(validClimates).contains(climate.toLowerCase());
}

boolean isValidActivities() {
  return true;
}

void loadDestinations() {
  String[] lines = loadStrings("destinations2.txt");
  for (String line : lines) {
    if (line.trim().length() > 0 && !line.startsWith("#")) {
      String[] parts = split(line, ',');
      String name = parts[0];
      int budget = int(parts[1].trim());
      String climate = parts[2].trim();
      String[] activities = split(parts[3].trim(), ' ');
      destinations.add(new Destination(name, budget, climate, activities));
    }
  }
}

void loadUsers() {
  String[] lines = loadStrings("users.txt");
  for (String line : lines) {
    if (line.trim().length() > 0 && !line.startsWith("#")) {
      String[] parts = split(line, ',');
      String username = parts[0];
      String password = parts[1];
      ArrayList<String> recommendations = new ArrayList<String>();
      for (int i = 2; i < parts.length; i++) {
        recommendations.add(parts[i]);
      }
      users.put(username, new User(username, password, recommendations));
    }
  }
}
