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

  //if (event == GEvent.CLICKED){
  //  if (!showRecommendations){
  //  displayQuestions();
  //  displayUserProfileIcon();
  //  }
  //  else if(!showDropdown){
  //  displayQuestions();
  //  displayUserProfileIcon();
  //  }
  //  else if (!showUserRecommendations){
  //  displayQuestions();
  //  displayUserProfileIcon();
  //  }
  //  else{
  //  displayLogin();
  //    }
  //  }
  
  
  //void addRecommendation(int index) {   
//  if (index >= 0 && index < recommendedDestinations.size()) {
//    Destination dest = recommendedDestinations.get(index);
//    if (!currentUser.recommendations.contains(dest.name)) {
//      currentUser.recommendations.add(dest.name);
//      saveUsers();
//      println("Added recommendation: " + dest.name + " for user: " + currentUser.username);
//    } else {
//      println("Destination already in recommendations: " + dest.name);
//    }
//  }
//}
  
  


  
