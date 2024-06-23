import g4p_controls.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.io.PrintWriter;

ArrayList<Destination> destinations = new ArrayList<Destination>();
ArrayList<Destination> recommendedDestinations = new ArrayList<Destination>();
HashMap<String, User> users = new HashMap<String, User>();

String[] questions = {
  "Enter your vacation duration (e.g., 7 days):",
  "Enter your total budget (e.g., $2000):",
  "Preferred climate (warm, cold, moderate):",
  "Preferred activities (e.g., beach, hiking, historical sites, nightlife):"
};
String[] userInputs = new String[questions.length];
String usernameInput = "";
String passwordInput = "";
String registrationMessage = "";

int currentQuestion = 0;
int recommendationsPerRow = 4; 
int fadeValue = 0;
int transitionSpeed = 5;  // transition speed value
float numDest = 2;
 
boolean showRecommendations = false;
boolean showDropdown = false;
boolean showUserRecommendations = false;
boolean introComplete = false;
boolean transitioning = false;

User currentUser = null;

PImage gameLogo, startButton, introBackground, userProfileIcon;

void setup() {
  size(1200, 700);

  gameLogo = loadImage("download.png");
  startButton = loadImage("destination.jpeg");
  introBackground = loadImage("bintur_header.jpg");
  userProfileIcon = loadImage("profile_icon.jpg");

  startButton.resize(int(300 / 1.5), int(119 / 1.5));
  introBackground.resize(int(2490 / 2), int(1960 / 2));
  userProfileIcon.resize(50, 50);

  loadDestinations();
  loadUsers();
  
  createGUI();
}

void draw() {
  background(255);

  if (!introComplete && !transitioning) {
    introScreen();
    backButton1.setVisible(false);
    backButton2.setVisible(false);
    slider1.setVisible(false);
    desti.setVisible(false);
  } else if (transitioning) {
    introScreen();
    backButton1.setVisible(false);
    backButton2.setVisible(false);
    slider1.setVisible(false);
    desti.setVisible(false);
    fill(0, fadeValue);
    rect(0, 0, width, height);
    fadeValue += transitionSpeed;
    if (fadeValue >= 255) {
      transitioning = false;
      introComplete = true;
    }
  
  } else if (currentUser == null) {
    displayLogin();
    backButton1.setVisible(false);
    backButton2.setVisible(false);
    slider1.setVisible(false);
    desti.setVisible(false);
  } else if (showUserRecommendations) {
    displayUserRecommendations();
    backButton1.setVisible(true);
    backButton2.setVisible(true);
    slider1.setVisible(false);
    desti.setVisible(false);
  } else if (!showRecommendations) {
    fill(0);
    textSize(20);
    text("Choose how many number of destinations to be recomended at once", 50, 350);
    displayQuestions();
    displayUserProfileIcon();
    backButton1.setVisible(true);
    backButton2.setVisible(false);
    slider1.setVisible(true);
    desti.setVisible(false);
    if (showDropdown) {
      displayDropdownMenu();
      backButton1.setVisible(true);
      backButton2.setVisible(false);
      fill(0);
      textSize(20);
      text("Choose how many number of destinations to be recomended at once", 50, 350);
      slider1.setVisible(true);
      desti.setVisible(false);
    }
  } else {
    displayRecommendations();
    displayUserProfileIcon();
    backButton1.setVisible(true);
    backButton2.setVisible(true);
    slider1.setVisible(false);
    desti.setVisible(true);    
      if (showDropdown) {
        displayDropdownMenu();
      }
  }
}

void introScreen() {
  image(introBackground, 0, -50);
  image(gameLogo, width / 2 - gameLogo.width / 2, height / 4 - gameLogo.height / 4);
  image(startButton, width / 2 - startButton.width / 2, height / 2 + gameLogo.height / 2 + 20);
  fill(0);
  textSize(48);
  textAlign(CENTER, CENTER);
  text("Welcome to TravelGuru!", width / 2, height / 9);
}

void resetQuestions() {
  for (int i = 0; i < userInputs.length; i++){
    userInputs[i] = "";
  }
  currentQuestion = 0;
  showRecommendations = false;
}

