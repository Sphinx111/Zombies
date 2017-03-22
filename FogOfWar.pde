import java.util.Collection;
import java.util.Iterator;
import java.util.Arrays;

class FogOfWar {
  
  Vec2 origin;
  Vec2 worldOrigin;
  float fogDistance = 10000;
  PShape fogShape;
  PShape fogShape2;
  
  RayFogDetector fogDetector = new RayFogDetector(this);
  
  float angle = 0;
  float leftAngle = 0;
  float rightAngle = 0;
  float bodyD = 1;
  float playerFOV = PI/2;
  int ray_index = 0;
  
  RaySort[] Vec2ToSort;
  ArrayList<Vec2> visibleVertices = new ArrayList<Vec2>();
  
  void update() {
    Actor player = actorControl.player;
    playerFOV = player.FOV;
    angle = player.body.getAngle();
    rightAngle = angle + (playerFOV/2);
    leftAngle = angle - (playerFOV/2);
    origin = box2d.getBodyPixelCoord(player.body);
    bodyD = player.myRadius;
    
    //Everything beyond this point not currently working...
    /*
    worldOrigin = new Vec2(box2d.scalarPixelsToWorld(origin.x - mainCamera.xOff),box2d.scalarPixelsToWorld(origin.y - mainCamera.yOff));
    //(float)Math.sqrt((player.myRadius/2* player.myRadius/2) + (player.myRadius/2 * player.myRadius/2)); //alternate bodyDiameter calc
    
    //cast raycast at edge of player's vision to catch any walls right on the border.
    Vec2 endLineLeft = new Vec2(worldOrigin.x + (fogDistance * (float)Math.sin(leftAngle)), worldOrigin.y + (fogDistance * (float)Math.cos(leftAngle)));
    box2d.world.raycast(fogDetector,worldOrigin,endLineLeft);
    //DEBUG LINE DRAWING
    stroke(0,250,0);
    strokeWeight(1);
    line(box2d.scalarWorldToPixels(worldOrigin.x),box2d.scalarWorldToPixels(worldOrigin.y),box2d.scalarWorldToPixels(endLineLeft.x),box2d.scalarWorldToPixels(endLineLeft.y));
    ray_index = 1;
    for (MapObject MO : mapHandler.allObjects) {
      float distToMO = MO.body.getWorldCenter().add(worldOrigin.mul(-1)).length();
      if (distToMO < box2d.scalarPixelsToWorld(player.maxSightRange)) {
        PolygonShape shape = (PolygonShape)(MO.myFix.m_shape);
        Vec2[] vertices = shape.m_vertices;
        for (Vec2 vertex: vertices) {
          box2d.world.raycast(fogDetector,worldOrigin,vertex);
          ray_index++;
          //DEBUG LINE DRAWING
          stroke(0,0,250);
          strokeWeight(1);
          line(box2d.scalarWorldToPixels(worldOrigin.x),box2d.scalarWorldToPixels(worldOrigin.y),box2d.scalarWorldToPixels(vertex.x),box2d.scalarWorldToPixels(vertex.y));
        }        
      }
    }
    //cast raycast at edge of player's vision to catch any walls right on the border.
    Vec2 endLineRight = new Vec2(worldOrigin.x + (fogDistance * (float)Math.sin(rightAngle)), worldOrigin.y + (fogDistance * (float)Math.cos(rightAngle)));
    box2d.world.raycast(fogDetector,worldOrigin,endLineRight);
    
    //get data from RayCastCallback object
    Collection visionPolygonVertices = fogDetector.getVertices();
    int n = visionPolygonVertices.size();
    Object[] verticesToSort = visionPolygonVertices.toArray();
    Vec2ToSort = new RaySort[n];
    
    //for each Hashmap key, create a comparable class for easy sorting.
    for (int i = 0; i < n; i++) {
      Vec2 point = (Vec2)verticesToSort[i];
      Vec2ToSort[i] = new RaySort(point);      
    }
    //Sort arrays by custom comparator (sort by angle from smallest to largest);
    Arrays.sort(Vec2ToSort,0,n);
    
    //if the angle to the vertex is within the player's FOV, copy point to visible vertices arrayList.
    for (int i = 0; i < n; i++) {
      if (Vec2ToSort[i].myAngle >= leftAngle && Vec2ToSort[i].myAngle <= rightAngle) {
        visibleVertices.add(Vec2ToSort[i].myPoint);
        strokeWeight(2);
        stroke(0,0,255);
        point(box2d.scalarWorldToPixels(Vec2ToSort[i].myPoint.x),box2d.scalarWorldToPixels(Vec2ToSort[i].myPoint.y));
      }
    }
    
    //points are now available in ArrayList for the show() function to use.
    
    ray_index = 0;
    fogDetector.cleanup();
    */
  }
  
