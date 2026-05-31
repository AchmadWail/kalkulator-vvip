class CalculatorLogic {
  String _expression = '';
  String _previewResult = '';
  final List<String> _history = [];
  bool _justCalculated = false;

  String get expression => _expression.isEmpty ? '0' : _expression;
  String get previewResult => _previewResult;
  List<String> get history => _history;

  void handleButtonPress(String buttonText) {
    if (buttonText == 'AC') {
      _expression = '';
      _previewResult = '';
      _justCalculated = false;
    } else if (buttonText == '⌫') { // Backspace
      if (_expression.isNotEmpty) {
        _expression = _expression.substring(0, _expression.length - 1);
        _updatePreview();
      }
    } else if (buttonText == '%') {
      if (_expression.isNotEmpty && _isNumeric(_expression[_expression.length - 1])) {
         // simple percent logic: append /100 or something, but let's just evaluate current and divide by 100 for now.
         _expression += '%';
         _updatePreview();
      }
    } else if (buttonText == '=' || buttonText == 'calculate') {
      if (_previewResult.isNotEmpty && _previewResult != 'Error') {
        _history.add('$_expression = $_previewResult');
        _expression = _previewResult;
        _previewResult = '';
        _justCalculated = true;
      }
    } else if (_isOperator(buttonText)) {
      _justCalculated = false;
      if (_expression.isNotEmpty) {
        String lastChar = _expression[_expression.length - 1];
        if (_isOperator(lastChar)) {
          // Replace last operator
          _expression = _expression.substring(0, _expression.length - 1) + buttonText;
        } else {
          _expression += buttonText;
        }
      } else if (buttonText == '-') {
        _expression = '-';
      }
      _updatePreview();
    } else {
      // It's a number or comma/dot
      if (_justCalculated) {
        _expression = '';
        _justCalculated = false;
      }
      
      String val = buttonText == ',' ? '.' : buttonText;
      
      if (_expression == '0' && val != '.') {
        _expression = val;
      } else {
        _expression += val;
      }
      _updatePreview();
    }
  }

  bool _isOperator(String c) {
    return c == '+' || c == '-' || c == '×' || c == '÷';
  }
  
  bool _isNumeric(String s) {
    if (s.isEmpty) return false;
    return double.tryParse(s) != null;
  }

  void _updatePreview() {
    if (_expression.isEmpty) {
      _previewResult = '';
      return;
    }
    
    String lastChar = _expression[_expression.length - 1];
    if (_isOperator(lastChar)) {
      // Don't evaluate if ends with operator, or just evaluate what we have
      _previewResult = '';
      return;
    }

    try {
      double res = _evaluateExpression(_expression);
      // Format
      String formatted = res.toString();
      if (formatted.endsWith('.0')) {
        formatted = formatted.substring(0, formatted.length - 2);
      } else if (formatted.length > 10 && formatted.contains('.')) {
        formatted = res.toStringAsFixed(6);
        while(formatted.contains('.') && (formatted.endsWith('0') || formatted.endsWith('.'))) {
            formatted = formatted.substring(0, formatted.length - 1);
        }
      }
      _previewResult = formatted;
    } catch (e) {
      _previewResult = '';
    }
  }

  double _evaluateExpression(String expr) {
    // A very simple evaluator for basic left-to-right math or proper precedence.
    // For MVP, we will do a simple sequential evaluation.
    // Replace custom operators with standard ones
    String cleanExpr = expr.replaceAll('×', '*').replaceAll('÷', '/').replaceAll('%', '/100');
    
    // Split by operators and keep operators
    RegExp regex = RegExp(r'(\d+\.?\d*)|([\+\-\*/])');
    Iterable<Match> matches = regex.allMatches(cleanExpr);
    
    List<String> tokens = [];
    for (var m in matches) {
      tokens.add(m.group(0)!);
    }
    
    if (tokens.isEmpty) return 0.0;
    
    // Handle leading negative sign
    if (tokens.length > 1 && tokens[0] == '-' && _isNumeric(tokens[1])) {
      tokens[1] = '-' + tokens[1];
      tokens.removeAt(0);
    }

    // Pass 1: Multiply / Divide
    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i] == '*' || tokens[i] == '/') {
        if (i > 0 && i < tokens.length - 1) {
          double a = double.parse(tokens[i-1]);
          double b = double.parse(tokens[i+1]);
          double res = tokens[i] == '*' ? (a * b) : (a / b);
          tokens[i-1] = res.toString();
          tokens.removeAt(i);
          tokens.removeAt(i);
          i--; // adjust index
        }
      }
    }
    
    // Pass 2: Add / Subtract
    double finalResult = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      if (i + 1 < tokens.length) {
        String op = tokens[i];
        double b = double.parse(tokens[i+1]);
        if (op == '+') finalResult += b;
        if (op == '-') finalResult -= b;
      }
    }
    
    return finalResult;
  }
}
