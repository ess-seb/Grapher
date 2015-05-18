public class Graph {
  
  HashMap<Integer, Node> nodes = new HashMap<Integer, Node>();
  PVector position;
  int id;
  String file;
  String name;
  String gender;
  String country;
  String age;
  String desc;
  
  Graph(XML xmlGraph) {
    position = new PVector(random(4000),random(4000),random(4000));
    // println(position);
    
    XML[] nodes = xmlGraph.getChild("graph").getChild("nodes").getChildren("node");
    // println("Nodes: " + nodes.length);
    for(XML node: nodes){
      int id = node.getInt("id");
      String label = node.getString("label");
      
      float size = node.getChild("viz:size").getFloat("value");
      float posX = node.getChild("viz:position").getFloat("x")/10;
      float posY = node.getChild("viz:position").getFloat("y")/10;
      float posZ = node.getChild("viz:position").getFloat("z")/10;
      
      PVector position = new PVector(posX, posY, posZ);
      
      int colR = 0, colG = 0, colB = 0;
      if (hasChild(node, "viz:color")){
        colR = node.getChild("viz:color").getInt("r");
        colG = node.getChild("viz:color").getInt("g");
        colB = node.getChild("viz:color").getInt("b");
      }
      color colour = color(colR, colG, colB);
      float ecce = node.getChild("attvalues").getChildren("attvalue")[0].getFloat("value");
      float closeness = node.getChild("attvalues").getChildren("attvalue")[1].getFloat("value");
      float between = node.getChild("attvalues").getChildren("attvalue")[2].getFloat("value");
      float modclass = node.getChild("attvalues").getChildren("attvalue")[3].getFloat("value");

      // println(id + " " + label + " " + size + " " + position + " " + colour + " " + ecce + " " + closeness + " " + between + " " + modclass);
      this.nodes.put(id, new Node(id, label, size, position, colour, ecce, closeness, between, modclass));
      
    }
    
    XML[] edges = xmlGraph.getChild("graph").getChild("edges").getChildren("edge");
    // println("\n\nEdges: " + edges.length);
    
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
      
      // println(id + " " + source + " " + target + " " + weight);
      
      Edge myEdge = new Edge(id, this.nodes.get(source), this.nodes.get(target), weight);
      this.nodes.get(source).addEdge(myEdge);
      this.nodes.get(target).addEdge(myEdge);
    }
    // println("LOADING COMPLETE");
  }
  
}
