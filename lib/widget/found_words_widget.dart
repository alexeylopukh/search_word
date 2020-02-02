import 'dart:math';

import 'package:flutter/material.dart';
import 'package:search_word/model/word_model.dart';
import 'package:search_word/widget/line_painter.dart';

class FoundWordsWidget extends StatefulWidget {
  final List<WordModel> findedWords;
  final double width;
  const FoundWordsWidget(
      {Key key, @required this.findedWords, @required this.width})
      : super(key: key);

  @override
  _FoundWordsWidgetState createState() => _FoundWordsWidgetState();
}

class _FoundWordsWidgetState extends State<FoundWordsWidget> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> childrens = [];
    widget.findedWords.forEach((w) {
      childrens.add(
        CustomPaint(
          painter: LinePainter(
              w.startCellKey.currentState.getCenter(),
              w.endCellKey.currentState.getCenter(),
              widget.width,
              Colors.primaries[Random().nextInt(Colors.primaries.length)]
                  .withOpacity(0.5)),
        ),
      );
    });
    return Stack(
      children: childrens,
    );
  }
}
