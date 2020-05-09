/*dataReader Daniel for queries  + Darragh for bar chart methods (bottom five methods)
 constructor takes path of file as String parameter
 dataReader(String path)
 Method interface: (Daniel : (1-15 methods))
 1. Story highestScore() : returns Story object with highestScore
 2. Story getTitle(String title) : returns story object with specified title, if doesnt exist returns null
 3. ArrayList<Story> highestStoryScores(int n) : returns ArrayList of the n most popular stories by score
 4. ArrayList<Story> mostRecentStories(int n) : returns the n most recent stories in an arraylist
 5. ArrayList<Story> getStoriesByAuthor(String author) : returns arraylist of stories by a certain author in order on recentness
 6. ArrayList<Comment> getCommentsByAuthor(String author) : returns arraylist of comments by a certain author
 7. ArrayList<Comment> CommentsFromStory(Story aStory) : returns arraylist of comments associated with a story
 8. ArrayList<Comment> CommentsFromComment(Comment aComment) : returns arraylist of comments associated with a comment
 9. Story getStoryById(int n) : returns if possible a story associated with a certain ID
 10. Comment getCommentByParent(int n) : returns if possible a comment associated with a certain parent
 11. Story getStory(int n) : returns story with an index in stories arraylist
 12. Comment getComment(int n) : returns comment with an index in comments arraylist
 13. ArrayList<Story> getStories() : returns arraylist of all the stories
 14. ArrayList<Commment> getComments() : returns arraylist of all the comments
 15. ArrayList<Story> mostCommented(int n) : returns arraylist of most commented stories */
class DataReader {
  private ArrayList<Story> stories = new ArrayList<Story>();
  private ArrayList<Comment> comments = new ArrayList<Comment>();
  private int nOfComments = 0;
  private int nOfStories = 0;
  private JSONObject json;
  private JSONArray values;
  private Story story;
  private Comment comment;
  private String type;
  private int descendants;
  private String url;
  private String title;
  private String by;
  private String text;
  private int score;
  private int time;
  private int id;
  private int parent;
  private JSONArray kids;
  private ArrayList<Integer> kidIDs = new ArrayList<Integer>();
  DataBaseAc dataBase;
  DataReader(String path) {
    dataBase =  new DataBaseAc();
    if (dataBase.toSetup) {
      String lines[] = loadStrings(path); // "newsFile.json"
      for (int i = 0; i < lines.length; i++) {
        if (isValidLine(lines[i])) {
          json = parseJSONObject(lines[i]);
          type = json.getString("type");
          ArrayList<Integer> kidInts = new ArrayList<Integer>();
          switch (type) {
          case "story":
            if (isValidLineStory(lines[i])) {
              descendants = json.getInt("descendants");
              url = json.getString("url");
              title = json.getString("title");
              score = json.getInt("score");
              by = json.getString("by");
              time = json.getInt("time");
              id = json.getInt("id");
              kids = json.getJSONArray("kids"); // [22, 24, 35]
              for (int x = 0; x < kids.size(); x++) {      
                kidInts.add(kids.getInt(x));
              }
            } else
              break;
            title = title.replace("'", "\"");
            url = url.replace("'", "\"");
            story = new Story(kidInts, descendants, url, title, by, score, time, id);   
            dataBase.addStory(url, title, score, id, descendants, by, time, kids.toString()); // descendants, author, time, kids

          case "comment":
            if (isValidLineComment(lines[i])) {
              parent = json.getInt("parent");
              text = json.getString("text");
              time = json.getInt("time");
              id = json.getInt("id");
              by = json.getString("by");
              kids = json.getJSONArray("kids"); // [22, 24, 35]
              for (int x = 0; x < kids.size(); x++) {      
                kidInts.add(kids.getInt(x));
              }
            } else
              break;
            text = text.replace("'", "\"");            
            text = text.replace("<p>", "\n\n");
            text = text.replace("<a", "");
            text = text.replace("</a>", "");
            comment = new Comment(kidInts, parent, text, by, time, id);            
            dataBase.addComment(by, text, time, id, parent, kids.toString()); //comment out after first time setup
          }
        }
      }
    }
  }

