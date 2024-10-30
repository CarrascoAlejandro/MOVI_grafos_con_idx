import 'package:flutter/material.dart';
import 'package:flutter_on_class_011/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grafos',
      home: Home(),
    );
  }
}
