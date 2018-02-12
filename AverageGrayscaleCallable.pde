public class AverageGrayscaleCallable implements ICallable{
  ImageProcessor ip = new ImageProcessor();
  public void call() {
    cur = ip.averageGrayscale(cur);
  }
}