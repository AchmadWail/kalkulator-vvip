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
        // Automatically sync AppColors with the notifier
        AppColors.isDark = isDark;
        
        return MaterialApp(
          key: ValueKey(isDark), // Force complete rebuild of the widget tree on theme change
          title: 'Kalkulator VIP',
          debugShowCheckedModeBanner: false,
          theme: isDark ? AppTheme.darkTheme : ThemeData.light().copyWith(
            scaffoldBackgroundColor: AppColors.background,
            appBarTheme: AppBarTheme(backgroundColor: AppColors.background),
          ),
          home: CalculatorScreen(),
        );
      },
    );
  }
}
