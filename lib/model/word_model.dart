import 'package:flutter/material.dart';
import 'package:search_word/widget/cell_widget.dart';
import 'field_cell.dart';

class WordModel {
  final String word;

  final FieldCell startCell;
  final FieldCell endCell;

  GlobalKey<CellWidgetState> startCellKey;
  GlobalKey<CellWidgetState> endCellKey;

  WordModel({
    @required this.word,
    @required this.startCell,
    @required this.endCell,
  });
}
