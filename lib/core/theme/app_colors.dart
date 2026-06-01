import 'package:flutter/material.dart';

class AppColors {
  static bool isDark = true;

  // Primary palette - Cyberpunk Neon
  static Color get background => isDark ? Color(0xFF0A0A1A) : Color(0xFFF0F2F8);
  static Color get surface => isDark ? Color(0xFF12122A) : Color(0xFFFFFFFF);
  static Color get surfaceVariant => isDark ? Color(0xFF1A1A3E) : Color(0xFFF5F5FA);
  
  static Color get numberButton => isDark ? Color(0xFF161636) : Color(0xFFFFFFFF);
  static Color get numberText => isDark ? Color(0xFFE8E8FF) : Color(0xFF1A1A2E);

  static Color get operatorButton => isDark ? Color(0xFF1E1E48) : Color(0xFFEDE9FE);
  static Color get operatorText => isDark ? Color(0xFFA78BFA) : Color(0xFF7C3AED);

  static Color get equalsButton => isDark ? Color(0xFFFF6B6B) : Color(0xFFEF4444);
  static Color get equalsText => Colors.white;

  static Color get accentCyan => isDark ? Color(0xFF22D3EE) : Color(0xFF0891B2);
  static Color get accentPurple => isDark ? Color(0xFFA78BFA) : Color(0xFF7C3AED);
  static Color get accentPink => isDark ? Color(0xFFF472B6) : Color(0xFFDB2777);
  static Color get accentGreen => isDark ? Color(0xFF34D399) : Color(0xFF059669);
  static Color get accentOrange => isDark ? Color(0xFFFBBF24) : Color(0xFFD97706);

  static Color get navCapsule => isDark ? Color(0xFF161636) : Color(0xFFFFFFFF);
  static Color get navbarIcon => isDark ? Color(0xFFA78BFA) : Color(0xFF7C3AED);

  static Color get previewText => isDark ? Color(0xFF4A4A78) : Color(0xFF9CA3AF);
  
  static Color get scientificButton => isDark ? Color(0xFF1A1A40) : Color(0xFFF0EDFF);
  static Color get scientificText => isDark ? Color(0xFF7DD3FC) : Color(0xFF0369A1);

  // Gradients
  static List<Color> get primaryGradient => isDark 
    ? [Color(0xFF7C3AED), Color(0xFFA78BFA)]
    : [Color(0xFF6D28D9), Color(0xFF8B5CF6)];
    
  static List<Color> get dangerGradient => isDark
    ? [Color(0xFFEF4444), Color(0xFFF97316)]
    : [Color(0xFFDC2626), Color(0xFFEA580C)];
}
