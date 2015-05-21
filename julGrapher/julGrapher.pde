/* //<>//
fix: add modes 1, 2, 3 for color views
fix: label colouring
add: tts for node and graph Label 
add: color active group mode
fix: doubleclick camera 

*/

import javax.swing.*; 
import javax.swing.SwingUtilities;
import javax.swing.filechooser.*;
import javax.swing.filechooser.FileFilter;
import peasy.*;
import controlP5.*;
import guru.ttslib.*;
import processing.dxf.*;
import processing.pdf.*;

boolean record;
PeasyCam cam;
boolean dataLoaded = false;
ArrayList<Graph> graphs = new ArrayList<Graph>();
ArrayList<Label> labelsNode = new ArrayList<Label>();
ArrayList<Label> labelsGraph = new ArrayList<Label>();
Graph activeGraphRef;
Graph activeGraphOri;
Node activeNodeRef;
Node overMouseNodeRef;
int activeGraph = 0;
int activeNode = 0;
PVector pointerV = new PVector();
TTS tts;

PFont fontGraphLabel;
PFont fontNodeLabel;

color colorNodes = color(0);
color colorEdges = color(0);
color colorActiveNode = color(203, 255, 229);
color colorConnNodes = color(155, 255, 205);
color colorHlActive = color(255);
color colorHL = color(255, 204, 153);


PShader fog;
PShader fogLine;
PShape logoSVG;

ControlP5 controlP5;
boolean showPanel = false, doFog = false, showGraphLabels = true, showNodeLabels = true, showColors = false;
boolean showSize = true, doSound = false;

static final int COLOR_ACTIVE_GROUP = 0, COLOR_FROM_FILE = 1, COLOR_NEAR_ONES = 2;
int viewMode = COLOR_ACTIVE_GROUP;

boolean isDataLoaded = false;
int loadingAllSteps = 0, loadingStep = 0, multiGraph = 1;
//colorModes: colorActiveGroup, colorFromFile, colorNearOnes

public void setup(){
    noCursor();
    fontGraphLabel = loadFont("Klavika-Medium-70.vlw");
    fontNodeLabel = loadFont("Klavika-Regular-70.vlw");
    logoSVG = loadShape("logo-01.svg");
    frameRate(24);
    // noLoop();
    hint(ENABLE_STROKE_PURE);
    cam = new PeasyCam(this, 1000);
    cam.setWheelScale(2.0);
    cam.setResetOnDoubleClick(false);
    frame.setLocation(0, 0);
    tts = new TTS();
    tts.setPitch( 0.5 );
    // tts.setPitchRange( 2000 )
    // tts.setPitchShift( 2 )
    
    size(displayWidth, displayHeight, P3D);
    background(190);
    smooth();
    stroke(200);
    
    // fog = loadShader("Fog.frag", "Fog.vert");
    // fogLine = loadShader("FogLine.frag", "FogLine.vert");
    
    
    
    // controlP5 = new ControlP5(this);
    // controlP5.setAutoDraw(false);
    // Group g1 = controlP5.addGroup("SETUP").setPosition(800, 20);
    // controlP5.addToggle("doFog", false, 0, 150, 24, 12)
    //  .setGroup(g1);
    // controlP5.hide();
    println("LOADED \nGraphs: " + graphs.size());
    thread("loadData");
}
  
  
public void draw() {
    if (!isDataLoaded) {
        introScreen();
      }
    

    if (isDataLoaded){
    if (record) {
     // beginRaw(DXF, "raw-####.dxf");
     beginRaw(PDF, "frame-###.pdf");
    }
    
    background(179);
    
    fill(255);
    // if (doFog) { 
    //   shader(fog, TRIANGLES);
    //   shader(fogLine, LINES);
    //   noLights();
    // } else {
    //   resetShader(TRIANGLES);
    //   resetShader(LINES); 
    // }
    
  
    
    if (activeGraphRef != null) {
        pointerV.x = screenX(activeGraphRef.position.x, activeGraphRef.position.y, activeGraphRef.position.z);
        pointerV.y = screenY(activeGraphRef.position.x, activeGraphRef.position.y, activeGraphRef.position.z);
    }
    if (activeGraphRef != null && showGraphLabels) {
        labelsGraph.add(new Label(screenX(activeGraphRef.position.x, activeGraphRef.position.y, activeGraphRef.position.z),
                                 screenY(activeGraphRef.position.x, activeGraphRef.position.y, activeGraphRef.position.z),
                                 0, 0, activeGraphRef.name, color(255), 48, fontGraphLabel));
    }
    hudBack();
    for(Graph graph: graphs){
      pushMatrix();
      translate(graph.position.x, graph.position.y, graph.position.z);
      // hint(DISABLE_DEPTH_TEST);
      for(Integer id: graph.nodes.keySet()) {
        Node n = null;
        n = graph.nodes.get(id);
        
        float size = 0;
        if (!showSize) {
          for(Edge e: n.edgesFromThis) {
            size += e.weight;
          }
          for(Edge e: n.edgesToThis) {
            size += e.weight;
          }
          size = map(size, 0, 50, 10, 50);
        } else {
          size = map(n.size, 0, 100, 10, 50);
        }
        
        color txtColor = color(255);
        // int size = n.edgesFromThis.size() + n.edgesToThis.size();
        if (dist(screenX(n.position.x, n.position.y, n.position.z),
                 screenY(n.position.x, n.position.y, n.position.z),
                 mouseX, mouseY) < 6 && activeGraphRef == graph){
          fill(colorHlActive);
          txtColor = color(0);
          overMouseNodeRef = n;
        } else {
          
          switch (viewMode) {
            case COLOR_FROM_FILE:
              fill(n.colour);
              txtColor = color(255); 
            break;
            
            case COLOR_NEAR_ONES:
              fill(colorNodes);
              txtColor = color(255);
              if (activeNodeRef != null && activeGraphRef == graph) {
                if (isNearNode(n, activeNodeRef, 1) && n != activeNodeRef){
                  fill(colorConnNodes);
                  txtColor = color(0);
                }
                else if (n == activeNodeRef) 
                {
                 txtColor = color(0); 
                 fill(colorActiveNode);
                }
              }
            break;
            
            case COLOR_ACTIVE_GROUP:
              fill(colorNodes);
              if (activeNodeRef != null) {
                if (activeNodeRef.colour == n.colour && activeGraphRef == graph){
                  fill(colorConnNodes);
                  txtColor = color(0);
                }
                if (n == activeNodeRef&& activeGraphRef == graph){
                  fill(colorActiveNode);
                  txtColor = color(0);
                }
              }
            break;
            
          }
        }
        
        if (activeGraphRef == graph && showNodeLabels){
          labelsNode.add(new Label(screenX(n.position.x, n.position.y, n.position.z),
                                   screenY(n.position.x, n.position.y, n.position.z),
                                   0, 0, n.label, txtColor, 20, fontNodeLabel));
        }
        
        pushMatrix();
        translate(n.position.x, n.position.y, n.position.z);
        
        noStroke();
        box(size);
        
        
        popMatrix();
        
        for(Edge edgeFrom: n.edgesFromThis){
          strokeWeight(map(edgeFrom.weight, 0, 13, 1, 8));
          stroke(colorEdges, map(edgeFrom.weight, 0, 11, 20, 255));  
          line(n.position.x, n.position.y, n.position.z,
               edgeFrom.target.position.x, edgeFrom.target.position.y, edgeFrom.target.position.z);
        }
        
        
      }
      popMatrix();
      hudFront();
    }
    
    if (record) { 
      endRaw();
      record = false;
      background(255,255,0);
    }
  }    

  
}


