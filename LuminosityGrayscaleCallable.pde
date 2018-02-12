public class LuminosityGrayscaleCallable implements ICallable{
  ImageProcessor ip = new ImageProcessor();
  public void call() {
    cur = ip.luminosityGrayscale(cur);
  }
}