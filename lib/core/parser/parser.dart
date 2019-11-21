import 'package:calculator_app/core/parser/ast/binary_expression.dart';
import 'package:calculator_app/core/parser/ast/expression.dart';
import 'package:calculator_app/core/parser/ast/number_expression.dart';
import 'package:calculator_app/core/parser/ast/sqrt_expression.dart';
import 'package:calculator_app/core/parser/ast/unary_expression.dart';
import 'package:calculator_app/core/parser/ast/variable_expression.dart';
import 'package:calculator_app/core/parser/token.dart';
import 'package:calculator_app/core/parser/token_type.dart';

final eof = Token(TokenType.eof);

class Parser {
  Parser(this._tokenList) : _pos = 0;

  final List<Token> _tokenList;
  int _pos;

  Expression parse() {
    return _expression();
  }

  Expression _expression() {
    return _additive();
  }

  Expression _additive() {
    Expression result = _multiplicative();

    while (true) {
      if (_match(TokenType.addition)) {
        result = BinaryExpression("+", result, _multiplicative());
        continue;
      } else if (_match(TokenType.subtraction)) {
        result = BinaryExpression("-", result, _multiplicative());
        continue;
      }

      break;
    }

    return result;
  }

  Expression _multiplicative() {
    Expression result = _exponential();

    while (true) {
      if (_match(TokenType.multiplication)) {
        result = BinaryExpression("*", result, _exponential());
        continue;
      } else if (_match(TokenType.division)) {
        result = BinaryExpression("/", result, _exponential());
        continue;
      }

      break;
    }

    return result;
  }

  Expression _exponential() {
    Expression result = _unary();

    while (true) {
      if (_match(TokenType.exponentiation)) {
        result = BinaryExpression("^", result, _unary());
        continue;
      }

      break;
    }

    return result;
  }

  Expression _unary() {
    if (_match(TokenType.subtraction)) {
      return UnaryExpression("-", _primary());
    }

    if (_match(TokenType.addition)) {
      return UnaryExpression("+", _primary());
    }

    return _primary();
  }

  Expression _primary() {
    final current = _peek();
    if (_match(TokenType.number)) {
      return NumberExpression(double.tryParse(current.text));
    }

    if(_match(TokenType.variable)) {
      return VariableExpression(current.text);
    }

    if(_peek().type == TokenType.sqrt && _peek(1).type == TokenType.left_paren) {
      return _sqrt();
    }

    if(_match(TokenType.left_paren)) {
      Expression result = _expression();
      _match(TokenType.right_paren);
      return result;
    }

    throw new Exception("Unknown expression: ${_peek()}" );
  }

  SqrtExpression _sqrt() {
    _consume(TokenType.sqrt);
    _consume(TokenType.left_paren);
    final expression = _expression();
    _match(TokenType.right_paren);
    return SqrtExpression(expression);
  }

  bool _match(TokenType type) {
    final current = _peek();
    if (type != current.type) return false;
    _pos++;
    return true;
  }

  Token _consume(TokenType type) {
    final Token current = _peek();
    if (type != current.type) throw new Exception("Token  $current doesn't match $type");
    _pos++;
    return current;
  }

  Token _peek([int seek = 0]) {
    final int position = _pos + seek;
    if (position >= _tokenList.length) return eof;
    return _tokenList[position];
  }
}
