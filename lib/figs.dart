import 'package:flutter/material.dart';
import 'package:flutter_on_class_011/models.dart';

class NodePainter extends CustomPainter{

  List<NodeModel> nodes;

  NodePainter(this.nodes);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    for (NodeModel node in nodes) {
      paint.color = node.color;
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
      textPainter.paint(canvas, Offset(node.x - textPainter.width / 2, node.y - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}

class EdgePainter extends CustomPainter{

  List<EdgeModel> edges;

  EdgePainter(this.edges);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 2.0
      ..color = Colors.black;

    for (EdgeModel edge in edges) {
      canvas.drawLine(Offset(edge.startNode.x, edge.startNode.y), Offset(edge.endNode.x, edge.endNode.y), paint);

      TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: edge.distance.toStringAsFixed(2),
        style: TextStyle(
        color: Colors.black,
        fontSize: 20,
        ),
      ),
      textDirection: TextDirection.ltr,
      );
      
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}