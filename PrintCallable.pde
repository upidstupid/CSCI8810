public class PrintCallable implements ICallable {
  private String text;
  PrintCallable(String _text) {
    this.text = _text;
  }
  public void call() {
    System.out.println(this.text);
  }
}