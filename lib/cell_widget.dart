import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';

class CellWidget extends StatefulWidget {
  final double size;
  final String text;
  final Offset offset;

  const CellWidget({Key key, this.size, this.text, this.offset})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CellWidgetState(offset);
  }
}

class CellWidgetState extends State<CellWidget>
    with AfterLayoutMixin<CellWidget> {
  CellWidgetState(this.offset);

  double get size => widget.size;
  String get text => widget.text;
  Offset offset;
  Offset startPosition;
  Offset endPosition;
  bool isTouched = false;

  @override
  Widget build(BuildContext context) {
    if (offset == null) offset = Offset(0, 0);
    return Container(
      height: size,
      width: size,
      color: isTouched ? Colors.orange : Colors.transparent,
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: size),
        ),
      ),
    );
  }

  getWidgetPosition() {
    final position =
        (context.findRenderObject() as RenderBox).localToGlobal(Offset.zero);
    startPosition = Offset(position.dx - offset.dx, position.dy - offset.dy);
    endPosition =
        Offset(position.dx - offset.dx + size, position.dy - offset.dy + size);
  }

  unSelect() {
    isTouched = false;
    update();
  }

  update() {
    setState(() {});
  }

  Offset getCenter() {
    final center = Offset((startPosition.dx + endPosition.dx) / 2,
        (startPosition.dy + endPosition.dy) / 2);
    return center;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getWidgetPosition();
  }
}
