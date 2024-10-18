
import 'package:flutter/material.dart';
import 'package:flutter_on_class_011/figs.dart';
import 'package:flutter_on_class_011/models.dart';
import 'package:flutter_on_class_011/node_utils.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<NodeModel> nodes = [];
  List<EdgeModel> edges = [];
  int mode = 0;
  int selectedNode = -1;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        
        body: Stack(
          children: [
            CustomPaint(
              painter: NodePainter(nodes),
            ),
            CustomPaint(
              painter: EdgePainter(edges),
            ),
            GestureDetector(
              onPanDown: (details) {
                print('Current mode: $mode');
                if(mode == 1) {
                  nodes.add(NodeModel(
                    details.localPosition.dx,
                    details.localPosition.dy,
                    20.0,
                    Colors.teal,
                    '${nodes.length + 1}'
                  ));
                  print('Node added ${nodes.length}');
                } else if(mode == 2) {
                  int touchedNode = findTouchedNode(details.localPosition.dx.toInt(), details.localPosition.dy.toInt(), nodes);
                  if(touchedNode != -1) {
                    nodes.removeAt(touchedNode);
                    print('Node removed $touchedNode');
                  }
                } else if(mode == 4) {
                  int touchedNode = findTouchedNode(details.localPosition.dx.toInt(), details.localPosition.dy.toInt(), nodes);
                  if(touchedNode != -1) {
                    if(selectedNode == -1) {
                      selectedNode = touchedNode;
                      print('Node selected $selectedNode');

                    } else {
                      edges.add(EdgeModel(nodes[selectedNode], nodes[touchedNode], 0.0));
                      selectedNode = -1;
                      print('Edge added');
                    }
                  }
                }
              },
              onPanUpdate: (details) {
                print('Current mode: $mode');
                if(mode == 3) {
                  int touchedNode = findTouchedNode(details.localPosition.dx.toInt(), details.localPosition.dy.toInt(), nodes);
                  if(touchedNode != -1) {
                    nodes[touchedNode].x = details.localPosition.dx;
                    nodes[touchedNode].y = details.localPosition.dy;
                    print('Node moved $touchedNode');
                  }
                }
              },
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  print('List of nodes:\n $nodes');
                  print('List of edges:\n $edges');
                },
                icon: const Icon(Icons.search),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if(mode == 1) {
                      mode = 0;
                    } else {
                      mode = 1;
                    }
                  });
                },
                icon: const Icon(Icons.add),
                color: (mode == 1) ? Colors.amber.shade400 : Colors.white,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if(mode == 2) {
                      mode = 0;
                    } else {
                      mode = 2;
                    }
                  });
                },
                icon: const Icon(Icons.delete),
                color: (mode == 2) ? Colors.red : Colors.white,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if(mode == 3) {
                      mode = 0;
                    } else {
                      mode = 3;
                    }
                  });
                },
                icon: const Icon(Icons.back_hand_rounded),
                color: (mode == 3) ? Colors.green : Colors.white,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if(mode == 4) {
                      mode = 0;
                    } else {
                      mode = 4;
                    }
                  });
                },
                icon: const Icon(Icons.arrow_forward),
                color: (mode == 4) ? Colors.pink.shade300 : Colors.white,
              ),
            ],
          ),
        )
      ),
    );
  }
}