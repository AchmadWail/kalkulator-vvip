import 'package:flutter/material.dart';
import '../logic/calculator_logic.dart';
import '../logic/secret_detector.dart';
import 'package:provider/provider.dart';
import '../../history/providers/history_provider.dart';

class CalculatorProvider with ChangeNotifier {
  final CalculatorLogic _logic = CalculatorLogic();
  final SecretDetector _secretDetector = SecretDetector();

  String get displayValue => _logic.expression;
  String get previewValue => _logic.previewResult;
  List<String> get history => _logic.history;

  void onButtonPress(String buttonText, BuildContext context) {
    // Intercept input for secret codes
    bool isSecret = _secretDetector.detect(buttonText, context);
    
    if (!isSecret) {
      if (buttonText == '=' && _logic.previewResult.isNotEmpty && _logic.previewResult != 'Error') {
        Provider.of<HistoryProvider>(context, listen: false).addHistory(_logic.expression, _logic.previewResult);
      }
      _logic.handleButtonPress(buttonText);
    } else {
      // Even if secret is detected, we might want to still show it calculating
      // For now, if it triggers a secret, we also let the calculator process the '=' 
      // so it looks like a normal calculation just happened.
      if (buttonText == '=') {
         if (_logic.previewResult.isNotEmpty && _logic.previewResult != 'Error') {
           Provider.of<HistoryProvider>(context, listen: false).addHistory(_logic.expression, _logic.previewResult);
         }
         _logic.handleButtonPress(buttonText);
      }
    }
    
    notifyListeners();
  }
}
