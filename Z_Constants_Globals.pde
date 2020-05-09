//Everyone
int widgetPressed = 0;
int SCREENX = 800;
int SCREENY = 800;
int headerWidth = 740;
int headerHeight = 70;
int tabWidth = 185;
int tabHeight = 30;
int globeWidgetHeight = 80;
int globeWidgetWidth = 340;
int globeWidgetWide = 700;
int upRdown = 5;
int searchbarID=-1;
int textOffset, screenMap, blinkTime;
int n = 5;
int totalCommentsPosted=0;
int totalStoriesPosted=0;
int numberOfStories2006=0;
int numberOfStories2007=0;
int numberOfComments2006=0;
int numberOfComments2007=0;
int lastActivity=0;

String storyTitlePage = "";
String textInput = "";
String screen = "search";
String numberOfComments = "Number of Comments.";
String numberOfStories = "Number of Stories.";
String points = "Highest Points Achieved";
String userStoriesAverage = "Average Stories Per Year.";
String user="";

float scrollDirection;
float yOffset = 0;
float R=width/3.0, d=7, spd=25.0, delta=PI/(float)(n+1)*spd;
float [] cur;
float numberOfCommentsGraph = 1;
float numberOfStoriesGraph = 1;
float pointsGraph = 1;
float userStoriesAverageGraph = 1;
float currentTime; 
float storiesMap2006;
float storiesMap2007;
float commentsMap2006;
float commentsMap2007;
float userHighestPoints=0;

boolean widgetMovement, isOnSearch;
boolean loaded = false;
boolean graphDraw = false;

PImage img;

PFont standFont;
PFont headFont;
PFont detailFont;
PFont titleFont;
PFont standardFont;

color backgroundColour = color(51);
color widgetColour = color(51);
color widgetPressedColour = color(0, 102, 204);
color hovorColour = color(100, 200, 300);

Widget newWidget, currentWidget, searchbar, resultWidget, theWidget, lastWidgetOnScreen;

Screen title, search, top, recent, userSearch, currentScreen, widget;

Tab Tab1, Tab2, Tab3, Tab4;

import java.util.*;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.nio.charset.Charset;
import java.nio.file.*;
import java.text.*;
import java.time.LocalDate; 
import org.jsoup.Jsoup;

ScrollBar scroll;
DataReader reader;
Story story;
long [] count;

ArrayList<Tab> Tabs = new ArrayList<Tab>();
ArrayList<Comment> kids = new ArrayList<Comment>();
