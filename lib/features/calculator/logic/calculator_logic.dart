import 'dart:math' as math;

class CalculatorLogic {
  String _expression = '';
  String _previewResult = '';
  final List<String> _history = [];
  bool _justCalculated = false;

  String get expression => _expression.isEmpty ? '0' : _expression;
  String get previewResult => _previewResult;
  List<String> get history => _history;

  String formatExpression(String expr) {
    if (expr == 'Error') return expr;
    return expr.replaceAllMapped(RegExp(r'\d+\.?\d*(?:[eE][+-]?\d+)?|\.\d+(?:[eE][+-]?\d+)?'), (match) {
      String numStr = match.group(0)!;
      String expPart = '';
      
      int eIndex = numStr.toLowerCase().indexOf('e');
      if (eIndex != -1) {
        expPart = numStr.substring(eIndex);
        numStr = numStr.substring(0, eIndex);
      }
      
      List<String> parts = numStr.split('.');
      String intPart = parts[0];
      String decPart = parts.length > 1 ? parts[1] : '';

      String formattedInt = '';
      int count = 0;
      for (int i = intPart.length - 1; i >= 0; i--) {
        if (count > 0 && count % 3 == 0 && intPart[i] != '-') {
          formattedInt = '.' + formattedInt;
        }
        formattedInt = intPart[i] + formattedInt;
        count++;
      }

      String formattedNum = parts.length > 1 ? formattedInt + ',' + decPart : formattedInt;
      return formattedNum + expPart;
    });
  }

