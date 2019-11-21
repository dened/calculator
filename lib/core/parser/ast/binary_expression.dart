import 'dart:math';

import 'package:calculator_app/core/parser/ast/expression.dart';

class BinaryExpression implements Expression {
  BinaryExpression(
    this.operation,
    this.expr1,
    this.expr2,
  );

  final String operation;
  final Expression expr1, expr2;

  @override
  double eval() {
    switch (operation) {
      case "+":
        return expr1.eval() + expr2.eval();
      case "-":
        return expr1.eval() - expr2.eval();
      case "*":
        return expr1.eval() * expr2.eval();
      case "/":
        return expr1.eval() / expr2.eval();
      case "^":
        return pow(expr1.eval(), expr2.eval());
      default:
        throw Exception("Unknown operator: $operation");
    }
  }
}
