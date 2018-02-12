import java.util.List;
import java.util.UUID;

String imageloc = "C:\\Users\\Brook\\Pictures\\IMAGE1.JPG";

boolean DEBUG = true;

PImage cur, init;

List<Button> buttons = new ArrayList<Button>();

void setup() {
  size(1000, 500);
  init = cur = loadImage(imageloc);
  background(255);
  Button b0 = new RectButton(color(0), color(225), width - 105, 0, 100, 25, new ResetCallable(), "Reset");
  Button b1 = new RectButton(color(0), color(225), width - 105, 30, 100, 25, new LightnessGrayscaleCallable(), "Lightness Grayscale");
  Button b2 = new RectButton(color(0), color(225), width - 105, 60, 100, 25, new AverageGrayscaleCallable(), "Average Grayscale");
  Button b3 = new RectButton(color(0), color(225), width - 105, 90, 100, 25, new LuminosityGrayscaleCallable(), "Luminosity Grayscale");
  Button b4 = new RectButton(color(0), color(225), width - 105, 120, 100, 25, new ICallable(){ImageProcessor ip = new ImageProcessor();public void call(){cur = ip.saltAndPepperNoise(cur,.2);}}, "Salt n Pepper Noise");
  Button b5 = new RectButton(color(0), color(225), width - 105, 150, 100, 25, new ICallable(){ImageProcessor ip = new ImageProcessor();public void call(){cur = ip.normalizedNoise(cur,.2);}}, "Normalized Noise");
  Button b6 = new RectButton(color(0), color(225), width - 105, 180, 100, 25, new ICallable(){ImageProcessor ip = new ImageProcessor();public void call(){cur = ip.reduceNoiseBySmoothing(cur);}}, "Smoothing");
  Button b7 = new RectButton(color(0), color(225), width - 105, 210, 100, 25, new ICallable(){ImageProcessor ip = new ImageProcessor();public void call(){cur = ip.reduceNoiseByMedianFiltering(cur);}}, "Median Filtering");
  Button b8 = new RectButton(color(0), color(225), width - 105, 240, 100, 25, new ICallable(){ImageProcessor ip = new ImageProcessor();public void call(){int threshold = ip.simpleThreshold(cur); System.out.println("Using threshold: " + threshold); cur = ip.binaryBySimpleThresholding(cur, threshold);}}, "Simple Binary Threshold");
  Button b9 = new RectButton(color(0), color(225), width - 105, 270, 100, 25, new ICallable(){ImageProcessor ip = new ImageProcessor();public void call(){cur = ip.binaryByPTile(cur, .05);}}, "Whiten 5%");
  Button b10 = new RectButton(color(0), color(225), width - 105, 300, 100, 25, new ICallable(){ImageProcessor ip = new ImageProcessor();public void call(){cur = ip.binaryByPTile(cur, .1);}}, "Whiten 10%");
  Button b11 = new RectButton(color(0), color(225), width - 105, 330, 100, 25, new ICallable(){ImageProcessor ip = new ImageProcessor();public void call(){cur = ip.binaryByPTile(cur, .3);}}, "Whiten 30%");
  Button b12 = new RectButton(color(0), color(225), width - 105, 360, 100, 25, new ICallable(){ImageProcessor ip = new ImageProcessor();public void call(){cur = ip.binaryByIterativeThresholding(cur);}}, "Iterative Thresholding");
  Button bexport = new RectButton(color(0), color(225), width - 105, 470, 100, 25, new ICallable(){public void call(){String filepath = "output_"+ UUID.randomUUID() + ".png"; System.out.println("Saving to: " + filepath);cur.save(filepath);}}, "Export");
  buttons.add(b0);
  buttons.add(b1);
  buttons.add(b2);
  buttons.add(b3);
  buttons.add(b4);
  buttons.add(b5);
  buttons.add(b6);
  buttons.add(b7);
  buttons.add(b8);
  buttons.add(b9);
  buttons.add(b10);
  buttons.add(b11);
  buttons.add(b12);
  buttons.add(bexport);
}

void draw() {
  update();
  background(255);
  image(cur, 0, 0);
  for(Button b: buttons) {
    b.render();
  }
  if(DEBUG) {
    pushStyle();
    fill(255);
    stroke(0);
    //rect(mouseX-2, mouseY-15, 75, 20);
    fill(0);
    text("( " + mouseX + " , "+ mouseY + " )", mouseX, mouseY);
    popStyle();
  }
}

void update() {
  for(Button b: buttons) {
    b.onMouseHover();
  }
}

void mousePressed() {
  for(Button b: buttons) {
    b.onClick();
  }
  if(DEBUG) {
    loadPixels();
    color c = color(pixels[mouseY*width+mouseX]);
    System.out.println("R: " + red(c) + " G: " + green(c) + " B: " + blue(c));
  }
}