  void handleButtonPress(String buttonText) {
    if (buttonText == 'AC') {
      _expression = '';
      _previewResult = '';
      _justCalculated = false;
    } else if (buttonText == '⌫') {
      if (_expression.isNotEmpty) {
        // Check if expression ends with a function name like sin(, cos(, etc.
        final funcPatterns = ['sin(', 'cos(', 'tan(', 'log(', 'ln(', '√(', 'asin(', 'acos(', 'atan('];
        bool removedFunc = false;
        for (final p in funcPatterns) {
          if (_expression.endsWith(p)) {
            _expression = _expression.substring(0, _expression.length - p.length);
            removedFunc = true;
            break;
          }
        }
        if (!removedFunc) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
        _updatePreview();
      }
    } else if (buttonText == '%') {
      if (_expression.isNotEmpty && (_isNumeric(_expression[_expression.length - 1]) || _expression.endsWith(')'))) {
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
    } else if (_isBasicOperator(buttonText)) {
      _justCalculated = false;
      if (_expression.isNotEmpty) {
        String lastChar = _expression[_expression.length - 1];
        if (_isBasicOperator(lastChar)) {
          _expression = _expression.substring(0, _expression.length - 1) + buttonText;
        } else {
          _expression += buttonText;
        }
      } else if (buttonText == '-') {
        _expression = '-';
      }
      _updatePreview();
    } else if (buttonText == 'SCI') {
      return;
    } else if (buttonText == 'π') {
      if (_justCalculated) {
        _expression = '';
        _justCalculated = false;
      }
      _expression += 'π';
      _updatePreview();
    } else if (buttonText == 'e') {
      if (_justCalculated) {
        _expression = '';
        _justCalculated = false;
      }
      _expression += 'e';
      _updatePreview();
    } else if (buttonText == 'x²') {
      if (_expression.isNotEmpty && (_isNumeric(_expression[_expression.length - 1]) || _expression.endsWith(')') || _expression.endsWith('π') || _expression.endsWith('e'))) {
        _expression += '²';
        _updatePreview();
      }
    } else if (buttonText == 'x³') {
      if (_expression.isNotEmpty && (_isNumeric(_expression[_expression.length - 1]) || _expression.endsWith(')') || _expression.endsWith('π') || _expression.endsWith('e'))) {
        _expression += '³';
        _updatePreview();
      }
    } else if (buttonText == 'xʸ') {
      if (_expression.isNotEmpty) {
        _expression += '^';
        _updatePreview();
      }
    } else if (buttonText == '1/x') {
      if (_expression.isNotEmpty) {
        _expression = '1÷($_expression)';
        _updatePreview();
      }
    } else if (buttonText == 'x!') {
      if (_expression.isNotEmpty && (_isNumeric(_expression[_expression.length - 1]) || _expression.endsWith(')'))) {
        _expression += '!';
        _updatePreview();
      }
    } else if (buttonText == '|x|') {
      if (_justCalculated) {
        _expression = '';
        _justCalculated = false;
      }
      _expression += 'abs(';
      _updatePreview();
    } else if (_isScientificFunction(buttonText)) {
      if (_justCalculated) {
        _expression = '';
        _justCalculated = false;
      }
      _expression += '$buttonText(';
      _updatePreview();
    } else if (buttonText == '(' || buttonText == ')') {
      if (_justCalculated && buttonText == '(') {
        _expression = '';
        _justCalculated = false;
      }
      _expression += buttonText;
      _updatePreview();
    } else {
      // It's a number or dot
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

  bool _isBasicOperator(String c) {
    return c == '+' || c == '-' || c == '×' || c == '÷';
  }
  
  bool _isScientificFunction(String s) {
    return ['sin', 'cos', 'tan', 'log', 'ln', '√', 'asin', 'acos', 'atan', 'abs'].contains(s);
  }

  bool _isNumeric(String s) {
    if (s.isEmpty) return false;
    return double.tryParse(s) != null || s == '.' || s == 'π' || s == 'e';
  }

  void _updatePreview() {
    if (_expression.isEmpty) {
      _previewResult = '';
      return;
    }

    String lastChar = _expression[_expression.length - 1];
    if (_isBasicOperator(lastChar) || lastChar == '(' || lastChar == '^') {
      _previewResult = '';
      return;
    }

    try {
      double res = _evaluateExpression(_expression);
      String formatted = _formatResult(res);
      _previewResult = formatted;
    } catch (e) {
      _previewResult = '';
    }
  }

  String _formatResult(double res) {
    if (res.isNaN || res.isInfinite) return 'Error';
    
    String formatted = res.toString();
    if (formatted.endsWith('.0')) {
      formatted = formatted.substring(0, formatted.length - 2);
    } else if (formatted.length > 12 && formatted.contains('.')) {
      formatted = res.toStringAsFixed(8);
      while (formatted.contains('.') && (formatted.endsWith('0') || formatted.endsWith('.'))) {
        formatted = formatted.substring(0, formatted.length - 1);
      }
    }
    
    // Scientific notation for very large/small numbers
    if (res.abs() > 999999999999 || (res.abs() < 0.000001 && res != 0)) {
      formatted = res.toStringAsExponential(6);
    }
    
    return formatted;
  }

  double _evaluateExpression(String expr) {
    // Preprocess: handle constants, functions, special operators
    String processed = expr;
    
    // Replace display symbols
    processed = processed.replaceAll('×', '*');
    processed = processed.replaceAll('÷', '/');
    processed = processed.replaceAll('%', '/100');
    processed = processed.replaceAll('π', '${math.pi}');
    processed = processed.replaceAll('²', '^2');
    processed = processed.replaceAll('³', '^3');
    
    // Replace 'e' constant (but not 'e' in exponent notation)
    processed = processed.replaceAllMapped(
      RegExp(r'(?<![0-9.])e(?![0-9+-])'),
      (m) => '${math.e}',
    );
    
    // Auto-close unclosed parentheses
    int openCount = processed.split('(').length - 1;
    int closeCount = processed.split(')').length - 1;
    for (int i = 0; i < openCount - closeCount; i++) {
      processed += ')';
    }
    
    return _parseExpression(processed, 0).value;
  }

  _ParseResult _parseExpression(String expr, int pos) {
    return _parseAddSub(expr, pos);
  }

  _ParseResult _parseAddSub(String expr, int pos) {
    var result = _parseMulDiv(expr, pos);
    double value = result.value;
    int p = result.pos;
    
    while (p < expr.length && (expr[p] == '+' || expr[p] == '-')) {
      String op = expr[p];
      p++;
      var next = _parseMulDiv(expr, p);
      p = next.pos;
      if (op == '+') {
        value += next.value;
      } else {
        value -= next.value;
      }
    }
    
    return _ParseResult(value, p);
  }

  _ParseResult _parseMulDiv(String expr, int pos) {
    var result = _parsePower(expr, pos);
    double value = result.value;
    int p = result.pos;
    
    while (p < expr.length && (expr[p] == '*' || expr[p] == '/')) {
      String op = expr[p];
      p++;
      var next = _parsePower(expr, p);
      p = next.pos;
      if (op == '*') {
        value *= next.value;
      } else {
        value /= next.value;
      }
    }
    
    return _ParseResult(value, p);
  }

  _ParseResult _parsePower(String expr, int pos) {
    var result = _parseUnary(expr, pos);
    double value = result.value;
    int p = result.pos;
    
    while (p < expr.length && expr[p] == '^') {
      p++;
      var next = _parseUnary(expr, p);
      p = next.pos;
      value = math.pow(value, next.value).toDouble();
    }
    
    // Handle factorial
    while (p < expr.length && expr[p] == '!') {
      p++;
      value = _factorial(value.toInt()).toDouble();
    }
    
    return _ParseResult(value, p);
  }

  _ParseResult _parseUnary(String expr, int pos) {
    if (pos < expr.length && expr[pos] == '-') {
      pos++;
      var result = _parsePrimary(expr, pos);
      return _ParseResult(-result.value, result.pos);
    }
    if (pos < expr.length && expr[pos] == '+') {
      pos++;
    }
    return _parsePrimary(expr, pos);
  }

  _ParseResult _parsePrimary(String expr, int pos) {
    // Skip whitespace
    while (pos < expr.length && expr[pos] == ' ') pos++;
    
    // Check for functions
    for (final func in ['sin', 'cos', 'tan', 'asin', 'acos', 'atan', 'log', 'ln', '√', 'abs']) {
      if (pos + func.length <= expr.length && expr.substring(pos, pos + func.length) == func) {
        int funcEnd = pos + func.length;
        if (funcEnd < expr.length && expr[funcEnd] == '(') {
          funcEnd++; // skip '('
          var argResult = _parseExpression(expr, funcEnd);
          int endPos = argResult.pos;
          if (endPos < expr.length && expr[endPos] == ')') {
            endPos++;
          }
          double argValue = argResult.value;
          double result;
          switch (func) {
            case 'sin': result = math.sin(argValue * math.pi / 180); break;
            case 'cos': result = math.cos(argValue * math.pi / 180); break;
            case 'tan': result = math.tan(argValue * math.pi / 180); break;
            case 'asin': result = math.asin(argValue) * 180 / math.pi; break;
            case 'acos': result = math.acos(argValue) * 180 / math.pi; break;
            case 'atan': result = math.atan(argValue) * 180 / math.pi; break;
            case 'log': result = math.log(argValue) / math.ln10; break;
            case 'ln': result = math.log(argValue); break;
            case '√': result = math.sqrt(argValue); break;
            case 'abs': result = argValue.abs(); break;
            default: result = argValue;
          }
          return _ParseResult(result, endPos);
        }
      }
    }

    // Parentheses
    if (pos < expr.length && expr[pos] == '(') {
      pos++;
      var result = _parseExpression(expr, pos);
      int p = result.pos;
      if (p < expr.length && expr[p] == ')') {
        p++;
      }
      return _ParseResult(result.value, p);
    }

    // Number
    int startPos = pos;
    while (pos < expr.length && (_isDigitOrDot(expr[pos]))) {
      pos++;
    }
    // Handle scientific notation in numbers like 3.14e+10
    if (pos < expr.length && (expr[pos] == 'e' || expr[pos] == 'E') && pos > startPos) {
      pos++;
      if (pos < expr.length && (expr[pos] == '+' || expr[pos] == '-')) {
        pos++;
      }
      while (pos < expr.length && _isDigitOrDot(expr[pos])) {
        pos++;
      }
    }
    
    if (startPos == pos) {
      throw FormatException('Unexpected character at position $pos');
    }
    
    String numStr = expr.substring(startPos, pos);
    double value = double.parse(numStr);
    
    return _ParseResult(value, pos);
  }

  bool _isDigitOrDot(String c) {
    return (c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57) || c == '.';
  }

  int _factorial(int n) {
    if (n < 0) return 0;
    if (n <= 1) return 1;
    if (n > 20) return 2432902008176640000; // Prevent overflow, max factorial for int
    int result = 1;
    for (int i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }
}

class _ParseResult {
  final double value;
  final int pos;
  _ParseResult(this.value, this.pos);
}
