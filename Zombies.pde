import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

Box2DProcessing box2d;
ActorController actorControl;
MapHandler mapHandler;
KeyboardHandler keyHandler;
FogOfWar fogOfWar;
UILayer uiLayer;
MouseHandler mouseHandler;
Camera mainCamera;
Boolean isPaused = true;
Boolean creatorMode = false;

float newMouseX;
float newMouseY;

void setup() {
  size(1300,720);
  box2d = new Box2DProcessing(this);
  box2d.createWorld(new Vec2(0,0));
  actorControl = new ActorController(10);
  mapHandler = new MapHandler();
  keyHandler = new KeyboardHandler();
  mouseHandler = new MouseHandler();
  fogOfWar = new FogOfWar();
  uiLayer = new UILayer();
  mainCamera = new Camera();
}

void draw() {
  background(51);
  mainCamera.applyTransform();
  mouseHandler.update();
  keyHandler.processKeyInput();
  mouseHandler.show();
  mapHandler.show();
  if (!isPaused) {
    box2d.step();
    actorControl.update();
    fogOfWar.update();
  }
    actorControl.show();
  if (!isPaused && !creatorMode) {
    fogOfWar.show();
  }
  uiLayer.show();
  if (!isPaused) {
    //Last step of each frame, perform cleanup over iterable lists.
    actorControl.cleanup();
  }
  mainCamera.undoTransform();
}

void keyPressed() {
  keyHandler.keyInCheck();
}

void keyReleased() {
  keyHandler.keyOutCheck();
}

void mousePressed() {
  mouseHandler.mouseInCheck();
}

void mouseReleased() {
  mouseHandler.mouseOutCheck();
}