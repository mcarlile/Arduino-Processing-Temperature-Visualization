#include <TinkerKit.h>

TKThermistor therm(I0);       // creating the object 'therm' that belongs to the 'TKThermistor' class 
                              // and giving the value to the desired output pin

float C, F;		      // temperature readings are returned in float format

TKLed led(O0);	// creating the object 'led' that belongs to the 'TKLed' class 
		// and giving the value to the desired output pin

void setup() 
{
  // initialize serial communications at 9600 bps
  Serial.begin(9600);
}

void loop() {
  F = therm.readFahrenheit();  	// Reading the temperature in Fahrenheit degrees and store in the F variable

  // Print the collected data in a row on the Serial Monitor
  Serial.print("Analog reading: ");	// Reading the analog value from the thermistor
  Serial.print(therm.read());
  Serial.print("\tC: ");
  Serial.print(C);
  Serial.print("\tF: ");
  Serial.println(F);

  delay(3000);                // Wait one second before get another temperature reading
if (F > 75.00)
{
  led.on();       // set the LED on
}
else if (F <= 75.00)
{
  led.off();      // set the LED off
}
}
