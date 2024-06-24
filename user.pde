//user class with destination with username, password, and list of recommendations
class User {
  String username;
  String password;
  ArrayList<String> recommendations;

  //constructor to create new user
  User(String username, String password, ArrayList<String> recommendations) {
    this.username = username;
    this.password = password;
    this.recommendations = recommendations;
  }
}

//user log in
void loginUser(String username, String password) {
  //checks if username exists 
  if (users.containsKey(username)) {
    User user = users.get(username);
    //checks if password matches
    if (user.password.equals(password)) {
      currentUser = user; //sets the current user to the logged in one
      registrationMessage = "";
      println("Login successful for user: " + username);
      currentQuestion = 0;  //resets currentQuestion after successful login
      showRecommendations = false;  
      Arrays.fill(userInputs, null);  //clears previous user inputs
    } else {
      registrationMessage = "Incorrect password.";
      println("Incorrect password for user: " + username);
    }
  } else {
    registrationMessage = "Username not found.";
    println("Username not found: " + username);
  }
}

//registers new user
void registerUser(String username, String password) {
  //checks if username or password is empty
  if (username.isEmpty() || password.isEmpty()) {
    registrationMessage = "Username and password cannot be empty.";
    println("Registration failed: Username and password cannot be empty.");
    //checks if username does not already exist
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

//saves users to text file
void saveUsers() {
  //creates printwriter for writing to text file
  PrintWriter writer = createWriter("users.txt");
  //iterates through all users
  for (User user : users.values()) {
    writer.print(user.username + "," + user.password);
    //iterates through user's recommendations
    for (String rec : user.recommendations) {
      writer.print("," + rec);
    }
    writer.println();
  }
  writer.close();
}
