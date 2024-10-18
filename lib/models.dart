import 'package:flutter/material.dart';

class NodeModel {
  double x, y, radius;
  Color color;
  String label;

  NodeModel(this.x, this.y, this.radius, this.color, this.label);
}

class EdgeModel {
  NodeModel startNode, endNode;
  double distance;

  EdgeModel(this.startNode, this.endNode, this.distance);
}