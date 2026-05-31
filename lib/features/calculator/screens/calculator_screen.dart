import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../widgets/display_widget.dart';
import '../widgets/keypad_widget.dart';
import '../widgets/navbar_top.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalculatorProvider(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const NavbarTop(),
              Expanded(
                child: const DisplayWidget(),
              ),
              const KeypadWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
