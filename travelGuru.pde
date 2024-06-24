//imports necessary libraries and classes
import g4p_controls.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.io.PrintWriter;

//global variables for destinations, recommendations, users
ArrayList<Destination> destinations = new ArrayList<Destination>();
ArrayList<Destination> recommendedDestinations = new ArrayList<Destination>();
HashMap<String, User> users = new HashMap<String, User>();

//arrays for questions and user inputs
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

//variables 
int currentQuestion = 0;
int recommendationsPerRow = 4; 
int fadeValue = 0;
int transitionSpeed = 5;
float numDest = 3;
 
//booleans to manage  states
boolean showRecommendations = false;
boolean showDropdown = false;
boolean showUserRecommendations = false;
boolean introComplete = false;
boolean transitioning = false;

User currentUser = null; //current logged-in user

PImage gameLogo, startButton, introBackground, userProfileIcon;

void setup() {
  size(1200, 700); //set size of screen

  //loads images
  gameLogo = loadImage("download.png");
  startButton = loadImage("destination.jpeg");
  introBackground = loadImage("bintur_header.jpg");
  userProfileIcon = loadImage("profile_icon.jpg");

  //resizes images 
  startButton.resize(int(300 / 1.5), int(119 / 1.5));
  introBackground.resize(int(2490 / 2), int(1960 / 2));
  userProfileIcon.resize(50, 50);

  //loads destinations and users from data files
  loadDestinations();
  loadUsers();
  
  createGUI();
}

void draw() {
  background(255);
  //handles different display states
  if (!introComplete && !transitioning) {
    introScreen(); //intro screen
    backButton1.setVisible(false);
    backButton2.setVisible(false);
    slider1.setVisible(false);
  } else if (transitioning) {
    //fade effect
    introScreen();
    backButton1.setVisible(false);
    backButton2.setVisible(false);
    slider1.setVisible(false);
    fill(0, fadeValue);
    rect(0, 0, width, height);
    fadeValue += transitionSpeed;
    if (fadeValue >= 255) {
      transitioning = false;
      introComplete = true;
    }
  } else if (currentUser == null) {
    displayLogin(); //login/registration screen
    backButton1.setVisible(false);
    backButton2.setVisible(false);
    slider1.setVisible(false);
  } else if (showUserRecommendations) {
    displayUserRecommendations(); //user's recomended destinations screen
    backButton1.setVisible(true);
    backButton2.setVisible(true);
    slider1.setVisible(false);
  } else if (!showRecommendations) {
    //displays questions and user input fields
    fill(0);
    textSize(20);
    textAlign(LEFT);
    text("Choose how many number of destinations to be recomended at once", 50, 350);
    displayQuestions();
    displayUserProfileIcon(); 
    displayResetButton();
    backButton1.setVisible(true);
    backButton2.setVisible(false);
    slider1.setVisible(true);
    if (showDropdown) {
      displayDropdownMenu(); //displays dropdown menu
      backButton1.setVisible(true);
      backButton2.setVisible(false);
      slider1.setVisible(true);
    }
  } else {
    displayRecommendations(); //displays recomneded destinations
    displayUserProfileIcon();
    backButton1.setVisible(true);
    backButton2.setVisible(true);
    slider1.setVisible(false);  
      if (showDropdown) {
        displayDropdownMenu();
      }
  }
}

//displays intro screen
void introScreen() {
  image(introBackground, 0, -50);
  image(gameLogo, width / 2 - gameLogo.width / 2, height / 4 - gameLogo.height / 4);
  image(startButton, width / 2 - startButton.width / 2, height / 2 + gameLogo.height / 2 + 20);
  fill(0);
  textSize(48);
  textAlign(CENTER, CENTER);
  text("Welcome to TravelGuru!", width / 2, height / 9);
}

//reset user inputs for questions
void resetQuestions() {
  for (int i = 0; i < userInputs.length; i++){
    userInputs[i] = "";
  }
  currentQuestion = 0;
  showRecommendations = false;
}

//displays login screen
void displayLogin() {
  fill(0);
  textSize(36);
  textAlign(CENTER, CENTER);
  text("Please Login or Register", width / 2, height / 4);
  textSize(24);
  textAlign(LEFT);
  text("Username:", width / 2 - 125, height / 2 - 20);
  text("Password:", width / 2 - 125, height / 2 + 20);
  
  //displays username and password input fields
  fill(255);
  rect(width / 2, height / 2 - 40, 200, 30);
  rect(width / 2, height / 2, 200, 30);

  fill(0);
  textAlign(LEFT, TOP);
  text(usernameInput, width / 2 + 5, height / 2 -35);
  text(passwordInput.replaceAll(".", "*"), width / 2 + 5, height / 2 + 5);

  //displays login and register buttons
  fill(200);
  rect(width / 2 - 100, height / 2 + 80, 80, 40);
  rect(width / 2 + 20, height / 2 + 80, 100, 40);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Login", width / 2 - 60, height / 2 + 100);
  text("Register", width / 2 + 70, height / 2 + 100);

  //displays registration message
  textSize(18);
  fill(255, 0, 0);
  textAlign(CENTER, CENTER);
  text(registrationMessage, width / 2, height / 2 + 140);
}

