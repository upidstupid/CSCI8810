import java.util.Arrays;

public class ImageProcessor {
  public PImage lightnessGrayscale(PImage in) {
    in.loadPixels();
    PImage out = in.copy();
    out.loadPixels();
    for(int i = 0; i < in.pixels.length; i++) {
      color cur = color(in.pixels[i]);
      color res = color((max(red(cur), green(cur), blue(cur)) + 
                         min(red(cur), green(cur), blue(cur))) / 2);
      out.pixels[i] = res;
    }
    
    return out;
  }
  
  public PImage averageGrayscale(PImage in) {
    in.loadPixels();
    PImage out = in.copy();
    out.loadPixels();
    for(int i = 0; i < in.pixels.length; i++) {
      color cur = color(in.pixels[i]);
      color res = color((red(cur) + green(cur) + blue(cur)) / 3);
      out.pixels[i] = res;
    }
    
    return out;
  }
  
  public PImage luminosityGrayscale(PImage in) {
    in.loadPixels();
    PImage out = in.copy();
    out.loadPixels();
    for(int i = 0; i < in.pixels.length; i++) {
      color cur = color(in.pixels[i]);
      color res = color((.21 * red(cur)) + (.71 * green(cur)) + (.08 * blue(cur)));
      out.pixels[i] = res;
    }
    
    return out;
  }
  
  public PImage saltAndPepperNoise(PImage in, float noiseRatio) {
    in.loadPixels();
    PImage out = in.copy();
    out.loadPixels();
    for(int i = 0; i < in.pixels.length; i++) {
      color res = in.pixels[i];
      if(random(0,1) < noiseRatio){
        res = color(0);
      }
      out.pixels[i] = res;
    }
    
    return out;
  }
  
  public PImage normalizedNoise(PImage in, float noiseRatio) {
    in.loadPixels();
    PImage out = in.copy();
    out.loadPixels();
    float accum = 0.0;
    for(int i = 0; i < in.pixels.length; i++) {
      color res = in.pixels[i];
      accum += noiseRatio;
      //offset the first column for each y and give a checkerboard effect
      if(i % in.width == 0 && ((i / in.width) % 2 == 1)) {accum -= 1.0;};
      if(accum > 1) {
        accum -= 1.0;
        res = color(0);
      }
      out.pixels[i] = res;
    }
    
    return out;
  }
  
  public PImage reduceNoiseBySmoothing(PImage in) {
    in.loadPixels();
    PImage out = in.copy();
    out.loadPixels();
    for(int i = 0; i < in.pixels.length; i++) {
      color res = color(0);
      //check that we can get neighborset for current pixel
      int calcX = i % in.width;
      int calcY = i / in.width;
      if(calcX != 0 && calcX != (in.width - 1) && 
         calcY != 0 && calcY != (in.height - 1)) {
        NeighborSet ns = new NeighborSet(in, calcX, calcY);
        float colorRes = ns.ns5sum() / 5.0;
        if (colorRes > 255.0) {
          colorRes = 255;
        } else if(colorRes < 0) {
          colorRes = 0.0;
        }
        res = color(colorRes);
      }
      out.pixels[i] = res;
    }
    
    return out;
  }
  
  public PImage reduceNoiseByMedianFiltering(PImage in) {
    in.loadPixels();
    PImage out = in.copy();
    out.loadPixels();
    for(int i = 0; i < in.pixels.length; i++) {
      color res = color(0);
      //check that we can get neighborset for current pixel
      int calcX = i % in.width;
      int calcY = i / in.width;
      if(calcX != 0 && calcX != (in.width - 1) && 
         calcY != 0 && calcY != (in.height - 1)) {
        NeighborSet ns = new NeighborSet(in, calcX, calcY);
        float[] ns5 = ns.ns5();
        Arrays.sort(ns5);
        float colorRes = ns5[2];
        res = color(colorRes);
      }
      out.pixels[i] = res;
    }
    
    return out;
  }
  
