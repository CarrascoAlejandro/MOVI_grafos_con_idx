import 'package:flutter/material.dart';

class NodeModel {
  double x, y, radius;
  Color color;
  String label;
  bool isSelected = false;

  NodeModel(this.x, this.y, this.radius, this.color, this.label, {this.isSelected = false});
}

class EdgeModel {
  NodeModel startNode, endNode;
  double distance;
  late double midX, midY;
  bool isSelected = false;

  EdgeModel(this.startNode, this.endNode, this.distance, {this.isSelected = false}) {
    midX = (startNode.x + endNode.x) / 2;
    midY = (startNode.y + endNode.y) / 2;
  }
}