public void keyReleased() {
  switch(key){            
    case'A':
    case'a':
     activeNode--;
     if (activeNode < 0){
       activeNode = graphs.get(activeGraph).nodes.size()-1;
     }
     println("aN: " + activeNode + " ");
     activeNodeRef = activeGraphRef.nodes.get(activeGraphRef.nodes.keySet().toArray()[activeNode]);
     if (doSound) thread("speakNodeLabel");
     lookAtPV(PVector.add(activeGraphRef.position, activeNodeRef.position), 300);
    break;
    
    case'D':
    case'd':
     activeNode++;
     if (activeNode >= graphs.get(activeGraph).nodes.size()){
       activeNode = 0;
     }
     activeNodeRef = activeGraphRef.nodes.get(activeGraphRef.nodes.keySet().toArray()[activeNode]);
     if (doSound) thread("speakNodeLabel");
     lookAtPV(PVector.add(activeGraphRef.position, activeNodeRef.position), 300);
    break;
    
    case'W':
    case'w':
     activeGraph++;
     if (activeGraph >= graphs.size()){
       activeGraph = 0;
     }
     activeNode = -1;
     activeGraphRef = graphs.get(activeGraph);
     if (doSound) thread("speakGraphLabel");
     lookAtPV(activeGraphRef.position, 2000);
    break;
    
    case'S':
    case's':
      activeGraph--;
     if (activeGraph < 0){
       activeGraph = graphs.size()-1;
     }
     activeNode = -1;
     activeGraphRef = graphs.get(activeGraph);
     if (doSound) thread("speakGraphLabel");
     lookAtPV(activeGraphRef.position, 2000);
    break;
    
    case'P':
    case'p':
       record = true;
       saveFrame("screenshot-###.png");
    break;
    
    case'X':
    case'x':
     activeNodeRef = null;
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
    case'M':
    case'm':
      showGraphLabels = !showGraphLabels;
    break;
    case'N':
    case'n':
      showNodeLabels = !showNodeLabels;
    break;
    case'1':
      viewMode = COLOR_FROM_FILE;
    break;
    case'2':
      viewMode = COLOR_NEAR_ONES;
    break;
    case'3':
      viewMode = COLOR_ACTIVE_GROUP;
    break;
    case'Z':
    case'z':
      showSize = !showSize;
    break;
    case'O':
    case'o':
      doSound = !doSound;
    break;
    case'r':
      graphs.clear();
      multiGraph = 1;
      thread("loadData");
    break;
    case'R':
      graphs.clear();
      multiGraph++;
      thread("loadData");
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


void hudBack() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
    if (pointerV != null && activeGraphRef != null && showGraphLabels) {
        noStroke();
        strokeWeight(3);
        fill(colorHL);
        ellipseMode(RADIUS);
        float dellipse = PVector.dist(new PVector(cam.getPosition()[0], cam.getPosition()[1], cam.getPosition()[2]), activeGraphRef.position);
        float radious = constrain(map(dellipse, 0, 10000, 300, 50), 50, 300);
        ellipse(pointerV.x, pointerV.y, radious, radious);
        
        drawLabels(labelsGraph);
        drawLabels(labelsNode);     
        
      }
  // controlP5.draw();
  hint(ENABLE_DEPTH_TEST);
  cam.endHUD();

}


void hudFront() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
      if (showGraphLabels) drawLabels(labelsGraph);
      if (showNodeLabels) drawLabels(labelsNode);
  hint(ENABLE_DEPTH_TEST);
  strokeWeight(1);
  stroke(255);  
  line(mouseX, 0, mouseX, height);
  line(0, mouseY, width, mouseY);
  cam.endHUD();
}


