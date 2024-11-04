import 'package:flutter/material.dart';
import 'package:flutter_on_class_011/pages/about.dart';
import 'package:flutter_on_class_011/pages/editor.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.blue.shade600,
                Colors.blue.shade500,
                Colors.blue.shade400,
              ])),
              child: Column(
                children: [
                  Image.asset(
                    'images/icons8-cloud-computing-64.png',
                    height: 100,),
                  Text(
                    'Kruskal\'s MST Graph Editor',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              ),
            ),
            // Add more items here if needed
            ListTile(
              title: const Text('About'),
              leading: Icon(Icons.info_outline),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => (AboutPage())));
              },
            ),
            ListTile(
              title: const Text('Editor'),
              leading: Icon(Icons.insights_rounded),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Editor()));
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Minimum_spanning_tree.svg/800px-Minimum_spanning_tree.svg.png',
                height: 200),
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
            Image.network(
                'https://images.stockcake.com/public/e/0/7/e07e8b9c-aff2-45bf-aff2-2b12d5df9480_large/industrial-pipe-network-stockcake.jpg',
                height: 200),
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
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Editor()));
                },
                child:
                    const Text('Go to Editor', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