void displayLogin() {
  fill(0);
  textSize(36);
  textAlign(CENTER, CENTER);
  text("Please Login or Register", width / 2, height / 4);
  textSize(24);
  textAlign(LEFT);
  text("Username:", width / 2 - 125, height / 2 - 20);
  text("Password:", width / 2 - 125, height / 2 + 20);
  
  // Display username and password input fields
  fill(255);
  rect(width / 2, height / 2 - 40, 200, 30);
  rect(width / 2, height / 2, 200, 30);

  fill(0);
  textAlign(LEFT, TOP);
  text(usernameInput, width / 2 + 5, height / 2 -35);
  text(passwordInput.replaceAll(".", "*"), width / 2 + 5, height / 2 + 5);

  // Display Login and Register buttons
  fill(200);
  rect(width / 2 - 100, height / 2 + 80, 80, 40);
  rect(width / 2 + 20, height / 2 + 80, 100, 40);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Login", width / 2 - 60, height / 2 + 100);
  text("Register", width / 2 + 70, height / 2 + 100);

  // Display registration message
  textSize(18);
  fill(255, 0, 0);
  textAlign(CENTER, CENTER);
  text(registrationMessage, width / 2, height / 2 + 140);
}

void displayQuestions() {
  fill(0);
  textSize(20);
  textAlign(LEFT);
  for (int i = 0; i < questions.length; i++) {
    text(questions[i], 50, 105 + i * 50);
    if (userInputs[i] != null) {
      text(userInputs[i], 50, 130 + i * 50);
    }
  }
  if (currentQuestion >= questions.length) {
    recommendDestination();
    showRecommendations = true;
  }
}

void displayUserProfileIcon() {
  image(userProfileIcon, width - 60, 10);
}

void displayDropdownMenu() {
  fill(200);
  rect(width - 175, 60, 180, 40);
  fill(0);
  textSize(16);
  textAlign(LEFT, TOP);
  text("Show Recommendations", width - 170, 70);
}

void displayRecommendations() {
  fill(0);
  textSize(15);
  textAlign(CENTER, CENTER);

  if (!recommendedDestinations.isEmpty()) {
    for (int i = 0; i < recommendedDestinations.size(); i++) {
      Destination dest = recommendedDestinations.get(i);
      int yPosition = 0;

      // Position the recommendations
      if (i == 0) {
        yPosition = height / 16; // Tops
      } else if (i == 1) {
        yPosition = 8 * height / 33; // Middle
      } else if (i == 2) {
        yPosition = 3 * height / 7; // Bottom
      }
        else if (i == 3) {
        yPosition = 20 * height / 33; // Bottom
      }
        else if (i == 4) {
        yPosition = 26 * height / 33; // Bottom
      }
      fill(255,0,0);
      text("Recommended Destination " + (i + 1) + ": " + dest.name, width / 2, yPosition - 20);
      fill(0);
      text("Budget: $" + dest.budget, width / 2, yPosition + 10);
      text("Climate: " + dest.climate, width / 2, yPosition + 40);
      text("Activities: " + join(dest.activities, ", "), width / 2, yPosition + 70);
    }
  } else {
    text("No destination matches found", width / 2, height / 2);
  }
}

void displayUserRecommendations() {
  fill(0);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("Your Recommended Destinations", width / 2, 50);
  textAlign(LEFT, TOP);
  int yOffset = 100;
  int xOffset = 50;
  int spacingX = 250;  // Horizontal spacing between recommendations
  int spacingY = 40;   // Vertical spacing between rows

  for (int i = 0; i < currentUser.recommendations.size(); i++) {
    int row = i / recommendationsPerRow;  // Determine the current row
    int col = i % recommendationsPerRow;  // Determine the current column
    text(currentUser.recommendations.get(i), xOffset + col * spacingX, yOffset + row * spacingY);
  }
}

