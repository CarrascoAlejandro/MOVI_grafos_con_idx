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
                  Icon(
                    Icons.insights_rounded,
                    size: 100,
                    color: Colors.white,
                  ),
                  Text(
                    'Kruskal\'s Graph Editor',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              ),
            ),
            // Add more items here if needed
            ListTile(
              title: const Text('Acerca del desarrollador'),
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
              'Algoritmo de Kruskal para árboles de expansión mínima',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            const Text(
                'El algoritmo de Kruskal es un algoritmo de árbol de expansión mínima que encuentra un borde el árbol de menor peso total en un grafo no direccionado. Es un algoritmo greedy en teoría de grafos ya que encuentra un árbol de expansión mínima para un grafo ponderado conectado, agregando arcos de costo creciente en cada paso.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            Image.network(
                'https://images.stockcake.com/public/e/0/7/e07e8b9c-aff2-45bf-aff2-2b12d5df9480_large/industrial-pipe-network-stockcake.jpg',
                height: 200),
            const SizedBox(height: 16.0),
            const Text(
              'Aplicaciones de la vida real',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            const Text(
                '1. Diseño de Redes: El algoritmo de Kruskal se puede utilizar para diseñar redes eficientes, como redes de computadoras, redes de telecomunicaciones y redes de transporte.\n\n'
                '2. Algoritmos de Aproximación: Se utiliza en varios algoritmos de aproximación para problemas NP-difíciles, incluido el problema del vendedor viajero.\n\n'
                '3. Análisis de Clústeres: El algoritmo de Kruskal se utiliza en el agrupamiento jerárquico para construir un árbol de expansión mínima de los puntos de datos.',
              style: TextStyle(fontSize: 16),
            ),
            Center(
                child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Editor()));
                  },
                  child: const Text('Ir al Editor', style: TextStyle(fontSize: 20)),
                ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
