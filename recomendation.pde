void recommendDestination() {
    //initializes ArrayList to store destiantionScore objects
    ArrayList<DestinationScore> scores = new ArrayList<DestinationScore>();
    
    //input values for comparisons
    int userBudget = int(userInputs[1].replaceAll("[^\\d]", ""));
    String userClimate = userInputs[2].trim();
    String[] userActivities = split(userInputs[3].trim(), ',');

    //calculate scores for each destination based on user preferences
    for (Destination dest : destinations) {
        int budgetDiff = abs(dest.budget - userBudget);
        int totalDifference = budgetDiff;

        //checks if destination climate matches user preferences
        if (dest.climate.equalsIgnoreCase(userClimate)) {
          //checks the activity prefrences next
            for (String activity : userActivities) {
                if (Arrays.asList(dest.activities).contains(trim(activity))) {
                    totalDifference -= 10; //
                }
            }
        } else {
            totalDifference += 50; //
        }

        //creates destinationScore object and adds to the scores ArrayList 
        scores.add(new DestinationScore(dest, totalDifference));
    }

    //sorts destinations by their calculated scores
    Collections.sort(scores, new Comparator<DestinationScore>() {
        public int compare(DestinationScore s1, DestinationScore s2) {
            return Integer.compare(s1.score, s2.score);
        }
    });

    //clears previouds recommendations and adds new ones
    recommendedDestinations.clear();
    
    //initializes count to track the destinations
    int count = 0;

    //loops through the sorted scores and adds destinations to recommendedDestinations
    for (DestinationScore score : scores) {
        Destination dest = score.destination;
        recommendedDestinations.add(dest); //adds it to the list
        count++;
        
        //checks if enough destinations have been added
        if (count >= numDest) {
            break;
        }
    }

    showRecommendations = true;
}

//calcualtes how well the destination activities match with the user prefrences
int countMatchingActivities(String[] destActivities, String[] userActivities) {
  int matchCount = 0;
  //iterates through user activities and checks it against the destination activities
  for (String activity : userActivities) {
    if (Arrays.asList(destActivities).contains(trim(activity))) {
      matchCount++;
    }
  }
  return matchCount;
}

//saves recomendation for user
void saveRecommendation(String username, String recommendation) {
  //checks if the username is valid
  if (users.containsKey(username)) {
    User user = users.get(username);
    //adds the recommendation to the user's list
    if (!user.recommendations.contains(recommendation)) {
      user.recommendations.add(recommendation);
      saveUsers();
    }
  }
}
