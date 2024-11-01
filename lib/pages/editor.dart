import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_on_class_011/utils/algorithm.dart';
import 'package:flutter_on_class_011/components/drawer.dart';
import 'package:flutter_on_class_011/components/figs.dart';
import 'package:flutter_on_class_011/models/node_model.dart';
import 'package:flutter_on_class_011/models/edge_model.dart';
import 'package:flutter_on_class_011/utils/node_name_generator.dart';
import 'package:flutter_on_class_011/utils/node_utils.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  List<NodeModel> nodes = [];
  List<EdgeModel> edges = [];
  NextNodeNameGenerator nextNodeNameGenerator = NextNodeNameGenerator(true);
  int mode = 0;
  int selectedNode = -1;
  int selectedEdge = -1;

  // Random
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Editor'),
        ),
          body: Stack(
            children: [
              GestureDetector(
                onPanDown: (details) {
                  setState(() {
                    print('Current mode: $mode');
                    if (mode != 7) {
                      for (var edge in edges) {
                        edge.isMST = null;
                      }
                    }
                    if (mode == 1) {
                      nodes.add(NodeModel(
                          details.localPosition.dx,
                          details.localPosition.dy,
                          Colors.teal,
                          nextNodeNameGenerator.getNextNodeName()));
                      print('Node added ${nodes.length}');
                    } else if (mode == 2) {
                      int touchedNode = findTouchedNode(
                          details.localPosition.dx.toInt(),
                          details.localPosition.dy.toInt(),
                          nodes);
                      if (touchedNode != -1) {
                        // Remove all edges connected to the node
                        edges.removeWhere((edge) =>
                            edge.startNode == nodes[touchedNode] ||
                            edge.endNode == nodes[touchedNode]);
                        nodes.removeAt(touchedNode);
                        print('Node removed $touchedNode');
                      }
                    } else if (mode == 3) {
                      if (selectedNode == -1) {
                        selectedNode = findTouchedNode(
                            details.localPosition.dx.toInt(),
                            details.localPosition.dy.toInt(),
                            nodes);
                        if (selectedNode != -1) {
                          nodes[selectedNode].isSelected = true;
                          print('Node selected $selectedNode');
                        }
                      } else {
                        nodes[selectedNode].x = details.localPosition.dx;
                        nodes[selectedNode].y = details.localPosition.dy;
                        nodes[selectedNode].isSelected = false;
                        // For each edge connected to the node, update the midpoint
                        for (var edge in edges) {
                          if (edge.startNode == nodes[selectedNode] ||
                              edge.endNode == nodes[selectedNode]) {
                                if(isMidpointOOB(
                                  edge.startNode.x,
                                  edge.startNode.y,
                                  edge.endNode.x,
                                  edge.endNode.y,
                                  edge.midX,
                                  edge.midY
                                )){
                                  edge.midX = (edge.startNode.x + edge.endNode.x) / 2;
                                  edge.midY = (edge.startNode.y + edge.endNode.y) / 2;
                                }
                          }
                        }

                        selectedNode = -1;
                        print('Node moved');
                      }
                    } else if (mode == 4) {
                      int touchedNode = findTouchedNode(
                          details.localPosition.dx.toInt(),
                          details.localPosition.dy.toInt(),
                          nodes);
                      if (touchedNode != -1) {
                        if (selectedNode == -1) {
                          selectedNode = touchedNode;
                          nodes[selectedNode].isSelected = true;
                          print('Node selected $selectedNode');
                        } else {
                          edges.add(EdgeModel(nodes[selectedNode],
                              nodes[touchedNode], random.nextInt(10) + 1));
                          nodes[selectedNode].isSelected = false;
                          selectedNode = -1;
                          print('Edge added');
                        }
                      }
                    } else if (mode == 5) {
                      if (selectedEdge == -1) {
                        selectedEdge = findTouchedEdgeMidpoint(
                            details.localPosition.dx.toInt(),
                            details.localPosition.dy.toInt(),
                            edges);
                        if (selectedEdge != -1) {
                          edges[selectedEdge].isSelected = true;
                          print('Edge selected $selectedEdge');
                        }
                      } else {
                        // move the selected edge midpoint to the new position
                        if (!isMidpointOOB(
                            edges[selectedEdge].startNode.x,
                            edges[selectedEdge].startNode.y,
                            edges[selectedEdge].endNode.x,
                            edges[selectedEdge].endNode.y,
                            details.localPosition.dx,
                            details.localPosition.dy)) {
                          edges[selectedEdge].midX = details.localPosition.dx;
                          edges[selectedEdge].midY = details.localPosition.dy;
                        } else {
                          print(
                              'Midpoint out of bounds capping to the maximum circle');
                           var cappedPoint = closestPointInBounds(
                          details.localPosition.dx,
                          details.localPosition.dy,
                          edges[selectedEdge].startNode.x,
                          edges[selectedEdge].startNode.y,
                          edges[selectedEdge].endNode.x,
                          edges[selectedEdge].endNode.y
                        );
                          print('Capped point: $cappedPoint');
                        edges[selectedEdge].midX = cappedPoint[0];
                        edges[selectedEdge].midY = cappedPoint[1]; 
                        }
                        edges[selectedEdge].isSelected = false;
                        selectedEdge = -1;
                        print('Edge moved');
                      }
                    } else if (mode == 8) {
                      // If tapped on a node, show the Change Node Name Input Dialog
                      // If tapped on an edge, show the Change Edge Weight Input Dialog
                      int touchedNode = findTouchedNode(
                          details.localPosition.dx.toInt(),
                          details.localPosition.dy.toInt(),
                          nodes);
                      if (touchedNode != -1) {
                        print('Touched node: $touchedNode');
                        showChangeNodeNameDialog(context, nodes[touchedNode]);
                      } else {
                        int touchedEdge = findTouchedEdgeMidpoint(
                            details.localPosition.dx.toInt(),
                            details.localPosition.dy.toInt(),
                            edges);
                        if (touchedEdge != -1) {
                          print('Touched edge: $touchedEdge');
                          showChangeEdgeWeightDialog(context, edges[touchedEdge]);
                        }
                      }

                      // clear the touched node and edge
                      selectedNode = -1;
                      selectedEdge = -1;
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
            color: Colors.blueGrey.shade700,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (mode == 1) {
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
                      if (mode == 2) {
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
                      if (mode == 3) {
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
                      if (mode == 4) {
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
                      if (mode == 5) {
                        mode = 0;
                      } else {
                        mode = 5;
                      }
                    });
                  },
                  icon: const Icon(Icons.back_hand_outlined),
                  color: (mode == 5) ? Colors.purple : Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (mode == 7) {
                        mode = 0;
                        for (var edge in edges) {
                          edge.isMST = null;
                        }
                      } else {
                        mode = 7;
                        KruskalMST(nodes, edges);
                      }
                    });
                  },
                  icon: const Icon(Icons.search),
                  color: (mode == 7) ? Colors.cyan.shade700 : Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (mode == 8) {
                        mode = 0;
                      } else {
                        mode = 8;
                      }
                    });
                  },
                  icon: const Icon(Icons.edit),
                  color: (mode == 8) ? Colors.cyan.shade700 : Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    showHelpDialog(context);
                  },
                  icon: const Icon(Icons.help),
                  color: Colors.white,
                )
              ],
            ),
          )),
    );
  }

  void showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Help'),
          content: const Text('1. Add Node: Tap on the screen to add a node\n'
              '2. Delete Node: Tap on a node to delete it\n'
              '3. Move Node: Tap on a node to select it, then tap on another location to move it\n'
              '4. Add Edge: Tap on a node to select it, then tap on another node to create an edge\n'
              '5. Move Edge: Tap on an edge to select it, then tap on another location to move the midpoint\n'
              '6. Find MST: Tap on the search icon to find the minimum spanning tree\n'
              '7. Help: Tap on the help icon to display this dialog\n'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showChangeNodeNameDialog(BuildContext context, NodeModel nod) async {
    final TextEditingController nodeNameController = TextEditingController();
    nodeNameController.text = nod.label;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Node Name'),
          content: TextField(
            controller: nodeNameController,
            decoration: const InputDecoration(labelText: 'Node Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  nod.label = nodeNameController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showChangeEdgeWeightDialog(BuildContext context, EdgeModel edg) async {
    final TextEditingController edgeWeightController = TextEditingController();
    edgeWeightController.text = edg.distance.toString();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Edge Weight'),
          content: TextField(
            controller: edgeWeightController,
            decoration: const InputDecoration(labelText: 'Edge Weight'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  edg.distance = double.parse(edgeWeightController.text);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
