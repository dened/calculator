import 'dart:math';

abstract class Calculator {
  Future<List<Point<double>>> calculate(
      String expression, double start, double end,
      [int amount]);
}
