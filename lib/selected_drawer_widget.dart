import 'package:flutter/material.dart';
import 'package:search_word/cell_widget.dart';
import 'dart:ui' as ui;

class SelectedDrawerWidget extends StatefulWidget {
  final double size;

  const SelectedDrawerWidget(this.size, {Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SelectedDrawerWidgetState();
  }
}

class SelectedDrawerWidgetState extends State<SelectedDrawerWidget> {
  GlobalKey<CellWidgetState> firstCell;
  GlobalKey<CellWidgetState> secondCell;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: firstCell == null || firstCell.currentState == null
          ? Container()
          : CustomPaint(
              size: Size(widget.size, widget.size),
              painter: LinePainter(
                  firstCell.currentState.getCenter(),
                  secondCell == null || secondCell.currentState == null
                      ? firstCell.currentState.getCenter()
                      : secondCell.currentState.getCenter()),
            ),
    );
  }

  setCells(GlobalKey<CellWidgetState> firstCell,
      GlobalKey<CellWidgetState> secondCell) {
//    if (this.firstCell == firstCell && this.secondCell == secondCell) return;
    this.firstCell = firstCell;
    this.secondCell = secondCell;
    setState(() {});
  }
}

class LinePainter extends CustomPainter {
  final Offset firstPoint;
  final Offset secondPoint;

  LinePainter(this.firstPoint, this.secondPoint);

  @override
  void paint(Canvas canvas, Size size) {
    final pointMode = ui.PointMode.polygon;
    final points = [firstPoint, secondPoint];
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
