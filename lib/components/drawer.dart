import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.blue.shade600,
              Colors.blue.shade500,
              Colors.blue.shade400,
            ])),
            child: Column(
              children: [
                FlutterLogo(
                  size: 100,
                ),
                Text(
                  'App',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                )
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                print('Home');
              },
            ),
          ),
          Container(
            color: Colors.blue.shade100,
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                print('Settings');
              },
            ),
          ),
          Container(
            color: Colors.red.shade200,
            child: ListTile(
              leading: Icon(Icons.one_k),
              title: Text('Page 1'),
              onTap: () {},
            ),
          ),
          Container(
            color: Colors.yellow.shade200,
            child: ListTile(
              leading: Icon(Icons.two_k),
              title: Text('Page 2'),
              onTap: () {},
            ),
          ),
          Container(
            color: Colors.green.shade200,
            child: ListTile(
              leading: Icon(Icons.three_k),
              title: Text('Page 3'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
