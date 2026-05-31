import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/calculator/screens/calculator_screen.dart';

class KalkulatorVipApp extends StatelessWidget {
  const KalkulatorVipApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator VIP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const CalculatorScreen(),
    );
  }
}
