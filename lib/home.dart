
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
  int selectedEdge = -1;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        
        body: Stack(
          children: [
            GestureDetector(
              onPanDown: (details) {
                setState(() {
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
                  } else if (mode == 3){
                    if (selectedNode == -1) {
                      selectedNode = findTouchedNode(details.localPosition.dx.toInt(), details.localPosition.dy.toInt(), nodes);
                      if (selectedNode != -1) {
                        nodes[selectedNode].isSelected = true;
                        print('Node selected $selectedNode');
                      }
                    } else {
                      nodes[selectedNode].x = details.localPosition.dx;
                      nodes[selectedNode].y = details.localPosition.dy;
                      nodes[selectedNode].isSelected = false;
                      selectedNode = -1;
                      print('Node moved');
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
                  } else if(mode == 5) {
                    if (selectedEdge == -1) {
                      selectedEdge = findTouchedEdgeMidpoint(details.localPosition.dx.toInt(), details.localPosition.dy.toInt(), edges);
                      if (selectedEdge != -1) {
                        edges[selectedEdge].isSelected = true;
                        print('Edge selected $selectedEdge');
                      }
                    } else {
                      // move the selected edge midpoint to the new position
                      if(isMidpointOOB(details.localPosition.dx, details.localPosition.dy, edges[selectedEdge].startNode.x, edges[selectedEdge].startNode.y, edges[selectedEdge].endNode.x, edges[selectedEdge].endNode.y)) {
                        edges[selectedEdge].midX = details.localPosition.dx;
                        edges[selectedEdge].midY = details.localPosition.dy;
                      } else {
                        print('Midpoint out of bounds capping to the maximum circle');
                        /* var cappedPoint = closestPointInBounds(
                          details.localPosition.dx,
                          details.localPosition.dy,
                          edges[selectedEdge].startNode.x,
                          edges[selectedEdge].startNode.y,
                          edges[selectedEdge].endNode.x,
                          edges[selectedEdge].endNode.y
                        );
                        edges[selectedEdge].midX = cappedPoint[0];
                        edges[selectedEdge].midY = cappedPoint[1]; */
                      }
                      edges[selectedEdge].isSelected = false;
                      selectedEdge = -1;
                      print('Edge moved');
                    }
                  }
                });
              },
              
            ),
            CustomPaint(
              painter: EdgePainter(edges),
            ),
            CustomPaint(
              painter: NodePainter(nodes),
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
              IconButton(
                onPressed: () {
                  setState(() {
                    if(mode == 5) {
                      mode = 0;
                    } else {
                      mode = 5;
                    }
                  });
                },
                icon: const Icon(Icons.back_hand_outlined),
                color: (mode == 5) ? Colors.purple : Colors.white,
              ),
            ],
          ),
        )
      ),
    );
  }
}