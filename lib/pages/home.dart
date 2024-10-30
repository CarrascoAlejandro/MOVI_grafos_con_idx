import 'package:flutter/material.dart';
import 'package:flutter_on_class_011/pages/welcome.dart';
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
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            // Add more items here if needed
            ListTile(
              title: const Text('Welcome Page'),
              onTap: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => WelcomePage())
                );
              },
            ),
            ListTile(
              title: const Text('Editor Page'),
              onTap: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Editor())
                );
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Home Page Content'),
      ),
    );
  }
}