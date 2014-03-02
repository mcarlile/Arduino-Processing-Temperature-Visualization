import controlP5.*;

float y = 1;
int targetRadiusMin = 100;
int targetRadiusMax = 150;
int player1score = 0;
float startTime, currTime;
float hitTime;
String player1FeedbackMessage;

ControlP5 cp5;
Slider2D s;
int player1 = 100;
int sliderTicks1 = 100;
int sliderTicks2 = 30;
Slider abc;


void setup() {

  size (600, 400);
  cp5 = new ControlP5(this);
  cp5.addSlider("player1")
    .setPosition(width/4, height/2)
      .setRange(0, 198)
        ;
  hitTime = 100; // 1000 millis = 1 second
  startTime = millis();

  smooth();
}

void draw () {
  background(0);
  String text = "Player 1 score: " + player1score;
  fill(255);
  text(text, 10, 10, 70, 80);
  noStroke();
  y = y + second();
  int s = second();

  //player out of range
  if ((player1 < targetRadiusMin) || (player1 > targetRadiusMax)) {
    currTime = millis() - startTime;
    if ( currTime >= hitTime )
    {
      startTime = millis();
      player1score--;
    }
    fill(255, 0, 0, 256);
    ellipse (width/4, height/2, player1, player1);
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

    ellipse (width/4, height/2, player1, player1);
  }
  //black inner range
  fill(0, 0, 0, 256);
  ellipse (width/4, height/2, 25, 25);
  fill(255);
  textAlign(CENTER, CENTER);
  text(player1FeedbackMessage, width/4, 300);
}

