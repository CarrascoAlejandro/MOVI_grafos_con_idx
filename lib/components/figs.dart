import 'package:flutter/material.dart';
import 'package:flutter_on_class_011/models/edge_model.dart';
import 'package:flutter_on_class_011/models/node_model.dart';
import 'package:flutter_on_class_011/utils/node_utils.dart';

class NodePainter extends CustomPainter {
  List<NodeModel> nodes;

  NodePainter(this.nodes);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    for (NodeModel node in nodes) {
      paint.color = node.isSelected ? Colors.green : node.color;
      canvas.drawCircle(Offset(node.x, node.y), node.radius, paint);

      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: node.label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(
              node.x - textPainter.width / 2, node.y - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class EdgePainter extends CustomPainter {
  List<EdgeModel> edges;

  EdgePainter(this.edges);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    Paint fillPaint = Paint()
      ..style = PaintingStyle.fill;

    for (EdgeModel edge in edges) {
      paint.color = edge.color ?? Colors.black;
      fillPaint.color = edge.color ?? Colors.black;

      // Draw the line
      Path path = Path();
      path.moveTo(edge.startNode.x, edge.startNode.y);
      try {
        path.arcToPoint(
          Offset(edge.endNode.x, edge.endNode.y),
          radius: Radius.circular(calculateRadius(
              edge.startNode.x, edge.startNode.y, edge.endNode.x, edge.endNode.y, edge.midX, edge.midY)),
            clockwise: isClockwise(
              edge.startNode.x, edge.startNode.y, edge.endNode.x, edge.endNode.y, edge.midX, edge.midY),
        );
      } catch (e) {
        print(e);
        path.lineTo(edge.endNode.x, edge.endNode.y);
      }
      canvas.drawPath(path, paint);

      // Draw the circle at the midpoint
      canvas.drawCircle(Offset(edge.midX, edge.midY), 10, fillPaint);

      // Draw the distance text inside the circle
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: edge.distance % 1 == 0 ? edge.distance.toInt().toString() : edge.distance.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(edge.midX - textPainter.width / 2, edge.midY - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
