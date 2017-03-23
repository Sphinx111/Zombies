import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import ddf.minim.*;

Box2DProcessing box2d;
StateManager gameStateManager;
ActorController actorControl;
MapHandler mapHandler;
KeyboardHandler keyHandler;
FogOfWar fogOfWar;
UILayer uiLayer;
MouseHandler mouseHandler;
Camera mainCamera;
Minim minim;
AudioSample soundZ;
AudioSample soundG;
Boolean isPaused = true;
Boolean creatorMode = false;

float newMouseX;
float newMouseY;

void setup() {
  size(1300,720);
  box2d = new Box2DProcessing(this);
  box2d.createWorld(new Vec2(0,0));
  gameStateManager = new StateManager();
  actorControl = new ActorController(15);
  mapHandler = new MapHandler();
  keyHandler = new KeyboardHandler();
  mouseHandler = new MouseHandler();
  fogOfWar = new FogOfWar();
  uiLayer = new UILayer();
  mainCamera = new Camera();
  mapHandler.loadMap("testMap");
  minim = new Minim(this);
  soundZ = minim.loadSample("zombie.mp3", 512);
  soundZ.setGain(-20);
  soundG = minim.loadSample("gunshot.mp3", 512);
  soundG.setGain(-15);
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
  gameStateManager.update();
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