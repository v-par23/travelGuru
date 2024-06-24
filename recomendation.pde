void recommendDestination() {
    ArrayList<DestinationScore> scores = new ArrayList<DestinationScore>();
    int userBudget = int(userInputs[1].replaceAll("[^\\d]", ""));
    String userClimate = userInputs[2].trim();
    String[] userActivities = split(userInputs[3].trim(), ',');

    // Calculate scores for each destination based on user preferences
    for (Destination dest : destinations) {
        int budgetDiff = abs(dest.budget - userBudget);
        int totalDifference = budgetDiff;

        if (dest.climate.equalsIgnoreCase(userClimate)) {
            for (String activity : userActivities) {
                if (Arrays.asList(dest.activities).contains(trim(activity))) {
                    totalDifference -= 10; // Reward matching activities
                }
            }
        } else {
            totalDifference += 50; // Penalize climate mismatch
        }

        scores.add(new DestinationScore(dest, totalDifference));
    }

    // Sort destinations by their calculated scores
    Collections.sort(scores, new Comparator<DestinationScore>() {
        public int compare(DestinationScore s1, DestinationScore s2) {
            return Integer.compare(s1.score, s2.score);
        }
    });

    // Filter and add matching destinations to the recommendedDestinations list
    recommendedDestinations.clear();
    String destinationInput = desti.getText().trim(); // Get user input and convert to lowercase
    int count = 0;

    for (DestinationScore score : scores) {
        Destination dest = score.destination;
        if (destinationInput.isEmpty() || dest.name.contains(destinationInput)) {
            if (!currentUser.recommendations.contains(dest.name)) {
                recommendedDestinations.add(dest);
                count++;
                if (count >= numDest) {
                    break;
                }
            }
        }
    }

    showRecommendations = true;
}

int countMatchingActivities(String[] destActivities, String[] userActivities) {
  int matchCount = 0;
  for (String activity : userActivities) {
    if (Arrays.asList(destActivities).contains(trim(activity))) {
      matchCount++;
    }
  }
  return matchCount;
}

void saveSpecifiedRecommendations(String input) {
  if (currentUser != null && input != null && !input.trim().isEmpty()) {
    String[] countries = split(input, ',');
    for (String country : countries) {
      country = country.trim();
      boolean found = false;
      for (Destination dest : recommendedDestinations) {
        if (dest.name.equalsIgnoreCase(country)) {
          saveRecommendation(currentUser.username, dest.name);
          found = true;
          break;
        }
      }
      if (!found) {
        println("Destination not in recommendations: " + country);
      }
    }
    println("Specified recommendations saved for user: " + currentUser.username);
  } else {
    println("No user logged in or empty input.");
  }
}

void saveRecommendation(String username, String recommendation) {
  if (users.containsKey(username)) {
    User user = users.get(username);
    if (!user.recommendations.contains(recommendation)) {
      user.recommendations.add(recommendation);
      saveUsers();
    }
  }
}
