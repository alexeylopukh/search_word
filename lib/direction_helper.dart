import 'package:flutter/cupertino.dart';

enum Direction { Up, Down, Left, Right, UpLeft, UpRight, DownLeft, DownRight }

class DirectionHelper {
  Direction getDirectionFromOffsets(Offset firstPoint, Offset secondPoint) {
    final offsetX = firstPoint.dx - secondPoint.dx;
    final offsetY = firstPoint.dy - secondPoint.dy;
    if (offsetX > 0) {
      if (offsetY > 0)
        return Direction.UpLeft;
      else if (offsetY < 0)
        return Direction.DownLeft;
      else
        return Direction.Left;
    } else if (offsetX < 0) {
      if (offsetY > 0)
        return Direction.UpRight;
      else if (offsetY < 0)
        return Direction.DownRight;
      else
        return Direction.Right;
    } else if (offsetX == 0) {
      if (offsetY > 0)
        return Direction.Up;
      else if (offsetY < 0) return Direction.Down;
    }
    return null;
  }
}
