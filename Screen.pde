// Bair + Colin + Xingchen
//Darragh did the userSearchInfo(), re-did search(), pieChart() and did the draw() method with relation to the userSearch screen with the pie and bar charts.

class Screen
{
  int numberOfWidgets;
  int timer = 0;
  int [] angles = new int[2];

  boolean moreComments=false;

  String headerText;
  String screenName;

  ArrayList<Story> stories = reader.getStories();
  ArrayList<Widget> Widgets = new ArrayList<Widget>();
  ArrayList<Object> resultIds = new ArrayList<Object>();


// Colin 
// initialises all required variables with the input values
// checks the screen and builds the Widgets arrayList accordingly
// all unique text/features are created here also 

  Screen(int numberOfWidgets) {

    this.numberOfWidgets = numberOfWidgets;
    screenName = screen;
    switch(screen) { 

    case "userSearch":
      fill(widgetColour);
      searchbar = new Widget(50, 170, globeWidgetWide, 30, -1, color(51), true, false,0);
      Widgets.add(searchbar);
      break;
    case "widget":
      textAlign(CENTER, CENTER);
      fill(255);
      text(storyTitlePage, SCREENX/2, 190);
      textAlign(LEFT, CENTER);
      int skippedComments = 0;
      for (int widgetIncriment = 0; widgetIncriment < kids.size(); widgetIncriment ++)
      {
          if (kids.get(widgetIncriment).getId() <= 1000) {
            newWidget = new Widget(50, 180 + (widgetIncriment-skippedComments) * (globeWidgetHeight+15), globeWidgetWide, globeWidgetHeight+2, kids.get(widgetIncriment).getId(), color(51), false, true,widgetIncriment-skippedComments);
            Widgets.add(newWidget);
          } else {
            skippedComments++;
          }
      }
      break;
    case "title":
      for (int widgetIncriment = 1; widgetIncriment < numberOfWidgets; widgetIncriment ++) {
        if (widgetIncriment % 2  != 1) {
          newWidget = new Widget(70+ (globeWidgetWidth), 170 + ((widgetIncriment-1)/2) * (globeWidgetHeight+5), globeWidgetWidth, globeWidgetHeight, widgetIncriment, color(51), false, false,0);
          Widgets.add(newWidget);
        } else {
          newWidget = new Widget(50, 170 + (widgetIncriment/2) * (globeWidgetHeight+5), globeWidgetWidth, globeWidgetHeight, widgetIncriment, color(51), false, false,0);
          Widgets.add(newWidget);
        }
      }
      break;
    case "search":
      fill(widgetColour);
      searchbar = new Widget(50, 170, globeWidgetWide, 30, -1, color(51), true, false,0);
      Widgets.add(searchbar);
      break;
    case "recent":
      ArrayList<Story> recentStories = reader.mostRecentStories(numberOfWidgets);
      for (int widgetIncriment = 0; widgetIncriment < numberOfWidgets; widgetIncriment ++)
      {
        newWidget = new Widget(50, 170 + widgetIncriment * (globeWidgetHeight+15), globeWidgetWide, globeWidgetHeight, recentStories.get(widgetIncriment).id, color(51), false, false,0);
        Widgets.add(newWidget);
      }
      break;
    case "top":
      for (int widgetIncriment = 0; widgetIncriment < numberOfWidgets; widgetIncriment ++)
      {
        newWidget = new Widget(50, 170 + widgetIncriment * (globeWidgetHeight+15), globeWidgetWide, globeWidgetHeight, reader.highestStoryScores(numberOfWidgets).get(widgetIncriment).getId(), color(51), false, false,0);
        Widgets.add(newWidget);
      }
      break;
    }
  }

// Colin (minorly)
// queries the reader for data based on the input text and sets all required variables
// decides if the moreComments boolean is positive or negative

