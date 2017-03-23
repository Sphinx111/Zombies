class StateManager {
  
  int framesToReset = 120; 
  int DEATH_NULL = 999999;
  int playerDeathMoment = DEATH_NULL;
  boolean startingReset = false;
 
 void update() {
   if (actorControl.player.myTeam == Team.ZOMBIE && !startingReset) {
     playerDeathMoment = frameCount;
     startingReset = true;
   }
   
   if (startingReset) {
     fill(255,0,0);
     textSize(22);
     text("You were killed",width/2 + 40,height/2 + 40);
     textSize(12);
   }
   
   if (frameCount >= playerDeathMoment + framesToReset) {
     performCleanup();
     actorControl = new ActorController(15);
     mapHandler.loadMap("testMap.txt");
     playerDeathMoment = DEATH_NULL;
     startingReset = false;
   }
   
 }
 
 void performCleanup() {
   for (Actor a : actorControl.actorsInScene) {
     actorControl.removeActor(a);
   }
   actorControl.cleanup();
 }
  
}