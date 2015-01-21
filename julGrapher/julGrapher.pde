import javax.swing.*;
import javax.swing.SwingUtilities;
import javax.swing.filechooser.*;
import javax.swing.filechooser.FileFilter;



public void setup(){
  // size(1280, 800, P3D);
  
    HashMap<Integer, Node> graph = new HashMap<Integer, Node>();
    
    XML xml = loadXML("rozm.xml");
    
    XML[] nodes = xml.getChildren("graph")[0].getChildren("nodes")[0].getChildren("node");
    
    println("len " + nodes.length);
    
    for (int i = 0; i < nodes.length; i++) {
      int id = nodes[i].getInt("id");
      println("dupa" + id);
    }
    
    XML[] rels = xml.getChildren("graph")[0].getChildren("edges")[0].getChildren("edge");

}
  
  
public void draw(){
    
    
}





public void keyReleased() {
  switch(key){         
    case'L':
//       String flName = getFile("Load XML");
//       println("LOADING COMPLETE:");
//       XML xmlLoaded = new XML(flName);
         XML xmlLoaded = new XML("rozm.xml");
         open("krozm.xml");
      println(xmlLoaded);
       println(xmlLoaded.getChildCount());
       // println(xmlLoaded.getChild(0));
       // for (int xl=0; xl<xmlLoaded.getChildCount(); xl++)
       //  {
       //    println("layer " + xl + ": " + xmlLoaded.getChild(xl).getChildCount() + " distorters");
       //    for (int xd=0; xd<xmlLoaded.getChild(xl).getChildCount(); xd++)
       //    {
       //      float dist_x = xmlLoaded.getChild(xl).getChild(xd).getFloat("x");
       //      float dist_y = xmlLoaded.getChild(xl).getChild(xd).getFloat("y");
       //      float dist_z = xmlLoaded.getChild(xl).getChild(xd).getFloat("z");       
       //      float dist_fA = xmlLoaded.getChild(xl).getChild(xd).getFloat("forceA");
       //      float dist_fB = xmlLoaded.getChild(xl).getChild(xd).getFloat("forceB");
            
       //      layers[xl].addDistorter(dist_x, dist_y, dist_z, dist_fA, dist_fB);
       //      //layers[xl].addDistorter();
       //    }
       //  }
    break;
  }
  
}


  // for (int i = 0; i < children.length; i ++ ) {
    
  //   // The diameter is child 0
  //   XMLElement diameterElement = children[i].getChild(0);
    
  //   // The diameter is the content of the first element while red and green are attributes of the second.
  //   int diameter = int(diameterElement.getContent());
    
  //   // Color is child 1
  //   XMLElement colorElement = children[i].getChild(1);
  //   int r = colorElement.getIntAttribute("red");
  //   int g = colorElement.getIntAttribute("green");
    
  //   // Make a new Bubble object with values from XML document
  //   bubbles[i] = new Bubble(r,g,diameter);
  // }
  
String getFile(String dialogTxt) {
    String fName = "";
    JFileChooser fc = new JFileChooser();
    int rc = fc.showDialog(null, dialogTxt);
    if (rc == JFileChooser.APPROVE_OPTION)
    {
      File file = fc.getSelectedFile();
      fName = file.getName();
      println("PATH: "+fName);
    }
    return fName;
  }
