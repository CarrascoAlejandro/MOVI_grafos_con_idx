import 'package:flutter_on_class_011/constants/ui_constants.dart';
import 'package:flutter_on_class_011/models/node_model.dart';
import 'package:flutter_on_class_011/models/edge_model.dart';

import 'dart:math';

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

int findTouchedEdgeMidpoint(int x, int y, List<EdgeModel> edges) {
  for (int i = 0; i < edges.length; i++) {
    if (x >= edges[i].midX - edgeTouchRadius &&
        x <= edges[i].midX + edgeTouchRadius &&
        y >= edges[i].midY - edgeTouchRadius &&
        y <= edges[i].midY + edgeTouchRadius) {
      return i;
    }
  }
  return -1;
}

double calculateRadius(double x1, double y1, double x2, double y2, double x3, double y3) {
  // Calculate delta values
  double dx2 = x2 - x1;
  double dy2 = y2 - y1;
  double dx3 = x3 - x1;
  double dy3 = y3 - y1;

  // Denominator for both x and y expressions
  double denominator = 2 * (dx2 * dy3 - dx3 * dy2);

  // Ensure no division by zero (points are collinear)
  if (denominator == 0) {
    throw Exception("Points are collinear, no circumcircle exists.");
  }

  // Calculate x and y coordinates of the circumcenter
  double numeratorX = dx2 * dx2 * dy3 - dx3 * dx3 * dy2 + dy2 * dy2 * dy3 - dy3 * dy3 * dy2;
  double numeratorY = dx2 * dx2 * dx3 - dx3 * dx3 * dx2 + dy2 * dy2 * dx3 - dy3 * dy3 * dx2;

  double circumcenterX = numeratorX / denominator;
  double circumcenterY = numeratorY / denominator;

  // Calculate the radius as the distance from the circumcenter to any point (p1)
  double radius = sqrt(circumcenterX * circumcenterX + circumcenterY * circumcenterY);

  return radius;
}

bool isClockwise(double x1, double y1, double x2, double y2, double x3, double y3) {
  // if the middle point is to the right of the line formed by the first and last points, the points are clockwise
  return (x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1) < 0;
}

bool isMidpointOOB(double x, double y, double x1, double y1, double midX, double midY) {
  // Check if the midpoint is out of the maximum possible circle between x1, y1 and x, y
  double dx = x - x1;
  double dy = y - y1;
  double d = sqrt(dx * dx + dy * dy);
  double dx2 = midX - x1;
  double dy2 = midY - y1;
  double d2 = sqrt(dx2 * dx2 + dy2 * dy2);
  return d2 > d;
}

List<double> closestPointInBounds(double intentX, double intentY, double x, double y, double x1, double y1){
  // if the intent point is OOB, find the closest point on the maximum circle between x, y and x1, y1
  double dx = x1 - x;
  double dy = y1 - y;
  double d = sqrt(dx * dx + dy * dy);

  // Normalize the direction vector
  double directionX = dx / d;
  double directionY = dy / d;

  // Calculate the closest point on the circle
  double closestX = x + directionX * d;
  double closestY = y + directionY * d;

  return [closestX, closestY];
}

