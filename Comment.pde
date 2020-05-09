/* Darragh
 constructor: Comment(JSONArray kids, int parent, String text, String by, int time, int id)
 method interface: (written by Darragh)
 1. int getParent() : returns parent
 2. int getTime() : returns seconds elapsed since 1970
 3. int getId() : returns Id
 4. String getText() : returns the text of the comment
 5. String getBy() : returns who the comment is by
 6. ArrayList<Integer> getKids() : returns the kids of the comment in an arraylist
 7. String getDate() : returns the date of the comment in an HH-MM-SS dd-MM-yyyy format , ie: 17:03:22 03-10-2003
 
 */

class Comment {  
  JSONArray kids;
  private ArrayList<Integer>kidInts = new ArrayList<Integer>();
  private String text;
  private String by;
  private int time;
  private int id;
  private int parent;

  Comment(ArrayList<Integer>kidInts, int parent, String text, String by, int time, int id) {
    this.kidInts = kidInts;
    this.parent = parent;
    this.text = text;
    this.by = by;
    this.time = time;
    this.id = id;
  }

  public String removeHTML(String s) {
    String nohtml = Jsoup.parse(s).text();
    return nohtml;
  }
  public int getParent() {
    return parent;
  }
  public int getTime() {
    return time;
  }
  public int getId() {
    return id;
  }
  public String getText() {
   
    return removeHTML(text);
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

  public int getYear() {
    String year = "";
    String tempDate = getDateSimple();
    char[] yearArray = tempDate.toCharArray();

    for (int i=0; i<4; i++) {
      year += yearArray[i];
    }
    return Integer.parseInt(year);
  }

  public LocalDate getDate1() {
    LocalDate date = LocalDate.parse(getDateSimple());
    return date;
  }
  public String getDateWestern() { //western date format ie day-month-year
    java.util.Date date = new java.util.Date(getTime() * 1000L);
    SimpleDateFormat jdf = new SimpleDateFormat("dd-MM-yyyy");
    String javaDate = jdf.format(date);
    return javaDate;
  }
}
