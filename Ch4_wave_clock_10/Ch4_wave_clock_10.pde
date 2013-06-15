/* 
From Generative Art by Matt Pearsom

Really nice... wide aspect ratio!
Now... light on dark background!
*/

float ang = -PI/2;
float x1, y1, x2, y2;
float centerX, centerY;
float rad;
int col;
float xNoise, yNoise, angNoise, radNoise;
float thisRad;
int colStep = 1; // flips between +/- 

float scaleX, scaleY, scaleXY;

void setup() {
  size(1600, 900); // must be bigger scaleX, scaleY
  background(20);
  smooth();
  noFill();
  frameRate(12);
  
  rad = random(80, 100);
  col = 127;
  xNoise = random(10);
  yNoise = random(10);
  angNoise = random(10);
  radNoise = random(10);
  
  scaleX = width/299;
  scaleY = height/299;
  scaleXY = sqrt(scaleX * scaleY);
}

void draw() {
  ang += PI/180; // should increment by 1 degrees
  xNoise += 0.005;
  yNoise += 0.005;
  radNoise += 0.01;
  //colNoise += 0.5;
  
  thisRad = rad + scaleXY *( 60 * noise(radNoise) - 30 );
  //thisCol = col + ( 200 * noise(colNoise) ) - 100;
  
  centerX = width/2 + scaleX * ( 200 * noise(xNoise) - 100 );
  centerY = height/2 + scaleY * ( 200 * noise(yNoise) - 100 );
  
  x1 = (centerX + scaleX * 2 * (thisRad * cos(ang) ));
  x2 = (centerX - scaleX * 2 * (thisRad * cos(ang) ));
  y1 = (centerY + scaleY * 2 * (thisRad * sin(ang) ));
  y2 = (centerY - scaleY * 2 * (thisRad * sin(ang) ));
  col += colStep;
  
  if ( (col > 230) || (col < 10) ) {colStep *= -1;}

  stroke(col, scaleXY * 60);
  line(x1, y1, x2, y2);
  stroke(255-col, scaleXY * 15);
  line(x2, y1, x1, y2);
  
  if (ang > 2*PI) {ang -= 2*PI;}
}
