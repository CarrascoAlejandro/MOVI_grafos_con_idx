import 'package:flutter_on_class_011/models/edge_model.dart';
import 'package:flutter_on_class_011/models/node_model.dart';

void KruskalMST(List<NodeModel> nodes, List<EdgeModel> edges) {
  // Sort edges by weight
  edges.sort((a, b) => a.distance.compareTo(b.distance));

  // Create a list of sets, each containing a single node
  List<Set<NodeModel>> sets = nodes.map((node) => {node}.toSet()).toList();

  // Create a list of edges in the MST
  List<EdgeModel> mst = [];

  // Iterate through the sorted edges
  for (EdgeModel edge in edges) {
    // Find the sets containing the nodes of the edge
    Set<NodeModel> set1 = sets.firstWhere((set) => set.contains(edge.startNode));
    Set<NodeModel> set2 = sets.firstWhere((set) => set.contains(edge.endNode));

    // If the sets are different, merge them and add the edge to the MST
    if (set1 != set2) {
      mst.add(edge);
      sets.remove(set1);
      sets.remove(set2);
      sets.add(set1.union(set2));
    }
  }

  // Highlight the edges in the MST
  for (EdgeModel edge in edges) {
    edge.isMST = mst.contains(edge);
  }

  // Update the state
  // setState(() {});
}