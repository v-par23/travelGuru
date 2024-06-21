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
  
