import org.jbox2d.callbacks.*;

class RayFogDetector implements RayCastCallback {
  
  public HashMap<Integer,Vec2> nearestRayHits = new HashMap<Integer,Vec2>();
  FogOfWar owner;
  
  public RayFogDetector(FogOfWar owner) {
    this.owner = owner;
  }
  
  float reportFixture(Fixture fix, Vec2 point, Vec2 normal, float fraction) {
    Object testObject = fix.getUserData();
    if (testObject instanceof MapObject) {
      int current_i = owner.ray_index;
      if (!nearestRayHits.containsKey(current_i)) {
        nearestRayHits.put(current_i,point.clone());
      } else if (nearestRayHits.get(current_i).add(owner.origin.mul(-1)).length() > point.add(owner.origin.mul(-1)).length()) {
        nearestRayHits.put(current_i,point.clone());
      }
    }
    return 1;
  }
  
  Collection getVertices() {
    return nearestRayHits.values();
  }
  
  void cleanup() {
    nearestRayHits = new HashMap<Integer,Vec2>();
  }
  
}