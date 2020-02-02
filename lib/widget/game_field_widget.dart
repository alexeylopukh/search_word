import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:search_word/helper/direction_helper.dart';
import 'package:search_word/interactor/game_field_generator_interactor.dart';
import 'package:search_word/model/word_model.dart';
import 'package:search_word/widget/found_words_widget.dart';
import 'package:search_word/widget/selected_drawer_widget.dart';
import 'package:vibration/vibration.dart';
import 'cell_widget.dart';

class GameFieldWidget extends StatefulWidget {
  final GameFieldGeneratorInteractor generator;

  const GameFieldWidget({Key key, @required this.generator}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return GameFieldWidgetState();
  }
}

class GameFieldWidgetState extends State<GameFieldWidget>
    with AfterLayoutMixin<GameFieldWidget> {
  List<WordModel> get availableWorlds => widget.generator.addedWords;
  List<List<String>> get field => widget.generator.gameField.field;
  List<List<GlobalKey<CellWidgetState>>> keysField = [];

  List<GlobalKey<CellWidgetState>> keys = [];

  Direction currentDirection;
  GlobalKey<CellWidgetState> firstCell;
  GlobalKey<CellWidgetState> secondCell;

  List<WordModel> foundedWords = [];

  Offset fieldOffset;

  Widget gameField;

  GlobalKey<SelectedDrawerWidgetState> selectedController =
      GlobalKey<SelectedDrawerWidgetState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (DragDownDetails details) {
        final touched = getKeyOfCurrentPosition(details.localPosition);
        if (touched != null)
          onFirstTap(touched);
        else {
          print('NOT FOUND');
        }
      },
      onPanUpdate: (DragUpdateDetails details) {
        final touched = getKeyOfCurrentPosition(details.localPosition);
        if (touched != null && touched != secondCell)
          onTapUpdate(touched, details.localPosition);
      },
      onPanEnd: (DragEndDetails details) {
        onTapEnd();
      },
      behavior: HitTestBehavior.translucent,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: <Widget>[
              SizedBox(
                height: constraints.maxWidth,
                width: constraints.maxWidth,
                child: FoundWordsWidget(
                  findedWords: foundedWords,
                  width: constraints.maxWidth / field.length - 1,
                ),
              ),
              SizedBox(
                height: constraints.maxWidth,
                width: constraints.maxWidth,
                child: SelectedDrawerWidget(
                  constraints.maxWidth,
                  constraints.maxWidth / field.length,
                  key: selectedController,
                ),
              ),
              gameField == null
                  ? generateField(constraints.maxWidth / field.length)
                  : gameField,
            ],
          );
        },
      ),
    );
  }

  Widget generateField(double width) {
    keysField.clear();
    final List<Widget> rows = [];
    for (int i = 0; i < field.length; i++) {
      final List<GlobalKey<CellWidgetState>> currentRowKeys = [];
      final List<Widget> currentRowWidgets = [];
      for (int j = 0; j < field[i].length; j++) {
        final key = GlobalKey<CellWidgetState>();
        currentRowKeys.add(key);
        keys.add(key);
        currentRowWidgets.add(CellWidget(
          y: i,
          x: j,
          size: width,
          text: field[i][j],
          key: key,
          offset: fieldOffset,
        ));
      }
      keysField.add(currentRowKeys);
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: currentRowWidgets,
      ));
    }
    gameField = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rows,
    );
    return gameField;
  }

  onFirstTap(GlobalKey<CellWidgetState> key) {
    Vibration.vibrate(duration: 10);
    firstCell = key;
    selectedController.currentState.setCells(
        firstCell.currentState.getCenter(), firstCell.currentState.getCenter());
  }

  onTapUpdate(
      GlobalKey<CellWidgetState> touchedKey, Offset touchedCoordinates) {
    if (!(firstCell != null && firstCell.currentState != null)) {
      firstCell = touchedKey;
      return;
    }

    final Direction newDirection = DirectionHelper().getDirectionFromOffsets(
        firstCell.currentState.getCenter(),
        touchedKey.currentState.getCenter());

    currentDirection = newDirection;

    final newSecondCell = correctDirection(touchedCoordinates);

    if (newSecondCell == secondCell) return;

    if (newSecondCell == null)
      secondCell = firstCell;
    else
      secondCell = newSecondCell;

    Vibration.vibrate(duration: 15);

    selectedController.currentState.setCells(firstCell.currentState.getCenter(),
        secondCell.currentState.getCenter());
  }

  GlobalKey<CellWidgetState> correctDirection(Offset touchedCoordinates) {
    final firstCoordinates = firstCell.currentState.getCenter();
    switch (currentDirection) {
      case Direction.Up:
        final corrCell = getKeyOfCurrentPosition(
            Offset(firstCoordinates.dx, touchedCoordinates.dy));
        if (corrCell != null) return corrCell;
        break;
      case Direction.Down:
        final corrCell = getKeyOfCurrentPosition(
            Offset(firstCoordinates.dx, touchedCoordinates.dy));
        if (corrCell != null) return corrCell;
        break;
      case Direction.Left:
        final corrCell = getKeyOfCurrentPosition(
            Offset(touchedCoordinates.dx, firstCoordinates.dy));
        if (corrCell != null) return corrCell;
        break;
      case Direction.Right:
        final corrCell = getKeyOfCurrentPosition(
            Offset(touchedCoordinates.dx, firstCoordinates.dy));
        if (corrCell != null) return corrCell;
        break;
      case Direction.UpLeft:
        final list = getCellsFromDirection(firstCell, currentDirection);
        final different = Offset(
            (firstCell.currentState.getCenter().dx - touchedCoordinates.dx)
                .abs(),
            (firstCell.currentState.getCenter().dy - touchedCoordinates.dy)
                .abs());
        final rightCell = getRightCell(
            options: list, different: different, touched: touchedCoordinates);
        return rightCell;
        break;
      case Direction.UpRight:
        final list = getCellsFromDirection(firstCell, currentDirection);
        final different = Offset(
            (firstCell.currentState.getCenter().dx - touchedCoordinates.dx)
                .abs(),
            (firstCell.currentState.getCenter().dy - touchedCoordinates.dy)
                .abs());

        final rightCell = getRightCell(
            options: list, different: different, touched: touchedCoordinates);
        return rightCell;
        break;
      case Direction.DownLeft:
        final list = getCellsFromDirection(firstCell, currentDirection);
        final different = Offset(
            (firstCell.currentState.getCenter().dx - touchedCoordinates.dx)
                .abs(),
            (firstCell.currentState.getCenter().dy - touchedCoordinates.dy)
                .abs());
        final rightCell = getRightCell(
            options: list, different: different, touched: touchedCoordinates);
        return rightCell;
        break;
      case Direction.DownRight:
        final list = getCellsFromDirection(firstCell, currentDirection);
        final different = Offset(
            (firstCell.currentState.getCenter().dx - touchedCoordinates.dx)
                .abs(),
            (firstCell.currentState.getCenter().dy - touchedCoordinates.dy)
                .abs());
        final rightCell = getRightCell(
            options: list, different: different, touched: touchedCoordinates);
        return rightCell;
        break;
    }
    return null;
  }

  GlobalKey<CellWidgetState> getRightCell(
      {List<GlobalKey<CellWidgetState>> options,
      Offset different,
      Offset touched}) {
    final iterator = options.iterator;
    if (different.dx > different.dy) {
      while (iterator.moveNext()) {
        final current = iterator.current;
        if (current.currentState.isXpositionHere(touched.dx)) {
          return current;
        }
      }
    } else {
      while (iterator.moveNext()) {
        final current = iterator.current;
        if (current.currentState.isYpositionHere(touched.dy)) {
          return current;
        }
      }
    }
    return null;
  }

  List<GlobalKey<CellWidgetState>> getCellsFromDirection(
      GlobalKey<CellWidgetState> firstCell, Direction direction) {
    int x = firstCell.currentState.x;
    int y = firstCell.currentState.y;
    bool canGo = true;
    final List<GlobalKey<CellWidgetState>> result = [];
    result.add(keysField[y][x]);
    switch (currentDirection) {
      case Direction.Up:
        while (canGo) {
          try {
            y--;
            final cell = keysField[y][x];
            result.add(cell);
          } catch (e) {
            canGo = false;
          }
        }
        break;
      case Direction.Down:
        while (canGo) {
          try {
            y++;
            final cell = keysField[y][x];
            result.add(cell);
          } catch (e) {
            canGo = false;
          }
        }
        break;
      case Direction.Left:
        while (canGo) {
          try {
            x--;
            final cell = keysField[y][x];
            result.add(cell);
          } catch (e) {
            canGo = false;
          }
        }
        break;
      case Direction.Right:
        while (canGo) {
          try {
            x++;
            final cell = keysField[y][x];
            result.add(cell);
          } catch (e) {
            canGo = false;
          }
        }
        break;
      case Direction.UpLeft:
        while (canGo) {
          try {
            y--;
            x--;
            final cell = keysField[y][x];
            result.add(cell);
          } catch (e) {
            canGo = false;
          }
        }
        break;
      case Direction.UpRight:
        while (canGo) {
          try {
            y--;
            x++;
            final cell = keysField[y][x];
            result.add(cell);
          } catch (e) {
            canGo = false;
          }
        }
        break;
      case Direction.DownLeft:
        while (canGo) {
          try {
            y++;
            x--;
            final cell = keysField[y][x];
            result.add(cell);
          } catch (e) {
            canGo = false;
          }
        }
        break;
      case Direction.DownRight:
        while (canGo) {
          try {
            y++;
            x++;
            final cell = keysField[y][x];
            result.add(cell);
          } catch (e) {
            canGo = false;
          }
        }
        break;
    }
    return result;
  }

  onTapEnd() {
    try {
      availableWorlds.forEach((w) {
        if (firstCell.currentState != null &&
            secondCell.currentState != null &&
            w.startCell.x == firstCell.currentState.x &&
            w.startCell.y == firstCell.currentState.y &&
            w.endCell.x == secondCell.currentState.x &&
            w.endCell.y == secondCell.currentState.y) {
          w.startCellKey = firstCell;
          w.endCellKey = secondCell;
          foundedWords.add(w);
          update();
        }
      });
    } catch (e) {}

    firstCell = null;
    secondCell = null;
    currentDirection = null;
    selectedController.currentState.setCells(null, null);
  }

  GlobalKey<CellWidgetState> getKeyOfCurrentPosition(Offset position) {
    final keysIterator = keys.iterator;
    while (keysIterator.moveNext()) {
      final key = keysIterator.current;
      final cell = key.currentState;
      if (cell != null &&
          position.dx >= cell.startPosition.dx &&
          position.dy >= cell.startPosition.dy &&
          position.dx <= cell.endPosition.dx &&
          position.dy <= cell.endPosition.dy) {
        return key;
      }
    }
    return null;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (fieldOffset == null) {
      fieldOffset =
          (context.findRenderObject() as RenderBox).localToGlobal(Offset.zero);
      gameField = null;
      update();
    }
  }

  update() {
    if (mounted) setState(() {});
  }
}
