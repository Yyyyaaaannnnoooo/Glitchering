class PWindow extends PApplet {
  PWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  void settings() {
    size(500, 200);
  }

  void setup() {
    background(150);
  }

  void draw() {
    fill(0);
    rect(0, 0, width, height);
    fill(255);
    text("DITHER FACTOR: "+fac+" LEVEL: "+level+" // UP AND DOWN TO CHANGE FACTOR, LEFT AND RIGHT TO CHANGE LEVEL", 0, 0, width, height);
  }
}