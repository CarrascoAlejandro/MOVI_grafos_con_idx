import 'dart:math';
import 'package:flutter/material.dart';

List<Color> generateRandomColors(int count) {
  final random = Random();
  final colors = <Color>[];

  for (int i = 0; i < count - 1; i++) {
    colors.add(Color((random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0));
  }

  colors.add(Colors.teal.shade500);

  return colors;
}