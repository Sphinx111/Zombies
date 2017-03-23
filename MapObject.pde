class MapObject {
 
  int myID;
  Body body; 
  Fixture myFix;
  BlockType myType;
  float pixWidth;
  float pixHeight;
  color myColor = color(100);
  
  public MapObject (Vec2 worldPosCenter, float worldWidth, float worldHeight, float angleOfRotation, BlockType type, int newID) {
    pixWidth = box2d.scalarWorldToPixels(worldWidth);
    pixHeight = box2d.scalarWorldToPixels(worldHeight);
    makeBody(worldPosCenter, worldWidth, worldHeight, angleOfRotation);
    myType = type;
    myID = newID;
  }
  
  
  void makeBody(Vec2 pos, float worldWidth, float worldHeight, float angleOfRotation) {
    
    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    sd.setAsBox(worldWidth/2,worldHeight/2);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0;
    fd.restitution = 0.05;
    
    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(pos);

    body = box2d.createBody(bd);
    body.setTransform(body.getWorldCenter(), angleOfRotation);
    myFix = body.createFixture(fd);
    body.setUserData(this);
    myFix.setUserData(this);
  }
  
  void show() {
    
      Vec2 pixPos = box2d.getBodyPixelCoord(body);
      float angle = body.getAngle();
      
      rectMode(CENTER);
      pushMatrix();
      translate(pixPos.x, pixPos.y);
      rotate(-angle);
      fill(myColor);
      stroke(0);
      strokeWeight(1);
      rect(0, 0, pixWidth, pixHeight);
      popMatrix();
  }
  
  
}