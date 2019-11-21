import 'package:calculator_app/core/parser/token.dart';
import 'package:calculator_app/core/parser/token_type.dart';
import 'package:calculator_app/core/validators.dart';

const OPERATOR_CHARS = "+-*/()^";

const OPERATOR_TOKENS = [
  TokenType.addition,
  TokenType.subtraction,
  TokenType.multiplication,
  TokenType.division,
  TokenType.left_paren,
  TokenType.right_paren,
  TokenType.exponentiation,
];

class Lexer {
  Lexer(this._input)
      : _tokenList = [],
        _pos = 0;

  final String _input;
  final List<Token> _tokenList;
  int _pos;

  List<Token> tokenize() {
    while (_pos < _input.length) {
      final current = _peek();
      if (isDigit(current))
        _tokenizeNumber();
      else if (isLetter(current)) {
        _tokenizeWord();
      } else if (OPERATOR_CHARS.contains(current)) {
        _tokenizeOperator();
      } else {
        _next();
      }
    }
    return _tokenList;
  }

  void _tokenizeNumber() {
    final buffer = StringBuffer();
    String current = _peek();
    int dotCount = 0;

    while (true) {
      if (current == ".") {
        if (++dotCount > 1) throw Exception("Invalid double number");
      } else if (!isDigit(current)) {
        break;
      }

      buffer.write(current);
      current = _next();
    }
    _addToken(TokenType.number, buffer.toString());
  }

  void _tokenizeOperator() {
    final index = OPERATOR_CHARS.indexOf(_peek());
    _addToken(OPERATOR_TOKENS[index]);
    _next();
  }

  void _tokenizeWord() {
    final buffer = StringBuffer();
    String current = _peek();

    while (true) {
      if (!isLetter(current) && !isDigit(current)) {
        break;
      }

      buffer.write(current);
      current = _next();
    }

    final word = buffer.toString();
    if (word == "sqrt") {
      _addToken(TokenType.sqrt);
    } else {
      _addToken(TokenType.variable, word);
    }
  }

  void _addToken(TokenType type, [String text]) {
    _tokenList.add(Token(type, text));
  }

  String _next() {
    _pos++;
    if (_pos >= _input.length) return '\n';
    return _peek();
  }

  String _peek() => _input[_pos];
}
