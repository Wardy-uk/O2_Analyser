#include <LiquidCrystal.h>
#include <Adafruit_ADS1015.h>
#include <Wire.h>
#include <SPI.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SH1106.h>
#include <Fonts/FreeSans9pt7b.h>

#define OLED_RESET 4

Adafruit_SH1106 display(OLED_RESET);
Adafruit_ADS1115 ads(0x48);
LiquidCrystal lcd(7, 8, 9, 10, 11, 12);

int16_t rawADCvalue;
float scalefactor = 0.1875F;
float volts = 0.0;
float percent = 0.0;
float MOD = 0.0;
float FO2 = 0.0;
float PO2 = 1.4;
float BAR = 0.0;
float MODd = 0.0;
float BARd = 0.0;
float PO2d = 1.6;

float calibvolts = 0.0;

float calibrationM = 1.99;

int sensorValue = 0;
int sensorMin = 1023;
int sensorMax = 0;



void setup() {


       Serial.begin(9600);
       Wire.begin();
       ads.begin();
       lcd.begin(16, 2);
       display.begin(SH1106_SWITCHCAPVCC, 0x3C);
       display.display();
       delay(1000);
       
       display.clearDisplay();
       display.display();

  int battValue = analogRead(A0);    
  float voltage = battValue * (5.0 / 1024.0);
 
  // print out the value you read:
 
  Serial.print("Voltage: ");
 
  Serial.print(voltage);
 
  Serial.println(" V");
 
        lcd.clear();
       lcd.setCursor(0,0);
       lcd.print("Batt Check");
       lcd.setCursor(0,1);
       lcd.print(voltage);
       lcd.print(" V");

   display.setFont(&FreeSans9pt7b);
       display.setTextColor(WHITE);
       display.setCursor(10,20);
       display.print("Batt Check:");
       display.setCursor(10,45);
       display.print(voltage);
      display.setCursor(50,45);
       display.print("v");

       display.display();



       delay(5000);

       display.clearDisplay();
       display.display();

       lcd.clear();
       lcd.setCursor(0,0);
       lcd.print("Calibrating");
       lcd.setCursor(0,1);
       lcd.print("Please Wait");

       display.setFont(&FreeSans9pt7b);
       display.setTextColor(WHITE);
       display.setCursor(10,20);
       display.print("Calibrating:");
       display.setCursor(10,45);
       display.print("Please Wait!");

       display.display();

       delay(5000);

       display.clearDisplay();
       display.display();

       lcd.clear();       
       display.clearDisplay();
       display.display();

         
        float Averagereading = 0;
        int MeasurementsToAverage = 25;
        for(int i = 0; i < MeasurementsToAverage; ++i)
        {
        Averagereading += ads.readADC_Differential_0_1();
        delay(1);
        }
        Averagereading /= MeasurementsToAverage;
       
      

       display.clearDisplay();
       display.display();

       
       calibvolts = ((Averagereading * scalefactor)/1000.0)*1000;  //converts reading to mVn 

       
      
       lcd.clear();
       lcd.setCursor(0,0);
       lcd.print("sensorValue");
       lcd.setCursor(0,1);
       lcd.print(calibvolts);
       lcd.print(" mV");

       display.setFont(&FreeSans9pt7b);
       display.setTextColor(WHITE);
       display.setCursor(01,15);
       display.print("SensorValue:");       
       display.setCursor(01,40);
       display.print(calibvolts);
       display.setCursor(45,40);
       display.print(" mV");
       
       display.display();

       delay(2500);

       calibrationM = (20.9/calibvolts);

       display.clearDisplay();
       display.display();

       display.setFont(&FreeSans9pt7b);
       display.setTextColor(WHITE);
       display.setCursor(01,15);
       display.print("CalibValue:");       
       display.setCursor(01,40);
       display.print(calibrationM);

       display.display();

       lcd.clear();
       lcd.setCursor(0,0);
       lcd.print("CalibValue:");
       lcd.setCursor(0,1);
       lcd.print(calibrationM);
   
}

// to do 1) add in calibration process - Done
// to do 2) add in push button reset
// to do 3) add in conditonal PPO2 (> 50% 1.6 < 50% 1.4) - workaround
// to do 4) add in average to reading - Done
// to do 5) add self check - compare calib vaue to expected
// to do 6) add "freeze screen" to stop loop and freeze display
// to do 7) add reset to setup and main loop
// to do 8) add battery test to set up - Done