void mouseClicked() {
  if (!introComplete && !transitioning) {
    if (mouseX > width / 2 - startButton.width / 2 && mouseX < width / 2 + startButton.width / 2 &&
        mouseY > height / 2 + gameLogo.height / 2 + 20 && mouseY < height / 2 + gameLogo.height / 2 + 20 + startButton.height) {
      println("Start button clicked");
      transitioning = true;
    }
  } 
  // Handle login and registration
  else if (currentUser == null) {
    if (mouseX > width / 2 && mouseX < width / 2 + 200) {
      if (mouseY > height / 2 - 40 && mouseY < height / 2 - 10) {
        currentQuestion = 0; // Focus on username input
      } else if (mouseY > height / 2 && mouseY < height / 2 + 30) {
        currentQuestion = 1; // Focus on password input
      }
    } 
    // Handle Login button click
    if (mouseX > width / 2 - 100 && mouseX < width / 2 - 20 &&
               mouseY > height / 2 + 80 && mouseY < height / 2 + 120) {
      loginUser(usernameInput, passwordInput);
    } 
    // Handle Register button click
    if (mouseX > width / 2 + 20 && mouseX < width / 2 + 100 &&
               mouseY > height / 2 + 80 && mouseY < height / 2 + 120) {
      registerUser(usernameInput, passwordInput);
    }
  } else {
    // Handle user profile icon click
    if (mouseX > width - 60 && mouseX < width - 10 && mouseY > 10 && mouseY < 60) {
      showDropdown = !showDropdown;
    }
    // Handle dropdown menu option click
    if (showDropdown && mouseX > width - 160 && mouseX < width - 10 && mouseY > 60 && mouseY < 100) {
      showDropdown = false;
      showUserRecommendations = true;
    }
  }
}

void keyPressed() {
  if (!introComplete && !transitioning) {
    return; // Don't process key presses during intro or transition
  }

  if (currentUser == null) {
    // Handle login and registration input
    if (keyCode == ENTER) {
      // Move focus between username and password input fields on ENTER
      currentQuestion = (currentQuestion + 1) % 2;
    } else if (keyCode == BACKSPACE) {
      if (currentQuestion == 0 && usernameInput.length() > 0) {
        usernameInput = usernameInput.substring(0, usernameInput.length() - 1);
      } else if (currentQuestion == 1 && passwordInput.length() > 0) {
        passwordInput = passwordInput.substring(0, passwordInput.length() - 1);
      }
    } else if (keyCode != SHIFT && keyCode != ALT && keyCode != CONTROL && keyCode != TAB && keyCode != DELETE && keyCode != ESC && keyCode != UP && keyCode != DOWN && keyCode != LEFT && keyCode != RIGHT) {
      if (currentQuestion == 0) {
        usernameInput += key;
      } else if (currentQuestion == 1) {
        passwordInput += key;
      }
    }
  } else if (!showRecommendations) {
    if (keyCode == ENTER) {
      currentQuestion++;
      if (currentQuestion >= questions.length) {
        recommendDestination();
        showRecommendations = true;
        for (Destination dest : recommendedDestinations) {
          saveRecommendation(currentUser.username, dest.name);
        }
      }
    } else if (keyCode == BACKSPACE) {
      if (userInputs[currentQuestion] != null && userInputs[currentQuestion].length() > 0) {
        userInputs[currentQuestion] = userInputs[currentQuestion].substring(0, userInputs[currentQuestion].length() - 1);
      }
    } else if (keyCode != SHIFT && keyCode != ALT && keyCode != CONTROL && keyCode != TAB && keyCode != DELETE && keyCode != ESC && keyCode != UP && keyCode != DOWN && keyCode != LEFT && keyCode != RIGHT) {
      if (userInputs[currentQuestion] == null) {
        userInputs[currentQuestion] = "";
      }
      userInputs[currentQuestion] += key;
    }
  }
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

void loginUser(String username, String password) {
  if (users.containsKey(username)) {
    User user = users.get(username);
    if (user.password.equals(password)) {
      currentUser = user;
      registrationMessage = "";
      println("Login successful for user: " + username);
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


boolean shouldRecommend(Destination dest, String input, int count) {
  return (input.isEmpty() || dest.name.toLowerCase().contains(input)) && count < numDest && !currentUser.recommendations.contains(dest.name);
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