  public PImage binaryBySimpleThresholding(PImage in, int threshold) {
    in.loadPixels();
    PImage out = in.copy();
    out.loadPixels();
    for(int i = 0; i < in.pixels.length; i++) {
      color res = color(0);
      int curIntensity = int(red(in.pixels[i]));
      if(curIntensity >= threshold) {
        res = color(255);
      }
      out.pixels[i] = res;
    }
    out.updatePixels();
    return out;
  }
  
  public PImage binaryByPTile(PImage in, float ptile) {
    in.loadPixels();
    PImage out = in.copy();
    out.loadPixels();
    int threshold = 255;
    int[] hist = this.histogram(in);
    float accum = 0.0;
    for(int j = hist.length - 1; j > 0 && ((accum / in.pixels.length) < ptile); j--) {
      threshold = j;
      accum += hist[j];
    }
    System.out.println("Using threshold: " + threshold);
    for(int i = 0; i < in.pixels.length; i++) {
      color res = color(0);
      int curIntensity = int(red(in.pixels[i]));
      if(curIntensity >= threshold) {
        res = color(255);
      }
      out.pixels[i] = res;
    }
    out.updatePixels();
    return out;
  }
  
  public PImage binaryByIterativeThresholding(PImage in) {
    in.loadPixels();
    PImage out = in.copy();
    out.loadPixels();
    int threshold = 125;
    System.out.println("initial threshold: " + threshold);
    int deltaT = 2;
    int n = 0;
    while(deltaT >= 1) {
      float R1 = 0.0;
      int r1Count = 0;
      float R2 = 0.0;
      int r2Count = 0;
      for(int i = 0; i < in.pixels.length; i++) {
        color res = color(0);
        int curIntensity = int(red(in.pixels[i]));
        if(curIntensity >= threshold) {
          res = color(255);
          R1 += curIntensity;
          r1Count++;
        } else {
          R2 += curIntensity;
          r2Count++;
        }
        out.pixels[i] = res;
      }
      
      int newThreshold = int(((R1/r1Count) + (R2/r2Count)) / 2);
      System.out.println("R1: " + R1 + " r1Count: " + r1Count + " R2: " + R2 + " r2Count: " + r2Count);
      System.out.println("New threshold computed: " + newThreshold);
      deltaT = abs(newThreshold - threshold);
      threshold = newThreshold;
    }
    out.updatePixels();
    return out;
  }
  
  public int[] histogram(PImage in) {
    int[] res = new int[256];
    in.loadPixels();
    for(int i = 0; i < in.pixels.length; i++) {
      res[int(red(in.pixels[i]))]++;
    }
    return res;
  }
  
  public int simpleThreshold(PImage in) {
    int[] hist = this.histogram(in);
    int indexOfLargest = 0;
    for ( int i = 0; i < hist.length; i++ ) { 
      if ( hist[i] > hist[indexOfLargest] ) { 
        indexOfLargest = i; 
      }
    }
    return indexOfLargest;
  }
  
  public class NeighborSet {
    final color mid;
    final color right;
    final color down;
    final color left;
    final color up;
    final color upright;
    final color upleft;
    final color downright;
    final color downleft;
    
    NeighborSet(PImage input, int x, int y) {
      this.mid = color(input.pixels[(y * input.width) + x]);
      this.right = color(input.pixels[(y * input.width) + x + 1]);
      this.down = color(input.pixels[((y + 1) * input.width) + x]);
      this.left = color(input.pixels[(y * input.width) + x - 1]);
      this.up = color(input.pixels[((y - 1) * input.width) + x]);
      this.upright = color(input.pixels[((y - 1) * input.width) + x + 1]);
      this.upleft = color(input.pixels[((y - 1) * input.width) + x - 1]);
      this.downright = color(input.pixels[((y + 1) * input.width) + x + 1]);
      this.downleft = color(input.pixels[((y + 1) * input.width) + x - 1]);
    }
    
    public float[] ns5() {
      float[] res = {red(this.mid), red(this.left), red(this.right), red(this.up), red(this.down)};
      return res;
    }
    
    public float ns5sum() {
      return red(this.mid) + red(this.right) + red(this.left) + red(this.down) + red(this.up);
    }
  }
}