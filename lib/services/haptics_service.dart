import 'package:flutter/services.dart';

/// Provides tactile feedback for button presses — Apple HIG friendly.
class HapticsService {
  HapticsService._();
  static final HapticsService instance = HapticsService._();

  void lightTap() => HapticFeedback.lightImpact();
  void mediumTap() => HapticFeedback.mediumImpact();
  void heavyTap() => HapticFeedback.heavyImpact();
  void selection() => HapticFeedback.selectionClick();
  void success() => HapticFeedback.mediumImpact();
  void error() => HapticFeedback.heavyImpact();
  void clear() => HapticFeedback.lightImpact();
}
