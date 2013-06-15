class Creature {
  float xPos, yPos;
  int rotation, oldRotation;
  
  float step;
  float stepNoise;
  final float STEP_NOISE_RATE = 0.02;
  final float BASE_STEP = 10;
  final float STEP_SCALE = 2; // impact of stepNoise on step length
  
  final float LEARN_RATE = 0.01;
  float expectation = 0.0;
  float distance; // to reward
  final float THRESHOLD = 100; // within this distance, reward is granted
  float vector; // angle to Reward in radians  
  float vectorX, vectorY;
  float affinity; // initial impact of reward on step length
  final float MIN_AFFINITY = 2;
  final float MAX_AFFINITY = 9;
  
  int ID;
  
  Creature( int tempID ) {
    ID = tempID;
    xPos = width/2;
    yPos = height/2;
    oldRotation = int(random(4)); // can be 0 to 3
    
    step = BASE_STEP;
    stepNoise = random(10);    
//    println("myReward??? " + myRewardX + " " + myRewardY);
  }
  
  void display() {
//    println("myReward???????? " + myRewardX + " " + myRewardY);
    stroke( 255 * (ID % 2), 0, 0);
    
//    println( degrees(vector) );
    
    step = BASE_STEP + 2 * STEP_SCALE * ( noise(stepNoise) - 0.5);
    stepNoise += STEP_NOISE_RATE;
    
    // Here's the reward sensing part...
    
    if (ID % 2 == 1) { // Reds driven to reward
      distance = dist( myRewardX, myRewardY, xPos, yPos);
      if ( distance < THRESHOLD ) {
        // Reward recieved. Increase expectation.
        
        expectation += LEARN_RATE * (myRewardValue - expectation);
//        println( ID + " Expectation " + expectation);
        
        affinity = map( expectation, 0, myRewardValue, MIN_AFFINITY, MAX_AFFINITY);
                
      }
      vectorX = (myRewardX - xPos) / distance;
      vectorY = (myRewardY - yPos) / distance;
      vector = acos( vectorX );
      
      if ( vectorY < 0) {
        vector = TWO_PI - vector;
      }
      
      step += cos(HALF_PI * rotation) * vectorX * affinity;
      step += sin(HALF_PI * rotation) * vectorY * affinity;
    }
    
  
    rotation = ( oldRotation + 2 + int(random(1, 4)) ) % 4;
    // can go in any direction except back where it came from
    
  //  oldx = xPos;
  //  oldy = yPos;
    
    xPos += ( step * cos(HALF_PI * rotation) );
    yPos += ( step * sin(HALF_PI * rotation) );
    
    if ( xPos <= width && yPos <= height && xPos >= 0 && yPos >= 0) {
  //    line(oldx, oldy, xPos, yPos);
      pushMatrix();
      translate(xPos, yPos);
      rotate(HALF_PI * rotation);
  //    line(0,0, step, 0);
      line(0,0, - step, 0);
      popMatrix();
      
    } else {
      xPos = (width + xPos) % width;
      yPos = (height + yPos) % height;
    }
    
    oldRotation = rotation;
    
//    println(ID + " " + step);
  }
}

