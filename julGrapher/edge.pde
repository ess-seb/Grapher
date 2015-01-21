public class Edge {

  public int id;
  public int source;
  public int target;
  public float weight = 1.0;
 

  Edge(int id, int source, int target, float weight) {
   this.id = id;
   this.source = source;
   this.target = target;
   this.weight = weight;
  }
}
