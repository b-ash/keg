/*
  Kegums
  Brewed on: October 14, 2013
  Authored by: Bryan Ash, Tim Hennekey
*/

int LED_PIN = 13;
int TEMP_PIN = A0;
int FLOW_METER_PIN = 2;

int POUR_INTERVAL_LOOPS = 60; // ~6 seconds
int TEMP_INTERVAL_LOOPS = 300; // ~30 seconds

int rawPulses = 0;
int rawPulsesPrev = 0;
int loopsAfterPourWithoutPulses = 0;
int tempCount = 0;

void resetPourCounters() {
  rawPulses = 0;
  rawPulsesPrev = 0;
  loopsAfterPourWithoutPulses = 0;
}

void sendPulsesToRaspberryPi() {
  Serial.print("pulses:");
  Serial.println(rawPulses, DEC);
}

void rpm() {
  rawPulses++;
}

void setup() {
  pinMode(LED_PIN, OUTPUT);
  pinMode(FLOW_METER_PIN, INPUT);
  Serial.begin(9600);
  attachInterrupt(0, rpm, RISING);
  sei();
}

void pourLoop() {
  // Has pouring stopped?
  if(rawPulses != 0 && rawPulses == rawPulsesPrev) {
    loopsAfterPourWithoutPulses += 1;
  }
  
  rawPulsesPrev = rawPulses;
  digitalWrite(LED_PIN, rawPulses > 0);
  
  // Send pulses to Raspberry Pi once pouring is done
  if(rawPulses != 0 && loopsAfterPourWithoutPulses >= POUR_INTERVAL_LOOPS) {
    if (rawPulses > 10) {
      sendPulsesToRaspberryPi();
    }
    resetPourCounters();
  }  
}

void tempLoop() {
  tempCount += 1;
  if (tempCount >= TEMP_INTERVAL_LOOPS) {
    tempCount = 0;
    int rawTemp = analogRead(TEMP_PIN);
    float temp = ((rawTemp / 1024.0 * 5 * 1000) - 500) / 10 * 9 / 5 + 32;
    Serial.print("temp:");
    Serial.println(temp, DEC); 
  }
}

void loop() {
  pourLoop();
  tempLoop();
  delay(100);
}
