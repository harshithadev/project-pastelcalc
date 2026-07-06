import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/calculation_entry.dart';
import '../services/calculator_engine.dart';
import '../services/haptics_service.dart';
import '../services/history_service.dart';
import '../theme/pastel_theme.dart';
import '../widgets/calc_button.dart';
import '../widgets/display_panel.dart';
import '../widgets/history_panel.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _engine = CalculatorEngine();
  final _history = HistoryService.instance;
  final _haptics = HapticsService.instance;

  List<CalculationEntry> _entries = [];
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    await _history.load();
    if (mounted) setState(() => _entries = _history.entries);
  }

  void _onButton(String label, {bool isOperator = false, bool isEquals = false}) {
    if (isEquals) {
      _haptics.mediumTap();
    } else if (label == 'C') {
      _haptics.clear();
    } else if (isOperator) {
      _haptics.selection();
    } else {
      _haptics.lightTap();
    }

    setState(() {
      switch (label) {
        case 'C':
          _engine.clear();
        case '⌫':
          _engine.backspace();
        case '=':
          final result = _engine.evaluate();
          if (result != null) {
            _haptics.success();
            _history.add(
              expression: result.expression,
              result: result.result,
            ).then((_) => _loadHistory());
            _engine.loadExpression(result.result);
          } else if (_engine.hasError) {
            _haptics.error();
          }
        default:
          _engine.append(label);
      }
    });
  }

  Future<void> _confirmDeleteAll() async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Clear all history?'),
        content: const Text('This removes every saved calculation from this device.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear all'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _haptics.heavyTap();
      await _history.deleteAll();
      await _loadHistory();
    }
  }

  void _reuseEntry(CalculationEntry entry) {
    _haptics.selection();
    setState(() {
      _engine.loadExpression(entry.expression);
      _showHistory = false;
    });
  }

  Future<void> _deleteEntry(String id) async {
    _haptics.lightTap();
    await _history.delete(id);
    await _loadHistory();
  }

  double _buttonGap(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width > 900) return 14;
    if (width > 600) return 12;
    return 10;
  }

  Widget _buttonRow(BuildContext context, List<_Btn> buttons) {
    final gap = _buttonGap(context);

    return Row(
      children: [
        for (var i = 0; i < buttons.length; i++) ...[
          if (i > 0) SizedBox(width: gap),
          buttons[i].build(context, _onButton),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final gap = _buttonGap(context);
    final isWide = MediaQuery.sizeOf(context).width > 700;
    final maxWidth = isWide ? 520.0 : double.infinity;

    return Scaffold(
      backgroundColor: PastelColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: PastelColors.rose.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  CupertinoIcons.function,
                                  size: 18,
                                  color: PastelColors.textPrimary.withValues(alpha: 0.85),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Pastel Calc',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          IconButton.filledTonal(
                            style: IconButton.styleFrom(
                              backgroundColor: PastelColors.sky,
                              foregroundColor: PastelColors.textOnAccent,
                            ),
                            onPressed: () {
                              _haptics.selection();
                              setState(() => _showHistory = true);
                            },
                            icon: Badge(
                              isLabelVisible: _entries.isNotEmpty,
                              label: Text('${_entries.length}'),
                              child: const Icon(CupertinoIcons.clock),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        flex: isWide ? 2 : 3,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: DisplayPanel(
                            expression: _engine.expression,
                            display: _engine.display,
                            error: _engine.error,
                          ),
                        ),
                      ),
                      SizedBox(height: gap + 4),
                      Expanded(
                        flex: isWide ? 5 : 7,
                        child: Column(
                          children: [
                            Expanded(
                              child: _buttonRow(context, [
                                _Btn('C', PastelColors.danger),
                                _Btn('⌫', PastelColors.peach),
                                _Btn('(', PastelColors.sky),
                                _Btn(')', PastelColors.sky),
                              ]),
                            ),
                            SizedBox(height: gap),
                            Expanded(
                              child: _buttonRow(context, [
                                _Btn('7', PastelColors.butter),
                                _Btn('8', PastelColors.butter),
                                _Btn('9', PastelColors.butter),
                                _Btn('÷', PastelColors.operator, isOperator: true),
                              ]),
                            ),
                            SizedBox(height: gap),
                            Expanded(
                              child: _buttonRow(context, [
                                _Btn('4', PastelColors.mint),
                                _Btn('5', PastelColors.mint),
                                _Btn('6', PastelColors.mint),
                                _Btn('×', PastelColors.operator, isOperator: true),
                              ]),
                            ),
                            SizedBox(height: gap),
                            Expanded(
                              child: _buttonRow(context, [
                                _Btn('1', PastelColors.lilac),
                                _Btn('2', PastelColors.lilac),
                                _Btn('3', PastelColors.lilac),
                                _Btn('−', PastelColors.operator, isOperator: true),
                              ]),
                            ),
                            SizedBox(height: gap),
                            Expanded(
                              child: _buttonRow(context, [
                                _Btn('i', PastelColors.rose),
                                _Btn('0', PastelColors.lilac),
                                _Btn('.', PastelColors.lilac),
                                _Btn('+', PastelColors.operator, isOperator: true),
                              ]),
                            ),
                            SizedBox(height: gap),
                            Expanded(
                              child: Row(
                                children: [
                                  CalcButton(
                                    label: '=',
                                    isWide: true,
                                    flex: 4,
                                    backgroundColor: PastelColors.equals,
                                    onPressed: () =>
                                        _onButton('=', isEquals: true),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_showHistory)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => setState(() => _showHistory = false),
                  child: Container(color: Colors.black.withValues(alpha: 0.18)),
                ),
              ),
            AnimatedSlide(
              offset: _showHistory ? Offset.zero : const Offset(0, 1),
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: isWide ? 0.55 : 0.62,
                  widthFactor: isWide ? 0.7 : 1,
                  child: HistoryPanel(
                    entries: _entries,
                    onReuse: _reuseEntry,
                    onDelete: _deleteEntry,
                    onDeleteAll: _confirmDeleteAll,
                    onClose: () => setState(() => _showHistory = false),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Btn {
  const _Btn(this.label, this.color, {this.isOperator = false});

  final String label;
  final Color color;
  final bool isOperator;

  Widget build(BuildContext context, void Function(String, {bool isOperator, bool isEquals}) onTap) {
    return CalcButton(
      label: label,
      backgroundColor: color,
      onPressed: () => onTap(label, isOperator: isOperator),
    );
  }
}
