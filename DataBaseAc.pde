//Daniel -  the whole class
import java.sql.*;



//Daniel
class DataBaseAc {
  private static final String jdbcDriver = "org.h2.Driver";
  String dbUrlLocal = "jdbc:h2:tcp://localhost/~/Desktop/database";
  String dbUrl = "jdbc:h2:" + dataPath("database");

  String usr = "root";
  String pass = "";
  java.sql.Connection conn = null;
  java.sql.Statement statement = null;
  boolean toSetup = false; //set to true if running for first time on localhost server

  public boolean toSetup() {
    return toSetup;
  }
  public DataBaseAc() {    
    if (toSetup)
      setupFirstTime();
    else
      connect(); // replace with setupFirstTime when using for first time
  }
//establishes a connection with local database file and initalises the driver
  void connect() {
    try {
      Class.forName("org.h2.Driver");
      System.out.println("Connecting to a selected database...");  
      conn = DriverManager.getConnection(dbUrl, usr, pass);
      statement = conn.createStatement();      

      System.out.println("Connected database successfully...");
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }

//method to get a set of results from a query
  public ResultSet getQueryResult(String query) {

    try {
      java.sql.Statement statement = conn.createStatement();
      ResultSet results = statement.executeQuery(query);
      return results;
    } 
    catch (Exception e) {
      println(e);
      return null;
    }
  }
 // returns comments that originate from a comment ( comments on a comment)
  public ArrayList<Comment> commentsFromComment(Comment aComment) {
    ArrayList<Comment> commentsFromComment = new ArrayList<Comment>();
    ArrayList<Integer> kids = aComment.getKids();
    String query = "SELECT * FROM comments ORDER BY time DESC";
    ResultSet results = getQueryResult(query);
    try {
      while (results.next()) {
        for (int i = 0; i < kids.size(); i++) {
          int parent = Integer.parseInt(results.getString("parent"));
          if (kids.get(i) == parent) {
            commentsFromComment.add(getCommentById(Integer.parseInt(results.getString("id"))));
            break;
          }
        }
      }
    }
    catch(Exception e) {
      println(e);
    }
    return commentsFromComment;
  }
// returns comments that originate from a story ( comments on a story)
  public ArrayList<Comment> commentsFromStory(Story aStory) {
    ArrayList<Comment> commentsFromStory = new ArrayList<Comment>();
    ArrayList<Integer> kids = aStory.getKids();
    String query = "SELECT * FROM comments ORDER BY time DESC";
    ResultSet results = getQueryResult(query);
    try {
      while (results.next()) {
        for (int i = 0; i < kids.size(); i++) {
          int parent = Integer.parseInt(results.getString("parent"));
          if (kids.get(i) == parent) {
            commentsFromStory.add(getCommentById(Integer.parseInt(results.getString("id"))));
            break;
          }
        }
      }
    }
    catch(Exception e) {
      println(e);
    }
    return commentsFromStory;
  }
//returns the stories published by a certain author
  public ArrayList<Story> getStoriesByAuthor(String author) {
    ArrayList<Story> storiesFromAuthor = new ArrayList<Story>();
    String query = "SELECT * FROM stories ORDER BY time DESC";
    ResultSet results = getQueryResult(query);
    try {
      while (results.next()) {
        if (author.toLowerCase().equals(results.getString("author").toLowerCase())) {
          storiesFromAuthor.add(getStoryById(Integer.parseInt(results.getString("id"))));
        }
      }
    }
    catch(Exception e) {
      println(e);
    }
    return storiesFromAuthor;
  }
//returns the comments made by a certain author
  public ArrayList<Comment> getCommentsByAuthor(String author) {
    ArrayList<Comment> commentsFromAuthor = new ArrayList<Comment>();
    String query = "SELECT * FROM comments ORDER BY time DESC";
    ResultSet results = getQueryResult(query);
    try {
      while (results.next()) {
        if (author.toLowerCase().equals(results.getString("author").toLowerCase())) {
          commentsFromAuthor.add(getCommentById(Integer.parseInt(results.getString("id"))));
        }
      }
    }
    catch(Exception e) {
      println(e);
    }
    return commentsFromAuthor;
  }
//returns the "n" most recent comments from the dataset
  public ArrayList<Story> mostCommented(int n) {
    ArrayList<Story> mostCommentedStories = new ArrayList<Story>();
    String query = "SELECT * FROM stories ORDER BY descendants DESC LIMIT " + n;
    ResultSet results = getQueryResult(query);
    try {
      while (results.next()) {
        Story aStory = new Story(stringToArray(results.getString("kids")), Integer.parseInt(results.getString("descendants")), 
          results.getString("url"), results.getString("title"), results.getString("author"), 
          Integer.parseInt(results.getString("score")), Integer.parseInt(results.getString("time")), 
          Integer.parseInt(results.getString("id")));  
        mostCommentedStories.add(aStory);
      }
    }
    catch(Exception e) {
      println(e);
    }
    return mostCommentedStories;
  }
//returns all the comments
  public ArrayList<Comment> getComments() {
    ArrayList<Comment> comments = new ArrayList<Comment>();
    String query = "SELECT * FROM comments";
    ResultSet results = getQueryResult(query);
    try {
      while (results.next()) {
        Comment aComment = new Comment(stringToArray(results.getString("kids")), Integer.parseInt(results.getString("parent")), 
          results.getString("text"), results.getString("author"), Integer.parseInt(results.getString("time")), 
          Integer.parseInt(results.getString("id")));
        comments.add(aComment);
      }
    }
    catch(Exception e) {
      println(e);
    }   
    return comments;
  }


//returns all the stories
  public ArrayList<Story> getStories() {
    ArrayList<Story> stories = new ArrayList<Story>();
    String query = "SELECT * FROM stories";
    ResultSet results = getQueryResult(query);
    try {
      while (results.next()) {
        Story aStory = new Story(stringToArray(results.getString("kids")), Integer.parseInt(results.getString("descendants")), 
          results.getString("url"), results.getString("title"), results.getString("author"), 
          Integer.parseInt(results.getString("score")), Integer.parseInt(results.getString("time")), 
          Integer.parseInt(results.getString("id")));  
        stories.add(aStory);
      }
    }
    catch(Exception e) {
      println(e);
    }   
    return stories;
  }
// returns the comment by a particular parent
  public Comment getCommentByParent(int n) {
    String query = "SELECT parent, id FROM comments";
    ResultSet results = getQueryResult(query);
    Comment aComment = null;
    try {
      while (results.next()) {
        if (Integer.parseInt(results.getString("parent")) == n) {
          aComment = getCommentById(Integer.parseInt(results.getString("id")));
        }
      }
    }
    catch(Exception e) {
      println(e);
    }
    return aComment;
  }
  //returns a story with a certain ID
  public Story getStoryById(int id)
  {
    String query = "SELECT * FROM stories WHERE id = "+id;
    ResultSet results = getQueryResult(query);
    Story aStory = null;
    try {
      results.next();

      aStory = new Story(stringToArray(results.getString("kids")), Integer.parseInt(results.getString("descendants")), 
        results.getString("url"), results.getString("title"), results.getString("author"), 
        Integer.parseInt(results.getString("score")), Integer.parseInt(results.getString("time")), id);
    }      
    catch (Exception e) {
      println(e);
      return null;
    }
    return aStory;
  } 
  
  
    public Story getStoryByTitle(String title)
  {
    String query = "SELECT * FROM stories WHERE title = "+ "'"+title+ "'";
    ResultSet results = getQueryResult(query);
    Story aStory = null;
    try {
      results.next();
      aStory = new Story(stringToArray(results.getString("kids")), Integer.parseInt(results.getString("descendants")), 
        results.getString("url"), results.getString("title"), results.getString("author"), 
        Integer.parseInt(results.getString("score")), Integer.parseInt(results.getString("time")), 
        Integer.parseInt(results.getString("id")));
    }      
    catch (Exception e) {
      println(e);
      return null;
    }
    return aStory;
  } 
//returns the comment associated with a particular ID
  public Comment getCommentById(int id)
  {
    String query = "SELECT * FROM comments WHERE id = "+id;
    // set the query string as your needed query
    ResultSet results = getQueryResult(query);
    Comment aComment = null;
    try {
      results.next();

      aComment = new Comment(stringToArray(results.getString("kids")), Integer.parseInt(results.getString("parent")), 
        results.getString("text"), results.getString("author"), Integer.parseInt(results.getString("time")), id);
    }      
    catch (Exception e) {
      println(e);
      return null;
    }
    return aComment;
  }

//returns the IDs of the "n" most popular stories
  public ArrayList<Integer> highestStoryIds(int n)
  {
    ArrayList<Integer> userIdList = new ArrayList<Integer>();
    String query = "SELECT id FROM stories ORDER BY score DESC LIMIT " + n;
    // set the query string as your needed query
    ResultSet results = getQueryResult(query);
    try {
      while (results.next())
      {
        int storyId = results.getInt("id") ;
        userIdList.add(storyId);
      }
      return userIdList;
    } 
    catch (Exception e) {
      println(e);
      return null;
    }
  }
// returns comments by "id" of a particular user publisher
  public ArrayList<Integer> commentsByUserId(String user) {
    ArrayList<Integer> commentIds =  new ArrayList<Integer>();
    String query = "SELECT * FROM comments ORDER BY time DESC";    
    ResultSet results = getQueryResult(query);
    try {
      while (results.next()) {
        if (results.getString("author").toLowerCase().equals(user.toLowerCase())) {
          commentIds.add(Integer.parseInt(results.getString("id")));
        }
      }
    } 
    catch(Exception e) {
      println(e);
    }
    return commentIds;
  }
//returns story IDs of stories by a particular user
  public ArrayList<Integer> storiesByUserId(String user) {
    ArrayList<Integer> storyIds =  new ArrayList<Integer>();
    String query = "SELECT * FROM stories ORDER BY time DESC";    
    ResultSet results = getQueryResult(query);
    try {
      while (results.next()) {
        if (results.getString("author").toLowerCase().equals(user.toLowerCase())) {
          storyIds.add(Integer.parseInt(results.getString("id")));
        }
      }
    } 
    catch(Exception e) {
      println(e);
    }
    return storyIds;
  }

  public ArrayList<Integer> recentStoryIds(int n)
  {
    ArrayList<Integer> userIdList = new ArrayList<Integer>();
    String query = "SELECT id FROM stories ORDER BY time DESC LIMIT " + n;
    // set the query string as your needed query
    ResultSet results = getQueryResult(query);

    try {
      while (results.next())
      {
        int storyId = results.getInt("id") ;
        userIdList.add(storyId);
      }
      return userIdList;
    } 
    catch (Exception e) {
      println(e);
      return null;
    }
  }

//converts String kid array in database to an ArrayList of Integers

  ArrayList<Integer> stringToArray(String kidsString) {
    ArrayList<Integer> arr =  new ArrayList<Integer>();
    //  kidsString.replace("\n", "");
    if (kidsString.length() < 9) {
      kidsString = kidsString.substring(1, kidsString.length()-1);
    } else {
      kidsString = kidsString.substring(4, kidsString.length()-2);
    }
    String[] stringArr = kidsString.split("\\s*,\\s*");
    for (int i = 0; i < stringArr.length; i++) {
      arr.add(Integer.parseInt(stringArr[i]));
    }

    return arr;
  }

//adds a comment to the database
  public void addComment(String author, String text, int time, int id, int parent, String kids) {

    try {

      String values = "VALUES (" + "'" + author + "', '" + text + "', " + time + ", " + id + ", " + 
        parent  + ", '" + kids   + "')";
      String sql = "INSERT INTO comments " + values;
      java.sql.Statement statement = conn.createStatement();
      statement.executeUpdate(sql);
    } 
    catch (Exception e) {
      System.out.println(e);
    }
  }
//adds a story to the database
  public void addStory(String url, String title, int score, int id, int descendants, String author, 
    int time, String kids) {

    try {
      String values = "VALUES (" + "'" + url + "', '" + title + "', " + score + ", " + id + 
        ", " + descendants + ", '" + author + "', " + time + ", '" + kids + "')";
      String sql = "INSERT INTO stories " + values;
      java.sql.Statement statement = conn.createStatement();
      statement.executeUpdate(sql);
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }

//sets up the database for the first time
  public void setupFirstTime() { //run once for first time setup

    String sql = "";
    try {
      Class.forName("com.mysql.jdbc.Driver");
      System.out.println("Connecting to a selected database...");  
      conn = DriverManager.getConnection(dbUrl, usr, pass);
      statement = conn.createStatement();      

      System.out.println("Connected database successfully...");
    } 
    catch (Exception e) {
    }
    try {
      sql = "DROP DATABASE Project";
      statement.executeUpdate(sql);
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
    try {
      sql = "CREATE DATABASE project";
      statement.executeUpdate(sql);
      System.out.println("Database created successfully...");          
      conn = DriverManager.getConnection(dbUrl, usr, pass);
      statement = conn.createStatement();  
      //
    } 
    catch (Exception e) {
      e.printStackTrace();
    }

    try {
      sql = "DROP TABLE stories ";
      statement = conn.createStatement();
      statement.executeUpdate(sql);
      System.out.println("stories deleted in given database...");
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
    try {
      sql = "DROP TABLE comments ";
      statement.executeUpdate(sql);
      System.out.println("comments deleted in given database...");
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
    try { //(url, title, score, id, descendants, author, time, kids (as string))
      sql = "CREATE TABLE stories\r\n" + "(\r\n url VARCHAR(255), title VARCHAR(255), score INT NOT NULL," 
        + "id INT NOT NULL, descendants INT NOT NULL, author VARCHAR(255), time INT NOT NULL," +
        "kids VARCHAR (30000))";
      statement.executeUpdate(sql);
      System.out.println("stories created");
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
    try {
      sql = "CREATE TABLE comments\r\n" + "(" + " author VARCHAR(255), text VARCHAR(10000)," 
        + "time INT NOT NULL, id INT NOT NULL, parent INT NOT NULL, kids VARCHAR(30000))";
      statement.executeUpdate(sql);
      System.out.println("comments created");
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }
}
