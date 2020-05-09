class Widget //< Bair + Colin > few on Xingchen// //<>// //<>//
{
  int widgetID;
  int xpos;
  int ypos;
  int id;
  int widgetHeight;
  int widgetWidth;
  int arrayPosition;
  int backupid;
  int timer = 0;
  int initialypos;

  String commentText;
  String titleShortened;

  public Story currentStory;
  public Comment currentComment;

  boolean comment = false;
  boolean isSpecialWidget;
  boolean blinkDraw;
  boolean beingHovered = false;
  boolean extended = false;

  color widgetColour;

// Colin + Bair
// initialises all variables with the input values, if the widget is a comment the currentComment is set, if not the currentStory is set

  Widget(int xpos, int ypos, int widgetWidth, int widgetHeight, int id, color widgetColour, boolean searchbar, boolean comment, int arrayPosition)
  {
    this.xpos = xpos;
    this.ypos = ypos;
    this.id = id;
    backupid = this.id;
    this.widgetColour=widgetColour;
    initialypos = ypos;
    this.widgetWidth = widgetWidth;
    this.widgetHeight = widgetHeight;
    this.comment = comment;
    this.arrayPosition = arrayPosition;
    if (comment)currentComment =  reader.getCommentById(id);
    if (!searchbar && !comment) { 
      currentStory = reader.getStoryById(this.id);
      titleShortened = currentStory.getTitle();
    }
    isSpecialWidget = searchbar;
  }

// Colin + Bair
// if the widget is being pressed and its not a comment or the searchbar set the storyTitlePage and set the screen to widget and sets the kids arrayList
// if its a normal widget we assign it the required text and information
// if the widget is a comment we watch for it being pressed and if it is we adjust all lower widgets positions along with extending the widgets size as long as the text is larger than the widgets size
// else we draw the blinking | and await text input

  void draw()
  {
    if (beingHovered && mousePressed && id >-1 && !comment && !scroll.pressed ) {
      try {
        storyTitlePage = reader.getStoryById(id).getTitle();
      } 
      catch(Exception e) {
        storyTitlePage = reader.getStoryById(backupid).getTitle();
      }
      screen = "widget";
      try {
        kids = reader.commentsFromStory(reader.getStoryById(id));
      } 
      catch(Exception e) {
        kids = reader.commentsFromStory(reader.getStoryById(id));
      }
      Story story = reader.getStoryById(id);

      widget = new Screen(reader.getStoryById(id).getKids().size());
      currentScreen = widget;
      if (currentScreen.Widgets.size() > 0)
        screenMap = currentScreen.Widgets.get(currentScreen.Widgets.size() - 1).ypos -680;
    }
    fill(widgetColour);
    rect(xpos, ypos + yOffset, widgetWidth, widgetHeight);
    pushStyle();
    fill(255);
    if (!isSpecialWidget && !comment) {
      textFont(standFont);
      textAlign(LEFT, BOTTOM);
      if (textWidth(currentStory.getTitle()) < widgetWidth)
      {
        text(currentStory.getTitle(), xpos + 8, ypos + 24 + yOffset);
      } else
      {
        if (textWidth(titleShortened) < widgetWidth-8)
        {
          text(titleShortened, xpos + 8, ypos + 24 + yOffset);
        } else
        {
          titleShortened = titleShortened.substring(0, titleShortened.length()-1);
        }
      }
      textFont(titleFont);
      text(reader.getStoryById(id).getScore() + " points        Comments:" + reader.getStoryById(id).getKids().size(), xpos + 10, ypos + 40 + yOffset);
      text("Posted by: " + currentStory.getBy(), xpos + 10, ypos + 56 + yOffset);
      text(currentStory.getDateWestern(), xpos + 10, ypos + 74 + yOffset);
    } else if (comment) {

      try {
        commentText = commentTextFormat(currentComment.getText());
        textAlign(LEFT, TOP);
        text(commentText, xpos +10, ypos + 15 + yOffset);
      } 
      catch(Exception e) {
      }
      textFont(standFont);
      textAlign(LEFT, BOTTOM);
      if (beingHovered && mousePressed && id >-1 && globeWidgetHeight < ceil(currentComment.getText().length() / 100.0) * 20 && !extended  && !scroll.pressed ) {
        widgetHeight = (ceil(currentComment.getText().length() / 100.0) * 20);
        extended = true;
      }
      
      if(extended && timer < 20){
        timer++;
      for (int i = arrayPosition+1; i < currentScreen.Widgets.size(); i++) {
          currentScreen.Widgets.get(i).ypos = round(currentScreen.Widgets.get(i).initialypos + map(timer,0,20, 0,((ceil(currentComment.getText().length() / 100.0) * 20) - globeWidgetHeight)));
          
          if(timer == 20) currentScreen.Widgets.get(i).initialypos = currentScreen.Widgets.get(i).ypos;
        }
      
      }
      if (currentComment != null)
        textFont(titleFont);
    } else {
      textAlign(LEFT, CENTER);
      text(textInput, xpos + 10, ypos + 15 + yOffset);
      if (isOnSearch && millis() - 500 > blinkTime)
      {
        blinkTime = millis();
        if (blinkDraw)  blinkDraw = false;
        else  blinkDraw =true;
      }
    }
    if (blinkDraw)
      line((xpos+12) + textOffset, ypos+ yOffset + 5, (xpos+12) + textOffset, ypos+ yOffset + 25);  
    popStyle();
  }

// Colin
// the input String is converted into a charecter array and is then tested for its length, if the length exceeds checkIndexMax the previous position of checkIndex is set to \n thus breaking the text
// once the array has been finished and all \n's have been added we convert the text back into a string and return it, this operation ensures that all strings are fit onto the widget size and prevents
// text overflow

  String commentTextFormat(String inputText) {
    char[] outputTextArray = inputText.toCharArray();
    int checkIndexMax = 100;
    int checkIndex = 0;
    boolean formatFinished = false;
    while (inputText.length() > checkIndexMax) {
      if (inputText.indexOf(' ', checkIndex) == -1) break;

      while (!formatFinished) {
        if (inputText.indexOf(' ', checkIndex) < checkIndexMax && textWidth(inputText.substring(checkIndexMax-100, inputText.indexOf(' ', checkIndex))) < widgetWidth) {
          checkIndex = inputText.indexOf(' ', checkIndex)+1;
        } else {
          formatFinished = true;
        }
      }
      outputTextArray[inputText.indexOf(' ', checkIndex)] = '\n';
      checkIndexMax += 100;
      formatFinished = false;
    }

    String outputTextString= "";
    if(extended && inputText.indexOf(' ', 400) >0 || inputText.indexOf(' ', 400) < 0){
      for (int stringThing=0; stringThing < inputText.length(); stringThing++) {
        outputTextString += outputTextArray[stringThing];
      }
    } else {
      int i = 0;
      while((outputTextString.length() < inputText.indexOf(' ', 400))){
        outputTextString += outputTextArray[i];
        i++;
      }
    }
    return outputTextString;
  }

  int getID(int mX, int mY) {
    if (mX>xpos && mX < xpos+widgetWidth && mY >ypos+yOffset && mY <ypos+yOffset+widgetHeight) {
      return id;
    }
    return 0;
  }
}
