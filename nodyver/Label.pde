public class Label {
 
  float x;
  float y;
  String text;
  int size;
  PFont font;
  float offx;
  float offy;
  
  Label(float x, float y, float offy, float offx, String text, int size, PFont font){
    this.x = x;
    this.y = y;
    this.text = text;
    this.size = size;
    this.font = font;
    this.offx = offx;
    this.offy = offy;
  }
  
}
