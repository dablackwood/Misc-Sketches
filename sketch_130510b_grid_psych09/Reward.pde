class Reward {
  int rewardValue = 100;
  float rewardX, rewardY;
  float xNoise, yNoise;
  final float NOISE_SCALE = 2;
  final float NOISE_RATE = 0.1;
  final float CENTERING_BIAS = 0.15; // from 0 to 1
  
  float xBias, yBias; // nudges toward center
  
  Reward(int tempRewardID) {
    rewardX = random(0.25 * width, 0.75 * width);
    rewardY = random(0.25 * height, 0.75 * height);    
//    println("Reward " + rewardX + " " + rewardY);
    xNoise = random(10);
    yNoise = random(10);
  }
  
  void display() {
    stroke(255,0,0);
    noFill();
    ellipse(rewardX, rewardY, 20, 20);
    
    xBias = map( rewardX, 0, width, CENTERING_BIAS / 2, -CENTERING_BIAS / 2);
    yBias = map( rewardY, 0, height, CENTERING_BIAS / 2, -CENTERING_BIAS / 2);
    
    rewardX += 2 * NOISE_SCALE * ( noise(xNoise) - 0.5 + xBias);
    rewardY += 2 * NOISE_SCALE * ( noise(yNoise) - 0.5 + yBias);
    
    xNoise += NOISE_SCALE;
    yNoise += NOISE_SCALE;
  }
  
  float[] location() {
    float[] loc = new float[2];
    loc[0] = rewardX;
    loc[1] = rewardY;
//    loc = [rewardX, rewardY];
    return loc;
  }
  
  float value() {
    return rewardValue;
  }
  
  void move() {
    rewardX = mouseX;
    rewardY = mouseY;
  }
}
