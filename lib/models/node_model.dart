import 'package:flutter/material.dart';

class NodeModel {
  double x, y, radius;
  Color color;
  String label;
  bool isSelected = false;

  NodeModel(this.x, this.y, this.radius, this.color, this.label, {this.isSelected = false});
}