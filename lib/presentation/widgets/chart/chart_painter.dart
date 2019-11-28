import 'dart:math';
import 'dart:ui';

import 'package:calculator_app/presentation/widgets/chart/chart_data.dart';
import 'package:calculator_app/presentation/widgets/chart/chart_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChartPainter extends CustomPainter {
  ChartPainter(
    this._pointList,
    this._chartStyle,
      this.data,
  )   : assert(_pointList != null),
        assert(_chartStyle != null) {

    gridPaint = Paint()..style = PaintingStyle.fill;
    backgroundPaint = Paint()..style = PaintingStyle.fill;
  }

  final ChartData data;

  Paint gridPaint, backgroundPaint;

  final List<Point<double>> _pointList;
  final ChartStyle _chartStyle;



  final double additionalSize = 20;

  @override
  void paint(Canvas canvas, Size size) {
    if(data.maxX == 0) {
      data.maxX = size.width;
    }
    if (data.maxY == 0) {
      data.maxY = size.height;
    }

    drawBackground(canvas, size);
    drawGrid(canvas, size);

    List<Offset> offsetList =
        _pointList.map((it) => _toOffset(it, size)).toList();
    _drawCoordinates(canvas, size);
    _drawPointList(canvas, offsetList);
  }

  void _drawPointList(Canvas canvas, List<Offset> offsetList) {
    Paint pointPaint = Paint()
      ..color = _chartStyle.dotColor
      ..strokeWidth = 2;

    canvas.drawPoints(PointMode.points, offsetList, pointPaint);
  }

  void _drawCoordinates(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    double dx = _hasXZero() ? _xOffset(0, size.width) : 0;
    canvas.drawLine(Offset(dx, 0),
        Offset(dx, size.height), paint);
    double dy = _hasYzero() ? _yOffset(0, size.height) : size.height;
    canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);

  }

  @override
  bool shouldRepaint(ChartPainter oldDelegate) {
    return !listEquals(oldDelegate._pointList, _pointList) ||
        oldDelegate._chartStyle != _chartStyle;
  }

  Offset _toOffset(Point<double> it, Size size) {
    return Offset(_xOffset(it.x, size.width),
        _yOffset(it.y, size.height));
  }

  double _xOffset(double x, double width) =>
      (x - data.minX) / (data.maxX - data.minX) * width + additionalSize;

  double _yOffset(double y, double height) {
    double newY = ((y - data.minY) / (data.maxY - data.minY) * height);
    return height - newY - additionalSize;
  }

  bool _hasXZero() => data.minX - additionalSize <= 0 && 0 <= data.maxX;

  bool _hasYzero() => data.minY - additionalSize <= 0 && 0 <= data.maxY;


  /// This function draws a colored background behind the chart.
  void drawBackground(Canvas canvas, Size viewSize) {
    final Size usableViewSize = getChartUsableDrawSize(viewSize);
    backgroundPaint.color = _chartStyle.backgroundColor;
    canvas.drawRect(
      Rect.fromLTWH(
        getLeftOffsetDrawSize(),
        getTopOffsetDrawSize(),
        usableViewSize.width,
        usableViewSize.height,
      ),
      backgroundPaint,
    );
  }

  void drawGrid(Canvas canvas, Size viewSize) {
//    if (!data.gridData.show || data.gridData == null) {
//      return;
//    }
    final Size usableViewSize = getChartUsableDrawSize(viewSize);
    // Show Vertical Grid
//    if (data.gridData.drawVerticalGrid) {
      double verticalSeek = data.minX;
      while (verticalSeek <= data.maxX) {
//        if (data.gridData.checkToShowVerticalGrid(verticalSeek)) {
//          final FlLine flLineStyle = data.gridData.getDrawingVerticalGridLine(verticalSeek);
          gridPaint.color = data.gridColor;
          gridPaint.strokeWidth = data.gridStrokeWidth;

          final double bothX = getPixelX(verticalSeek, usableViewSize);
          final double x1 = bothX;
          final double y1 = 0 + getTopOffsetDrawSize();
          final double x2 = bothX;
          final double y2 = usableViewSize.height + getTopOffsetDrawSize();
          canvas.drawLine(
            Offset(x1, y1),
            Offset(x2, y2),
            gridPaint,
          );
//        }
        verticalSeek += data.verticalInterval;
      }
//    }

    // Show Horizontal Grid
//    if (data.gridData.drawHorizontalGrid) {
      double horizontalSeek = data.minY;
      while (horizontalSeek <= data.maxY) {
//        if (data.gridData.checkToShowHorizontalGrid(horizontalSeek)) {
          gridPaint.color = data.gridColor;
          gridPaint.strokeWidth = data.gridStrokeWidth;

          final double bothY = getPixelY(horizontalSeek, usableViewSize);
          final double x1 = 0 + getLeftOffsetDrawSize();
          final double y1 = bothY;
          final double x2 = usableViewSize.width + getLeftOffsetDrawSize();
          final double y2 = bothY;
          canvas.drawLine(
            Offset(x1, y1),
            Offset(x2, y2),
            gridPaint,
          );
          horizontalSeek += data.horizontalInterval;
        }


//      }
//    }
  }



  /// With this function we can convert our [FlSpot] x
  /// to the view base axis x .
  /// the view 0, 0 is on the top/left, but the spots is bottom/left
  double getPixelX(double spotX, Size chartUsableSize) {
    return (((spotX - data.minX) / (data.maxX - data.minX)) * chartUsableSize.width) +
        getLeftOffsetDrawSize();
  }

  /// With this function we can convert our [FlSpot] y
  /// to the view base axis y.
  double getPixelY(
      double spotY,
      Size chartUsableSize,
      ) {
    double y = ((spotY - data.minY) / (data.maxY - data.minY)) * chartUsableSize.height;
    y = chartUsableSize.height - y;
    return y + getTopOffsetDrawSize();
  }


  /// calculate the size that we can draw our chart.
  /// [getExtraNeededHorizontalSpace] and [getExtraNeededVerticalSpace]
  /// is the needed space to draw horizontal and vertical
  /// stuff around our chart.
  /// then we subtract them from raw [viewSize]
  Size getChartUsableDrawSize(Size viewSize) {
    final usableWidth = viewSize.width - getExtraNeededHorizontalSpace();
    final usableHeight = viewSize.height - getExtraNeededVerticalSpace();
    return Size(usableWidth, usableHeight);
  }

  /// extra needed space to show horizontal contents around the chart,
  /// like: left, right padding, left, right titles, and so on,
  /// each child class can override this function.
  double getExtraNeededHorizontalSpace() => 0;

  /// extra needed space to show vertical contents around the chart,
  /// like: tob, bottom padding, top, bottom titles, and so on,
  /// each child class can override this function.
  double getExtraNeededVerticalSpace() => 0;

  /// left offset to draw the chart
  /// we should use this to offset our x axis when we drawing the chart,
  /// and the width space we can use to draw chart is[getChartUsableDrawSize.width]
  double getLeftOffsetDrawSize() => 0;

  /// top offset to draw the chart
  /// we should use this to offset our y axis when we drawing the chart,
  /// and the height space we can use to draw chart is[getChartUsableDrawSize.height]
  double getTopOffsetDrawSize() => 0;
}
