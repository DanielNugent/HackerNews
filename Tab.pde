// Colin
class Tab {

  color tabColour = widgetColour;
  String screen;
  int xpos, ypos;

// Colin
// initialises xpos,ypos and screen
  
  Tab(int xpos, int ypos, String screen)
  {
    this.xpos = xpos;
    this.ypos = ypos;
    this.screen = screen;
  }

// Colin
// checks for the mouse position and changes the tab colour if it is being hovored
// if being hovored and the mouse is pressed set the currentScreen to screen, reset the yOffset,and set the required screenMap

  void draw() {
    if (mouseX > xpos && mouseX< xpos+tabWidth &&  mouseY > ypos && mouseY < ypos + tabHeight)
      tabColour=hovorColour;
    else   
    tabColour = widgetColour;

    fill(tabColour);
    rect(xpos, ypos, tabWidth, tabHeight);
    fill(255);
    textFont(standFont);
    text(screen.toUpperCase(), xpos + tabWidth*0.5, ypos + tabHeight*0.5);

    if (mouseX > xpos && mouseX< xpos+tabWidth &&  mouseY > ypos && mouseY < ypos + tabHeight && mousePressed) {
      switch(screen) {
      case "search":
        currentScreen = search;
        yOffset = 0;
        if (currentScreen.Widgets.size() > 0)
          screenMap = currentScreen.Widgets.get(currentScreen.Widgets.size() - 1).ypos -680;
        break;
      case "top":
        currentScreen = top;
        yOffset = 0;
          screenMap = currentScreen.Widgets.get(currentScreen.Widgets.size() - 1).ypos -680;
        break;
      case "recent":
        currentScreen = recent;
        yOffset = 0;
          screenMap = currentScreen.Widgets.get(currentScreen.Widgets.size() - 1).ypos -680;
        break;
      case "userSearch":
        currentScreen = userSearch;
        yOffset = 0;
        if (currentScreen.Widgets.size() > 0)
          screenMap = currentScreen.Widgets.get(currentScreen.Widgets.size() - 1).ypos -680;
        break;
      default:
        break;
      }
    }
  }
}
