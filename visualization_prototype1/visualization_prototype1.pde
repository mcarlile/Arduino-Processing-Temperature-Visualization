import controlP5.*;
import processing.serial.*;

Serial myPort;  // Create object from Serial class
String inString;      // Data received from the serial port
float numFloat; 
int time;
int counter0 = 3;
int counter1 = 7;
int counter2 = 3;

int wait = 1000;
int sizeMultiplier = 3;
float exponent = 1.1; 
float sizer;
float radius = 500;
float scaledRadius = 0;
float scaledMin;
float scaledMax;

float y = 1;
float targetRadiusMin = 83;
float targetRadiusMax = 85;
float extremeRadiusMax = 95;
float player1score = 0;
float startTime, currTime;
float hitTime;
String player1FeedbackMessage;

boolean round1begin = false;
boolean round1over = false;
boolean round2over = false;
boolean round2begin = false;

ControlP5 cp5;
Slider2D s;
float player1 = 82.5;
int sliderTicks1 = 100;
int sliderTicks2 = 30;
Slider abc;
float smoother = 0;

void setup() {
  if (player1 >= targetRadiusMax) {
    exponent = 3;
  } 
  else {
    exponent = 1.1;
  }


  String portName = Serial.list()[5];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil(10);
  time = millis();//store the current time
  size (displayWidth, displayHeight);
  cp5 = new ControlP5(this);

  //create player1 temperature slider
  cp5.addSlider("player1")
    .setPosition(width/2, height/4)
      .setRange(70, 100)
        ;
  smooth();
}

void serialEvent(Serial p) {
  inString = (p.readString());
  try {
    numFloat = Float.parseFloat(inString);
    //    player1 = abs(numFloat);
    //player1 = player1 * 0.95f + abs(numFloat) * 0.05f;
  } 
  catch(Exception e) {
  }
}

void draw () {

  if (round1begin == false) {
    background(0);
    fill(255);
    y = y + second();
    int s = second();
    if (millis() - time >= wait) { //every second
      if (counter0 >= 1) {
        counter0--;
      }
      if (counter0 < 1) {
        round1begin = true;
      }
      time = millis();//also update the stored time

      textSize(18);
    }

    currTime = millis() - startTime;
    if ( currTime >= hitTime )
    {
      startTime = millis();
    }
    text("Player 1, prepare to incubate in: " + counter0, width/2, height/2);
  }





  //round1 code
  if ((counter1 > 0) && (round1begin == true) && (round1over != true)) {
    //    scaledRadius = (radius * Scaling((smoother - targetRadiusMin)/(targetRadiusMax - targetRadiusMin)));
    scaledRadius = (radius * ((smoother - targetRadiusMin)/(targetRadiusMax - targetRadiusMin)));
    scaledMin = targetRadiusMin;
    scaledMax = targetRadiusMax;


    sizer = (pow(player1, exponent) * sizeMultiplier);
    println(sizer);
    background(0);
    noStroke();
    y = y + second();
    int s = second();
    if (millis() - time >= wait) { //every second
      if (counter1 >= 1) {
        counter1--;
      }
      if (counter1 < 1) {
        round1over = true;
      }
      println(counter1);//
      time = millis();//also update the stored time
    }

    currTime = millis() - startTime;
    if ( currTime >= hitTime )
    {
      startTime = millis();
    }

    //player 1 code
    //player out of range
    if ((smoother < targetRadiusMin) || (smoother > targetRadiusMax)) {
      fill(255, 0, 0, 255); //red
      player1FeedbackMessage = "temperature outside acceptable range";
    } 
    else {
      fill(0, 255, 0, 255); //green
      player1FeedbackMessage = "temperature inside acceptable range";
      player1score++;
    }

    //    ellipse (width/2, height/2, (scaledRadius), (scaledRadius));
    ellipse (width/2, height/2, (scaledRadius), (scaledRadius));

    textAlign(CENTER, CENTER);
    fill(255);
    text(player1FeedbackMessage, width/2, 350);
    textSize(18);
    text("current temperature: " + player1, width/2, 375); 
    text("Player 1 score: " + player1score, width/2, 45); 
    text("Seconds remaining: " + counter1, width/2, 20); 


    //  //minimum range indicator
    fill(0, 0, 0, 0);
    strokeWeight(1);
    stroke(255);
    ellipse (width/2, height/2, (scaledMin), (scaledMin));

    //    //maximum range indicator
    fill(0, 0, 0, 0);
    strokeWeight(1);
    stroke(255);
    ellipse (width/2, height/2, (scaledMax), (scaledMax));

    //radius indicator
    fill(0, 0, 0, 0);
    strokeWeight(3);
    stroke(255);
    ellipse (width/2, height/2, (radius), (radius));

    //smoothing code
    smoother = smoother * 0.95f + player1 * 0.05f;
  }




  //message between rounds
  if ((round1over == true) && (round2begin != true)) {
    background(0);
    fill(255);
    y = y + second();
    int s = second();
    if (millis() - time >= wait) { //every second
      if (counter2 >= 1) {
        counter2--;
      }
      if (counter2 < 1) {
        round2begin = true;
      }
      time = millis();//also update the stored time

      textSize(18);
    }

    currTime = millis() - startTime;
    if ( currTime >= hitTime )
    {
      startTime = millis();
    }
    text("Player 1, prepare to incubate in: " + counter2, width/2, height/2);
  }
}

float Scaling (float x) {
  if (x<=0) {
    return 0;
  } 
  else if ((x>0) && (x<= (1/2f))) {
    return (float)(sq(x-2)/2f);
  } 
  else if ((x>(1/2f)) && (x<= 1)) {
    return (float)(( sqrt((x+(1/2f))*2)/2f) + (1/2f));
  }
  else
    return (float)1;
}

