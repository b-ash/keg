/*
  Kegums
  Brewed on: October 14, 2013
  Authored by: Bryan Ash, Tim Hennekey
*/

int LED_PIN = 13;
int FLOW_METER_PIN = 2;
int LOOPS_TO_WAIT_BEFORE_SENDING = 400; // ~6 seconds

int rawPulses = 0;
int pulseTracker = 0;
int loopsAfterPourWithoutPulses = 0;


/*******
 Helpers
 *******/
void listenForInterrupts() {
  sei();  // Enable interrupts
  delay(15);
  cli();  // Disable interrupts
}

void resetCounters() {
  rawPulses = 0;
  pulseTracker = 0;
  loopsAfterPourWithoutPulses = 0;
}

void sendPulsesToRaspberryPi() {
  Serial.print("pulses:");
  Serial.println(pulseTracker, DEC);
}

/***********************
 Arduino function hooks 
 ***********************/
void rpm() {
  rawPulses++;
}

void setup() {
  pinMode(LED_PIN, OUTPUT);
  pinMode(FLOW_METER_PIN, INPUT);
  Serial.begin(9600);
  attachInterrupt(0, rpm, RISING);
}

void loop() {
  listenForInterrupts();

  // Has pouring stopped?
  if(rawPulses != 0 && rawPulses == pulseTracker) {
    loopsAfterPourWithoutPulses += 1;
  }
  
  pulseTracker = rawPulses;
  
  // Send pulses to Raspberry Pi once pouring is done
  if(rawPulses != 0 && loopsAfterPourWithoutPulses >= LOOPS_TO_WAIT_BEFORE_SENDING) {
    sendPulsesToRaspberryPi();
    resetCounters();
  }
}
