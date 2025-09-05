import 'dart:math';
import 'package:flutter/material.dart';
import 'package:myapp/screen/quiz/models/balloon_model.dart';

class BalloonPainter extends CustomPainter {
  final List<Balloon> balloons;

  BalloonPainter({required this.balloons});

  @override
  void paint(Canvas canvas, Size size) {
    final balloonPaint = Paint();
    final stringPaint = Paint()
      ..color = Colors.white.withOpacity(0.4) // Reduced opacity for a softer look
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (var balloon in balloons) {
      // 1. Draw the oval body
      balloonPaint.color = balloon.color;
      final rect = Rect.fromCenter(
        center: Offset(balloon.x, balloon.y),
        width: balloon.size * 1.6,
        height: balloon.size * 2,
      );
      canvas.drawOval(rect, balloonPaint);

      // 2. Draw the knot
      final knotCenter = Offset(balloon.x, balloon.y + balloon.size);
      canvas.drawCircle(knotCenter, 3.0, balloonPaint);

      // 3. Draw the squiggly string
      final path = Path();
      path.moveTo(knotCenter.dx, knotCenter.dy);

      final segmentLength = (balloon.size * 3) / balloon.stringSegments;

      for (int i = 0; i < balloon.stringSegments; i++) {
        final controlX = knotCenter.dx + balloon.stringHorizontalOffsets[i];
        final controlY = knotCenter.dy + segmentLength * (i + 0.5);
        final endX = knotCenter.dx;
        final endY = knotCenter.dy + segmentLength * (i + 1);

        path.quadraticBezierTo(controlX, controlY, endX, endY);
      }

      canvas.drawPath(path, stringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