  void userInfoSearch() {
    // sets all required values and finds the story average from 2001 - 2010


    user=textInput;

    userHighestPoints = reader.getUsersHighestPoints(textInput);

    numberOfStories2006 = reader.getNumberOfStoriesByUserInYear(textInput, 2006);
    numberOfStories2007 = reader.getNumberOfStoriesByUserInYear(textInput, 2007);

    numberOfComments2006 = reader.getNumberOfCommentsByUserInYear(textInput, 2006);
    numberOfComments2007 = reader.getNumberOfCommentsByUserInYear(textInput, 2007);

    totalCommentsPosted = reader.getNumberOfCommentsByUser(textInput);
    totalStoriesPosted = reader.getNumberOfStoriesByUser(textInput);

    if (totalCommentsPosted>totalStoriesPosted) {

      double tempNumber = ((double)totalStoriesPosted/(double)totalCommentsPosted)*360;

      angles[0]= (int) Math.round(tempNumber);
      angles[1]= 360-angles[0];
      moreComments=true;
    } else if (totalCommentsPosted<totalStoriesPosted) {


      double tempNumber = ((double)totalCommentsPosted/(double)totalStoriesPosted)*360;

      angles[0]= (int) Math.round(tempNumber);
      angles[1]= 360-angles[0];
      moreComments=false;
    }

    graphDraw = true;
    timer = 0;
  }   

  void search()
  {
    boolean toSearchAuthor = true;
    boolean toSearchTitle = true;
    int resultsPrint = -1;
    for (int i = 0; i < stories.size(); i++)
    {

      if (stories.get(i).searchForTitle(textInput) && toSearchTitle)
      {
        toSearchAuthor = false;
        resultsPrint++;
        resultWidget = new Widget(50, 220 + resultsPrint * (globeWidgetHeight+15), globeWidgetWide, globeWidgetHeight, stories.get(i).id, color(51), false, false,0);
        resultIds.add(resultWidget);
      }
      if (stories.get(i).searchForAuthor(textInput) && toSearchAuthor) {
        toSearchTitle = false;
        resultsPrint++;
        resultWidget = new Widget(50, 220 + resultsPrint * (globeWidgetHeight+15), globeWidgetWide, globeWidgetHeight, stories.get(i).id, color(51), false, false,0);
        resultIds.add(resultWidget);
      }

      if (resultIds.size()<2) {

        if (stories.get(i).searchByID(textInput) || stories.get(i).searchByPoints(textInput)) {
          resultsPrint++;
          resultWidget = new Widget(50, 220 + resultsPrint * (globeWidgetHeight+15), globeWidgetWide, globeWidgetHeight, stories.get(i).id, color(51), false, false,0);
          resultIds.add(resultWidget);
        }
      }
    }
    while (Widgets.size() > 1) {
      Widgets.remove(Widgets.size()-1);
    }
    for (int arrayListCopy = 0; arrayListCopy < resultIds.size(); arrayListCopy++) {
      Widgets.add((Widget) resultIds.get(arrayListCopy));
    }
    screenMap = currentScreen.Widgets.get(currentScreen.Widgets.size() - 1).ypos -680;
  }

// Colin
// checks for scrollDirection and updates upRdown accordingly
// moves all widgets, draws all widgets and resets scrollDirection
// if required draws the scroll bar, draws all tabs
// if the current screen is widget draw the story title and dynamically updates the screenMap variable
// if current screen is userSearch 
 
