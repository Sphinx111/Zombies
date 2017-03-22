class KeyboardHandler {
  
  boolean[] keys = new boolean[9];
  // 0 - Shoot (x)
  // 1 - Forward
  // 2 - Backwards
  // 3 - Left
  // 4 - Right
  // 5 - Pause (p)
  // 6 - Creator Mode (m)
  // 7 - SaveMap (s);
  // 8 - LoadMap (l);
  
  void processKeyInput() {
    if (keys[0]) {
      actorControl.shoot(actorControl.player);
    }
    if (keys[1]) {
      actorControl.moveForward(actorControl.player);
    } else if (keys[2]) {
      actorControl.moveBackward(actorControl.player);
    }
    if (keys[3]) {
      actorControl.moveLeft(actorControl.player);
    } else if (keys[4]) {
      actorControl.moveRight(actorControl.player);
    }
    //if (keys[5]) {
    //  if (isPaused) {
    //    isPaused = false;
    //  } else {
    //    isPaused = true;
    //  }
    //}
    //if (keys[6]) {
    //  if (creatorMode) {
    //    creatorMode = false;
    //  } else {
    //    creatorMode = true;
    //  }
    //}
  }
  
  void keyInCheck() {
    if (key == 'x') {
      keys[0] = true;
    }
    if (keyCode == UP) {
      keys[1] = true;
    }
    if (keyCode == DOWN) {
      keys[2] = true;
    }
    if (keyCode == LEFT) {
      keys[3] = true;
    }
    if (keyCode == RIGHT) {
      keys[4] = true;
    }
    if (key == 'p') {
      //keys[5] = true;
      if (isPaused) {
        isPaused = false;
      } else {
        isPaused = true;
      }
    }
    if (key == 'm') {
      //keys[6] = true;
      if (creatorMode) {
        creatorMode = false;
      } else {
        creatorMode = true;
      }
    }
    if (key == 's') {
      mapHandler.saveMap();
    }
    if (key == 'l') {
      mapHandler.loadMap("testMap");
    }
  }
  
  void keyOutCheck() {
    if (key == 'x') {
      keys[0] = false;
    }
    if (keyCode == UP) {
      keys[1] = false;
    }
    if (keyCode == DOWN) {
      keys[2] = false;
    }
    if (keyCode == LEFT) {
      keys[3] = false;
    }
    if (keyCode == RIGHT) {
      keys[4] = false;
    }
    if (key == 'p') {
      keys[5] = false;
    }
    if (key == 'm') {
      keys[6] = false;
    }
  }
  
}