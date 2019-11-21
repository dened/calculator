import 'package:calculator_app/core/parser/ast/expression.dart';
import 'package:calculator_app/core/parser/variables.dart';

class VariableExpression implements Expression {
  VariableExpression(this._name);

  final String _name;

  @override
  double eval() {

    final value = getVariable(_name);
    if (value == null) throw Exception("Not found value for variable: $_name");
    return value;
  }
}