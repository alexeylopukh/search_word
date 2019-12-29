import 'package:flutter/material.dart';
import 'package:search_word/selected_drawer_widget.dart';
import 'cell_widget.dart';

class GameFieldWidget extends StatefulWidget {
  final List<List<String>> field;

  const GameFieldWidget({Key key, @required this.field}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return GameFieldWidgetState();
  }
}

class GameFieldWidgetState extends State<GameFieldWidget> {
  List<List<String>> get field => widget.field;
  List<GlobalKey<CellWidgetState>> keys = [];
  List<GlobalKey<CellWidgetState>> selectedCells = [];

  GlobalKey<CellWidgetState> firstCell;
  GlobalKey<CellWidgetState> secondCell;

  GlobalKey<SelectedDrawerWidgetState> selectedController =
      GlobalKey<SelectedDrawerWidgetState>();

  @override
  Widget build(BuildContext context) {
    keys = [];
    return GestureDetector(
      onPanDown: (DragDownDetails details) {
        final touched = getKeyOfCurrentPosition(details.globalPosition);
        if (touched != null) onFirstTap(touched);
//        print(
//            'start: X: ${details.globalPosition.dx} Y:${details.globalPosition.dy}');
      },
      onPanUpdate: (DragUpdateDetails details) {
        final touched = getKeyOfCurrentPosition(details.globalPosition);
        if (touched != null) onTapUpdate(touched);
//        print('X: ${details.localPosition.dx} Y:${details.localPosition.dy}');
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
    firstCell = key;
    selectedController.currentState.setCells(firstCell, secondCell);
//    selectedCells.add(key);
  }

  onTapUpdate(GlobalKey<CellWidgetState> key) {
    secondCell = key;
    selectedController.currentState.setCells(firstCell, secondCell);

//    selectedCells.add(key);
  }

  onTapEnd() {}

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
}
