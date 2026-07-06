import '../models/complex_number.dart';

enum _TokenType { number, imagUnit, plus, minus, multiply, divide, lparen, rparen, end }

class _Token {
  const _Token(this.type, [this.value = 0]);

  final _TokenType type;
  final double value;
}

/// Parses and evaluates arithmetic expressions with complex-number support.
class CalculatorEngine {
  String _expression = '';
  String _display = '0';
  String? _error;

  String get expression => _expression;
  String get display => _display;
  String? get error => _error;
  bool get hasError => _error != null;

  void clear() {
    _expression = '';
    _display = '0';
    _error = null;
  }

  void backspace() {
    _error = null;
    if (_expression.isEmpty) {
      _display = '0';
      return;
    }
    _expression = _expression.substring(0, _expression.length - 1);
    _display = _expression.isEmpty ? '0' : _expression;
  }

  void append(String value) {
    _error = null;
    if (_display == '0' && !_isOperator(value) && value != '(' && value != 'i') {
      _expression = value == '.' ? '0.' : value;
    } else {
      _expression += value;
    }
    _display = _expression;
  }

  bool _isOperator(String value) =>
      value == '+' || value == '−' || value == '-' || value == '×' || value == '*' || value == '÷' || value == '/';

  CalculationResult? evaluate() {
    _error = null;
    if (_expression.trim().isEmpty) return null;

    final normalized = _expression
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('−', '-');

    try {
      final tokens = _tokenize(normalized);
      final parser = _Parser(tokens);
      final result = parser.parse();
      if (!parser.isAtEnd) {
        throw CalculatorMathException('Unexpected characters');
      }
      final formatted = result.format();
      return CalculationResult(
        expression: _expression,
        result: formatted,
      );
    } on CalculatorMathException catch (e) {
      _error = e.message;
      return null;
    } catch (_) {
      _error = 'Invalid expression';
      return null;
    }
  }

  void loadExpression(String expr) {
    _error = null;
    _expression = expr;
    _display = expr.isEmpty ? '0' : expr;
  }

  List<_Token> _tokenize(String input) {
    final tokens = <_Token>[];
    var i = 0;

    while (i < input.length) {
      final ch = input[i];

      if (ch == ' ' || ch == '\t') {
        i++;
        continue;
      }

      if (_isDigit(ch) || ch == '.') {
        final start = i;
        while (i < input.length && (_isDigit(input[i]) || input[i] == '.')) {
          i++;
        }
        var number = double.parse(input.substring(start, i));
        if (i < input.length && input[i] == 'i') {
          if (number == 1) {
            tokens.add(_Token(_TokenType.imagUnit));
          } else {
            tokens.add(_Token(_TokenType.number, number));
            tokens.add(_Token(_TokenType.multiply));
            tokens.add(_Token(_TokenType.imagUnit));
          }
          i++;
        } else {
          tokens.add(_Token(_TokenType.number, number));
        }
        continue;
      }

      switch (ch) {
        case 'i':
        case 'j':
          tokens.add(_Token(_TokenType.imagUnit));
        case '+':
          tokens.add(_Token(_TokenType.plus));
        case '-':
          tokens.add(_Token(_TokenType.minus));
        case '*':
          tokens.add(_Token(_TokenType.multiply));
        case '/':
          tokens.add(_Token(_TokenType.divide));
        case '(':
          tokens.add(_Token(_TokenType.lparen));
        case ')':
          tokens.add(_Token(_TokenType.rparen));
        default:
          throw CalculatorMathException('Unknown symbol "$ch"');
      }
      i++;
    }

    tokens.add(const _Token(_TokenType.end));
    return tokens;
  }

  bool _isDigit(String ch) => ch.codeUnitAt(0) >= 48 && ch.codeUnitAt(0) <= 57;
}

class CalculationResult {
  const CalculationResult({required this.expression, required this.result});

  final String expression;
  final String result;
}

class _Parser {
  _Parser(this.tokens);

  final List<_Token> tokens;
  int _index = 0;

  bool get isAtEnd => _peek().type == _TokenType.end;

  _Token _peek() => tokens[_index];

  _Token _advance() => tokens[_index++];

  Complex parse() => _parseExpression();

  Complex _parseExpression() {
    var left = _parseTerm();
    while (_peek().type == _TokenType.plus || _peek().type == _TokenType.minus) {
      final op = _advance().type;
      final right = _parseTerm();
      left = op == _TokenType.plus ? left + right : left - right;
    }
    return left;
  }

  Complex _parseTerm() {
    var left = _parseUnary();
    while (_peek().type == _TokenType.multiply ||
        _peek().type == _TokenType.divide) {
      final op = _advance().type;
      final right = _parseUnary();
      left = op == _TokenType.multiply ? left * right : left / right;
    }
    return left;
  }

  Complex _parseUnary() {
    if (_peek().type == _TokenType.plus) {
      _advance();
      return _parseUnary();
    }
    if (_peek().type == _TokenType.minus) {
      _advance();
      return -_parseUnary();
    }
    return _parsePrimary();
  }

  Complex _parsePrimary() {
    final token = _peek();

    if (token.type == _TokenType.number) {
      _advance();
      return Complex(token.value);
    }

    if (token.type == _TokenType.imagUnit) {
      _advance();
      return Complex.i;
    }

    if (token.type == _TokenType.lparen) {
      _advance();
      final value = _parseExpression();
      if (_peek().type != _TokenType.rparen) {
        throw CalculatorMathException('Missing closing parenthesis');
      }
      _advance();
      return value;
    }

    throw CalculatorMathException('Unexpected token');
  }
}
