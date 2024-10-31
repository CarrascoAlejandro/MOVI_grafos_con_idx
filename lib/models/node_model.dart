import 'package:flutter/material.dart';
import 'package:flutter_on_class_011/constants/ui_constants.dart';

class NodeModel {
  double x, y;
  Color color;
  String label;
  bool isSelected = false;
  double radius = nodeBaseRadius;

  NodeModel(this.x, this.y, this.color, this.label, {this.radius = nodeBaseRadius, this.isSelected = false});
}