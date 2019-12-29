import 'package:flutter/material.dart';
import 'package:search_word/model/field_cell.dart';

class GameField {
  final int size;
  List<List<String>> field = [];

  GameField({@required this.size}) {
    generateEmptyField();
  }

  generateEmptyField() {
    field = [];
    for (int i = 0; i < size; i++) {
      final List<String> row = [];
      for (int j = 0; j < size; j++) {
        row.add('');
      }
      field.add(row);
    }
  }

  bool writeChar(int x, int y, String char) {
    try {
      if (field[y][x] == '' || field[y][x] == char) {
        field[y][x] = char;
        return true;
      } else
        return false;
    } catch (e) {
      return false;
    }
  }

  List<FieldCell> getAvailableStartPoints(String startChar) {
    final List<FieldCell> result = [];
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        if (field[y][x] == '' || field[y][x] == startChar)
          result.add(FieldCell(x: x, y: y, value: field[y][x]));
      }
    }
    return result;
  }
}
