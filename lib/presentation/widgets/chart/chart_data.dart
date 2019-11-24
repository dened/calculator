import 'dart:math';

import 'package:flutter/material.dart';

class ChartData {
  double horizontalInterval = 10;

  double verticalInterval = 10;

  Color gridColor = Colors.grey;
  double gridStrokeWidth = 0.5;

  ChartData(this.pointList) {
    _initExtremumValue();
  }

  final List<Point<double>> pointList;
  double minX = double.infinity;
  double minY = double.infinity;
  double maxX = double.negativeInfinity;
  double maxY = double.negativeInfinity;

  void _initExtremumValue() {
    if (pointList.isNotEmpty) {
      pointList.forEach((it) {
        minX = min(minX, it.x);
        minY = min(minY, it.y);
        maxX = max(maxX, it.x);
        maxY = max(maxY, it.y);
      });
    } else {
      minX = 0;
      minY = 0;
      maxX = 0;
      maxY = 0;
    }
  }
}
