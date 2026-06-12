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

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController(text: "1");
  String _result = "";
  String _fromUnit = "USD";
  String _toUnit = "IDR";
  late AnimationController _animController;
  late Animation<double> _resultAnim;

  Map<String, double> _rates = {};
  List<String> _units = [];
  bool _isLoading = true;
  String _lastUpdated = "";

  // Currency flag emoji map
  final Map<String, String> _flagEmoji = {
    'USD': '🇺🇸', 'EUR': '🇪🇺', 'GBP': '🇬🇧', 'JPY': '🇯🇵', 'IDR': '🇮🇩',
    'MYR': '🇲🇾', 'SGD': '🇸🇬', 'AUD': '🇦🇺', 'CAD': '🇨🇦', 'CHF': '🇨🇭',
    'CNY': '🇨🇳', 'HKD': '🇭🇰', 'INR': '🇮🇳', 'KRW': '🇰🇷', 'THB': '🇹🇭',
    'PHP': '🇵🇭', 'NZD': '🇳🇿', 'BRL': '🇧🇷', 'SEK': '🇸🇪', 'NOK': '🇳🇴',
    'DKK': '🇩🇰', 'ZAR': '🇿🇦', 'TRY': '🇹🇷', 'RUB': '🇷🇺', 'MXN': '🇲🇽',
    'PLN': '🇵🇱', 'CZK': '🇨🇿', 'HUF': '🇭🇺', 'ILS': '🇮🇱', 'ISK': '🇮🇸',
    'BGN': '🇧🇬', 'RON': '🇷🇴', 'HRK': '🇭🇷',
  };

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _resultAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _fetchRates();
    _inputController.addListener(_calculate);
  }

  @override
  void dispose() {
    _animController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _fetchRates() async {
    try {
      final res = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'));
      if (res.statusCode == 200) {
        _parseData(res.body);
        _lastUpdated = "Live";
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
      _lastUpdated = "Offline";
    } catch (_) {
      setState(() {
        _isLoading = false;
        _units = ["USD", "IDR"];
        _rates = {"USD": 1.0, "IDR": 18095.70};
        _lastUpdated = "Fallback";
      });
      _calculate();
    }
  }

  void _parseData(String jsonStr) {
    final data = jsonDecode(jsonStr);
    final ratesMap = data['rates'] as Map<String, dynamic>;

    Map<String, double> parsedRates = {};
    parsedRates['USD'] = 1.0;

    ratesMap.forEach((key, value) {
      parsedRates[key] = (value as num).toDouble();
    });

    // Enforce custom IDR rate
    parsedRates['IDR'] = 18095.70;

    setState(() {
      _rates = parsedRates;
      _units = parsedRates.keys.toList()..sort();
      _isLoading = false;
    });
    _calculate();
  }

  void _calculate() {
    if (_rates.isEmpty) return;

    String cleanText = _inputController.text.replaceAll('.', '').replaceAll(',', '.');
    double value = double.tryParse(cleanText) ?? 0.0;
    double inUsd = value / (_rates[_fromUnit] ?? 1.0);
    double outValue = inUsd * (_rates[_toUnit] ?? 1.0);

    setState(() {
      _result = _formatCurrency(outValue);
    });
    _animController.reset();
    _animController.forward();
  }

  String _formatCurrency(double v) {
    if (v == 0) return "0";
    String str = v.toStringAsFixed(2);
    List<String> parts = str.split('.');
    String intPart = parts[0];
    String decPart = parts.length > 1 ? parts[1] : '';

    while (decPart.endsWith('0')) {
      decPart = decPart.substring(0, decPart.length - 1);
    }

    intPart = intPart.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );

    if (decPart.isEmpty) {
      return intPart;
    } else {
      return '$intPart,$decPart';
    }
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
    });
    _calculate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Konverter Valuta"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.numberText),
        actions: [
          if (_lastUpdated.isNotEmpty)
            Center(
              child: Container(
                margin: EdgeInsets.only(right: 16),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _lastUpdated == "Live"
                    ? AppColors.accentGreen.withOpacity(0.15)
                    : AppColors.accentOrange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6, height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _lastUpdated == "Live" ? AppColors.accentGreen : AppColors.accentOrange,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      _lastUpdated,
                      style: TextStyle(
                        color: _lastUpdated == "Live" ? AppColors.accentGreen : AppColors.accentOrange,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColors.accentCyan),
                    strokeWidth: 2,
                  ),
                  SizedBox(height: 16),
                  Text("Memuat kurs...", style: TextStyle(color: AppColors.previewText)),
                ],
              ),
            )
          : Stack(
              children: [
                Positioned(
                  top: -80, left: -60,
                  child: Container(
                    width: 200, height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        AppColors.accentGreen.withOpacity(0.08),
                        Colors.transparent,
                      ]),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Input
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.accentGreen.withOpacity(0.2)),
                          ),
                          child: TextField(
                            controller: _inputController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            style: TextStyle(color: AppColors.numberText, fontSize: 28, fontWeight: FontWeight.w500, height: 1.2),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                              hintText: "Jumlah",
                              hintStyle: TextStyle(color: AppColors.previewText.withOpacity(0.5), fontSize: 20, height: 1.2),
                            ),
                          ),
                        ),
                        SizedBox(height: 28),
                        // Currency selectors
                        Row(
                          children: [
                            Expanded(child: _buildCurrencySelector(_fromUnit, (v) {
                              setState(() => _fromUnit = v!);
                              _calculate();
                            })),
                            GestureDetector(
                              onTap: _swapCurrencies,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 12),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppColors.accentGreen.withOpacity(0.2), AppColors.accentCyan.withOpacity(0.2)],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.swap_horiz_rounded, color: AppColors.accentGreen, size: 24),
                              ),
                            ),
                            Expanded(child: _buildCurrencySelector(_toUnit, (v) {
                              setState(() => _toUnit = v!);
                              _calculate();
                            })),
                          ],
                        ),
                        SizedBox(height: 50),
                        // Result
                        FadeTransition(
                          opacity: _resultAnim,
                          child: ScaleTransition(
                            scale: _resultAnim,
                          child: Column(
                            children: [
                              Text("Hasil Konversi", style: TextStyle(color: AppColors.previewText, fontSize: 14, letterSpacing: 1)),
                              SizedBox(height: 10),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      _flagEmoji[_toUnit] ?? '💱',
                                      style: TextStyle(fontSize: 32),
                                    ),
                                    SizedBox(width: 10),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: ShaderMask(
                                        shaderCallback: (bounds) => LinearGradient(
                                          colors: [AppColors.accentGreen, AppColors.accentCyan],
                                        ).createShader(bounds),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Text(
                                            _result,
                                            style: TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: 1.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      _toUnit,
                                      style: TextStyle(color: AppColors.previewText, fontSize: 18, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              // Exchange rate info
                              if (_rates.isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "1 $_fromUnit = ${(_rates[_toUnit]! / _rates[_fromUnit]!).toStringAsFixed(4)} $_toUnit",
                                    style: TextStyle(color: AppColors.previewText, fontSize: 13),
                                  ),
                                ),
                            ],
                          ),
                        ),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCurrencySelector(String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.numberText.withOpacity(0.05)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          dropdownColor: AppColors.surface,
          style: TextStyle(color: AppColors.numberText, fontSize: 16),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.previewText),
          items: _units.map((u) => DropdownMenuItem(
            value: u,
            child: Row(
              children: [
                Text(_flagEmoji[u] ?? '💱', style: TextStyle(fontSize: 18)),
                SizedBox(width: 8),
                Text(u),
              ],
            ),
          )).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
