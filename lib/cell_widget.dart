import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';

class CellWidget extends StatefulWidget {
  final double size;
  final String text;

  const CellWidget({Key key, this.size, this.text}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CellWidgetState();
  }
}

class CellWidgetState extends State<CellWidget>
    with AfterLayoutMixin<CellWidget> {
  double get size => widget.size;
  String get text => widget.text;
  Offset startPosition;
  Offset endPosition;
  bool isTouched = false;

  @override
  Widget build(BuildContext context) {
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
    startPosition = Offset(position.dx, position.dy);
    endPosition = Offset(position.dx + size, position.dy + size);
  }

  unSelect() {
    isTouched = false;
    update();
  }

  update() {
    setState(() {});
  }

  Offset getCenter() {
    return Offset((startPosition.dx + endPosition.dx) / 2,
        (startPosition.dy + endPosition.dy) / 2);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    getWidgetPosition();
  }
}
