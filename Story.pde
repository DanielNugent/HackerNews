/* Daniel did the main part of the class, Darragh did all the methods relating to searching for stories and users and returning queries, i.e. searchByAuthor(), searchByTitle, searchByID() and searchByPoints()
 constructor: Story(JSONArray kids, int descendants, String url, String title, String by, int score, int time, int id)
 method interface: (1-10)  written by Daniel
 1. int getTitle() : returns title of the story
 2. int getDescendants() : returns the number of descendants of the story (can be inaccurate)
 3. String getUrl() : return the url of the story in a string 
 4. int getTime() : returns seconds elapsed since 1970
 5. int getId() : returns Id
 6. String getScore() : returns the score of the story
 7. String getBy() : returns who the story is by
 8. ArrayList<Integer> getKids() : returns the kids of the comment in an arraylist
 9. String getDate() : returns the date of the story in an HH-MM-SS dd-MM-yyyy format , ie: 17:03:22 03-10-2003
 
 */
class Story {
  JSONArray kids;
  private int descendants;
  private ArrayList<Integer> kidInts = new ArrayList<Integer>();
  private String url;
  private String title;
  private String by;
  private int score;
  private int time;
  private int id;

  
  
  Story(ArrayList<Integer> kidInts, int descendants, String url, String title, String by, int score, int time, int id) {
    this.kidInts = kidInts;
    this.descendants = descendants;
    this.url = url;
    this.title = title;
    this.by = by;
    this.score = score;
    this.time = time;
    this.id = id;
  }
  public String getTitle() {
    return title;
  }

  public int getDescendants() {
    return descendants;
  }
  public int getTime() {
    return time;
  }
  public int getScore() {
    return score;
  }
  public int getId() {
    return id;
  }
  public String getUrl() {
    return url;
  }
  public String getBy() {
    return by;
  }
  public ArrayList<Integer> getKids() {   
    return kidInts;
  }


  public String getDateSimple() {
    java.util.Date date = new java.util.Date(getTime()*1000L); 
    SimpleDateFormat jdf = new SimpleDateFormat("yyyy-MM-dd");
    String javaDate = jdf.format(date);
    return javaDate;
  }
  public String getDate() {
    java.util.Date date = new java.util.Date(getTime()*1000L); 
    SimpleDateFormat jdf = new SimpleDateFormat("hh:mm:ss dd-MM-yyyy");
    String javaDate = jdf.format(date);
    return javaDate;
  }
  public LocalDate getDate1() {
    LocalDate date = LocalDate.parse(getDateSimple());
    return date;
  }

  public int getYear() {
    String year = "";
    String tempDate = getDateSimple();
    char[] yearArray = tempDate.toCharArray();

    for (int i=0; i<4; i++) {
      year += yearArray[i];
    }
    return Integer.parseInt(year);
  }

  public String getDateWestern() { //western date format ie day-month-year
    java.util.Date date = new java.util.Date(getTime() * 1000L);
    SimpleDateFormat jdf = new SimpleDateFormat("dd-MM-yyyy");
    String javaDate = jdf.format(date);
    return javaDate;
  }
  //public void goToUrl(){
  //  link(getUrl());
  //}

  //below is Darragh
  public boolean searchForTitle(String userInput) {

    // allows stories to be returned if the userInput is a title without spacing

    if (userInput.toLowerCase().replaceAll("\\s", "").equals(title.toLowerCase().replaceAll("\\s", ""))) {
      return true;
    }

    // checks if the any or multiple word(s) in a story title matches userInput

    String firstWord="";
    int wordCounter=0;

    //checks number of spaces (words) in user input
    for (int x=0; x<userInput.length(); x++) {
      if (userInput.charAt(x) == (' ')) wordCounter++;
    }

    for (int i=0; i<title.length(); i++) {

      firstWord += title.charAt(i);

      if (firstWord.toLowerCase().equals(userInput.toLowerCase())) {
        return true;
      }

      if (title.charAt(i) == ' ') {
        if (wordCounter==0) firstWord="";
        wordCounter--;
      }
    }





    return false;
  }

  public boolean searchForAuthor(String userInput) {

    // allows stories to be returned if the userInput is an author without spacing

    if (userInput.toLowerCase().replaceAll("\\s", "").equals(by.toLowerCase().replaceAll("\\s", ""))) {
      return true;
    }

    //allows a story to be returned if the authors first four letters were inputted
    int wordCounter=0;
    for (int x=0; x<userInput.length(); x++) {
      if (userInput.charAt(x) == (' ')) wordCounter++;
    }

    if (wordCounter==0) {
      String byAbbreviation="";
      String userInputAbbreviation="";

      int sizeOfBy=by.length();
      if (sizeOfBy>4) sizeOfBy=4;
      if (sizeOfBy>userInput.length()) sizeOfBy=userInput.length();

      for (int i=0; i<sizeOfBy; i++) {

        byAbbreviation += by.charAt(i);
        userInputAbbreviation += userInput.charAt(i);
      }

      if (byAbbreviation.toLowerCase().replaceAll("\\s", "").equals(userInputAbbreviation.toLowerCase().replaceAll("\\s", ""))) {
        return true;
      }
    } 
    return false;
  }

  public boolean searchByID(String userInput) {

    String lookingForID="";

    if (userInput.length() > 7) {
      for (int i=0; i<3; i++) {

        lookingForID+= userInput.charAt(i);
      }
    }

    if (lookingForID.equalsIgnoreCase("id:")) {

      userInput = userInput.replace("id:", "");

      if (Integer.parseInt(userInput)==id) {
        return true;
      }
    }

    return false;
  }

  public boolean searchByPoints(String userInput) {  
    String lookingForPoints="";

    for (int i=0; i<7; i++) {
      if (i >= userInput.length()) //without this program broke
        break;
      lookingForPoints+= userInput.charAt(i);
    }


    if (lookingForPoints.equalsIgnoreCase("points:")) {

      userInput = userInput.replace("points:", "");

      if (Integer.parseInt(userInput)==score) {
        return true;
      }
    }

    return false;
  }
}
