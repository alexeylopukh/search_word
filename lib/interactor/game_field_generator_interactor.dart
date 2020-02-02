import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:search_word/interactor/string_from_list.dart';
import 'package:search_word/model/field_cell.dart';
import 'package:search_word/model/game_field.dart';
import 'package:search_word/model/word_model.dart';
import '../helper/direction_helper.dart';

class GameFieldGeneratorInteractor {
  final List<String> words;
  final List<WordModel> addedWords = [];
  final int size;
  final String abc = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

  GameFieldGeneratorInteractor({@required this.words, this.size = 7}) {
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
      final writedWord = writeWord(currentWord, startPoints);
      if (writedWord != null) {
        addedWords.add(writedWord);
        successfully = true;
        return;
      }
    });
    fillEmptyCells();
    return successfully;
  }

  WordModel writeWord(List<String> word, List<FieldCell> startPoints) {
    final startPointsIterator = startPoints.iterator;
    while (startPointsIterator.moveNext()) {
      final startPoint = startPointsIterator.current;

      final writedWord = tryWriteWord(word, startPoint);
      if (writedWord != null) return writedWord;
    }
    return null;
  }

  WordModel tryWriteWord(List<String> word, FieldCell startPoint) {
    final directions = generateRandomDirections();
    final directionsIterator = directions.iterator;
    while (directionsIterator.moveNext()) {
      bool writed = true;
      final backup = getBackup(gameField.field);
      final direction = directionsIterator.current;
      x = startPoint.x;
      y = startPoint.y;
      final wordIterator = word.iterator;
      while (wordIterator.moveNext() && writed) {
        final char = wordIterator.current;
        if (!gameField.writeChar(x, y, char)) {
          writed = false;
        } else if (char != word.last) moveToDirection(direction);
      }
      if (writed) {
        return WordModel(
            word: getStringFromList(word),
            startCell:
                FieldCell(x: startPoint.x, y: startPoint.y, value: word.first),
            endCell: FieldCell(x: x, y: y, value: word.last));
      } else
        gameField.field = backup;
    }
    return null;
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

  fillEmptyCells() {
    List<String> abcList = abc.split('');
    gameField.getAvailableStartPoints('').forEach((cell) {
      gameField.field[cell.y][cell.x] =
          abcList[Random().nextInt(abcList.length)];
    });
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
