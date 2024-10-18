import 'package:flutter_on_class_011/models.dart';

int findTouchedNode(int x, int y, List<NodeModel> nodes) {
  for (int i = 0; i < nodes.length; i++) {
    if (x >= nodes[i].x - nodes[i].radius &&
        x <= nodes[i].x + nodes[i].radius &&
        y >= nodes[i].y - nodes[i].radius &&
        y <= nodes[i].y + nodes[i].radius) {
      return i;
    }
  }
  return -1;
}