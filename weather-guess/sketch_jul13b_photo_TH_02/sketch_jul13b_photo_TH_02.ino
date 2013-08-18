/* 
DHT Written by ladyada, public domain
Photodiode (photovoltaic mode) + OpAmp
From Sensors class @ HackPgh.

Adapted for use with Processing... minimal output.

*/

#include "DHT.h"

#define DHTPIN 2     // what pin we're connected to
#define DHTTYPE DHT22   // DHT 22  (AM2302)
// Connect pin 1 (on the left) of the sensor to +5V
// Connect pin 2 of the sensor to whatever your DHTPIN is
// Connect pin 4 (on the right) of the sensor to GROUND
// Connect a 10K resistor from pin 2 (data) to pin 1 (power) of the sensor
DHT dht(DHTPIN, DHTTYPE);

const int inPin = A0;
const float alpha = 0.8; // filter strength
float fValue = 0; // for filter

void setup() {
  Serial.begin(9600); 
 
  dht.begin();
}

void loop() {
  // Reading temperature or humidity takes about 250 milliseconds!
  // Sensor readings may also be up to 2 seconds 'old' (its a very slow sensor)
  float h = dht.readHumidity();
  float t = (dht.readTemperature() ); //* 1.8) + 32;
  
  float inValue = 0;
  for (int i=0; i<20; i++) {
    inValue += analogRead(inPin);
  }
  inValue /= 10;
  fValue = (inValue * alpha) + (fValue * (1-alpha) );
  
  delay(2000); // pause for reading

  // check if returns are valid, if they are NaN (not a number) then something went wrong!
  if (isnan(t) || isnan(h)) {
    Serial.println("Failed to read from DHT");
  } else {
    Serial.print("Humidity: "); 
    Serial.print(h);
    Serial.print("%  ");
    Serial.print("Temp: "); 
    Serial.print(t);
    Serial.print("*C"); // changed from C
  }
  Serial.print("  Light: ");
  Serial.println(fValue);
}
