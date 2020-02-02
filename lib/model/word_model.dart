import 'package:flutter/cupertino.dart';

import 'field_cell.dart';

class WordModel {
  final String word;

  final FieldCell startCell;
  final FieldCell endCell;

  WordModel({
    @required this.word,
    @required this.startCell,
    @required this.endCell,
  });
}
