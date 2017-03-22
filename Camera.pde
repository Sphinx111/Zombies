class Camera {
  float xOff;
  float yOff;
  float screenShakeValue = 0;
  
  void applyTransform() {
    xOff = width/2 - box2d.getBodyPixelCoord(actorControl.player.body).x + applyScreenShake();
    yOff = height/2 - box2d.getBodyPixelCoord(actorControl.player.body).y + applyScreenShake();
    pushMatrix();
    translate(xOff,yOff);
    screenShakeValue = 0;
  }
  
  void screenShake(float amount) {
    screenShakeValue = amount;
  }
  
  float applyScreenShake() {
    float newAmount = ((float)Math.random() * 2 * screenShakeValue) - screenShakeValue;
    return newAmount;
  }
  
  void undoTransform() {
    popMatrix();
  }
  
}