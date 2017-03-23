class MouseHandler {
  Vec2 firstClick;
  Vec2 releasePoint;
  Vec2 thirdClick;
  BlockType currentType = BlockType.FIXED;
  boolean holdClick = false;
  boolean readyForStageOne = true;
  boolean readyForStageTwo = false;
  boolean readyForStageThree = false;
  
  void mouseInCheck() {
    if (mouseButton == LEFT) {
      if (mouseX > uiLayer.uiPanelX && mouseY < uiLayer.uiPanelY + uiLayer.uiPanelHeight || (mouseX > uiLayer.uiActiveXMin && mouseX < uiLayer.uiActiveXMax && mouseY > uiLayer.uiActiveYMin && mouseY < uiLayer.uiActiveYMax)) {
          currentType = uiLayer.getClickedType(currentType);
      } else { 
        if (creatorMode) {
          //Do one thing if in FIXED, SENSOR, or DOOR MODE
          if (currentType == BlockType.FIXED || currentType == BlockType.SENSOR || currentType == BlockType.DOOR) {
            if (readyForStageOne) {
              firstClick = new Vec2(box2d.scalarPixelsToWorld(newMouseX-(width/2)), box2d.scalarPixelsToWorld(newMouseY-(height/2)));
              readyForStageOne = false;
              readyForStageTwo = true;
            } else if (readyForStageThree) {
              thirdClick = new Vec2(box2d.scalarPixelsToWorld(newMouseX-(width/2)), box2d.scalarPixelsToWorld(newMouseY-(height/2)));
              mapHandler.createMapObjectByMouse(firstClick,releasePoint,thirdClick, currentType);
              firstClick = null;
              releasePoint = null;
              thirdClick = null;
              readyForStageOne = true;
              readyForStageTwo = false;
              readyForStageThree = false;
            }
          //OR if in Actor mode, create an actor instead.
          } else {
            // TODO: actor creation code.
            
          }
        } else {
          holdClick = true;
        }
      }
    }
  }
  
  void mouseOutCheck() {
    if (creatorMode) {
      if (readyForStageTwo) {
        releasePoint = new Vec2(box2d.scalarPixelsToWorld(newMouseX-(width/2)), box2d.scalarPixelsToWorld(newMouseY-(height/2)));
        if (releasePoint.add(firstClick.mul(-1)).length() < box2d.scalarPixelsToWorld(2)) {
          releasePoint = null;
          firstClick = null;
          readyForStageOne = true;
          readyForStageTwo = false;
        } else { 
          readyForStageTwo = false;
          readyForStageThree = true;
        }
      }
    }
    holdClick = false;
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
    
    actorControl.player.turnTowards(new Vec2(newMouseX,newMouseY));
    if (holdClick && !isPaused) {
      actorControl.player.shoot();
    }
    
    fill(255);
    text(mouseX + "," + mouseY,0,0);
    
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