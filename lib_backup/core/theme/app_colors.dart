import 'package:flutter/material.dart';

class AppColors {
  static bool isDark = true;
  
  static Color get background => isDark ? Color(0xFF11111A) : Color(0xFFF2F2F7);
  static Color get numberButton => isDark ? Color(0xFF181825) : Colors.white;
  static Color get numberText => isDark ? Colors.white : Colors.black87;
  
  static Color get operatorButton => isDark ? Color(0xFF2A2441) : Color(0xFFE5E5EA);
  static Color get operatorText => isDark ? Color(0xFF8678F9) : Color(0xFF5E5CE6);

  static Color get equalsButton => isDark ? Color(0xFFF9C784) : Color(0xFFFF9F0A);
  static Color get equalsText => isDark ? Colors.black : Colors.white;
  
  static Color get navCapsule => isDark ? Color(0xFF181825) : Colors.white;
  static Color get navbarIcon => isDark ? Color(0xFF8678F9) : Color(0xFF5E5CE6);
  
  static Color get previewText => isDark ? Color(0xFF4A4A68) : Color(0xFF8E8E93);

  // Added colors to fix build errors
  static Color get accentGreen => isDark ? Color(0xFF30D158) : Color(0xFF34C759);
  static Color get accentPurple => isDark ? Color(0xFFBF5AF2) : Color(0xFFAF52DE);
  static Color get accentCyan => isDark ? Color(0xFF64D2FF) : Color(0xFF32ADE6);
  static Color get accentPink => isDark ? Color(0xFFFF375F) : Color(0xFFFF2D55);
  static Color get surface => isDark ? Color(0xFF1E1E2C) : Colors.white;
  static Color get surfaceVariant => isDark ? Color(0xFF2A2A3C) : Color(0xFFF2F2F7);
}
