import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_on_class_011/constants/ui_constants.dart';
import 'package:flutter_on_class_011/utils/algorithm.dart';
import 'package:flutter_on_class_011/components/figs.dart';
import 'package:flutter_on_class_011/models/node_model.dart';
import 'package:flutter_on_class_011/models/edge_model.dart';
import 'package:flutter_on_class_011/utils/animation_colors.dart';
import 'package:flutter_on_class_011/utils/node_name_generator.dart';
import 'package:flutter_on_class_011/utils/node_utils.dart';
import 'package:flutter_on_class_011/utils/scale_move_utils.dart';

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
  bool kruskalMSTmaximized = true;
  bool zoomingIn = false;
  String showingTreeTitle = 'Editor';

  // Random
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: (mode == 7)
                ? Text('Árbol de Expansión $showingTreeTitle')
                : Text('Editor'),
            actions: [
              // Go back to the home page
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.home),
              ),
            ],
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
                          Colors.teal.shade300,
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
                      } else {
                        // Remove the edge if it was touched
                        int touchedEdge = findTouchedEdgeMidpoint(
                            details.localPosition.dx.toInt(),
                            details.localPosition.dy.toInt(),
                            edges);
                        if (touchedEdge != -1) {
                          edges.removeAt(touchedEdge);
                          print('Edge removed $touchedEdge');
                        }
                      }
                    } else if (mode == 3) {
                      if (selectedNode == -1) {
                        // if no node is selected
                        selectedNode = findTouchedNode(
                            details.localPosition.dx.toInt(),
                            details.localPosition.dy.toInt(),
                            nodes);
                        if (selectedNode != -1) {
                          // if node was touched in bounds
                          nodes[selectedNode].isSelected = true;
                          print('Node selected $selectedNode');
                        } else {
                          // if no node was selected check edges
                          if (selectedEdge == -1) {
                            // if no edge is selected
                            selectedEdge = findTouchedEdgeMidpoint(
                                details.localPosition.dx.toInt(),
                                details.localPosition.dy.toInt(),
                                edges);
                            if (selectedEdge != -1) {
                              // if edge was touched in bounds
                              edges[selectedEdge].isSelected = true;
                              edges[selectedEdge].color = Colors.red;
                              print('Edge selected $selectedEdge');
                            } else {
                              // no edge nor node was touched
                              print('Nothing selected');
                            }
                          } else {
                            // move the selected edge midpoint to the new position
                            // as long as it is in bounds otherwise cap it to the maximum circle
                            if (!isMidpointOOB(
                                edges[selectedEdge].startNode.x,
                                edges[selectedEdge].startNode.y,
                                edges[selectedEdge].endNode.x,
                                edges[selectedEdge].endNode.y,
                                details.localPosition.dx,
                                details.localPosition.dy)) {
                              edges[selectedEdge].midX =
                                  details.localPosition.dx;
                              edges[selectedEdge].midY =
                                  details.localPosition.dy;
                            } else {
                              print(
                                  'Midpoint out of bounds capping to the maximum circle');
                              var cappedPoint = closestPointInBounds(
                                  details.localPosition.dx,
                                  details.localPosition.dy,
                                  edges[selectedEdge].startNode.x,
                                  edges[selectedEdge].startNode.y,
                                  edges[selectedEdge].endNode.x,
                                  edges[selectedEdge].endNode.y);
                              print('Capped point: $cappedPoint');
                              edges[selectedEdge].midX = cappedPoint[0];
                              edges[selectedEdge].midY = cappedPoint[1];
                            }
                            edges[selectedEdge].isSelected = false;
                            edges[selectedEdge].color = null;
                            selectedEdge = -1;
                            print('Edge moved');
                          }
                        }
                      } else {
                        // if a node is already selected move it
                        nodes[selectedNode].x = details.localPosition.dx;
                        nodes[selectedNode].y = details.localPosition.dy;
                        nodes[selectedNode].isSelected = false;
                        // For each edge connected to the node, update the midpoint
                        for (var edge in edges) {
                          if (edge.startNode == nodes[selectedNode] ||
                              edge.endNode == nodes[selectedNode]) {
                            if (isMidpointOOB(
                                edge.startNode.x,
                                edge.startNode.y,
                                edge.endNode.x,
                                edge.endNode.y,
                                edge.midX,
                                edge.midY)) {
                              edge.midX =
                                  (edge.startNode.x + edge.endNode.x) / 2;
                              edge.midY =
                                  (edge.startNode.y + edge.endNode.y) / 2;
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
                      if (zoomingIn) {
                        nodes.forEach((node) {
                          node.x = scaleLinearFromCenter(
                              node.x, details.localPosition.dx);
                          node.y = scaleLinearFromCenter(
                              node.y, details.localPosition.dy);
                        });
                        edges.forEach((edge) {
                          edge.midX = scaleLinearFromCenter(
                              edge.midX, details.localPosition.dx);
                          edge.midY = scaleLinearFromCenter(
                              edge.midY, details.localPosition.dy);
                        });
                      } else {
                        nodes.forEach((node) {
                          node.x = scaleLinearFromCenter(
                              node.x,
                              details.localPosition.dx,
                              1 / defaultScalingFactor);
                          node.y = scaleLinearFromCenter(
                              node.y,
                              details.localPosition.dy,
                              1 / defaultScalingFactor);
                        });
                        edges.forEach((edge) {
                          edge.midX = scaleLinearFromCenter(
                              edge.midX,
                              details.localPosition.dx,
                              1 / defaultScalingFactor);
                          edge.midY = scaleLinearFromCenter(
                              edge.midY,
                              details.localPosition.dy,
                              1 / defaultScalingFactor);
                        });
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
                          showChangeEdgeWeightDialog(
                              context, edges[touchedEdge]);
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
          bottomNavigationBar: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: BottomAppBar(
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
                        if (mode != 7) {
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(
                              MediaQuery.of(context).size.width / 2,
                              MediaQuery.of(context).size.height - 50,
                              MediaQuery.of(context).size.width / 2,
                              0,
                            ),
                            items: [
                              PopupMenuItem(
                                value: 'max',
                                child: Text('Max'),
                              ),
                              PopupMenuItem(
                                value: 'min',
                                child: Text('Min'),
                              ),
                            ],
                          ).then((value) {
                            setState(() {
                              if (value == 'max') {
                                kruskalMSTmaximized = true;
                              } else if (value == 'min') {
                                kruskalMSTmaximized = false;
                              }
                              mode = 7;
                              showingTreeTitle = (kruskalMSTmaximized)
                                  ? 'Máxima'
                                  : 'Mínima';
                              KruskalMST(nodes, edges, kruskalMSTmaximized);
                            });
                            setState(() {
                              List<EdgeModel> edgesInMST = edges.where((edge) => edge.isMST == true).toList();
                              List<Color> colors = generateRandomColors(edgesInMST.length -1);
                              print(colors);
                              for(int i = 0; i < (2*edgesInMST.length)-1; i++) {
                                
                                Future.delayed(Duration(milliseconds: 150 * i), () {
                                  setState(() {
                                    print("iteration: $i");
                                    for(int j = 0; j < edgesInMST.length; j++){
                                      int colorIndex = min(max(-1, i-j), colors.length-1);
                                      if(colorIndex != -1){
                                        edgesInMST[j].color = colors[colorIndex];
                                        print("putting color: ${colors[colorIndex]} in edge: ${edgesInMST[j].startNode.label} - ${edgesInMST[j].endNode.label}");
                                      }
                                        
                                      
                                    }

                                  });
                                });
                              }
                            });
                          });
                        } else if (mode == 7) {
                          setState(() {
                            mode = 0;
                            for (var edge in edges) {
                              edge.isMST = null;
                              edge.color = null;
                            }
                          });
                        }
                      },
                      icon: const Icon(Icons.insights),
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
                      color:
                          (mode == 8) ? Colors.purple.shade700 : Colors.white,
                    ),
                    IconButton(
                      onPressed: () {
                        if (mode != 7) {
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(
                              MediaQuery.of(context).size.width / 2,
                              MediaQuery.of(context).size.height - 50,
                              MediaQuery.of(context).size.width / 2,
                              0,
                            ),
                            items: [
                              PopupMenuItem(
                                value: 'zoomIn',
                                child: Text('Zoom In'),
                              ),
                              PopupMenuItem(
                                value: 'zoomOut',
                                child: Text('Zoom Out'),
                              ),
                            ],
                          ).then((value) {
                            setState(() {
                              if (value == 'zoomIn') {
                                zoomingIn = true;
                              } else if (value == 'zoomOut') {
                                zoomingIn = false;
                              }
                              mode = 5;
                            });
                          });
                        } else if (mode == 5) {
                          setState(() {
                            mode = 0;
                          });
                        }
                      },
                      icon: const Icon(Icons.zoom_in),
                      color: (mode == 5) ? Colors.orange : Colors.white,
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
              ))),
    );
  }

  void showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Help'),
          content: const Text(
              "1. Añadir Nodo: Toca en la pantalla para añadir un nodo\n"
              "2. Eliminar Nodo: Toca en un nodo o borde para eliminarlo\n"
              "3. Mover Nodo: Toca en un nodo o borde para seleccionarlo, luego toca en la pantalla para moverlo\n"
              "4. Añadir Arista: Toca en un nodo para seleccionarlo, luego toca en otro nodo para añadir una arista\n"
              "5. Encontrar MST: Toca en la pantalla para encontrar el Árbol de Expansión Mínima/Máxima\n"
              "6. Editar Nodo/Arista: Toca en un nodo para cambiar su nombre, toca en una arista para cambiar su peso\n"
              "7. Acercar/Alejar: Toca en la pantalla para acercar/alejar\n"
              "8. Ayuda: Toca en el icono de ayuda para mostrar este diálogo\n"),
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

  Future<void> showChangeNodeNameDialog(
      BuildContext context, NodeModel nod) async {
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

  Future<void> showChangeEdgeWeightDialog(
      BuildContext context, EdgeModel edg) async {
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
            keyboardType: TextInputType.number,
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
