/*
matches up with arduino sketch:
sketch_jul13b_photo_TH_02
*/

import processing.serial.*;

Serial port;
String val;
int lf = 10;
float temp;
float humidity;
int light;
int ten_t; // 10 * temp (converted to fahrenheit)
int ten_h; // 10 * humidity
float xpos;
float ypos;


void setup() {
  size(800,600);
  smooth();
  frameRate(1);
  
  println(Serial.list() );
  String arduinoPort = Serial.list()[0];
  port = new Serial(this, arduinoPort, 9600);
  port.bufferUntil(lf); // line feed
  
  ellipseMode(CENTER);
}

void draw() {
  noStroke();
  fill( map(light, 0,1023, 0,255) );
  
  // x-axis is temperature. y-axis is humidity.
  xpos = map( ten_t, 600, 900, 0,width);
  ypos = map( ten_h, 300,1000, height,0);
  
  ellipse(xpos,ypos, 4,4);
  }

void serialEvent(Serial p) {
  val = p.readString();
  val = trim(val);
  
  String[][] valString = matchAll(val, "(\\d+\\.\\d+)");
  println(val); 
  
  humidity = float(valString[0][1] );
  temp = float(valString[1][1] );
  light = int(valString[2][1] );
  ten_h = int(10 * humidity);
  ten_t = int(10 * (1.8 * temp + 32));
  println(ten_h +" "+ ten_t +" "+ light); 
} 
