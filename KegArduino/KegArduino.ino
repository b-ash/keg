/*
  Kegums
  Brewed on: October 14, 2013
  Authored by: Bryan Ash, Tim Hennekey, Trevor Rundell
*/

int POUR_LED_PIN = 13;
int TEMP_SENSOR_PIN = A0;
int FLOW_METER_PIN = 2;

int POUR_INTERVAL_LOOPS = 60; // ~6 seconds
int TEMP_INTERVAL_LOOPS = 300; // ~30 seconds
int POUR_DEBOUNCE_PULSES = 170;

int rawPulses = 0;
int rawPulsesPrev = 0;
int lastPourSend = 0;
int loopsAfterPourWithoutPulses = 0;
int tempCount = 0;

void resetPourCounters() {
  rawPulses = 0;
  rawPulsesPrev = 0;
  lastPourSend = 0;
  loopsAfterPourWithoutPulses = 0;
}

void sendPourToSerial() {
  Serial.print("pour:");
  Serial.println(rawPulses, DEC);
}

void sendPourEndToSerial() {
  Serial.print("pour-end:");
  Serial.println(rawPulses, DEC);
}

void rpm() {
  rawPulses++;
}

void setup() {
  pinMode(POUR_LED_PIN, OUTPUT);
  pinMode(FLOW_METER_PIN, INPUT);
  Serial.begin(9600);
  attachInterrupt(0, rpm, RISING);
  sei();
}

void pourLoop() {
  if (rawPulses <= 0) {
    return;
  }

  Serial.print('info:raw pulses:');
  Serial.println(rawPulses, DEC);

  if (rawPulses == rawPulsesPrev) {
    loopsAfterPourWithoutPulses += 1;
  }

  rawPulsesPrev = rawPulses;
  boolean pouring = rawPulses > POUR_DEBOUNCE_PULSES;
  boolean finished = loopsAfterPourWithoutPulses >= POUR_INTERVAL_LOOPS;
  digitalWrite(POUR_LED_PIN, pouring && !finished);

  if (pouring) {
    if (rawPulses - lastPourSend >= 150) {
      sendPourToSerial();
      lastPourSend = rawPulses;
    }
    if (finished) {
      sendPourEndToSerial();
    }
  }

  if (finished) {
    resetPourCounters();
  }
}

/**
 * see http://learn.adafruit.com/tmp36-temperature-sensor
 */
void tempLoop() {
  tempCount += 1;
  if (tempCount >= TEMP_INTERVAL_LOOPS) {
    tempCount = 0;
    int rawTemp = analogRead(TEMP_SENSOR_PIN);
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
