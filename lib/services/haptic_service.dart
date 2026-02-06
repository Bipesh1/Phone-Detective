// Phone Detective - Haptic Service

import 'package:flutter/services.dart';

class HapticService {
  /// Light tap feedback - for button taps, navigation
  static void lightTap() {
    HapticFeedback.lightImpact();
  }

  /// Medium feedback - for marking clues, selecting items
  static void mediumTap() {
    HapticFeedback.mediumImpact();
  }

  /// Heavy feedback - for solving cases, important actions
  static void heavyTap() {
    HapticFeedback.heavyImpact();
  }

  /// Selection feedback - for toggles, checkboxes
  static void selection() {
    HapticFeedback.selectionClick();
  }

  /// Vibrate pattern - for errors, warnings
  static void vibrate() {
    HapticFeedback.vibrate();
  }
}
