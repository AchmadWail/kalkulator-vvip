import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

class CurrencyScreen extends StatefulWidget {
  CurrencyScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'IDR';
  String _result = '0.0';
  
  Map<String, dynamic> _rates = {};
  List<String> _currencies = ['USD', 'IDR', 'EUR', 'JPY', 'GBP', 'AUD', 'SGD'];

  @override
  void initState() {
    super.initState();
    _loadRates();
  }

  Future<void> _loadRates() async {
    try {
      // Load fallback local JSON data
      final String response = await rootBundle.loadString('assets/data/currency_rates.json');
      final data = await json.decode(response);
      setState(() {
        _rates = data['rates'];
        // Also add base currency
        _rates[data['base']] = 1.0;
        
        List<String> loadedCurrencies = _rates.keys.toList();
        if (loadedCurrencies.isNotEmpty) {
          _currencies = loadedCurrencies;
          if (!_currencies.contains(_fromCurrency)) _fromCurrency = _currencies[0];
          if (!_currencies.contains(_toCurrency)) _toCurrency = _currencies.length > 1 ? _currencies[1] : _currencies[0];
        }
      });
    } catch (e) {
      // Silently fail, use dummy fallback rates if file doesn't exist yet
      _rates = {
        'USD': 1.0,
        'IDR': 15500.0,
        'EUR': 0.92,
        'JPY': 150.0,
        'GBP': 0.79,
        'AUD': 1.53,
        'SGD': 1.34,
      };
    }
  }

  void _calculate() {
    if (_inputController.text.isEmpty) {
      setState(() => _result = '0.0');
      return;
    }
    double value = double.tryParse(_inputController.text) ?? 0;
    
    // Logic: Convert from X to USD, then USD to Y
    double fromRate = _rates[_fromCurrency] ?? 1.0;
    double toRate = _rates[_toCurrency] ?? 1.0;
    
    double baseValue = value / fromRate;
    double finalValue = baseValue * toRate;

    setState(() {
      _result = finalValue.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Konverter Mata Uang', style: TextStyle(color: AppColors.numberText)),
        backgroundColor: AppColors.navCapsule,
        iconTheme: IconThemeData(color: AppColors.numberText),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: AppColors.numberText, fontSize: 32),
              onChanged: (v) => _calculate(),
              decoration: InputDecoration(
                labelText: 'Jumlah',
                labelStyle: TextStyle(color: AppColors.numberText.withOpacity(0.54)),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.numberText.withOpacity(0.24))),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.equalsButton)),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDropdown(true),
                Icon(Icons.swap_horiz, color: AppColors.numberText.withOpacity(0.54), size: 32),
                _buildDropdown(false),
              ],
            ),
            SizedBox(height: 48),
            Text('Hasil Konversi:', style: TextStyle(color: AppColors.numberText.withOpacity(0.54), fontSize: 18)),
            SizedBox(height: 8),
            Text(
              '$_result $_toCurrency',
              style: TextStyle(color: AppColors.equalsButton, fontSize: 40, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(bool isFrom) {
    String currentValue = isFrom ? _fromCurrency : _toCurrency;
    return DropdownButton<String>(
      value: currentValue,
      dropdownColor: AppColors.navCapsule,
      style: TextStyle(color: AppColors.numberText, fontSize: 24),
      underline: Container(height: 1, color: AppColors.numberText.withOpacity(0.24)),
      items: _currencies.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
      onChanged: (val) {
        if (val != null) {
          setState(() {
            if (isFrom) _fromCurrency = val;
            else _toCurrency = val;
            _calculate();
          });
        }
      },
    );
  }
}
