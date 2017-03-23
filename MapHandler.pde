import java.io.PrintWriter;
import java.io.FileReader;
import java.io.BufferedReader;

class MapHandler {
 
  int uniqueIDCounter = 0;
  ArrayList<MapObject> allObjects = new ArrayList<MapObject>();
  PrintWriter printToSave;
  BufferedReader readToLoad;
  String name = "testMap";
  
  void createMapObjectByMouse(Vec2 origin, Vec2 end, Vec2 objWidthSet, BlockType type) {
    float midX = (origin.x + end.x) / 2;
    float midY = -(origin.y + end.y) / 2;
    Vec2 midPoint = new Vec2 (midX, midY);
    Vec2 vecStartEnd = end.add(origin.mul(-1));
    float angle = (float)Math.atan2(vecStartEnd.y, vecStartEnd.x);
    float lengthOfLine = (float)Math.sqrt((vecStartEnd.x * vecStartEnd.x) + (vecStartEnd.y * vecStartEnd.y));
    Vec2 objWidthVec = objWidthSet.add(end.mul(-1));
    float widthOfLine = (float)Math.sqrt((objWidthVec.x * objWidthVec.x) + (objWidthVec.y * objWidthVec.y));
    
    allObjects.add(new MapObject(midPoint,lengthOfLine,widthOfLine,-angle, type, uniqueIDCounter));
    uniqueIDCounter += 1;
  }
  
  void createActorByMouse(Vec2 origin, Team team, Type type) {
    
  }
  
  void createMapObjectFromLoad(Vec2 origin, float wide, float tall, float angle, BlockType type, int newID) {
    float xDiff = box2d.scalarPixelsToWorld(mainCamera.xOff);
    float yDiff = box2d.scalarPixelsToWorld(mainCamera.yOff);
    Vec2 alteredPos = new Vec2(origin.x - xDiff, origin.y - yDiff);
    allObjects.add(new MapObject(alteredPos, wide,tall,angle,type, newID));
  }
  
  void show() {
    for (MapObject m : allObjects) {
      m.show();
    }
  }
  
  void saveMap() {
    boolean saveReady = false;
    try {
      printToSave = new PrintWriter(name + ".txt");
      saveReady = true;
    } catch (Exception e) {
      e.printStackTrace();
      saveReady = false;
    }
    if (saveReady) {
      for (MapObject m : allObjects) {
        //prepare stringbuilder for saving a line of data.
        StringBuilder newline = new StringBuilder();
        //get string of blockType for first piece of data
        newline.append(BlockType.getString(m.myType) + ",");
        int saveID = m.myID;
        newline.append(saveID + ",");
        Vec2 savePos = m.body.getPosition();
        newline.append(savePos.x + "," + savePos.y);
        float saveAngle = m.body.getAngle();
        newline.append("," + saveAngle);
        float xVal = box2d.scalarPixelsToWorld(m.pixWidth);
        newline.append("," + xVal);
        float yVal = box2d.scalarPixelsToWorld(m.pixHeight);
        newline.append("," + yVal);
        
        printToSave.println(newline);
      }
      printToSave.close();
    }
  }
  
  void loadMap(String mapName) {
    String inputData = "";
    String[] inputLines;
    boolean loadReady = false;
    try {
      readToLoad = new BufferedReader(new FileReader(mapName+".txt"));
      loadReady = true;
    } catch (Exception e) {
      e.printStackTrace();
      loadReady = false;
    }
    
    if (loadReady) {
      int highestLoadID = 0; //var tracks highest ID loaded in, so mapHandler can continue adding ID's from new highest value.
      allObjects.clear(); //delete all existing map objects when loading new map.
      
      try {
        //get data from file and store in memory quickly.
        StringBuilder sb = new StringBuilder();
        String line = readToLoad.readLine();
  
        while (line != null) {
          sb.append(line);
          sb.append(System.lineSeparator());
          line = readToLoad.readLine();
        }
        inputData = sb.toString();
        readToLoad.close();
      } catch (Exception e) {
        e.printStackTrace();
      }
      inputLines = inputData.split(System.getProperty("line.separator"));
      //build MapObjects from saved data
      try {
        for (int i = 0; i < inputLines.length; i++) {
          String[] dataPieces = inputLines[i].split(",");
          int p = dataPieces.length;
          BlockType loadType = BlockType.getTypeFromString(dataPieces[0]);
          int newID = Integer.parseInt(dataPieces[1]);
          float x = Float.parseFloat(dataPieces[2]);
          float y = Float.parseFloat(dataPieces[3]);
          float angle = Float.parseFloat(dataPieces[4]);
          Vec2 newPos = new Vec2(x,y);
          float wide = Float.parseFloat(dataPieces[5]);
          float tall = Float.parseFloat(dataPieces[6]);
          createMapObjectFromLoad(newPos,wide,tall,angle, loadType, newID);
          if (newID > highestLoadID) {
            highestLoadID = newID;
          }
        }
      } catch (Exception e) {
        e.printStackTrace();
      }
      uniqueIDCounter = highestLoadID; // lets map handler continue adding map objects from loaded ID system
      
    }
  }
}