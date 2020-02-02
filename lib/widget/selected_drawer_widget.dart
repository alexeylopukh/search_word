import 'package:flutter/material.dart';

import 'line_painter.dart';

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
              painter: LinePainter(first, second == null ? first : second,
                  widget.width, Colors.orange.withOpacity(0.5)),
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
