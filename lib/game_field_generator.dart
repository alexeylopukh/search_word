import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:search_word/model/field_cell.dart';
import 'package:search_word/model/game_field.dart';

class GameFieldGenerator {
  final List<String> words;
  final List<String> addedWords = [];
  final int size;

  GameFieldGenerator({@required this.words, this.size = 7}) {
    gameField = GameField(size: size);
  }

  GameField gameField;
  int y = 0;
  int x = 0;

  bool generateField() {
    bool successfully = false;
    words.forEach((w) {
      List<String> currentWord = w.split('');
      List<FieldCell> startPoints =
          gameField.getAvailableStartPoints(currentWord.first);
      startPoints.shuffle();
      if (writeWord(currentWord, startPoints)) {
        addedWords.add(w);
        successfully = true;
        return;
      }
    });
    return successfully;
  }

  bool writeWord(List<String> word, List<FieldCell> startPoints) {
    bool successfully = false;
    final startPointsIterator = startPoints.iterator;
    while (startPointsIterator.moveNext()) {
      final startPoint = startPointsIterator.current;
      if (tryWriteWord(word, startPoint)) {
        successfully = true;
        break;
      }
    }
    return successfully;
  }

  bool tryWriteWord(List<String> word, FieldCell startPoint) {
    bool successfully = false;
    final directions = generateRandomDirections();
    final directionsIterator = directions.iterator;
    while (directionsIterator.moveNext()) {
      bool writed = true;
      final backup = getBackup(gameField.field);
//      List<List<String>> backup = [];
//      backup.addAll(gameField.field)
      final direction = directionsIterator.current;
      x = startPoint.x;
      y = startPoint.y;
      final wordIterator = word.iterator;
      while (wordIterator.moveNext() && writed) {
        final char = wordIterator.current;
        if (!gameField.writeChar(x, y, char)) {
          writed = false;
        } else
          moveToDirection(direction);
      }
      if (writed) {
        successfully = true;
        break;
      } else
        gameField.field = backup;
    }
    return successfully;
  }

  List<List<String>> getBackup(List<List<String>> object) {
    List<dynamic> copy = jsonDecode(jsonEncode(object));
    List<List<String>> result = [];
    copy.forEach((item) => result.add(List.from(item)));
    return result;
  }

  List<Direction> generateRandomDirections() {
    final result = [
      Direction.Up,
      Direction.Down,
      Direction.Left,
      Direction.Right,
      Direction.UpLeft,
      Direction.UpRight,
      Direction.DownLeft,
      Direction.DownRight
    ];
    result.shuffle();
    return result;
  }

  moveToDirection(Direction direction) {
    switch (direction) {
      case Direction.Up:
        y--;
        break;
      case Direction.Down:
        y++;
        break;
      case Direction.Left:
        x--;
        break;
      case Direction.Right:
        y++;
        break;
      case Direction.UpLeft:
        y--;
        x--;
        break;
      case Direction.UpRight:
        y--;
        x++;
        break;
      case Direction.DownLeft:
        y++;
        x--;
        break;
      case Direction.DownRight:
        y++;
        x++;
        break;
    }
  }
}

enum Direction { Up, Down, Left, Right, UpLeft, UpRight, DownLeft, DownRight }
