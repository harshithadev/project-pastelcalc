class CalculationEntry {
  const CalculationEntry({
    required this.id,
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  final String id;
  final String expression;
  final String result;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
        'id': id,
        'expression': expression,
        'result': result,
        'timestamp': timestamp.toIso8601String(),
      };

  factory CalculationEntry.fromJson(Map<String, dynamic> json) =>
      CalculationEntry(
        id: json['id'] as String,
        expression: json['expression'] as String,
        result: json['result'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  CalculationEntry copyWith({
    String? expression,
    String? result,
    DateTime? timestamp,
  }) =>
      CalculationEntry(
        id: id,
        expression: expression ?? this.expression,
        result: result ?? this.result,
        timestamp: timestamp ?? this.timestamp,
      );
}
