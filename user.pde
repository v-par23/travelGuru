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


 void loginUser(String username, String password) {
  if (users.containsKey(username)) {
    User user = users.get(username);
    if (user.password.equals(password)) {
      currentUser = user;
      registrationMessage = "";
      println("Login successful for user: " + username);
      currentQuestion = 0;  // Reset currentQuestion after successful login
      showRecommendations = false;  // Reset showRecommendations flag
      Arrays.fill(userInputs, null);  // Clear previous user inputs
    } else {
      registrationMessage = "Incorrect password.";
      println("Incorrect password for user: " + username);
    }
  } else {
    registrationMessage = "Username not found.";
    println("Username not found: " + username);
  }
}

void registerUser(String username, String password) {
  if (username.isEmpty() || password.isEmpty()) {
    registrationMessage = "Username and password cannot be empty.";
    println("Registration failed: Username and password cannot be empty.");
  } else if (!users.containsKey(username)) {
    users.put(username, new User(username, password, new ArrayList<String>()));
    saveUsers();
    registrationMessage = "Registration successful!";
    usernameInput = "";
    passwordInput = "";
    println("Registration successful for user: " + username);
  } else {
    registrationMessage = "Username already exists.";
    println("Username already exists: " + username);
  }
}

void saveUsers() {
  PrintWriter writer = createWriter("users.txt");
  for (User user : users.values()) {
    writer.print(user.username + "," + user.password);
    for (String rec : user.recommendations) {
      writer.print("," + rec);
    }
    writer.println();
  }
  writer.close();
}


  


  
