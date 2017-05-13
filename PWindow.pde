import controlP5.*;
ControlP5 cp5;
class PWindow extends PApplet {

  float factor = 16;
  int level = 1;
  PWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  void settings() {
    size(500, 200);
  }

  void setup() {
    cp5 = new ControlP5(this);
    cp5.addSlider("factor").setPosition(100, 50).setSize(300, 20).setRange(-10, 20);
    cp5.addSlider("level").setPosition(100, 100).setSize(300, 20).setRange(1, 10);
    background(0, 150, 0);
    frame.setTitle("I <3 DITHERING");
  }

  void draw() {
    fac = factor;
    println(factor);
    //rect(0, 0, width, height);
    //fill(255);
    //text("DITHER FACTOR: "+fac+" LEVEL: "+level+" // UP AND DOWN TO CHANGE FACTOR, LEFT AND RIGHT TO CHANGE LEVEL", 0, 0, width, height);
  }
}