  public boolean isValidLineComment(String line) {

    if (line.contains("\"parent\":") && line.contains("\"text\":") && line.contains("\"time\":")
      && line.contains("\"id\":") && line.contains("\"by\":") && line.contains("\"kids\":")) {

      return true;
    }

    return false;
  }

  public boolean isValidLineStory(String line) {
    JSONObject temp = null;
    if (line.contains("\"url\":") && line.contains("\"descendants\":") && line.contains("\"title\":")
      && line.contains("\"score\":") && line.contains("\"by\":") && line.contains("\"time\":")
      && line.contains("\"id\":") && line.contains("\"kids\":"))
      return true;
    return false;
  }


  public Story getTitle(String title) {
      return dataBase.getStoryByTitle(title);
  }

  public boolean isValidLine(String line) {
    int count = 0;
    for (char c : line.toCharArray()) {
      if (c == '{')
        count++;
    }
    if (count == 1 && line.contains("\"type\":"))
      return true;

    return false;
  }

  public ArrayList<Story> mostRecentStories(int n) {
    ArrayList<Story> recentStories = new ArrayList<Story>();
    ArrayList<Integer> recentStoryIds = dataBase.recentStoryIds(n);  
    for (int i = 0; i < recentStoryIds.size(); i++) {
      recentStories.add(getStoryById(recentStoryIds.get(i)));
    }

    return recentStories;
  }

  public ArrayList<Story> highestStoryScores(int n) {

    ArrayList<Story> highestScores = new ArrayList<Story>();
    ArrayList<Integer> highestStoryIds = dataBase.highestStoryIds(n);  
    for (int i = 0; i < highestStoryIds.size(); i++) {
      highestScores.add(getStoryById(highestStoryIds.get(i)));
    }

    return highestScores;
  }

  public ArrayList<Story> getStories() { // n is index
    return dataBase.getStories();
  }

  public ArrayList<Comment> getComments() { // n is index
    return dataBase.getComments();
  }

  public Story getStoryById(int n) { // n is index
    return dataBase.getStoryById(n);
  }
  
   public Comment getCommentById(int n) { // n is index
    return dataBase.getCommentById(n);
  }

  public Comment getCommentByParent(int n) {
    return dataBase.getCommentByParent(n);
  }

  public ArrayList<Comment> getCommentsByAuthor(String author) { // returns arraylist of comments by a certain
    return dataBase.getCommentsByAuthor(author);
  }

  public ArrayList<Story> getStoriesByAuthor(String author) { // returns arraylist of stories by a certain author
    return dataBase.getStoriesByAuthor(author);
  }

  public ArrayList<Comment> commentsFromStory(Story aStory) {
    return dataBase.commentsFromStory(aStory);
  }

  public ArrayList<Comment> commentsFromComment(Comment aComment) {
    return dataBase.commentsFromComment(aComment);
  }

  public ArrayList<Story> mostCommented(int n) {
    return dataBase.mostCommented(n);
  }

  public int getNumberOfCommentsByUser(String userName) {

    return getCommentsByAuthor(userName).size();
  }

  public int getNumberOfStoriesByUser(String userName) {

    return getStoriesByAuthor(userName).size();
  }

  public int getUsersHighestPoints(String userName) {

    ArrayList<Story> userStories = getStoriesByAuthor(userName);
    int highestNumber=0;
    int compareNumber=0;
    for (int i=0; i<userStories.size(); i++) {
      compareNumber = userStories.get(i).score;
      if (compareNumber>highestNumber) {
        highestNumber=compareNumber;
      }
    }

    return highestNumber;
  }

  public int getNumberOfStoriesByUserInYear(String userName, int year) {
    ArrayList<Story> userStories = getStoriesByAuthor(userName);
    int counter=0;

    for (int i=0; i<userStories.size(); i++) {
      if (userStories.get(i).getYear() == year) {
        counter++;
      }
    }

    return counter;
  }

  public int getNumberOfCommentsByUserInYear(String userName, int year) {
    ArrayList<Comment> userComments = getCommentsByAuthor(userName);
    int counter=0;

    for (int i=0; i<userComments.size(); i++) {
      if (userComments.get(i).getYear() == year) {
        counter++;
      }
    }

    return counter;
  }
}
