import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:search_word/direction_helper.dart';
import 'package:search_word/selected_drawer_widget.dart';
import 'package:vibration/vibration.dart';
import 'cell_widget.dart';

class GameFieldWidget extends StatefulWidget {
  final List<List<String>> field;

  const GameFieldWidget({Key key, @required this.field}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return GameFieldWidgetState();
  }
}

class GameFieldWidgetState extends State<GameFieldWidget>
    with AfterLayoutMixin<GameFieldWidget> {
  List<List<String>> get field => widget.field;
  List<GlobalKey<CellWidgetState>> keys = [];
  List<GlobalKey<CellWidgetState>> selectedCells = [];

  Direction currentDirection;
  GlobalKey<CellWidgetState> firstCell;
  GlobalKey<CellWidgetState> secondCell;

  Offset fieldOffset;

  GlobalKey<SelectedDrawerWidgetState> selectedController =
      GlobalKey<SelectedDrawerWidgetState>();

  @override
  Widget build(BuildContext context) {
    keys = [];
    return GestureDetector(
      onPanDown: (DragDownDetails details) {
        final touched = getKeyOfCurrentPosition(details.localPosition);
        if (touched != null)
          onFirstTap(touched);
        else {
          print('NOT FOUND');
        }
//        print(
//            'start: X: ${details.localPosition.dx} Y:${details.localPosition.dy}');
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
                child: SelectedDrawerWidget(
                  constraints.maxWidth,
                  constraints.maxWidth / field.length,
                  key: selectedController,
                ),
              ),
              generateField(constraints.maxWidth / field.length),
            ],
          );
        },
      ),
    );
  }

  Widget generateField(double width) {
    final List<Widget> rows = [];
    for (int i = 0; i < field.length; i++) {
      final List<Widget> currentRowWidgets = [];
      for (int j = 0; j < field[i].length; j++) {
        final key = GlobalKey<CellWidgetState>();
        keys.add(key);
        currentRowWidgets.add(CellWidget(
          size: width,
          text: field[i][j],
          key: key,
          offset: fieldOffset,
        ));
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: currentRowWidgets,
      ));
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rows,
    );
  }

  onFirstTap(GlobalKey<CellWidgetState> key) {
    Vibration.vibrate(duration: 10);
    firstCell = key;
    selectedController.currentState.setCells(
        firstCell.currentState.getCenter(), firstCell.currentState.getCenter());
//    print('first');
//    selectedCells.add(key);
  }

  onTapUpdate(GlobalKey<CellWidgetState> key, Offset touchedCoordinates) {
    bool needRepait = true;
    if (firstCell == null || firstCell.currentState == null) {
      firstCell = key;
      needRepait = false;
    }

    final Direction direction = DirectionHelper().getDirectionFromOffsets(
        firstCell.currentState.getCenter(), key.currentState.getCenter());

    if (!needRepait) return;
    if (currentDirection != null &&
        direction != null &&
        currentDirection != direction) {
      final corrCell = correctDirection(touchedCoordinates);
      if (corrCell == secondCell)
        return;
      else
        secondCell = corrCell;
    } else {
      secondCell = key;
      currentDirection = direction;
    }

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
        // TODO: Handle this case.
        break;
      case Direction.Left:
        // TODO: Handle this case.
        break;
      case Direction.Right:
        // TODO: Handle this case.
        break;
      case Direction.UpLeft:
        // TODO: Handle this case.
        break;
      case Direction.UpRight:
        // TODO: Handle this case.
        break;
      case Direction.DownLeft:
        // TODO: Handle this case.
        break;
      case Direction.DownRight:
        // TODO: Handle this case.
        break;
    }
    return null;
  }

  onTapEnd() {
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
      setState(() {});
    }
  }
}
