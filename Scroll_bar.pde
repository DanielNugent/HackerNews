// Colin
class ScrollBar {
  float xpos, ypos, scrollOffset;
  boolean pressed;
  color colour;
  
  // Colin
  // initialises the xpos and ypos and colour of the scrollbar
  
  ScrollBar(float xpos, float ypos) {
    this.xpos = xpos;
    this.ypos = ypos;
    colour = widgetColour;
  }
  
 // Colin
 // detects if the scroll bar is being interacted with by the mouse

  void draw() {
    fill(colour);
    scrollOffset = map(yOffset, 0, -screenMap, 0, -575);
    rect(xpos, ypos - scrollOffset, 15, 30);
    if (yOffset>0)
      yOffset = 0;

    if (mouseX > xpos && mouseX < xpos+15 && mousePressed) {
      pressed = true; 
      colour = widgetPressedColour;
     // println(colour + "colour");
      move();
    } else if (pressed && mousePressed) {
      pressed = true;
      colour = widgetPressedColour;
      println(colour + "colour");
      move();
    } else {
      colour = widgetColour;
      scroll.pressed = false;
    }
  }

// Colin
// moves all widgets in unison by changing yOffset

  void move() {
    if (pressed && mouseY < SCREENY-60 && mouseY> 175) {
      scrollOffset = -1*(mouseY - 15) + ypos;
      yOffset = scrollOffset*(screenMap/575.0);
    } else if (pressed && mouseY > SCREENY-40) {
      yOffset = -screenMap;
      scrollOffset =  map(yOffset, 0, -screenMap, 0, -575) ;
    } else if (pressed && mouseY < ypos+15) {
      scrollOffset = 0;
      yOffset = scrollOffset;
    }
  }
}
