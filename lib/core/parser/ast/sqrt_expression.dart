import 'dart:math';

import 'package:calculator_app/core/parser/ast/expression.dart';

class SqrtExpression implements Expression{
  SqrtExpression(this._expression);

  final Expression _expression;

  @override
  double eval() => sqrt(_expression.eval());
}