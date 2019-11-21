import 'package:calculator_app/core/parser/token_type.dart';

class Token {
  Token(this.type, [this.text]);

  final TokenType type;
  final String text;

  @override
  String toString() => "${type.toString()}: ${text ?? ""}";
}