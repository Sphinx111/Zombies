class MouseHandler {
  Vec2 firstClick;
  Vec2 releasePoint;
  Vec2 thirdClick;
  
  boolean readyForStageOne = true;
  boolean readyForStageTwo = false;
  boolean readyForStageThree = false;
  
  void mouseInCheck() {
    if (creatorMode) {
      if (readyForStageOne) {
        firstClick = new Vec2(box2d.scalarPixelsToWorld(newMouseX-(width/2)), box2d.scalarPixelsToWorld(newMouseY-(height/2)));
        readyForStageOne = false;
        readyForStageTwo = true;
      } else if (readyForStageThree) {
        thirdClick = new Vec2(box2d.scalarPixelsToWorld(newMouseX-(width/2)), box2d.scalarPixelsToWorld(newMouseY-(height/2)));
        mapHandler.createMapObjectByMouse(firstClick,releasePoint,thirdClick);
        firstClick = null;
        releasePoint = null;
        thirdClick = null;
        readyForStageOne = true;
        readyForStageTwo = false;
        readyForStageThree = false;
      }
    }
    
  }
  
  void mouseOutCheck() {
    if (creatorMode) {
      if (readyForStageTwo) {
        releasePoint = new Vec2(box2d.scalarPixelsToWorld(newMouseX-(width/2)), box2d.scalarPixelsToWorld(newMouseY-(height/2)));
        readyForStageTwo = false;
        readyForStageThree = true;
      }
    }
  }
  
  void show() {
    if (creatorMode) {
      if (readyForStageTwo) {
        stroke(255);
        strokeWeight(1);
        fill(255);
        text("Drawing something in MouseHandler", 10,20);
        line(box2d.scalarWorldToPixels(firstClick.x)+(width/2),box2d.scalarWorldToPixels(firstClick.y)+(height/2),newMouseX,newMouseY);
      } else if (readyForStageThree && thirdClick == null) {
        stroke(255);
        strokeWeight(1);
        Vec2 currentMouseWorld = new Vec2(box2d.scalarPixelsToWorld(newMouseX-(width/2)), box2d.scalarPixelsToWorld(newMouseY-(height/2)));
        float widthVectorLength = releasePoint.add(currentMouseWorld.mul(-1)).length();
        float projectedWidth = box2d.scalarWorldToPixels(widthVectorLength);
        strokeWeight(projectedWidth);
        line(box2d.scalarWorldToPixels(firstClick.x)+(width/2),box2d.scalarWorldToPixels(firstClick.y)+(height/2),box2d.scalarWorldToPixels(releasePoint.x)+(width/2),box2d.scalarWorldToPixels(releasePoint.y)+(height/2));
        strokeWeight(1);
      }
    }
  }
  
  void update() {
    newMouseX = mouseX - mainCamera.xOff;
    newMouseY = mouseY - mainCamera.yOff;
    
    if (!creatorMode) {
      firstClick = null;
      releasePoint = null;
      thirdClick = null;
      readyForStageOne = true;
      readyForStageTwo = false;
      readyForStageThree = false;
    }
  }
  
  
}