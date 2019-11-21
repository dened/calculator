import 'package:calculator_app/core/parser/ast/expression.dart';

class UnaryExpression implements Expression {
  UnaryExpression(this._operation, this._expression);

  final String _operation;
  final Expression _expression;

  @override
  double eval() {
    switch (_operation) {
      case "-":
        return -_expression.eval();
      default:
        return _expression.eval();
    }
  }
}