void drawLabels(ArrayList<Label> labels){
  for (Label lab: labels){
          textFont(fontGraphLabel, lab.size);
          textAlign(CENTER);
          fill(lab.colour);
          text(lab.text, lab.x + lab.offx, lab.y + lab.offy);
        }
        labels.clear();
}

void controlEvent(ControlEvent theEvent) {
  println(theEvent.controller().id());
}

void delay(int delay)
{
  int time = millis();
  while(millis() - time <= delay);
}

boolean loadData(){
  loadingAllSteps = 0;
  loadingStep = 0;
  isDataLoaded = false;
  XML xmlConfigs = loadXML("config.xml");
  loadingAllSteps = xmlConfigs.getChildren("graph").length * multiGraph;
  for (int ig=0; ig<multiGraph; ig++){
      for(XML graphConfig: xmlConfigs.getChildren("graph")){
        XML xmlGraph = loadXML(graphConfig.getChild("file").getString("path"));
        Graph newGraph = new Graph(xmlGraph);
        graphs.add(newGraph);
        newGraph.id = graphConfig.getInt("id");
        newGraph.file = graphConfig.getChild("file").getString("path");
        newGraph.name = graphConfig.getChild("person").getString("name");
        newGraph.gender = graphConfig.getChild("person").getString("gender");
        newGraph.age = graphConfig.getChild("person").getString("age");
        newGraph.country = graphConfig.getChild("person").getString("country");
        newGraph.desc = graphConfig.getContent();
        loadingStep++;
        // delay(15);
      }
    }
    activeGraphRef = graphs.get(activeGraph);
    activeGraphOri = graphs.get(activeGraph);  
    lookAtPV(activeGraphRef.position, 2000);
    
    isDataLoaded = true;
    return true;
}

void mouseClicked() {
  if (overMouseNodeRef != null){
    // println(overMouseNodeRef);
    if (overMouseNodeRef != activeNodeRef) {
      activeNodeRef = overMouseNodeRef;
      if (doSound) thread("speakNodeLabel");
      lookAtPV(PVector.add(activeGraphRef.position, activeNodeRef.position), 300);
      overMouseNodeRef = null;
    }
    else if (overMouseNodeRef == activeNodeRef) {
      activeNodeRef = null;
    }
  }
}

void mousePressed(){
  if(mouseButton==LEFT){
     if(mouseEvent.getClickCount()==2){
        activeNodeRef=null;
        activeGraphRef = activeGraphOri;
        lookAtPV(activeGraphRef.position, 2000);
    }
  }
}


boolean isNearNode(Node nProbe, Node nSearch, int deep) {
  deep--;
  boolean success = false;
  if (deep >= 0){
      
    for (Edge edge: nProbe.edgesFromThis) {
      if (edge.target == nSearch || success){
        success = true;
        break;
      } else {
        for (Edge edgeD: edge.target.edgesFromThis) {
         if (isNearNode(edgeD.target, nSearch, deep)){
           success = true;
           break;
         }
        }
      }
    }
    
    for (Edge edge: nProbe.edgesToThis) {
      if (edge.source == nSearch || success){
        success = true;
        break;
      } else {
        for (Edge edgeD: edge.source.edgesToThis) {
         if (isNearNode(edgeD.source, nSearch, deep)){
           success = true;
           break;
         }
        }
      }
    }
    
  }
  return success; 
}

void speakNodeLabel(){
  tts.speak(activeNodeRef.label);
}

void speakGraphLabel(){
  tts.speak(activeGraphRef.name);
}

void introScreen(){
  background(179);
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
    noStroke();
    noFill();
    shape(logoSVG, width/2-192/2, height/2-240/2, 192, 244);
    stroke(124);
    line(width/2-150, height/2+220, width/2+150, height/2+220);
    stroke(255);
    line(width/2-150, height/2+220, width/2-150+map(loadingStep, 0, loadingAllSteps, 0, 300), height/2+220);
  hint(ENABLE_DEPTH_TEST);
  cam.endHUD();
  // introScreen();
}