//displays questions during setup
void displayQuestions() {
  fill(0);
  textSize(20);
  textAlign(LEFT);
  //displays each question with the current input
  for (int i = 0; i < questions.length; i++) {
    text(questions[i], 50, 105 + i * 50);
    if (userInputs[i] != null) {
      text(userInputs[i], 50, 130 + i * 50);
    }
  }
  //checks if all questions are answered to move to the recommendations
  if (currentQuestion >= questions.length) {
    recommendDestination();
    showRecommendations = true;
  }
}

//displays the user profile icon
void displayUserProfileIcon() {
  image(userProfileIcon, width - 90, 10);
}

//displays dropdown menu 
void displayDropdownMenu() {
  fill(200);
  rect(width - 220, 60, 200, 40);
  fill(0);
  textSize(16);
  textAlign(LEFT, TOP);
  text("Show Recommendations", width - 215, 70);
}

//displays recomended destinations
void displayRecommendations() {
  fill(0);
  textSize(15);
  textAlign(CENTER, CENTER);
  
  //checks if recomended destinations list is not empty 
  if (!recommendedDestinations.isEmpty()) {
    //loops through each recommended destination in the list
    for (int i = 0; i < recommendedDestinations.size(); i++) {
      Destination dest = recommendedDestinations.get(i); //gets the current destination object
      int yPosition = 0;

      //positions the recommendations by determining the vertical position
      if (i == 0) {
        yPosition = height / 16; //1
      } else if (i == 1) {
        yPosition = 8 * height / 33; //2
      } else if (i == 2) {
        yPosition = 3 * height / 7; //3
      }
        else if (i == 3) {
        yPosition = 20 * height / 33; //4
      }
        else if (i == 4) {
        yPosition = 26 * height / 33; //5
      }
      //displays the details of each recommended destination
      fill(255,0,0);
      text("Recommended Destination " + (i + 1) + ": " + dest.name, width / 2, yPosition - 20);
      fill(0);
      text("Budget: $" + dest.budget, width / 2, yPosition + 10);
      text("Climate: " + dest.climate, width / 2, yPosition + 40);
      text("Activities: " + join(dest.activities, ", "), width / 2, yPosition + 70);
    }
    //if no destination is found
  } else {
    text("No destination matches found", width / 2, height / 2);
  }
}

//displays the user's recommended destinations
void displayUserRecommendations() {
  fill(0);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("Your Recommended Destinations", width / 2, 50);
  textAlign(LEFT, TOP);
  int yOffset = 100;
  int xOffset = 50;
  int spacingX = 250;  //horizontal spacing between recommendations
  int spacingY = 40;   //vertical spacing between rows

  //loops through user's recommendations to displays them
  for (int i = 0; i < currentUser.recommendations.size(); i++) {
    int row = i / recommendationsPerRow;  //determines the current row
    int col = i % recommendationsPerRow;  //determinse the current column
    text(currentUser.recommendations.get(i), xOffset + col * spacingX, yOffset + row * spacingY);
  }
}

//displays the reset button
void displayResetButton() {
  fill(200);
  rect(610, 140, 170, 40);
  fill(0);
  textAlign(CENTER, CENTER);
  text("Reset Questions", 695, 160);
}

