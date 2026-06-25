import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../../../core/theme/app_colors.dart';

class CurrencyConverterScreen extends StatefulWidget {
  CurrencyConverterScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyConverterScreen> createState() => _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _inputController = TextEditingController(text: "1");
  String _result = "";
  String _fromUnit = "USD";
  String _toUnit = "IDR";
  
  Map<String, double> _rates = {};
  List<String> _units = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRates();
    _inputController.addListener(_calculate);
  }

  Future<void> _fetchRates() async {
    try {
      final res = await http.get(Uri.parse('https://api.frankfurter.app/latest?from=USD'));
      if (res.statusCode == 200) {
        _parseData(res.body);
      } else {
        await _loadFallback();
      }
    } catch (_) {
      await _loadFallback();
    }
  }

  Future<void> _loadFallback() async {
    try {
      final str = await rootBundle.loadString('assets/data/currency_rates.json');
      _parseData(str);
    } catch (_) {
      setState(() {
        _isLoading = false;
        _units = ["USD", "IDR"];
        _rates = {"USD": 1.0, "IDR": 16000.0};
      });
      _calculate();
    }
  }

  void _parseData(String jsonStr) {
    final data = jsonDecode(jsonStr);
    final ratesMap = data['rates'] as Map<String, dynamic>;
    
    Map<String, double> parsedRates = {};
    parsedRates['USD'] = 1.0; // Base
    
    ratesMap.forEach((key, value) {
      parsedRates[key] = (value as num).toDouble();
    });

    setState(() {
      _rates = parsedRates;
      _units = parsedRates.keys.toList()..sort();
      _isLoading = false;
    });
    _calculate();
  }

  void _calculate() {
    if (_rates.isEmpty) return;
    
    double value = double.tryParse(_inputController.text) ?? 0.0;
    
    // Convert from source to USD (Base)
    double inUsd = value / (_rates[_fromUnit] ?? 1.0);
    
    // Convert from USD to target
    double outValue = inUsd * (_rates[_toUnit] ?? 1.0);

    setState(() {
      _result = outValue.toStringAsFixed(2);
      // Remove trailing .00 if needed, but for currency fixed 2 is standard
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Konverter Valuta", style: TextStyle(color: AppColors.numberText)), 
        backgroundColor: AppColors.background, 
        iconTheme: IconThemeData(color: AppColors.numberText)
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator(color: AppColors.equalsButton))
        : Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: AppColors.numberText, fontSize: 32),
              decoration: InputDecoration(
                labelText: "Jumlah", 
                labelStyle: TextStyle(color: AppColors.previewText),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.operatorButton)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.equalsButton)),
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.numberButton,
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _fromUnit,
                        dropdownColor: AppColors.numberButton,
                        style: TextStyle(color: AppColors.numberText, fontSize: 18),
                        items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                        onChanged: (v) {
                          setState(() => _fromUnit = v!);
                          _calculate();
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(Icons.swap_horiz, color: AppColors.navbarIcon, size: 32),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.numberButton,
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _toUnit,
                        dropdownColor: AppColors.numberButton,
                        style: TextStyle(color: AppColors.numberText, fontSize: 18),
                        items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                        onChanged: (v) {
                          setState(() => _toUnit = v!);
                          _calculate();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
            Text("Hasil Konversi:", style: TextStyle(color: AppColors.previewText, fontSize: 16)),
            SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "$_result $_toUnit", 
                style: TextStyle(color: AppColors.equalsButton, fontSize: 48, fontWeight: FontWeight.bold)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
