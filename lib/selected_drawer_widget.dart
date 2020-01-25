import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:vibration/vibration.dart';

class SelectedDrawerWidget extends StatefulWidget {
  final double size;
  final double width;

  SelectedDrawerWidget(
    this.size,
    this.width, {
    Key key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SelectedDrawerWidgetState();
  }
}

class SelectedDrawerWidgetState extends State<SelectedDrawerWidget> {
  Offset first;
  Offset second;
  LinePainter painter;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: first == null
          ? Container()
          : CustomPaint(
              size: Size(widget.size, widget.size),
              painter: LinePainter(
                  first, second == null ? first : second, widget.width),
            ),
    );
  }

  setCells(Offset firstCell, Offset secondCell) {
    if (this.first == firstCell && this.second == secondCell) {
      return;
    }
    this.first = firstCell;
    this.second = secondCell;
    setState(() {});
  }
}

class LinePainter extends CustomPainter {
  final Offset firstPoint;
  final Offset secondPoint;
  final double width;

  LinePainter(this.firstPoint, this.secondPoint, this.width);

  @override
  void paint(Canvas canvas, Size size) {
    final pointMode = ui.PointMode.polygon;
    final points = [firstPoint, secondPoint];
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}
