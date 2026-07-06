import 'package:flutter_test/flutter_test.dart';
import 'package:pastelcalc/models/complex_number.dart';
import 'package:pastelcalc/services/calculator_engine.dart';

void main() {
  group('Complex', () {
    test('formats real numbers', () {
      expect(const Complex(42).format(), '42');
      expect(const Complex(3.5).format(), '3.5');
    });

    test('formats imaginary numbers', () {
      expect(Complex.i.format(), 'i');
      expect(const Complex(0, 4).format(), '4i');
      expect(const Complex(0, -1).format(), '-i');
    });

    test('formats complex numbers', () {
      expect(const Complex(3, 4).format(), '3+4i');
      expect(const Complex(3, -4).format(), '3-4i');
    });

    test('adds and multiplies', () {
      expect(Complex(1, 2) + Complex(3, 4), const Complex(4, 6));
      expect(Complex(1, 2) * Complex(3, 4), const Complex(-5, 10));
    });

    test('divides complex numbers', () {
      expect(Complex.i / Complex.i, const Complex(1));
    });
  });

  group('CalculatorEngine', () {
    late CalculatorEngine engine;

    setUp(() => engine = CalculatorEngine());

    test('evaluates basic arithmetic', () {
      engine.loadExpression('2+3');
      expect(engine.evaluate()?.result, '5');

      engine.loadExpression('10-4');
      expect(engine.evaluate()?.result, '6');

      engine.loadExpression('6×7');
      expect(engine.evaluate()?.result, '42');

      engine.loadExpression('15÷3');
      expect(engine.evaluate()?.result, '5');
    });

    test('evaluates complex expressions', () {
      engine.loadExpression('i*i');
      expect(engine.evaluate()?.result, '-1');

      engine.loadExpression('(1+i)*(1-i)');
      expect(engine.evaluate()?.result, '2');

      engine.loadExpression('3+4i');
      expect(engine.evaluate()?.result, '3+4i');
    });

    test('handles division by zero', () {
      engine.loadExpression('5÷0');
      expect(engine.evaluate(), isNull);
      expect(engine.error, isNotNull);
    });

    test('backspace and clear', () {
      engine.append('123');
      engine.backspace();
      expect(engine.display, '12');
      engine.clear();
      expect(engine.display, '0');
    });
  });
}
