/*
matches up with arduino sketch:
sketch_jul13b_photo_TH_02

include onformative YahooWeather library.
*/

import processing.serial.*;
import com.onformative.yahooweather.*;

YahooWeather weather;
int wUpdate = 30000; // milliseconds

Serial port;
String val;
int lf = 10;
float temp, humidity;
int light;
int ten_t; // 10 * temp (converted to fahrenheit)
int ten_h; // 10 * humidity
//float xpos, ypos;
final int MIN_TEMP = 30; // fahrenheit
final int MAX_TEMP = 80; // fahrenheit


int officialT, officialH;


void setup() {
  size(800,600);
  smooth();
  frameRate(1);
  
  println(Serial.list() );
  String arduinoPort = Serial.list()[1];
  port = new Serial(this, arduinoPort, 9600);
  port.bufferUntil(lf); // line feed
  
  ellipseMode(CENTER);
  
  // 2473224 = the WOEID of Pittsburgh
  // use this site to find out about your WOEID : 
  // http://sigizmund.info/woeidinfo/
  weather = new YahooWeather(this, 2473224, "f", wUpdate);
  
}

void draw() {
//  weather.update();
  
//  drawDot( ten_t, ten_h );
//  int officialT = weather.getTemperature();
//  int officialH = weather.getHumidity();
//  drawDot( 10*officialT, 10*officialH);
  
  }

void serialEvent(Serial p) {
  val = p.readString();
  val = trim(val);
  
  String[][] valString = matchAll(val, "(\\d+\\.\\d+)");
//  println(val); // raw text from arduino
  
  humidity = float(valString[0][1] );
  temp = float(valString[1][1] );
  light = int(valString[2][1] );
  ten_h = int(10 * humidity);
  ten_t = int(10 * (1.8 * temp + 32));
  println((ten_h / 10.0) +" "+ (ten_t / 10.0) +" "+ light); 
  drawDot( ten_t, ten_h );
  
  weather.update();
  // trying to update weather whenever arduino pushes an update
  int officialT = weather.getTemperature();
  int officialH = weather.getHumidity();
  String condition = weather.getWeatherCondition();
  println(officialH +" "+ officialT +" "+ condition); 
  drawDot( 10*officialT, 10*officialH);
  
  drawLine( 10*officialT, 10*officialH, ten_t, ten_h );
  
} 

void drawDot( int tempTenTemp, int tempTenHumidity ) {
  int tenTemp = tempTenTemp;
  int tenHumidity = tempTenHumidity;
//  println("Drawing " + tenHumidity +" "+ tenTemp);
  noStroke();
  fill( map(light, 0,1023, 0,255) );
  
  // x-axis is temperature. y-axis is humidity.
  ellipse( mapT(tenTemp), mapH(tenHumidity), 4,4);
}

void drawLine(  int tempOfficialT, int tempOfficialH, int tempT, int tempH ) {
  // All inputs 10*value
  int officialT = tempOfficialT;
  int officialH = tempOfficialH;
  int T = tempT;
  int H = tempH;
    
  strokeWeight(2);
  stroke( map(light, 0,1023, 0,255) );
  noFill();
  line( mapT(officialT), mapH(officialH), mapT(T), mapH(H) );
  
}

float mapT( int tempTenTemp ){
  int tenTemp = tempTenTemp;
  return map( tenTemp, 10*MIN_TEMP, 10*MAX_TEMP, 0,width);
}

float mapH( int tempTenHumidity ){
  int tenHumidity = tempTenHumidity;
  return map( tenHumidity, 0,1000, height,0);
}
