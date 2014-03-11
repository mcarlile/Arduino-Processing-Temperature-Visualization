import controlP5.*;
import processing.serial.*;

Serial myPort;  // Create object from Serial class
String inString;      // Data received from the serial port
float numFloat; 
int time;
int counter0 = 5;
int counterDefinition = 10;

int counter1 = 5;
int counter2 = 3;
float greenValue = 255;

int wait = 1000;
int sizeMultiplier = 3;
float exponent = 1.1; 
float sizer;
float radius = 5; // not really radius, should be refactored to something more appropriate
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
String definition;
String subtitle;

boolean round0end = false;
boolean tutorialBegin = false;
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
float smoother = 85;

PImage title1;
PImage nestEggBackground;
PFont chickenScratch;

void setup() {
  title1 = loadImage("title1.png");
  nestEggBackground = loadImage("eggbackground.png");
  chickenScratch = createFont("ChickenScratchAOE", 32);
  textFont(chickenScratch);
  subtitle = "/ ˈbrü-de / ";
  definition = "being in a state of readiness to brood eggs that is characterized by cessation of laying and by marked changes in behavior and physiology.";



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
  //  cp5.addSlider("player1")
  //    .setPosition(width/2, height/4)
  //      .setRange(70, 100)
  //        ;
  //  smooth();
}

void serialEvent(Serial p) {
  inString = (p.readString());
  try {
    numFloat = Float.parseFloat(inString);
    player1 = abs(numFloat);
    //player1 = player1 * 0.95f + abs(numFloat) * 0.05f;
  } 
  catch(Exception e) {
  }
}

void draw () {

  if ((round1begin == false) && (round0end == false)) {
    background(255);
    fill(0);
    imageMode(CENTER);
    image(title1, width/2, height/2, width, height);    

    y = y + second();
    int s = second();
    if (millis() - time >= wait) { //every second
      if (counter0 >= 1) {
        counter0--;
      }
      if (counter0 < 1) {
        tutorialBegin = true;
        round0end = true;
      }
      time = millis();//also update the stored time
    }
    textSize(48);
    text("Player 1, prepare to incubate in: " + counter0, 80, ((height/4)*3));

    currTime = millis() - startTime;
    if ( currTime >= hitTime )
    {
      startTime = millis();
    }
  }

  if (tutorialBegin == true) {
    background(0);
    println (counterDefinition);
    y = y + second();
    int s = second();
    if (millis() - time >= wait) { //every second


      if ((counterDefinition <= 10) && (counterDefinition >= 1)) {
        counterDefinition--;
        subtitle = "how to win";
        definition = "keep your eggs within 83 and 85 degrees so they can incubate properly! the player (bird) who keeps their eggs within the nominal range more often is the winner.";
      }

      if (counterDefinition < 1) {
        round1begin = true;
      }
      time = millis();//also update the stored time
    }


    fill(255);
    textAlign(CENTER, CENTER);
    textSize(48);
    text(subtitle, width/2, height/2);
    textSize(36);
    textAlign(LEFT, LEFT);
    text(definition, width/4, height/2+50, width/2, 300);  // Text wraps within text box

    currTime = millis() - startTime;
    if ( currTime >= hitTime )
    {
      startTime = millis();
    }
  }



  //round1 code
  if ((counter1 > 0) && (round1begin == true) && (round1over != true)) {

    //    scaledRadius = (radius * Scaling((smoother - targetRadiusMin)/(targetRadiusMax - targetRadiusMin)));
    //    scaledRadius = (radius * ((smoother - targetRadiusMin)/(targetRadiusMax - targetRadiusMin)));
    scaledRadius = (smoother * radius);
    scaledMin = targetRadiusMin * radius;
    scaledMax = targetRadiusMax * radius;

    background(255);
    image(nestEggBackground, width/2, height/2, width, height);    
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
    }
    else {
      fill(255, 255, 0, 255); //yellow
      player1score++;
    }

    //    ellipse (width/2, height/2, (scaledRadius), (scaledRadius));
    ellipse (width/2, height/2, (scaledRadius), (scaledRadius));


    textAlign(CENTER, CENTER);
    fill(0);
    textSize(72);
    textAlign(LEFT, CENTER);
    text("Seconds remaining: " + counter1, 30, 30); 
    textAlign(RIGHT, CENTER);
    text("Player 1 score:  " + player1score, width-30, 30); 
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(100);
    text(player1, width/2, height/2); 

    //    text("current temperature: " + player1, width/2, 400); 



    //  //minimum range indicator
    fill(0, 0, 0, 0);
    strokeWeight(1);
    stroke(0);
    ellipse (width/2, height/2, (scaledMin), (scaledMin));

    //    //maximum range indicator
    fill(0, 0, 0, 0);
    strokeWeight(1);
    stroke(0);
    ellipse (width/2, height/2, (scaledMax), (scaledMax));

    //smoothing code
    smoother = smoother * 0.95f + player1 * 0.05f;
  }

  //message between rounds
  if ((round1over == true) && (round2begin != true)) {
    background(0);
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
    }

    currTime = millis() - startTime;
    if ( currTime >= hitTime )
    {
      startTime = millis();
    }
    fill(255);
    textSize(36);
    text("Player 2, prepare to incubate in:" + counter2, width/2, height/2);
    text("Score to beat: " + player1score, width/2, height/2 + 50);
  }
}

//float Scaling (float x) {
//  if (x<=0) {
//    return 0;
//  } 
//  else if ((x>0) && (x<= (1/2f))) {
//    return (float)(sq(x-2)/2f);
//  } 

