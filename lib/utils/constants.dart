// Phone Detective - App Constants

import 'package:flutter/material.dart';

// ============ COLORS ============
class AppColors {
  // Backgrounds
  static const Color background = Color(0xFF000000);
  static const Color backgroundSecondary = Color(0xFF1C1C1E);
  static const Color surfaceDark = Color(0xFF2C2C2E);
  static const Color surfaceLight = Color(0xFF3A3A3C);
  
  // Primary accent
  static const Color primary = Color(0xFF007AFF);
  static const Color primaryDark = Color(0xFF0051A8);
  
  // Semantic colors
  static const Color clue = Color(0xFFFFCC00);  // Amber for clues
  static const Color success = Color(0xFF34C759);
  static const Color danger = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFF9500);
  
  // Text colors
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0x99FFFFFF);  // 60% white
  static const Color textTertiary = Color(0x66FFFFFF);   // 40% white
  
  // Message bubbles
  static const Color messageBubbleSent = Color(0xFF007AFF);
  static const Color messageBubbleReceived = Color(0xFF3A3A3C);
  
  // App icon backgrounds
  static const List<Color> appIconColors = [
    Color(0xFF34C759), // Messages green
    Color(0xFFFF9500), // Gallery orange
    Color(0xFF5856D6), // Contacts purple
    Color(0xFF007AFF), // Email blue
    Color(0xFFFFCC00), // Notes yellow
    Color(0xFFFF3B30), // Call Log red
    Color(0xFF8E8E93), // Settings gray
    Color(0xFFAF52DE), // Journal purple
  ];
}

// ============ DURATIONS ============
class AppDurations {
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration screenTransition = Duration(milliseconds: 300);
  static const Duration appLaunch = Duration(milliseconds: 250);
  static const Duration buttonTap = Duration(milliseconds: 100);
  static const Duration clueHighlight = Duration(milliseconds: 500);
}

// ============ CURVES ============
class AppCurves {
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve springCurve = Curves.easeOutBack;
  static const Curve bounceCurve = Curves.bounceOut;
}

// ============ CASE UNLOCK LOGIC ============
class CaseUnlock {
  static const Map<int, List<int>> requirements = {
    1: [],           // Always unlocked
    2: [1],          // Requires case 1
    3: [1],          // Requires case 1
    4: [3],          // Requires case 3
    5: [3],          // Requires case 3
    6: [3],          // Requires case 3
    7: [6],          // Requires case 6
    8: [6],          // Requires case 6
    9: [6],          // Requires case 6
    10: [1, 2, 3, 4, 5, 6, 7, 8, 9],  // Requires all previous
  };
  
  static bool isUnlocked(int caseNumber, Set<int> solvedCases) {
    if (caseNumber == 1) return true;
    final required = requirements[caseNumber] ?? [];
    return required.every((req) => solvedCases.contains(req));
  }
}

// ============ PHONE FRAME DIMENSIONS ============
class PhoneFrameDimensions {
  static const double bezelRadius = 40.0;
  static const double notchWidth = 120.0;
  static const double notchHeight = 30.0;
  static const double statusBarHeight = 44.0;
  static const double homeIndicatorHeight = 34.0;
}