  class RaySort implements Comparable<RaySort> {
      
      float NULL_ANGLE_VALUE = -999999999;
      Vec2 myPoint;
      float myAngle = NULL_ANGLE_VALUE; 
      
      public RaySort(Vec2 point) {
        myPoint = point;
      }
      
      //produces array sorted from RIGHT to LEFT
      public int compareTo(RaySort comparison) {
        if (comparison.myAngle == NULL_ANGLE_VALUE) {
          Vec2 point = comparison.myPoint;
          Vec2 vecToPoint = point.add(worldOrigin.mul(-1));
          comparison.myAngle = (float)Math.atan2(vecToPoint.y,vecToPoint.x);
        }
        if (myAngle == NULL_ANGLE_VALUE) {
          Vec2 vecToMe = myPoint.add(worldOrigin.mul(-1));
          myAngle = (float)Math.atan2(vecToMe.y,vecToMe.x);
        }
        if (myAngle - comparison.myAngle < 0) {
          return -1;
        } else if (myAngle - comparison.myAngle > 0) {
          return 1;
        } else {
          return 0;
        }
      }
      
    }
  
  void show() {
    text("" + leftAngle, 20,20);
    Vec2 endLineLeft = new Vec2(origin.x + (fogDistance * (float)Math.sin(leftAngle)), origin.y + (fogDistance * (float)Math.cos(leftAngle)));
    Vec2 endLineRight = new Vec2(origin.x + (fogDistance * (float)Math.sin(rightAngle)), origin.y + (fogDistance * (float)Math.cos(rightAngle)));
    Vec2 offScreenLeft = new Vec2(origin.x + (fogDistance * (float)Math.sin(angle - (PI/2))), origin.y + (fogDistance * (float)Math.cos(leftAngle - (PI/2))));
    Vec2 offScreenRight = new Vec2(origin.x + (fogDistance * (float)Math.sin(angle + (PI/2))), origin.y + (fogDistance * (float)Math.cos(rightAngle + (PI/2))));
    Vec2 behindShape = new Vec2(origin.x + (fogDistance * (float)Math.sin(angle + PI)), origin.y + (fogDistance * (float)Math.cos(angle + PI)));
    Vec2 shapeLeftCorner = new Vec2(origin.x + (bodyD * (float)Math.sin(angle - (2 * PI / 360 * 135))), origin.y + (bodyD * (float)Math.cos(angle - (2 * PI / 360 * 135))));
    Vec2 shapeRightCorner = new Vec2(origin.x + (bodyD * (float)Math.sin(angle + (2 * PI / 360 * 135))), origin.y + (bodyD * (float)Math.cos(angle + (2 * PI / 360 * 135))));
    
    
    fogShape = createShape();
    fogShape.beginShape();
    fogShape.fill(0);
    fogShape.noStroke();
    fogShape.vertex(endLineLeft.x, endLineLeft.y);
    fogShape.vertex(offScreenLeft.x,offScreenLeft.y);
    fogShape.vertex(behindShape.x,behindShape.y);
    fogShape.vertex(offScreenRight.x,offScreenRight.y);
    fogShape.vertex(endLineRight.x,endLineRight.y);
    fogShape.beginContour();
    fogShape.vertex(endLineRight.x,endLineRight.y);
    fogShape.vertex(shapeRightCorner.x,shapeRightCorner.y);
    fogShape.vertex(shapeLeftCorner.x,shapeLeftCorner.y);
    fogShape.vertex(endLineLeft.x, endLineLeft.y);
    
    //This section currently not working (relies on raycasting)
    /* fogShape.vertex(shapeRightCorner.x,shapeRightCorner.y);
      for (Vec2 vertex : visibleVertices) {
        fogShape.vertex(box2d.scalarWorldToPixels(vertex.x),box2d.scalarWorldToPixels(vertex.y));
      }
    fogShape.vertex(shapeLeftCorner.x,shapeLeftCorner.y);
    */
    fogShape.endContour();
    fogShape.endShape();
    shapeMode(CORNER);
    shape(fogShape,0,0);
  }
}