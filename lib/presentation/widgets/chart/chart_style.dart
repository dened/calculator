import 'package:flutter/material.dart';

class ChartStyle {
  ChartStyle({Color dotColor, Color backgroundColor})
      : this.dotColor = dotColor ?? Colors.red,
  this.backgroundColor = backgroundColor ?? Colors.limeAccent;

  final Color dotColor;
  final Color backgroundColor;
}
