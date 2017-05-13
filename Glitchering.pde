/////GLICHERING//////
//ARROW UP AND DOWN TO CHANGE THE DITHERING FACTOR
//ARROW LEFT AND RIGHT TO CHANGE THE NUMBER OF COLORS IN THE IMAGE
//USE KEY S TO SAVE AN IMAGE
PWindow win;
PImage img, img2, img3;
int level = 1, count = 0;
float num = 0, fac = 16;
int textHeight = 17;
void settings() {
  img  = loadImage("1.jpg");//upload your image here
  //img  = createImage(600, 600, RGB);
  //img = randomGradient();
  img3 = createImage(img.width, img.height, RGB);
  size(img.width, img.height + textHeight, JAVA2D);
}
void setup() {
  win = new PWindow();
  noStroke();
  noSmooth();
}

void draw() {
  dither(img, fac, level);
}

void keyPressed() {
  switch(key) {
    case('g'):
    img = randomGradient();
    case('s'): 
    String date = new java.text.SimpleDateFormat("yyyy_MM_dd_kkmmss").format(new java.util.Date ());
    saveFrame("dithering"+date+".jpg");
    case(CODED):
    if (keyCode == UP) {
      fac += 0.1;
    } else if (keyCode == DOWN) {
      fac -= 0.1;
    } else if (keyCode == LEFT) {
      level -= 1;
    } else if (keyCode == RIGHT) {
      level +=1;
    }
  }
}
/// source image, blank image for black and white dither, 
/// factor is a float that changes the amount of black of the image, and the structure of the dither
void dither(PImage src1, float factor, int lev) {
  int s = 1;
  //println(factor);
  ///create a copy of the original image///
  PImage src = createImage(src1.width, src1.height, RGB);
  for (int i = 0; i < src.pixels.length; i++) {
    src.pixels[i] = src1.pixels[i];
  }
  src.loadPixels();
  for (int x = 2; x < src.width-2; x+=s) {
    for (int y = 2; y < src.height-2; y+=s) {
      int index = x + y * src.width;
      color oldpixel = src.pixels[index];
      color newpixel = findClosestColor(oldpixel, lev); //con 8 pixel sorting
      src.pixels[index] = newpixel;
      color quant_error = subColor(oldpixel, newpixel);

      //Floyd Steinberg
      color s1 = src.pixels[(x + s)+ ( y * src.width)];
      src.pixels[(x + s)+ ( y * src.width)] = quantizedColor(s1, quant_error, (7.0 + num)/factor);
      color s2 = src.pixels[(x - s)+ ( (y + s)     * src.width)];
      src.pixels[(x - s)+ ( (y + s) * src.width)] = quantizedColor(s2, quant_error, (3.0 + num)/factor);
      color s3 = src.pixels[x + ( (y + s) * src.width)];
      src.pixels[x + ( (y + s) * src.width)] = quantizedColor(s3, quant_error, (5.0 + num)/factor);
      color s4 = src.pixels[(x + s)+ ((y + s ) * src.width)];
      src.pixels[(x + s)+ ((y + s ) * src.width)] = quantizedColor(s4, quant_error, (1.0 + num)/factor);
    }
  }
  src.updatePixels();
  //image(src1, 0, 0);
  image(src, 0, textHeight);
}

PImage randomGradient() {
  PImage img = createImage(600, 600, RGB);
  color c1 = color(random(255), random(255), random(255));
  color c2 = color(random(255), random(255), random(255));
  img.loadPixels();
  for (int y = 0; y < img.width; y++) {
    for (int x = 0; x < img.height; x++) {
      int index = x + y * img.width;
      float amp = map(index, 0, img.width * img.height, 0, 1);
      color col = lerpColor(c1, c2, amp);
      img.pixels[index] = col;
    }
  }
  img.updatePixels();
  return img;
}

/// find the nearest color, lev defines the number ///
/// of colors the image will be divided,           /// 
/// with 1 meaning 8 colors (RGB + CMYK + WHITE)   ///

color findClosestColor(color in, int lev) {

  float r = (in >> 16) & 0xFF;
  float g = (in >> 8) & 0xFF;
  float b = in & 0xFF;
  ///Normalizing the colors///
  //level = lev;
  float norm = 255.0 / lev;
  float nR = round((r / 255) * lev) * norm;
  float nG = round((g / 255) * lev) * norm;
  float nB = round((b / 255) * lev) * norm;
  color newPix = color (nR, nG, nB);
  return newPix;
}


/////subtracting two different colors (a - b)////
color subColor (color a, color b) {

  float r1 = (a >> 16) & 0xFF;
  float g1 = (a >> 8) & 0xFF;
  float b1 = a & 0xFF;

  float r2 = (b >> 16) & 0xFF;
  float g2 = (b >> 8) & 0xFF;
  float b2 = b & 0xFF;

  float r3 = r1 - r2;
  float g3 = g1 - g2;
  float b3 = b1 - b2;

  color c = color(r3, g3, b3);
  return c;
}

/////returns the result between the original color and the quantization error////
color quantizedColor(color c1, color c2, float mult ) {

  float r1 = (c1 >> 16) & 0xFF;
  float g1 = (c1>> 8) & 0xFF;
  float b1 = c1 & 0xFF;

  float r2 = (c2 >> 16) & 0xFF;
  float g2 = (c2>> 8) & 0xFF;
  float b2 = c2 & 0xFF;

  float nR = r1 + mult * r2;
  float nG = g1 + mult * g2;
  float nB = b1 + mult * b2;

  color c3 = color (nR, nG, nB);
  return c3;
}