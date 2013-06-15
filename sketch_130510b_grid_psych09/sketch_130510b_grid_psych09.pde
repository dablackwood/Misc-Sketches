/* Adapting from Artificial Behavior: Computer Simulation of
Psychological Processes, by Gene D. Steinhauer 

Each "Creature" can walk north, south, east, or west.
Adjusts length of step to create a change of velocity.
Relative position of Reward drives adjustment to velocity.
Two groups: 1. affected by reward and 2. not

- Add a threshold radius around the reward.
- Each time the Creature crosses threshold, 
  increase its affinity using learning curve.
- Reward moves with noise, heads toward center, and 
  relocates when mouse is clicked.

Next steps:  
- Add multiple rewards.
- Make reward have different values.
- Make creatures with different learning rates.
- Giving / withholding reward randomly within threshold.

**********************************/

Creature[] myCreature;
final int CREATURE_COUNT = 600;

Reward myReward;
//final int REWARD_COUNT = 1;

float myRewardX, myRewardY; // to allow Creature to know location of Reward
float myRewardValue; // to allow Creature to be rewarded

void setup() {
  size(displayWidth,displayHeight);
  background(200);
  smooth();
  frameRate(20);
  strokeWeight(2);
  
  myCreature = new Creature[CREATURE_COUNT];
  for (int i = 0; i < CREATURE_COUNT; i++) {
    myCreature[i] = new Creature(i); 
  }
  
  myReward = new Reward(0);

}

void draw() {
  myReward.display();
  
  myRewardX = myReward.location()[0];
  myRewardY = myReward.location()[1];  
//  println("myReward " + myRewardX + " " + myRewardY);
  myRewardValue = myReward.value();
  
  for (int i = 0; i < CREATURE_COUNT; i++) {
    myCreature[i].display();
  }
  
  fill(255, 40);
//  stroke(2);
  noStroke();
  rect(0,0,width,height);
  
}

void mousePressed() {
  myReward.move();
}
