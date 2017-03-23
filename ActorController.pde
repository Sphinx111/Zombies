class ActorController {
  
  ArrayList<Actor> actorsInScene = new ArrayList<Actor>();
  ArrayList<Actor> actorsToRemove = new ArrayList<Actor>(0);
  Actor player = null;
  Vec2 playerStartPos = new Vec2(width/2,height/2);
  
  public ActorController(int n) {
    for (int i = 0; i < n; i++) {
      Vec2 newPos = new Vec2((width/2 - 50) + (float)Math.random() * 100, (height/2 - 250) + (float)Math.random() * 100);
      if (i == 0) {
        Actor newPlayer = new Actor(playerStartPos, true, Team.HUMAN, Type.SOLDIER);
        actorsInScene.add(newPlayer);
        player = newPlayer;
      } else if (i % 10 == 0) {
        actorsInScene.add(new Actor(newPos, false, Team.ZOMBIE, Type.BIG_ZOMBIE));
      } else {
        actorsInScene.add(new Actor(newPos, false, Team.ZOMBIE, Type.BASIC_ZOMBIE));
      }
    }
  }
  
  void createActor(Vec2 pos, boolean isPlayer, Team team, Type type) {
    actorsInScene.add(new Actor(pos,isPlayer,team,type));
  }
  
  void removeActor(Actor deadActor) {
    if (!actorsToRemove.contains(deadActor)) {
      actorsToRemove.add(deadActor);
    }
  }
  
  void cleanup() {
    //Go through list of actors removed this turn, and clear them from the activeActors ArrayList
    for (Actor a : actorsToRemove) {
      box2d.world.destroyBody(a.body);
      actorsInScene.remove(a);
      //if the player being removed is the player, nullify the "player" field/pointer in ActorController.
      if (a.isPlayer) {
        player = null;
      }
    }
    actorsToRemove.clear();
  }
  
  void update() {
    for (Actor a : actorsInScene) {
      //a.applyForce(new Vec2(50000,0));
      if (!a.isPlayer) {
        a.runBehaviour();
      }
      a.update();
    }
  }
  
  void show() {
    for (Actor a : actorsInScene) {
      a.show();
    }
  }
  
  void shoot(Actor a) {
    a.shoot();
  }
  
  void moveForward(Actor a) {
    a.applyForce(new Vec2(0,1).mul(a.accel));
  }
  void moveBackward(Actor a) {
    a.applyForce(new Vec2(0,-1).mul(a.accel));
  }
  void moveLeft(Actor a) {
    a.applyForce(new Vec2(-1,0).mul(a.accel));
  }
  void moveRight(Actor a) {
    a.applyForce(new Vec2(1,0).mul(a.accel));
  }
  
}