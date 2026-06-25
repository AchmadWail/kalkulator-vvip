import 'package:flutter/material.dart';
import '../logic/calculator_logic.dart';
import '../logic/secret_detector.dart';
import 'package:provider/provider.dart';
import '../../history/providers/history_provider.dart';

class CalculatorProvider with ChangeNotifier {
  final CalculatorLogic _logic = CalculatorLogic();
  final SecretDetector _secretDetector = SecretDetector();
  bool _isScientificMode = false;

  String get displayValue => _logic.formatExpression(_logic.expression);
  String get previewValue => _logic.previewResult.isEmpty ? '' : _logic.formatExpression(_logic.previewResult);
  List<String> get history => _logic.history.map((h) => _logic.formatExpression(h)).toList();
  bool get isScientificMode => _isScientificMode;

  void toggleScientificMode() {
    _isScientificMode = !_isScientificMode;
    notifyListeners();
  }

  void onButtonPress(String buttonText, BuildContext context) {
    if (buttonText == 'SCI') {
      toggleScientificMode();
      return;
    }

    // Intercept input for secret codes
    bool isSecret = _secretDetector.detect(buttonText, context);

    if (!isSecret) {
      if (buttonText == '=' && _logic.previewResult.isNotEmpty && _logic.previewResult != 'Error') {
        Provider.of<HistoryProvider>(context, listen: false).addHistory(
          _logic.formatExpression(_logic.expression), 
          _logic.formatExpression(_logic.previewResult)
        );
      }
      _logic.handleButtonPress(buttonText);
    } else {
      if (buttonText == '=') {
        if (_logic.previewResult.isNotEmpty && _logic.previewResult != 'Error') {
          Provider.of<HistoryProvider>(context, listen: false).addHistory(
            _logic.formatExpression(_logic.expression), 
            _logic.formatExpression(_logic.previewResult)
          );
        }
        _logic.handleButtonPress(buttonText);
      }
    }

    notifyListeners();
  }
}
