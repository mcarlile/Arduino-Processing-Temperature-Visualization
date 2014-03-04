import controlP5.*;
import processing.serial.*;

Serial myPort;  // Create object from Serial class
String inString;      // Data received from the serial port
float numFloat; 
int time;
int counter = 60;
int wait = 1000;

float y = 1;
float targetRadiusMin = 83;
float targetRadiusMax = 87;
float player1score = 0;
float startTime, currTime;
float hitTime;
String player1FeedbackMessage;

ControlP5 cp5;
Slider2D s;
float player1 = 100;
int sliderTicks1 = 100;
int sliderTicks2 = 30;
Slider abc;


void setup() {
  String portName = Serial.list()[5];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil(10);
  time = millis();//store the current time
  size (600, 400);
  cp5 = new ControlP5(this);
  //create player1 temperature slider
  //  cp5.addSlider("player1")
  //    .setPosition(width/2, height/2)
  //      .setRange(0, 198)
  //        ;
  smooth();
}

void serialEvent(Serial p) {
  inString = (p.readString());
  try {
    numFloat = Float.parseFloat(inString);
    player1 = abs(numFloat);
  } 
  catch(Exception e) {
  }
}

void draw () {
  background(0);
  noStroke();
  y = y + second();
  int s = second();
  if (millis() - time >= wait) { //every second
    if (counter >= 1) {
      counter--;
    }
    println(counter);//if it is, do something
    time = millis();//also update the stored time
  }
  //player 1 code
  //player out of range
  if ((player1 < targetRadiusMin) || (player1 > targetRadiusMax)) {
    currTime = millis() - startTime;
    if ( currTime >= hitTime )
    {
      startTime = millis();
    }
    fill(255, 0, 0, 256);
    ellipse (width/2, height/2, (player1*3), (player1*3));
    player1FeedbackMessage = "temperature outside acceptable range";
  }   
  else {
    //increment player 1s score every 1/10th of a second and set the color circle to green
    currTime = millis() - startTime;
    if ( currTime >= hitTime )
    {
      startTime = millis();
      player1score++;
    }
    fill(0, 255, 0, 255);
    player1FeedbackMessage = "temperature within acceptable range";
    ellipse (width/2, height/2, (player1*3), (player1*3));
  }
  textAlign(CENTER, CENTER);
  fill(255);
  text(player1FeedbackMessage, width/2, 350);
  textSize(18);
  text("current temperature: " + player1, width/2, 375); 
  text("Player 1 score: " + player1score, width/2, 45); 
  text("Seconds remaining: " + counter, width/2, 20); 

  //  //minimum range indicator
  fill(0, 0, 0, 0);
  strokeWeight(1);
  stroke(255);
  ellipse (width/2, height/2, (targetRadiusMin *3), (targetRadiusMin *3));

  //    //maximum range indicator
  fill(0, 0, 0, 0);
  strokeWeight(1);
  stroke(255);
  ellipse (width/2, height/2, (targetRadiusMax *3), (targetRadiusMax *3));
}

