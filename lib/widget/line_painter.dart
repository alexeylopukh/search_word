import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class LinePainter extends CustomPainter {
  final Offset firstPoint;
  final Offset secondPoint;
  final double width;
  final Color color;

  LinePainter(this.firstPoint, this.secondPoint, this.width, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final pointMode = ui.PointMode.polygon;
    final points = [firstPoint, secondPoint];
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}