  void draw()
  {   
    fill(widgetColour);
    stroke(255);
    rect(30, 150, headerWidth, 630);

    widgetMovement = false;

    if (scrollDirection > 0 && Widgets.get(Widgets.size() -1).ypos > 770-globeWidgetHeight) { 
      upRdown = -20; 
      widgetMovement = true;
    } else if (scrollDirection < 0 && Widgets.get(0).ypos <= 160) {
      upRdown= +20; 
      widgetMovement = true;
    }

    if (widgetMovement) widgetMove(currentScreen);
    for (int widgetPrintCount = 0; widgetPrintCount < Widgets.size(); widgetPrintCount++) Widgets.get(widgetPrintCount).draw();
    if (scrollDirection != 0) scrollDirection = 0;

    fill(backgroundColour);
    noStroke();
    rect(0, 0, SCREENX, 150);
    rect(0, SCREENY-19, SCREENX, 20);
    fill(widgetColour);
    stroke(240);
    fill(widgetColour);
    if (Widgets.size() > 0) {
      if (Widgets.get(Widgets.size()-1).ypos + globeWidgetHeight > SCREENY-20 || Widgets.get(0).ypos < 170)
        scroll.draw();
    }
    for (int tabPrintCount = 0; tabPrintCount < Tabs.size(); tabPrintCount++) Tabs.get(tabPrintCount).draw();  

    if (currentScreen == widget) {
      Story currentStory = reader.getTitle(storyTitlePage);
      headerText =currentStory.getTitle(); 
    
      if(currentScreen.Widgets.size() > 0)
        screenMap = currentScreen.Widgets.get(currentScreen.Widgets.size()-1).ypos -680;
      else {
        textAlign(CENTER,CENTER);
        text("No Comments Found!",SCREENX/2,210);
      }
      fill(widgetColour);
      rect(SCREENX/2 - textWidth(headerText)/2.0 - 5, 130, textWidth(headerText)+10, 20);
      fill(255);
      textAlign(CENTER,CENTER);
      text(headerText, SCREENX/2, 140);
    }
    if (currentScreen==userSearch) {
      fill(240);
      // writes the underlying text

      textAlign(LEFT, CENTER);


      text("Total comments posted: " + (int) totalCommentsPosted, 60, 240);
      text("Total stories posted: " + (int) totalStoriesPosted, 60, 260);
      text("User's highest score on a story: " + (int) userHighestPoints, 60, 280);

      text("Stories in", 350, SCREENY-70);
      text("2006:" + " " + (int) numberOfStories2006, 350, SCREENY-55);

      text("Stories in", 350 + (SCREENX-100)*0.15, SCREENY-70);
      text("2007:" + " " + (int) numberOfStories2007, 350 + (SCREENX-100)*0.15, SCREENY-55);

      text("Comments in", 350 + (SCREENX-100)*0.30, SCREENY-70);
      text("2006:" + " " + (int) numberOfComments2006, 350 + (SCREENX-100)*0.30, SCREENY-55);

      text("Comments in", 350 + (SCREENX-100)*0.45, SCREENY-70);
      text("2007:" + " " + (int) numberOfComments2007, 350 + (SCREENX-100)*0.45, SCREENY-55);
      // controls the timer
      if (graphDraw) timer++;
      if (timer >= 100) graphDraw = false;

      // draws the bars in with their changing height values , uses map to make all animations take the same amount of time

      storiesMap2006 = map(timer, 0, 100, 0, (numberOfStories2006>150) ? 300 : numberOfStories2006*2);
      rect(350, SCREENY-80 - storiesMap2006, 80, storiesMap2006);
      storiesMap2007 = map(timer, 0, 100, 0, (numberOfStories2007>150) ? 300 : numberOfStories2007*2);
      rect(350 + (SCREENX-100)*0.15, SCREENY-80 - storiesMap2007, 80, storiesMap2007);
      commentsMap2006 = map(timer, 0, 100, 0, (numberOfComments2006>150) ? 300 : numberOfComments2006*2);
      rect(350 + (SCREENX-100)*0.3, SCREENY-80 - commentsMap2006, 80, commentsMap2006);
      commentsMap2007 = map(timer, 0, 100, 0, (numberOfComments2007>150) ? 300 : numberOfComments2007*2);
      rect(350 + (SCREENX-100)*0.45, SCREENY-80 - commentsMap2007, 80, commentsMap2007);

      // draws a pie chart


      if (angles.length!=0) {
        pieChart(200, angles);
      }

      noFill();
      stroke(255);
      rect(340, 400, 415, 365);
      rect(330, 400, -285, 365);
    }
  }

  void pieChart(float diameter, int[] data) {
    float lastAngle = 0;
    noStroke();
    for (int i = 0; i < data.length; i++) {

      if (moreComments) {
        if (i==0) fill(100);
        if (i==1) fill(150);
      } else {
        if (i==0) fill(150);
        if (i==1) fill(100);
      }
      arc(85+(diameter/2), (SCREENY-140)-(diameter/2), diameter, diameter, lastAngle, lastAngle+radians(data[i]));
      lastAngle += radians(data[i]);
    }

    fill(240);
    text("Stories", 110, SCREENY-70);
    text("Comments", 190, SCREENY-70);
    fill(100);
    rect(95, SCREENY-80, 10, 20);
    fill(150);
    rect(175, SCREENY-80, 10, 20);
  }

// Colin
// moves each widget by the required amount thus scrolling

  void widgetMove(Screen scr) {

    for (int widgetMoveCount = 0; widgetMoveCount<scr.Widgets.size(); widgetMoveCount++) {
      scr.Widgets.get(widgetMoveCount).ypos += upRdown;
    }
  }
}    
