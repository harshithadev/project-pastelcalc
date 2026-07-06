import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/calculation_entry.dart';

/// Persists calculation history locally — no network, no cloud.
class HistoryService {
  HistoryService._();
  static final HistoryService instance = HistoryService._();

  static const _storageKey = 'calculation_history_v1';
  final _uuid = const Uuid();

  List<CalculationEntry> _entries = [];
  bool _loaded = false;

  List<CalculationEntry> get entries => List.unmodifiable(_entries);

  Future<void> load() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      final list = jsonDecode(raw) as List<dynamic>;
      _entries = list
          .map((e) => CalculationEntry.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }
    _loaded = true;
  }

  Future<CalculationEntry> add({
    required String expression,
    required String result,
  }) async {
    await load();
    final entry = CalculationEntry(
      id: _uuid.v4(),
      expression: expression,
      result: result,
      timestamp: DateTime.now(),
    );
    _entries.insert(0, entry);
    await _persist();
    return entry;
  }

  Future<void> update(String id, {String? expression, String? result}) async {
    await load();
    final index = _entries.indexWhere((e) => e.id == id);
    if (index == -1) return;
    _entries[index] = _entries[index].copyWith(
      expression: expression,
      result: result,
      timestamp: DateTime.now(),
    );
    await _persist();
  }

  Future<void> delete(String id) async {
    await load();
    _entries.removeWhere((e) => e.id == id);
    await _persist();
  }

  Future<void> deleteAll() async {
    await load();
    _entries = [];
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_entries.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }
}
