class UILayer {

  ArrayList<String> strings = new ArrayList<String>();
  float x = width - 100;
  float y = 20;
  float yDiff = 10;
  
  void showText(String textToShow,float x, float y) {
    strings.add(textToShow);
  }
  
  void show() {
    pushMatrix();
    translate(-mainCamera.xOff,-mainCamera.yOff);
    int i = 0;
    for (String s : strings) {
      fill(255);
      float newY = y + (yDiff * i); 
      text(s, x, newY);
      i++;
    }
    strings.clear();
    popMatrix();
  }
  
}