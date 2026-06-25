import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../widgets/display_widget.dart';
import '../widgets/keypad_widget.dart';
import '../widgets/navbar_top.dart';
import '../../../core/theme/app_colors.dart';

class CalculatorScreen extends StatelessWidget {
  CalculatorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalculatorProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              NavbarTop(),
              Expanded(
                flex: 4,
                child: DisplayWidget(),
              ),
              Expanded(
                flex: 6,
                child: KeypadWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
