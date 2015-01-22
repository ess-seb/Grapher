import javax.swing.*;
import javax.swing.SwingUtilities;
import javax.swing.filechooser.*;
import javax.swing.filechooser.FileFilter;

HashMap<Integer, Node> graph;

public void setup(){
  // size(1280, 800, P3D);
  
    graph = new HashMap<Integer, Node>();
    
    XML xml = loadXML("rozm.xml");
    
    
    XML[] nodes = xml.getChild("graph").getChild("nodes").getChildren("node");
    println("Nodes: " + nodes.length);
    for(XML node: nodes){
      int id = node.getInt("id");
      String label = node.getString("label");
      
      float size = node.getChild("viz:size").getFloat("value");
      float posX = node.getChild("viz:position").getFloat("x");
      float posY = node.getChild("viz:position").getFloat("y");
      float posZ = node.getChild("viz:position").getFloat("z");
      
      PVector position = new PVector(posX, posY, posZ);
      
      int colR = 0, colG = 0, colB = 0;
      if (hasChild(node, "viz:color")){
        colR = node.getChild("viz:color").getInt("r");
        colG = node.getChild("viz:color").getInt("g");
        colB = node.getChild("viz:color").getInt("b");
      }
      color colour = color(colR, colG, colB);
  
      float ecce = node.getChild("attvalues").getChild(0).getFloat("value");
      float closeness = node.getChild("attvalues").getChild(1).getFloat("value");
      float between = node.getChild("attvalues").getChild(2).getFloat("value");
      float modclass = node.getChild("attvalues").getChild(3).getFloat("value");
      
      println(id + " " + label + " " + size + " " + position + " " + colour + " " + ecce + " " + closeness + " " + between + " " + modclass);
      graph.put(id, new Node(id, label, size, position, colour, ecce, closeness, between, modclass));
      
    }
    
    XML[] edges = xml.getChild("graph").getChild("edges").getChildren("edge");
    println("\n\nEdges: " + edges.length);
    
    for(XML edge: edges){
      
      int id;
      if (edge.hasAttribute("id")){
        id = edge.getInt("id");
      } else {
        id = 0;
      }
      
      int source = edge.getInt("source");
      int target = edge.getInt("target");
      
      float weight;
      if (edge.hasAttribute("weight")){
        weight = edge.getFloat("weight");
      } else {
        weight = 0.0;
      }
      
      println(id + " " + source + " " + target + " " + weight);
      
      Edge myEdge = new Edge(id, source, target, weight);
      graph.get(source).addEdge(myEdge);
      graph.get(target).addEdge(myEdge);
    }
    Node n = graph.get(33); //for debuging
    println(graph.get(121).edgesFromThis.get(1).target + " = 18006");
    println(graph.get(121).edgesToThis.get(1).source + " = 2064");
    println("LOADING COMPLETE"); //<>//
}
  
  
public void draw(){
    
    
} //<>//


 //<>//


public void keyReleased() {
  switch(key){         
    case'l':
    case'L':
      String flName = getFile("Load XML");
      println("LOADING COMPLETE:");
      XML xmlLoaded = new XML(flName);
    break;
  }
  
}

  
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
  
  
boolean hasChild(XML myXml, String myKey) {
  boolean has = false;
  for(String tempKey: myXml.listChildren()){
    if (tempKey == myKey){
      has = true;
      break;
    }
  }
  return has;
}
