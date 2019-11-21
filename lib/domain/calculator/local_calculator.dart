import 'dart:math';

import 'package:calculator_app/core/parser/lexer.dart';
import 'package:calculator_app/core/parser/parser.dart';
import 'package:calculator_app/core/parser/variables.dart';
import 'package:calculator_app/domain/calculator/calculator.dart';

class LocalCalculator implements Calculator {

  @override
  Future<List<Point<double>>> calculate(String expression, double start, double end, [int amount = 1000]) {
    final tokenList = Lexer(expression).tokenize();
    final exp = Parser(tokenList).parse();

    double step = (start - end) / amount;
    double current = start;
    final List<Point<double>> pointList = [];
    while(current < end) {
      putVariable("x", current);

      pointList.add(Point(current, exp.eval()));

      current += step;
    }

    return Future.sync(() => pointList);
  }
}