import controlP5.*; //<>//

/*
0.4.1

*/

import javax.swing.*;
import javax.swing.SwingUtilities;
import javax.swing.filechooser.*;
import javax.swing.filechooser.FileFilter;
import peasy.*;
import controlp5.*;


PeasyCam cam;
ArrayList<Graph> graphs = new ArrayList<Graph>();
Graph activeGraphRef;
Object activeNodeRef;
int activeGraph = 0;
int activeNode = 0;

PShader fog;
PShader fogLine;

public void setup(){
    // hint(ENABLE_STROKE_PURE);
    cam = new PeasyCam(this, 1000);
    cam.setWheelScale(2.0);
  
    size(1280, 800, P3D);
    smooth();
    
    XML xml = loadXML("rozm.xml");
    for (int ig=0; ig<5; ig++){
      graphs.add(new Graph(xml));
    }
    
    fog = loadShader("Fog.frag", "Fog.vert");
    fogLine = loadShader("FogLine.frag", "FogLine.vert");
    
}
  
  
public void draw() {
  background(190);
  fill(255);
  
  shader(fog, TRIANGLES);
  shader(fogLine, LINES);
  noLights();
  
  for(Graph graph: graphs){
    pushMatrix();
    translate(graph.position.x, graph.position.y, graph.position.z);
    for(Integer id: graph.nodes.keySet()) {
      Node n = null;
      n = graph.nodes.get(id);
      
      for(Edge edgeFrom: n.edgesFromThis){
        strokeWeight(map(edgeFrom.weight, 0, 13, 1, 30));
        stroke(0, map(edgeFrom.weight, 0, 11, 20, 255));  
        line(n.position.x, n.position.y, n.position.z,
             edgeFrom.target.position.x, edgeFrom.target.position.y, edgeFrom.target.position.z);
      }
      
      noStroke();
      pushMatrix();
      translate(n.position.x, n.position.y, n.position.z);
      
      // int size = n.edgesFromThis.size() + n.edgesToThis.size();
      int size = 0;
      for(Edge e: n.edgesFromThis){
        size += e.weight;
      }
      for(Edge e: n.edgesToThis){
        size += e.weight;
      }
      
      box(map(size, 0, 50, 10, 50));
      popMatrix();
      
      
    }
    popMatrix();
  }
}


public void keyReleased() {
  switch(key){         
    case'l':
    case'L':
      String flName = getFile("Load XML");
      println("LOADING COMPLETE:");
      XML xmlLoaded = new XML(flName);
    break;
    
    case'A':
    case'a':
     activeNode--;
     if (activeNode < 0){
       activeNode = graphs.get(activeGraph).nodes.size()-1;
     }
     println("aN: " + activeNode + " ");
     activeNodeRef = activeGraphRef.nodes.keySet().toArray()[activeNode];
     lookAtPV(PVector.add(activeGraphRef.position, activeGraphRef.nodes.get(activeNodeRef).position), 300);
    break;
    
    case'D':
    case'd':
     activeNode++;
     if (activeNode >= graphs.get(activeGraph).nodes.size()){
       activeNode = 0;
     }
     activeNodeRef = activeGraphRef.nodes.keySet().toArray()[activeNode];
     lookAtPV(PVector.add(activeGraphRef.position, activeGraphRef.nodes.get(activeNodeRef).position), 300);
    break;
    
    case'W':
    case'w':
     activeGraph++;
     if (activeGraph >= graphs.size()){
       activeGraph = 0;
     }
     activeNode = -1;
     activeGraphRef = graphs.get(activeGraph);
     lookAtPV(activeGraphRef.position, 2000);
    break;
    
    case'S':
    case's':
      activeGraph--;
     if (activeGraph < 0){
       activeGraph = 0;
     }
     activeNode = -1;
     lookAtPV(graphs.get(activeGraph).position, 1800);
    break;
    
    case'X':
    case'x':
     lookAtPV(graphs.get(activeGraph).position, 1800);
    break;
  }
  
}

void lookAtPV(PVector vec, float dist){
  cam.lookAt(vec.x, vec.y, vec.z, dist, 800);
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
