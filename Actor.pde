import org.jbox2d.dynamics.contacts.ContactEdge;

class Actor {
  
  boolean isPlayer = false; //is this the player's character
  Team myTeam; // which team this actor is assigned to
  float myRadius; // radius in pixels
  Type myType; //type of actor
  Weapon myWeapon = null; //weapon held by this actor
  color myColor;
  
  float maxSightRange = 1000; //max range in pixels that player can see.
  float FOV = PI/2; //angle player can see in Radians;
  float accel = 300;
  float maxSpeed = 30;
  float turnSpeed = (2 * PI / 360) * 3;
  int health = 100;
  
  Body body; //The actor's physics simulation body.
  
  public Actor(Vec2 pos, boolean isPlayer, Team team, Type type) {
    this.isPlayer = isPlayer;
    myTeam = team;
    if (myTeam == Team.ZOMBIE) {
      myColor = color(100,200,100);
    } else if (myTeam == Team.HUMAN) {
      myColor = color(100,100,200);
      myWeapon = new Weapon();
    } else {
      myColor = color(150,150,150);
    }
    myType = type;
    if (myType == Type.BIG_ZOMBIE) {
      myRadius = 30;
      health = 10000;
      maxSpeed = maxSpeed * 1;
    } else {
      myRadius = 20;
      maxSpeed = maxSpeed * 1.15;
      health = 2500;
    }
    
    makeBody(pos, myRadius);
    System.out.println("New player created!");
  }
  
  void applyForce(Vec2 force) {
    body.applyForceToCenter(force);
  }
  
  void move(Vec2 dir) {
    Vec2 newVec = new Vec2(accel * (float)Math.cos(body.getAngle()-(PI/2)), accel * (float)Math.sin(body.getAngle()-(PI/2)));
    newVec = newVec.mul(dir.y);
    Vec2 newVec2 = new Vec2(accel * (float)Math.sin(body.getAngle()-(PI/2)), accel * (float)Math.cos(body.getAngle()-(PI/2)));
    newVec2 = newVec2.mul(dir.x);
    this.applyForce(newVec);
    this.applyForce(newVec2);
    
    //if the new speed is greater than the maxspeed, scale it down to maxspeed.
    Vec2 newVel = body.getLinearVelocity();
    if (newVel.length() > maxSpeed) {
      body.setLinearVelocity(newVel.mul((maxSpeed)/newVel.length()));
    }
  }
  
  void turnTowards(Vec2 pixPos) {
    Vec2 worldPos = box2d.coordPixelsToWorld(pixPos);
    Vec2 vecToMouse = worldPos.add(body.getPosition().mul(-1));
    float newAngle = PI/2 + (float)Math.atan2(vecToMouse.y,vecToMouse.x);
    body.setAngularVelocity(0);
    body.setTransform(body.getWorldCenter(), newAngle);
  }
  
  void shoot() {
    if (myWeapon != null) {
      myWeapon.shoot(this, this.body.getAngle());
    }
  }
  
  void update() {
    //next two lines set body to face direction of travel (although this is not what the final version needs).
    //float newAngle = (float) Math.atan2((double) body.getLinearVelocity().y, (double) body.getLinearVelocity().x); 
    //body.setTransform(body.getWorldCenter(), newAngle - ((float)Math.PI)/2.0f);
    if (health < 0) {
      actorControl.removeActor(this);
    }
    if (myWeapon != null) {
      myWeapon.update();
    }
    
    for (ContactEdge ce = body.getContactList(); ce != null; ce = ce.next) {
      Object other = ce.other.getUserData();
      if (other instanceof Actor) {
        Actor stranger = (Actor)other;
        if (myTeam == Team.HUMAN && stranger.myTeam == Team.ZOMBIE) {
          myTeam = Team.ZOMBIE;
          myWeapon = null;
          myColor = stranger.myColor;
          myType = stranger.myType;
          mainCamera.screenShake(50);
        }
      }
    }
    
  }
  
  void show() {
      Vec2 pixPos = box2d.getBodyPixelCoord(body);
      float angle = body.getAngle();
      
      rectMode(CENTER);
      pushMatrix();
      translate(pixPos.x, pixPos.y);
      rotate(-angle);
      fill(myColor);
      stroke(0);
      strokeWeight(1);
      rect(0, 0, myRadius, myRadius);
      if (myTeam == Team.ZOMBIE) {
        pushMatrix();
        translate(myRadius/2,(myRadius/4));
        rect(0,0,myRadius/4,myRadius);
        popMatrix();
        pushMatrix();
        translate(-myRadius/2,(myRadius/4));
        rect(0,0,myRadius/4,myRadius);
        popMatrix();
      }
      if (myTeam == Team.HUMAN && myType == Type.SOLDIER) {
        rect(0,myRadius/2,0,myRadius/2);
      }
      popMatrix();
  }
  
  void wasHit(Vec2 force, int damage) {
    this.applyForce(force);
    health -= damage;
  }
  
  void makeBody(Vec2 pos, float radius) {
    
    // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    float box2dr = box2d.scalarPixelsToWorld(radius/2);
    sd.setAsBox(box2dr,box2dr);

    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0;
    fd.restitution = 0.05;
    
    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(pos));

    body = box2d.createBody(bd);
    body.setAngularDamping(0.5);
    body.setLinearDamping(8);
    Fixture fix = body.createFixture(fd);
    body.setUserData(this);
    fix.setUserData(this);
  }
  
  void runBehaviour() {
    if (!isPaused && !creatorMode) {
      //This function carries out the default AI behaviour.
      Vec2 target = actorControl.player.body.getWorldCenter();
      Vec2 directionToTarget = target.add(body.getWorldCenter().mul(-1));
      float distToTarget = box2d.scalarWorldToPixels(directionToTarget.length());
      if (distToTarget < 200 && Math.random() < 0.001) {
        soundZ.trigger();
      }
      float newAngle = (float) Math.atan2((double)directionToTarget.y, (double)directionToTarget.x) + (PI/2);
      body.setTransform(body.getWorldCenter(),newAngle);
      body.setAngularVelocity(0);
      float moveChance = 1;
      if (actorControl.player.myTeam == Team.HUMAN) {
        moveChance = 1;
      } else {
        moveChance = 0.1;
      }
      if ((float)Math.random() <= moveChance) {
        move(new Vec2(0,1));
      }
    }
    
  }
  
}