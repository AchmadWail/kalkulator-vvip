import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'features/calculator/screens/calculator_screen.dart';

final ValueNotifier<bool> themeNotifier = ValueNotifier(true);

class KalkulatorVipApp extends StatelessWidget {
  KalkulatorVipApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (context, isDark, child) {
        AppColors.isDark = isDark;

        return MaterialApp(
          key: ValueKey(isDark),
          title: 'Kalkulator VVIP',
          debugShowCheckedModeBanner: false,
          theme: isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
          home: CalculatorScreen(),
        );
      },
    );
  }
}
