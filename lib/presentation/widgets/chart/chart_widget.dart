import 'dart:math';

import 'package:calculator_app/presentation/widgets/chart/chart_data.dart';
import 'package:calculator_app/presentation/widgets/chart/chart_painter.dart';
import 'package:calculator_app/presentation/widgets/chart/chart_style.dart';
import 'package:flutter/material.dart';

class ChartWidget extends StatelessWidget {
  ChartWidget(this.pointList, {ChartStyle chartStyle})
      : this.chartStyle = chartStyle ?? ChartStyle();

  final List<Point<double>> pointList;
  final ChartStyle chartStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: CustomPaint(
        painter: ChartPainter(pointList, chartStyle, ChartData(pointList)),
      ),
    );
  }
}
