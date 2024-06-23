/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void backButton_click1(GButton source, GEvent event) { //_CODE_:backButton1:397388:
  currentUser = null;
  showRecommendations = false;
  showUserRecommendations = false;
  currentQuestion = 0;
  Arrays.fill(userInputs, null);
  usernameInput = "";
  passwordInput = "";
  registrationMessage = "";
  println("button1 - GButton >> GEvent." + event + " @ " + millis());

} //_CODE_:backButton1:397388:

public void button2_click1(GButton source, GEvent event) { //_CODE_:backButton2:968307:
    if (showRecommendations) {
    showRecommendations = false;
    resetQuestions();
  } else if (showUserRecommendations) {
    showUserRecommendations = false;
  }


  println("backButton2 - GButton >> GEvent." + event + " @ " + millis());
} //_CODE_:backButton2:968307:

public void slider1_change1(GSlider source, GEvent event) { //_CODE_:slider1:358523:
  numDest = slider1.getValueF();
  println("slider1 - GSlider >> GEvent." + event + " @ " + millis());
} //_CODE_:slider1:358523:

public void desti_change1(GTextField source, GEvent event) { //_CODE_:desti:774704
  //if (event == GEvent.ENTERED) {
  //  String enteredText = desti.getText().trim();
  //  if (!enteredText.isEmpty() && currentUser != null) {
  //    for (Destination d : recommendedDestinations) {
  //      if (d.name.equalsIgnoreCase(enteredText)) {
  //        currentUser.addDestination(d);
  //        saveUsers();
  //        desti.setText("");  // Clear the text field after saving the destination
  //        break;
  //      }
  //    }
  //  }
  //}
  if (event == GEvent.ENTERED || event == GEvent.LOST_FOCUS) {
    String input = desti.getText();
    saveSpecifiedRecommendations(input);
    desti.setText(""); // Clear the text field after saving recommendations
  }
  println("desti - GTextField >> GEvent." + event + " @ " + millis());
} //_CODE_:desti:774704:


// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  surface.setTitle("Sketch Window");
  backButton1 = new GButton(this, 40, 651, 94, 33);
  backButton1.setText("Switch User / Logout");
  backButton1.addEventHandler(this, "backButton_click1");
  backButton2 = new GButton(this, 157, 651, 80, 30);
  backButton2.setText("Recomend Destination");
  backButton2.addEventHandler(this, "button2_click1");
  slider1 = new GSlider(this, 83, 370, 100, 40, 10.0);
  slider1.setShowValue(true);
  slider1.setLimits(2.0, 1.0, 5.0);
  slider1.setShowTicks(true);
  slider1.setNumberFormat(G4P.DECIMAL, 1);
  slider1.setOpaque(true);
  slider1.addEventHandler(this, "slider1_change1");
  desti = new GTextField(this, 873, 321, 260, 30, G4P.SCROLLBARS_NONE);
  desti.setPromptText("Enter the destinations you would like to save");
  desti.setOpaque(true);
  desti.addEventHandler(this, "desti_change1");
}

// Variable declarations 
// autogenerated do not edit
GButton backButton1; 
GButton backButton2; 
GSlider slider1; 
GTextField desti; 
