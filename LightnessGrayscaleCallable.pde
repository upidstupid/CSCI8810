public class LightnessGrayscaleCallable implements ICallable{
  ImageProcessor ip = new ImageProcessor();
  public void call() {
    cur = ip.lightnessGrayscale(cur);
  }
}