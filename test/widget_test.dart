import 'package:flutter_test/flutter_test.dart';
import 'package:pastelcalc/main.dart';
import 'package:pastelcalc/widgets/display_panel.dart';

void main() {
  testWidgets('Pastel Calc launches', (WidgetTester tester) async {
    await tester.pumpWidget(const PastelCalcApp());
    expect(find.text('Pastel Calc'), findsOneWidget);
    expect(find.byType(DisplayPanel), findsOneWidget);
  });
}