void loop() {

 
 
  
 




       float rawADCvalue = 0;
        int MeasurementsToAverage = 20;
        for(int i = 0; i < MeasurementsToAverage; ++i)
        {
        rawADCvalue += ads.readADC_Differential_0_1();
        delay(1);
        }
        rawADCvalue /= MeasurementsToAverage;

      //rawADCvalue = ads.readADC_Differential_0_1();
       
      volts = ((rawADCvalue * scalefactor)/1000.0)*1000;  //converts reading to mVn      
      percent = (volts*calibrationM);
      
      FO2 = (percent/100);
      
      BAR = (PO2/FO2);
      MOD = (BAR-1)*10;
      
      BARd = (PO2d/FO2);
      MODd = (BARd-1)*10;
      
         
      // print voltage:    
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("O2: ");
      lcd.print(percent,2);
      lcd.print(" %");

      //Print MOD
      
      lcd.setCursor(0, 1);
      lcd.print(MOD, 1);
      lcd.print(" m -> ");
      lcd.print(MODd, 1);
      lcd.print(" m");

      
      // display 3 lines of text
      display.clearDisplay();
      //display.display();
      display.setFont(&FreeSans9pt7b);
      //display.setTextSize(2);
      display.setTextColor(WHITE);
      display.setCursor(1,15);
      display.print("O2:");
      display.setCursor(45,15);
      display.print(percent,2);
      display.setCursor(95,15);
      display.print("%");
      

      display.setFont(&FreeSans9pt7b);
      //display.setTextSize(2);
      display.setTextColor(WHITE);
      display.setCursor(1,31);
      display.print("MOD:");

      display.setFont(&FreeSans9pt7b);
      //display.setTextSize(2);
      display.setTextColor(WHITE);
      display.setCursor(1,47);
      display.print("1.4 =");
      display.setCursor(45,47);
      display.print(MOD);
      display.setCursor(95,47);
      display.print("m");

      

      display.setFont(&FreeSans9pt7b);
      //display.setTextSize(2);
      display.setTextColor(WHITE);
      display.setCursor(1,63);
      display.print("1.6 =");
      display.setCursor(45,63);
      display.print(MODd);
      display.setCursor(95,63);
      display.print("m");
  
      // update display with all of the above graphics
      display.display();

  

      delay(1);
}
int getBandgap(void) // Returns actual value of Vcc (x 100)
    {

#if defined(__AVR_ATmega1280__) || defined(__AVR_ATmega2560__)
     // For mega boards
     const long InternalReferenceVoltage = 1115L;  // Adjust this value to your boards specific internal BG voltage x1000
        // REFS1 REFS0          --> 0 1, AVcc internal ref. -Selects AVcc reference
        // MUX4 MUX3 MUX2 MUX1 MUX0  --> 11110 1.1V (VBG)         -Selects channel 30, bandgap voltage, to measure
     ADMUX = (0<<REFS1) | (1<<REFS0) | (0<<ADLAR)| (0<<MUX5) | (1<<MUX4) | (1<<MUX3) | (1<<MUX2) | (1<<MUX1) | (0<<MUX0);
  
#else
     // For 168/328 boards
     const long InternalReferenceVoltage = 1056L;  // Adjust this value to your boards specific internal BG voltage x1000
        // REFS1 REFS0          --> 0 1, AVcc internal ref. -Selects AVcc external reference
        // MUX3 MUX2 MUX1 MUX0  --> 1110 1.1V (VBG)         -Selects channel 14, bandgap voltage, to measure
     ADMUX = (0<<REFS1) | (1<<REFS0) | (0<<ADLAR) | (1<<MUX3) | (1<<MUX2) | (1<<MUX1) | (0<<MUX0);
       
#endif
     delay(50);  // Let mux settle a little to get a more stable A/D conversion
        // Start a conversion  
     ADCSRA |= _BV( ADSC );
        // Wait for it to complete
     while( ( (ADCSRA & (1<<ADSC)) != 0 ) );
        // Scale the value
     int results = (((InternalReferenceVoltage * 1024L) / ADC) + 5L) / 10L; // calculates for straight line value 
     return results;
    }