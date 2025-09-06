import 'dart:math';
import 'package:flutter/material.dart';

class PartyHatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Hat body (cone)
    paint.color = Colors.blue.withAlpha(150);
    final path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    // Pom-pom
    paint.color = Colors.yellow.withAlpha(200);
    canvas.drawCircle(Offset(size.width * 0.5, 0), size.width * 0.15, paint);

    // Stripes
    paint.color = Colors.white.withAlpha(180);
    paint.strokeWidth = 2;
    for (double i = 0.2; i < 1.0; i += 0.25) {
      final y = size.height * i;
      final x1 = size.width * 0.5 - (y / size.height) * (size.width * 0.5);
      final x2 = size.width * 0.5 + (y / size.height) * (size.width * 0.5);
      canvas.drawLine(Offset(x1, y), Offset(x2, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
