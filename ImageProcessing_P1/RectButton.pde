public class RectButton implements Button {
  private color strokeColor;
  private color fillColor;
  private int rectX;
  private int rectY;
  private int rectXSize;
  private int rectYSize;
  private boolean highlighted = false;
  private String text;
  private ICallable callable;
  RectButton(color _strokeColor, color _fillColor,
             int _rectX, int _rectY, int _rectXSize, 
             int _rectYSize, ICallable _callable, String _text){
    this.strokeColor = _strokeColor;
    this.fillColor = _fillColor;
    this.rectX = _rectX;
    this.rectY = _rectY;
    this.rectXSize = _rectXSize;
    this.rectYSize = _rectYSize;
    this.callable = _callable;
    this.text = _text;
  }
  
  public void render(){
    pushStyle();
    stroke(this.strokeColor);
    fill(this.fillColor);
    rect(this.rectX, this.rectY, this.rectXSize, this.rectYSize);
    fill(0);
    text(this.text, this.rectX + 2, this.rectY + (this.rectYSize/2));
    popStyle();
  }
  
  public void highlight(){
    if (!this.highlighted){
      this.highlighted = true;
      this.strokeColor = this.strokeColor*2;
      this.fillColor = this.fillColor/2;
    }
  }
  
  public void noHighlight(){
    if (this.highlighted){
      this.highlighted = false;
      this.strokeColor = this.strokeColor/2;
      this.fillColor = this.fillColor*2;
    }
  }
  
  public void click(){
    //TODO: provide some click rendering
    this.callable.call();
  }
  
  public boolean isMouseHovering(){ 
    return (mouseX >= this.rectX && mouseX <= this.rectX+this.rectXSize && 
            mouseY >= this.rectY && mouseY <= this.rectY+this.rectYSize);
  }
  
  public void onClick(){
    if (this.isMouseHovering()) {
      this.click();
    }
  }
  
  public void onMouseHover(){
    if (this.isMouseHovering()){
      //this.highlight();
    } else {
      //this.noHighlight();
    }
  }
}