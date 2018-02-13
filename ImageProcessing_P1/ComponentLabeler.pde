public class ComponentLabeler {
  
  public PImage labelComponents(PImage in) {
    in.loadPixels();
    PImage out = in.copy();
    out.loadPixels();
    
    HashMap<Integer, Integer> alias = new HashMap<Integer, Integer>();
    
    int labelId = 1;
    for(int i = 0; i < in.pixels.length; i++) {
      int calcX = i % in.width;
      int calcY = i / in.width;
      
      color res = color(0);
      int leftValue = int(red(out.pixels[i - 1]));
      int upValue = int(red(out.pixels[i - in.width]));
      if(calcX == 0 || calcY == 0 || red(in.pixels[i]) == 0) {}
      else if(leftValue == 0 && upValue == 0) {
        res = color(labelId);
        labelId++;
      } else if(leftValue != 0 && upValue != 0) {
        res = color(leftValue);
        alias.put(new Integer(upValue), new Integer(leftValue));
      } else {
        res = leftValue != 0 ? color(leftValue) : color(upValue);
      }
      out.pixels[i] = res;
    }
    
    
    
    return out;
  }
}