// :::::: Voltage Protector for ATtiny13 ::::::
// ::::::   Code By Mohammad Ghaffari    ::::::
// ::::::  https://github.com/mhmdght    :::::: 
 
#include <tiny13.h>
#include <delay.h>

// Config
// Delay Timer
unsigned char start_time = 20;

// Pin definitions
// PB0 = Relay
// PB1 = Red LED
// PB2 = Yellow LED
// PB3 = Green LED
// PB4 = Voltage reading (ADC2)

unsigned char vwarn = 0;
unsigned char vsafe = 0;
unsigned char analog = 0;

// Function prototypes
void voltage(void);
void warning(void);
void wait(void);
void normal(void);

void voltage() {
  // Read ADC value from PB4 (ADC2)
  ADMUX = (1 << REFS0) | (1 << ADLAR) | 2;
  ADCSRA = (1 << ADEN) | (1 << ADPS2) | (1 << ADPS1);
  ADCSRA = ADCSRA | (1 << ADSC);
  while (ADCSRA & (1 << ADSC));
  
  analog = ADCH;
  
  // Thresholds: 1.065V = ~54, 0.795V = ~40
  if (analog >= 54 || analog <= 40) {
    vsafe = 0;
  }
  else {
    vsafe = 1;
  }
}

void warning() {
  vwarn = 1;
  PORTB.0 = 0;  // Relay OFF
  PORTB.2 = 1;  // Yellow ON
  PORTB.1 = 1;  // Red ON
  PORTB.3 = 0;  // Green OFF
  delay_ms(50);
  PORTB.1 = 0;  // Red OFF
}

void wait(){
  //second to milisecond
  long wait_time = start_time * 1000;

  //Remove Voltage Warning
  vwarn = 0;
  //Yellow LED
  PORTB.2 = 1;
  //wait before start
  delay_ms(wait_time);
  voltage();
    if (vsafe==0){
    //Warning For Under/Over Voltage
    warning();
  }
}

void normal() {
  PORTB.2 = 0;  // Yellow OFF
  PORTB.1 = 0;  // Red OFF
  PORTB.3 = 1;  // Green ON
  PORTB.0 = 1;  // Relay ON
}

void main() {
  // Setup INPUT/OUTPUT pins
  DDRB.0 = 1;  // PB0 output
  DDRB.1 = 1;  // PB1 output
  DDRB.2 = 1;  // PB2 output
  DDRB.3 = 1;  // PB3 output
  DDRB.4 = 0;  // PB4 input
  
  // Disable AC output
  PORTB.0 = 0;
  
  // First Check Voltage
  voltage();
  if (vsafe == 0) {
    warning();
  }
  else {
    wait();
  }
  
  while(1) {
    voltage();
    
    if (vsafe == 1 && vwarn == 0) {
      normal();
    }
    else if (vsafe == 1 && vwarn == 1) {
      wait();
    }
    else {
      warning();
    }
  }
}