import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/calculator_screen.dart';
import 'theme/pastel_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const PastelCalcApp());
}

/// Fully offline calculator — no analytics, no network, no tracking.
class PastelCalcApp extends StatelessWidget {
  const PastelCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pastel Calc',
      debugShowCheckedModeBanner: false,
      theme: PastelTheme.build(),
      home: const CalculatorScreen(),
    );
  }
}
