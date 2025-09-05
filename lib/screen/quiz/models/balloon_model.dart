import 'dart:math';
import 'package:flutter/material.dart';

class Balloon {
  final int id;
  late double x, y;
  final double size;
  final double speed;
  final Color color;

  // Properties for the squiggly string
  late int stringSegments;
  late List<double> stringHorizontalOffsets;

  Balloon({
    required this.id,
    required this.size,
    required this.speed,
    required this.color,
  });

  void reset(Size screenSize) {
    final random = Random();
    x = random.nextDouble() * screenSize.width;
    y = random.nextDouble() * screenSize.height + screenSize.height; // Start below the screen

    // Generate a random pattern for the string
    stringSegments = random.nextInt(2) + 2; // 2 or 3 squiggles
    stringHorizontalOffsets = List.generate(
      stringSegments,
      (_) => (random.nextDouble() - 0.5) * size * 1.5, // Random horizontal pull
    );
  }

  void move(Size screenSize) {
    y -= speed;
    // The balloon body's lowest point is y + size.
    // The string adds another 3 * size to the length.
    // So, we reset when the whole object is off-screen.
    if (y < -(size * 5)) {
      reset(screenSize);
    }
  }
}
