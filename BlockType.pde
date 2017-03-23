public enum BlockType {
  FIXED, //static world geometry
  SENSOR, //dynamic sensor bodies, buttons etc
  DOOR, //KINEMATIC bodies (usually linked to sensors or gameLogic).
  ACTOR, // ie = not a worldBlock, use Actor Save/Load.
  NO_TYPE; // used to handle blocks loaded without any type information.
  
  
  public static String getString(BlockType testType) {
    if (testType == BlockType.FIXED) {
      return "FIXED";
    } else if (testType == BlockType.SENSOR) {
      return "SENSOR";
    } else if (testType == BlockType.DOOR) {
      return "DOOR";
    } else if (testType == BlockType.ACTOR) {
      return "ACTOR";
    } else {
      return "NO_TYPE";
    } 
  }
  
  public static BlockType getTypeFromString(String testString) {
    if (testString == "FIXED") {
      return BlockType.FIXED;
    } else if (testString == "SENSOR") {
      return BlockType.SENSOR;
    } else if (testString == "DOOR") {
      return BlockType.DOOR;
    } else if (testString == "ACTOR") {
      return BlockType.ACTOR;
    } else {
      return BlockType.NO_TYPE;
    }
    
  }
  
}