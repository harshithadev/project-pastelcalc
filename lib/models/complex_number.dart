import 'dart:math' as math;

/// A lightweight complex number used for all calculator arithmetic.
class Complex {
  const Complex(this.real, [this.imag = 0]);

  final double real;
  final double imag;

  static const zero = Complex(0);
  static const one = Complex(1);
  static const i = Complex(0, 1);

  bool get isReal => imag.abs() < 1e-12;
  bool get isImaginary => real.abs() < 1e-12 && imag.abs() >= 1e-12;
  bool get isZero => real.abs() < 1e-12 && imag.abs() < 1e-12;

  double get magnitude => math.sqrt(real * real + imag * imag);

  Complex operator +(Complex other) =>
      Complex(real + other.real, imag + other.imag);

  Complex operator -(Complex other) =>
      Complex(real - other.real, imag - other.imag);

  Complex operator -() => Complex(-real, -imag);

  Complex operator *(Complex other) => Complex(
        real * other.real - imag * other.imag,
        real * other.imag + imag * other.real,
      );

  Complex operator /(Complex other) {
    final denom = other.real * other.real + other.imag * other.imag;
    if (denom.abs() < 1e-24) {
      throw CalculatorMathException('Cannot divide by zero');
    }
    return Complex(
      (real * other.real + imag * other.imag) / denom,
      (imag * other.real - real * other.imag) / denom,
    );
  }

  String format({int precision = 10}) {
    final r = _trim(real, precision);
    final i = _trim(imag.abs(), precision);

    if (isZero) return '0';
    if (isReal) return r;
    if (isImaginary) {
      if ((imag - 1).abs() < 1e-12) return 'i';
      if ((imag + 1).abs() < 1e-12) return '-i';
      return imag < 0 ? '-${i}i' : '${i}i';
    }

    final sign = imag < 0 ? '-' : '+';
    final imagPart = (imag.abs() - 1).abs() < 1e-12
        ? 'i'
        : imag.abs() < 1e-12
            ? ''
            : '${i}i';
    if (imagPart.isEmpty) return r;
    return '$r$sign$imagPart';
  }

  static String _trim(double value, int precision) {
    if (value.isNaN || value.isInfinite) {
      return value.toString();
    }
    var text = value.toStringAsFixed(precision);
    while (text.contains('.') && (text.endsWith('0') || text.endsWith('.'))) {
      text = text.endsWith('.') ? text.substring(0, text.length - 1) : text.substring(0, text.length - 1);
    }
    return text;
  }

  @override
  String toString() => format();

  @override
  bool operator ==(Object other) =>
      other is Complex &&
      (real - other.real).abs() < 1e-9 &&
      (imag - other.imag).abs() < 1e-9;

  @override
  int get hashCode => Object.hash(real, imag);
}

class CalculatorMathException implements Exception {
  CalculatorMathException(this.message);
  final String message;

  @override
  String toString() => message;
}
