public class Edge {

  public int id;
  public Node source;
  public Node target;
  public float weight = 1.0;
 

  Edge(int id, Node source, Node target, float weight) {
   this.id = id;
   this.source = source;
   this.target = target;
   this.weight = weight;
  }
}
