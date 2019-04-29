import processing.video.*;

Capture cam;
int numPixels;
int[] frameAverage, frameSumB, frameSumG, frameSumR;
int count = 0;

void setup() {
  size(1280, 720); // 720p 
  cam = new Capture(this, width, height);
  cam.start();
  numPixels = cam.width * cam.height;
  frameAverage = new int[numPixels]; // initialized with 0
  frameSumR = new int[numPixels];
  frameSumG = new int[numPixels];
  frameSumB = new int[numPixels];
}

void draw() {
  if (cam.available()) {
    count++;
    loadPixels();
    cam.read();
    cam.loadPixels();
    for (int i = 0; i < numPixels; i++) {
      color currentColor = cam.pixels[i];
      int currentR = (currentColor >> 16) & 0xFF; 
      int currentG = (currentColor >> 8) & 0xFF;
      int currentB = currentColor & 0xFF;
      frameSumR[i] += currentR; // TODO will overflow
      frameSumG[i] += currentG;
      frameSumB[i] += currentB;
      int newR = int(float(frameSumR[i])/float(count));
      int newG = int(float(frameSumG[i])/float(count));
      int newB = int(float(frameSumB[i])/float(count));
      pixels[i] = color(newR, newG, newB);
    }
    updatePixels();
  }
}

void mouseClicked() {
  String filename = "" + year() + "_" + month() + "_" + day() + "_" + hour() + "_" + minute() + "_" + second() + "_" + "averaging.png";
  saveFrame(filename);
}
