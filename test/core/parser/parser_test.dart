import 'package:calculator_app/core/parser/lexer.dart';
import 'package:calculator_app/core/parser/parser.dart';
import 'package:calculator_app/core/parser/variables.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  double _eval(String expression, [double variable]) {
    final tokenList = Lexer(expression).tokenize();
    final exp = Parser(tokenList).parse();

    putVariable("x", variable);

    return exp.eval();
  }

  group("tests with correct expression", () {
    test('simple test with a number', () {
      expect(_eval("0"), 0);
      expect(_eval("105.3333"), 105.3333);
      expect(_eval("2"), 2);
      expect(_eval("1234567890"), 1234567890);
    });

    test('simple test with an unary minus', () {
      expect(_eval("-105.3333"), -105.3333);
    });

    test('simple test with binary operations', () {
      expect(_eval("33.3 + 5"), 38.3);
      expect(_eval("10.5 * 4"), 42);
      expect(_eval("999999 /  111111"), 9);
      expect(_eval("000094 - 40"), 54);
      expect(_eval("2^10"), 1024);
    });

    test('simple test with sqrt', () {
      expect(_eval("sqrt(4)"), 2);
      expect(_eval("sqrt(637.5625‬)"), 25.25);
    });

    test('simple test with parentheses', () {
      expect(_eval("(2 + 2) * 2"), 8);
      expect(_eval("(1+1)^(2 + 2) * 2"), 32);
      expect(_eval("(1+1)^((2 + 2) * 2)"), 256);
    });

    test('simple test with variable', () {
      expect(_eval("-2 + x", 2), 0);
      expect(_eval("2 - x", 12), -10);
    });
  });
}
