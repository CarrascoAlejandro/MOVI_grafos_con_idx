import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network('https://via.placeholder.com/400x200', height: 200),
            const SizedBox(height: 16.0),
            const Text(
              'Kruskal\'s Minimum Spanning Tree',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Kruskal\'s algorithm is a minimum-spanning-tree algorithm which finds an edge of the least possible weight that connects any two trees in the forest. It is a greedy algorithm in graph theory as it finds a minimum spanning tree for a connected weighted graph adding increasing cost arcs at each step.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            Image.network('https://via.placeholder.com/400x200', height: 200),
            const SizedBox(height: 16.0),
            const Text(
              'Real-life Applications',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            const Text(
              '1. Network Design: Kruskal\'s algorithm can be used to design efficient networks, such as computer networks, telecommunications networks, and transportation networks.\n\n'
              '2. Approximation Algorithms: It is used in various approximation algorithms for NP-hard problems, including the traveling salesman problem.\n\n'
              '3. Cluster Analysis: Kruskal\'s algorithm is used in hierarchical clustering to build a minimum spanning tree of the data points.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WelcomePage(),
  ));
}