//handles mouseClicked events
void mouseClicked() {
  //handles start button click on intro screen
  if (!introComplete && !transitioning) {
    if (mouseX > width / 2 - startButton.width / 2 && mouseX < width / 2 + startButton.width / 2 &&
        mouseY > height / 2 + gameLogo.height / 2 + 20 && mouseY < height / 2 + gameLogo.height / 2 + 20 + startButton.height) {
      println("Start button clicked");
      transitioning = true; //starts transitioning to main screen
    }
  } 
  //handles login and registration
  else if (currentUser == null) {
    //checks if mouse is over username or the passowrd input fields
    if (mouseX > width / 2 && mouseX < width / 2 + 200) {
      if (mouseY > height / 2 - 40 && mouseY < height / 2 - 10) {
        currentQuestion = 0; // Focus on username input
      } else if (mouseY > height / 2 && mouseY < height / 2 + 30) {
        currentQuestion = 1; // Focus on password input
      }
    } 
    //handle login button click
    if (mouseX > width / 2 - 100 && mouseX < width / 2 - 20 &&
               mouseY > height / 2 + 80 && mouseY < height / 2 + 120) {
      loginUser(usernameInput, passwordInput);
    } 
    //handles register button click
    if (mouseX > width / 2 + 20 && mouseX < width / 2 + 100 &&
               mouseY > height / 2 + 80 && mouseY < height / 2 + 120) {
      registerUser(usernameInput, passwordInput);
    }
  } else {
    //handlse user profile icon click
    if (mouseX > width - 90 && mouseX < width - 40 && mouseY > 10 && mouseY < 60) {
      showDropdown = !showDropdown;
    }
    //handles dropdown menu option click
    if (showDropdown && mouseX > width - 220 && mouseX < width - 220 + 200 && mouseY > 60 && mouseY < 100) {
      showDropdown = false;
      showUserRecommendations = true;
    }
    //handles click on reset questions button
    if (mouseX >= 610 && mouseX <= 780 && mouseY >= 140 && mouseY <= 180) {
      resetQuestions();
    }
  }
}

//handles keyPressed events
void keyPressed() {
  if (!introComplete && !transitioning) {
    return; //does not process key presses during intro or transition
  }

  if (currentUser == null) {
    //handles login and registration input
    if (keyCode == ENTER) {
      //focuses between username and password input fields on ENTER
      currentQuestion = (currentQuestion + 1) % 2;
    } else if (keyCode == BACKSPACE) {
      //handles BACKSPACE to delete chracters during input fields
      if (currentQuestion == 0 && usernameInput.length() > 0) {
        usernameInput = usernameInput.substring(0, usernameInput.length() - 1);
      } else if (currentQuestion == 1 && passwordInput.length() > 0) {
        passwordInput = passwordInput.substring(0, passwordInput.length() - 1);
      }
    } else if (keyCode != SHIFT && keyCode != ALT && keyCode != CONTROL && keyCode != TAB && keyCode != DELETE && keyCode != ESC && keyCode != UP && keyCode != DOWN && keyCode != LEFT && keyCode != RIGHT) {
      //handles typing characters into the input fields
      if (currentQuestion == 0) {
        usernameInput += key;
      } else if (currentQuestion == 1) {
        passwordInput += key;
      }
    }
  } else if (!showRecommendations) {
      handleQuestionInput(); //handles when user is typing in question input field
  }
}

//handle input field for questions
void handleQuestionInput() {
    if (keyCode == ENTER) {
    //checks if the current question has an input
    if (userInputs[currentQuestion] == null || userInputs[currentQuestion].trim().isEmpty()) {
      return;  //does not advance if the current input is empty
    }

    //validatse the input based on the current question
    if (currentQuestion == 0 && !isValidDuration(userInputs[currentQuestion])) {
      println("Invalid duration. Please enter a valid number of days (1-365).");
      return;
    } else if (currentQuestion == 1 && !isValidBudget(userInputs[currentQuestion])) {
      println("Invalid budget. Please enter a valid budget.");
      return;
    } else if (currentQuestion == 2 && !isValidClimate(userInputs[currentQuestion])) {
      println("Invalid climate. Please enter 'warm', 'cold', or 'moderate'.");
      return;
    } else if (currentQuestion == 3 && !isValidActivities()) {
      println("Invalid activities. Please enter valid activities separated by commas.");
      return;
    }

    //advances to the next question
    currentQuestion++;

    //once all the questions are answered, it recommends destinations and saves them
    if (currentQuestion >= questions.length) {
      recommendDestination();
      showRecommendations = true;
      for (Destination dest : recommendedDestinations) {
        saveRecommendation(currentUser.username, dest.name); //saves each destination to user's saved recommendations
      }
    }
  } else if (keyCode == BACKSPACE) {
    //handles BACKSPACE for the question input field
    if (userInputs[currentQuestion] != null && userInputs[currentQuestion].length() > 0) {
      userInputs[currentQuestion] = userInputs[currentQuestion].substring(0, userInputs[currentQuestion].length() - 1);
    }
  } else if (keyCode != SHIFT && keyCode != ALT && keyCode != CONTROL && keyCode != TAB && keyCode != DELETE && keyCode != ESC && keyCode != UP && keyCode != DOWN && keyCode != LEFT && keyCode != RIGHT) {
    //handles typing characters into the question input fields
    if (userInputs[currentQuestion] == null) {
      userInputs[currentQuestion] = "";
    }
    userInputs[currentQuestion] += key;
  }
}
