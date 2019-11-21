import 'package:calculator_app/core/parser/ast/expression.dart';

class NumberExpression implements Expression {
  NumberExpression(this._value);

  final double _value;

  @override
  double eval() => _value;
}