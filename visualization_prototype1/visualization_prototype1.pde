import controlP5.*;
import processing.serial.*;

Serial myPort;  // Create object from Serial class
String inString;      // Data received from the serial port
float numFloat; 

float y = 1;
float targetRadiusMin = 70;
float targetRadiusMax = 100;
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

  size (600, 400);
  cp5 = new ControlP5(this);
  //create player1 temperature slider
  cp5.addSlider("player1")
    .setPosition(width/2, height/2)
      .setRange(0, 198)
        ;
  smooth();
}

void serialEvent(Serial p) {
  //  inString = (myPort.readString());
  inString = (p.readString());
  try {
    numFloat = Float.parseFloat(inString);
    player1 = abs(numFloat);
    println(player1);
  } 
  catch(Exception e) {
  }
}

void draw () {
  background(0);
  String text = "Player 1 score: " + player1score;
  fill(255);
  text(text, 10, 10, 70, 80);
  noStroke();
  y = y + second();
  int s = second();

  //player 1 code
  //player out of range
  if ((player1 < targetRadiusMin) || (player1 > targetRadiusMax)) {
    currTime = millis() - startTime;
    if ( currTime >= hitTime )
    {
      startTime = millis();
      player1score--;
    }
    fill(255, 0, 0, 256);
    ellipse (width/2, height/2, player1, player1);
    player1FeedbackMessage = "you're doing it wrong";
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
    player1FeedbackMessage = "now you're cooking!";

    ellipse (width/2, height/2, player1, player1);
  }
  //black inner range
  fill(0, 0, 0, 256);
  ellipse (width/2, height/2, 25, 25);
  fill(255);
  textAlign(CENTER, CENTER);
  text(player1FeedbackMessage, width/2, 350);
}


