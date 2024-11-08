import 'package:flutter/material.dart';
import 'package:flutter_on_class_011/models/node_model.dart';

class EdgeModel {
  NodeModel startNode, endNode;
  double distance;
  late double midX, midY;
  bool isSelected = false;

  bool? isMST;
  Color? color;

  EdgeModel(this.startNode, this.endNode, this.distance, {this.isSelected = false}) {
    midX = (startNode.x + endNode.x) / 2;
    midY = (startNode.y + endNode.y) / 2;
  }
}