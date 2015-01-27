/* //<>//
0.4.2
add: gui controlP5
add: on/off shaders

*/

import javax.swing.*;
import javax.swing.SwingUtilities;
import javax.swing.filechooser.*;
import javax.swing.filechooser.FileFilter;
import peasy.*;
import controlP5.*;


PeasyCam cam;
ArrayList<Graph> graphs = new ArrayList<Graph>();
Graph activeGraphRef;
Object activeNodeRef;
int activeGraph = 0;
int activeNode = 0;
PVector pointerV = new PVector();

PShader fog;
PShader fogLine;

ControlP5 controlP5;
boolean showPanel = false, doFog = false;

public void setup(){
    // hint(ENABLE_STROKE_PURE);
    cam = new PeasyCam(this, 1000);
    cam.setWheelScale(2.0);
  
    size(2500, 1200, P3D);
    smooth();
    
    XML xml = loadXML("rozm.gexf");
    for (int ig=0; ig<5; ig++){
      graphs.add(new Graph(xml));
    }
    
    fog = loadShader("Fog.frag", "Fog.vert");
    fogLine = loadShader("FogLine.frag", "FogLine.vert");
    
    
    controlP5 = new ControlP5(this);
    controlP5.setAutoDraw(false);
    Group g1 = controlP5.addGroup("SETUP").setPosition(800, 20);
    controlP5.addToggle("doFog", false, 0, 150, 24, 12)
     .setGroup(g1); 
    
}
  
  
public void draw() {
  background(190);
  
  fill(255);
  if (doFog) { 
    shader(fog, TRIANGLES);
    shader(fogLine, LINES);
    noLights();
  }
  else {
    resetShader(TRIANGLES);
    resetShader(LINES); 
  }
  

  hud();
  if (activeGraphRef != null) {
      pointerV.x = screenX(activeGraphRef.position.x, activeGraphRef.position.y, activeGraphRef.position.z);
      pointerV.y = screenY(activeGraphRef.position.x, activeGraphRef.position.y, activeGraphRef.position.z);
  }
    
  for(Graph graph: graphs){
    
    
    
    pushMatrix();
    translate(graph.position.x, graph.position.y, graph.position.z);
    
    

    
    for(Integer id: graph.nodes.keySet()) {
      Node n = null;
      n = graph.nodes.get(id);
      
      
      for(Edge edgeFrom: n.edgesFromThis){
        strokeWeight(map(edgeFrom.weight, 0, 13, 1, 8));
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
    case'G':
    case'g':
      showPanel = !showPanel;
      if (showPanel) {
        controlP5.show();
      } else if (!showPanel) {
        controlP5.hide();
      }
    break;
  }
  gui();
  
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


void gui() {
  // hint(DISABLE_DEPTH_TEST);
  // cam.beginHUD();
  // controlP5.draw();
  // cam.endHUD();
  // hint(ENABLE_DEPTH_TEST);
}

void hud() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
    if (pointerV != null) {
        stroke(200);
        strokeWeight(30);
        noFill();
        ellipseMode(RADIUS);
        ellipse(pointerV.x, pointerV.y, 400, 400);
        fill(255);
        println(activeGraphRef);
      }
  controlP5.draw();
  hint(ENABLE_DEPTH_TEST);
  cam.endHUD();

}

void controlEvent(ControlEvent theEvent) {
  println(theEvent.controller().id());
}
