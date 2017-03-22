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
  float maxSpeed = 20;
  float turnSpeed = (2 * PI / 360) * 3;
  int health = 100;
  
  Body body; //The actor's physics simulation body.
  
  public Actor(Vec2 pos, boolean isPlayer, Team team, Type type) {
    this.isPlayer = isPlayer;
    myTeam = team;
    if (myTeam == Team.ZOMBIE) {
      myColor = color(100,200,100);
      health = 5000;
      maxSpeed = maxSpeed * 1.1;
    } else if (myTeam == Team.HUMAN) {
      myColor = color(100,100,200);
      myWeapon = new Weapon();
    } else {
      myColor = color(150,150,150);
    }
    myType = type;
    if (myType == Type.BIG_ZOMBIE) {
      myRadius = 30;
    } else {
      myRadius = 20;
    }
    if (isPlayer) {
      pos = new Vec2(width/2,height/2);
    }
    
    makeBody(pos, myRadius);
    System.out.println("New player created!");
  }
  
  void applyForce(Vec2 force) {
    body.applyForceToCenter(force);
  }
  
  void move(float direction) {
    Vec2 newVec = new Vec2(accel * (float)Math.cos(body.getAngle()-(PI/2)), accel * (float)Math.sin(body.getAngle()-(PI/2)));
    newVec = newVec.mul(direction);
    this.applyForce(newVec);
    
    //if the new speed is greater than the maxspeed, scale it down to maxspeed.
    Vec2 newVel = body.getLinearVelocity();
    if (newVel.length() > maxSpeed) {
      body.setLinearVelocity(newVel.mul((maxSpeed)/newVel.length()));
    }
  }
  
  void turn(float direction) {
    float newAngle = body.getAngle() + (direction * turnSpeed);
    body.setAngularVelocity(0);
    body.setTransform(body.getWorldCenter(), newAngle);
  }
  
  void shoot() {
    Vec2 textPos = box2d.getBodyPixelCoord(body);
    fill(255);
    textSize(12);
    text("pew pew", textPos.x, textPos.y + myRadius + 10);
    myWeapon.shoot(this, this.body.getAngle());
  }
  
  void update() {
    //next two lines set body to face direction of travel (although this is not what the final version needs).
    //float newAngle = (float) Math.atan2((double) body.getLinearVelocity().y, (double) body.getLinearVelocity().x); 
    //body.setTransform(body.getWorldCenter(), newAngle - ((float)Math.PI)/2.0f);
    if (health < 0) {
      box2d.world.destroyBody(body);
      actorControl.removeActor(this);
    }
    if (myWeapon != null) {
      myWeapon.update();
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
      if (isPlayer) {
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
      float newAngle = (float) Math.atan2((double)directionToTarget.y, (double)directionToTarget.x) + (PI/2);
      body.setTransform(body.getWorldCenter(),newAngle);
      body.setAngularVelocity(0);
      move(1);
    }
    
  }
  
}