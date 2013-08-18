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
float light;

void setup() {
  size(400,400);
  println(Serial.list() );
  String arduinoPort = Serial.list()[1];
  port = new Serial(this, arduinoPort, 9600);
  port.bufferUntil(lf); // line feed
}

void draw() {
  }

void serialEvent(Serial p) {
  val = p.readString();
  val = trim(val);
  
  String[][] valString = matchAll(val, "(\\d+\\.\\d+)");
  println(val); 
  
  humidity = float(valString[0][1] );
  temp = float(valString[1][1] );
  light = float(valString[2][1] );
  println(humidity +" "+ temp +" "+ light); 
} 
