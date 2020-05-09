// Everyone
void settings()
{
  size(SCREENX, SCREENY);
}

// Colin + Bair
// initialises all required objects, sets the lastWidgetOnScreen Widget and begins the thread "myThread"

void setup()
{
  titleFont =  loadFont("MicrosoftJhengHeiLight-14.vlw");// we have to use this font
  standFont = loadFont("Arial-BoldMT-14.vlw");// othter font didn't fit
  standardFont = loadFont("Dialog.plain-13.vlw");
  img = loadImage("hex stories.jpg");
  reader = new DataReader("newsFile.json");
  scroll = new ScrollBar(SCREENX-37.5, 160);
  background(backgroundColour);
  smooth();
  noStroke();
  loaded = false;
  thread("myThread");
  if (currentScreen != null)
    lastWidgetOnScreen = currentScreen.Widgets.get(currentScreen.Widgets.size() - 1);
}

//  Bair
//  Adds each key typed into a string and removes characters with backspace
void keyTyped()
{

  if (currentScreen==search || currentScreen==userSearch) {

    if (isOnSearch)
    {
      if (key == BACKSPACE || key == DELETE)
      {
        if (textInput.length() > 0)
        {
          textInput = textInput.substring(0, textInput.length()-1);
        }
      } else if (key == ENTER || key == RETURN)
      {
        if (currentScreen==search) {
          currentScreen.search();
        } else if (currentScreen==userSearch) {
          currentScreen.userInfoSearch();
        }
      } else
      {
        textInput += key;
      }
      textOffset = 1;
      for (int i = 0; i < textInput.length(); i++)
      {
        textOffset += textWidth(textInput.toCharArray()[i]);
      }
    }
  }
}

// Colin (minorly) + Bair (minorly)
// waits until the loaded boolean is true, then draws the currentScreen
// if the screen is not search or userSearch reset the text input and reinitialise the searchbar
// checks if a widget is being hovered over, if so it changes its colour

void draw()
{
  if (loaded) {
    background(backgroundColour);
    currentScreen.draw();
    rect(30, 20, 740, 70);
    fill(255);
    textAlign(CENTER, CENTER);
    image(img, 31, 21);
    fill(255);
    rect(30, 150, 740, 0.7);
    rect(30, 780, 740, 0.7);
  }
  else{
    background(51);
    translate(width/2,height/2);
    fill(0);
    textSize(20);
    fill(255);
    text("Loading...", -55, 115);
    textSize(12);
    for(int i=0;i<n;i++){
      cur[i]=(float)(count[i]-i*delta)/spd;
      ellipse(R*cos(cur[i])-10,R*sin(cur[i])+10,d,d); 
      fill(255);
      if(((int)(cur[i]/PI))%2==0){
        count[i]++;
      }
      else{
        count[i]+=10;
      }
    }
  }
  if (mouseX > 30 && mouseX < 770 && mouseY > 20 && mouseY < 90)
  {
    cursor(HAND);
  } else
  {
    cursor(ARROW);
  }
  try {
    if (currentScreen!=search && currentScreen != userSearch) {

      textInput = "";
      searchbar = new Widget(50, 170, globeWidgetWide, 30, -1, color(51), true, false, 0);
      screen = "search";
      search = new Screen(0);
      screen = "userSearch";
      userSearch = new Screen(0);
      textOffset = 1;
    }
  } 
  catch(Exception e) {
  }

  int event;
  if (currentScreen != null) {
    if (currentScreen.Widgets!=null) {
      for (int i = 0; i<currentScreen.Widgets.size(); i++) {
        Widget aWidget = (Widget) currentScreen.Widgets.get(i);
        event = aWidget.getID(mouseX, mouseY);
        if (event != 0) {
          aWidget.widgetColour=color(100, 200, 300);
          aWidget.beingHovered =true;
        } else {
          aWidget.beingHovered =false;
          aWidget.widgetColour=color(51);
        }
      }
    }
  }
}

// Colin
// checks the mouse wheel and moves all widgets accordingly stopping if the first or last widget is drawn entirely on screen

void mouseWheel(MouseEvent event) {
  if (currentScreen.Widgets.size() > 0) {
    if (yOffset + (event.getCount()*-1)*7 < 0  
      && currentScreen.Widgets.get(currentScreen.Widgets.size() - 1).ypos + globeWidgetHeight + yOffset + ((event.getCount()*-1)*7) > SCREENY-40 ) 
      yOffset += (event.getCount()*-1)*7;
  }
}

// Colin + Bair (minorly)
// used to detect the mouse being pressed on the banner thus changing the screen to title
// also checks for if the search bar is activated
// Bair: changed to mouseClicked from mousePressed

void mouseClicked() {
  if (mouseX > 30 && mouseX < 30 + headerWidth && mouseY > 20 && mouseY < 20 + headerHeight)
  {
    yOffset = 0;
    currentScreen = title;
    for (int incriment = 0; incriment < currentScreen.Widgets.size(); incriment++) {
      currentScreen.Widgets.get(incriment).beingHovered = false;
    }
  }
  int event;
  if (currentScreen.Widgets!=null) {
    for (int i = 0; i<currentScreen.Widgets.size(); i++) {
      Widget aWidget = (Widget) currentScreen.Widgets.get(i);
      event = aWidget.getID(mouseX, mouseY);
      switch(event) {
      case -1:
        isOnSearch = true;
        break;
      default:
        isOnSearch = false;
      }
    }
  }
}

// Colin
// initialises all screens and tabs while data is loading

void myThread() {  
  count=new long[n];
  cur=new float[n];
  for (int i=0; i<n; i++) {
    count[i]=0;
    cur[i]=0.0;
  }
  screen = "title";
  title = new Screen(15);
  screen = "search";
  Tab1= new Tab(30, 90, screen);
  search = new Screen(1);
  screen = "recent";
  Tab3= new Tab(30+tabWidth*2, 90, screen);
  recent = new Screen(11);
  screen = "top";
  Tab2= new Tab(30+tabWidth, 90, screen);
  top = new Screen(11);
  screen = "userSearch";
  Tab4= new Tab(30+tabWidth*3, 90, screen);
  userSearch = new Screen(0);
  Tabs.add(Tab1);
  Tabs.add(Tab2);
  Tabs.add(Tab3);
  Tabs.add(Tab4);
  delay(500);
  currentScreen = title;
  loaded = true;
  return;
}
