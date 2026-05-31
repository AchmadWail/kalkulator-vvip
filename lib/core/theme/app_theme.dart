import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Inter', // Default clean font
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      iconTheme: IconThemeData(
        color: AppColors.navbarIcon,
      ),
    );
  }
}
