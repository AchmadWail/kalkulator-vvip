import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class UnitScreen extends StatefulWidget {
  UnitScreen({Key? key}) : super(key: key);

  @override
  State<UnitScreen> createState() => _UnitScreenState();
}

class _UnitScreenState extends State<UnitScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Konverter Satuan', style: TextStyle(color: AppColors.numberText)),
        backgroundColor: AppColors.navCapsule,
        iconTheme: IconThemeData(color: AppColors.numberText),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.equalsButton,
          labelColor: AppColors.equalsButton,
          unselectedLabelColor: AppColors.numberText.withOpacity(0.60),
          tabs: [
            Tab(text: 'Panjang'),
            Tab(text: 'Berat'),
            Tab(text: 'Suhu'),
            Tab(text: 'Area'),
            Tab(text: 'Volume'),
            Tab(text: 'Waktu'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ConverterTab(type: 'Panjang', units: ['Meter (m)', 'Kilometer (km)', 'Sentimeter (cm)', 'Milimeter (mm)', 'Mil (mi)', 'Yard (yd)', 'Kaki (ft)', 'Inci (in)']),
          _ConverterTab(type: 'Berat', units: ['Kilogram (kg)', 'Gram (g)', 'Miligram (mg)', 'Pound (lb)', 'Ounce (oz)']),
          _ConverterTab(type: 'Suhu', units: ['Celcius (C)', 'Fahrenheit (F)', 'Kelvin (K)']),
          _ConverterTab(type: 'Area', units: ['Meter Persegi (m2)', 'Hektar (ha)', 'Acre', 'Kilometer Persegi (km2)']),
          _ConverterTab(type: 'Volume', units: ['Liter (L)', 'Mililiter (mL)', 'Galon (gal)', 'Meter Kubik (m3)']),
          _ConverterTab(type: 'Waktu', units: ['Detik', 'Menit', 'Jam', 'Hari']),
        ],
      ),
    );
  }
}

class _ConverterTab extends StatefulWidget {
  final String type;
  final List<String> units;
  const _ConverterTab({required this.type, required this.units});

  @override
  State<_ConverterTab> createState() => _ConverterTabState();
}

class _ConverterTabState extends State<_ConverterTab> {
  final TextEditingController _inputController = TextEditingController();
  late String _fromUnit;
  late String _toUnit;
  String _result = '0.0';

  @override
  void initState() {
    super.initState();
    _fromUnit = widget.units[0];
    _toUnit = widget.units.length > 1 ? widget.units[1] : widget.units[0];
  }

  void _calculate() {
    if (_inputController.text.isEmpty) {
      setState(() => _result = '0.0');
      return;
    }
    double value = double.tryParse(_inputController.text.replaceAll(',', '.')) ?? 0;
    
    double converted = value;
    if (_fromUnit != _toUnit) {
       converted = _convert(value, widget.type, _fromUnit, _toUnit);
    }

    setState(() {
      _result = converted.toStringAsFixed(4).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
      if (_result.endsWith('.')) _result = _result.substring(0, _result.length - 1);
    });
  }

  double _convert(double val, String type, String from, String to) {
    if (type == 'Suhu') {
      // Suhu butuh rumus spesifik
      double inCelcius = val;
      if (from.contains('F')) inCelcius = (val - 32) * 5 / 9;
      else if (from.contains('K')) inCelcius = val - 273.15;

      if (to.contains('F')) return (inCelcius * 9 / 5) + 32;
      if (to.contains('K')) return inCelcius + 273.15;
      return inCelcius;
    }

    // Untuk yang lain, konversi ke satuan dasar (base unit) lalu ke target
    double baseVal = val;

    // 1. Convert to Base
    if (type == 'Panjang') { // Base: Meter
      if (from.contains('km')) baseVal = val * 1000;
      else if (from.contains('cm')) baseVal = val / 100;
      else if (from.contains('mm')) baseVal = val / 1000;
      else if (from.contains('mi')) baseVal = val * 1609.34;
      else if (from.contains('yd')) baseVal = val * 0.9144;
      else if (from.contains('ft')) baseVal = val * 0.3048;
      else if (from.contains('in')) baseVal = val * 0.0254;
    } else if (type == 'Berat') { // Base: Gram
      if (from.contains('kg')) baseVal = val * 1000;
      else if (from.contains('mg')) baseVal = val / 1000;
      else if (from.contains('lb')) baseVal = val * 453.592;
      else if (from.contains('oz')) baseVal = val * 28.3495;
    } else if (type == 'Area') { // Base: Meter Persegi
      if (from.contains('ha')) baseVal = val * 10000;
      else if (from.contains('Acre')) baseVal = val * 4046.86;
      else if (from.contains('km2')) baseVal = val * 1000000;
    } else if (type == 'Volume') { // Base: Liter
      if (from.contains('mL')) baseVal = val / 1000;
      else if (from.contains('gal')) baseVal = val * 3.78541;
      else if (from.contains('m3')) baseVal = val * 1000;
    } else if (type == 'Waktu') { // Base: Detik
      if (from == 'Menit') baseVal = val * 60;
      else if (from == 'Jam') baseVal = val * 3600;
      else if (from == 'Hari') baseVal = val * 86400;
    }

    // 2. Convert from Base to Target
    if (type == 'Panjang') {
      if (to.contains('km')) return baseVal / 1000;
      if (to.contains('cm')) return baseVal * 100;
      if (to.contains('mm')) return baseVal * 1000;
      if (to.contains('mi')) return baseVal / 1609.34;
      if (to.contains('yd')) return baseVal / 0.9144;
      if (to.contains('ft')) return baseVal / 0.3048;
      if (to.contains('in')) return baseVal / 0.0254;
    } else if (type == 'Berat') {
      if (to.contains('kg')) return baseVal / 1000;
      if (to.contains('mg')) return baseVal * 1000;
      if (to.contains('lb')) return baseVal / 453.592;
      if (to.contains('oz')) return baseVal / 28.3495;
    } else if (type == 'Area') {
      if (to.contains('ha')) return baseVal / 10000;
      if (to.contains('Acre')) return baseVal / 4046.86;
      if (to.contains('km2')) return baseVal / 1000000;
    } else if (type == 'Volume') {
      if (to.contains('mL')) return baseVal * 1000;
      if (to.contains('gal')) return baseVal / 3.78541;
      if (to.contains('m3')) return baseVal / 1000;
    } else if (type == 'Waktu') {
      if (to == 'Menit') return baseVal / 60;
      if (to == 'Jam') return baseVal / 3600;
      if (to == 'Hari') return baseVal / 86400;
    }

    return baseVal;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              labelText: 'Masukkan Nilai',
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
              Icon(Icons.arrow_forward, color: AppColors.numberText.withOpacity(0.54)),
              _buildDropdown(false),
            ],
          ),
          SizedBox(height: 48),
          Text('Hasil:', style: TextStyle(color: AppColors.numberText.withOpacity(0.54), fontSize: 18)),
          SizedBox(height: 8),
          Text(
            '$_result $_toUnit',
            style: TextStyle(color: AppColors.equalsButton, fontSize: 40, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _buildDropdown(bool isFrom) {
    String currentValue = isFrom ? _fromUnit : _toUnit;
    return DropdownButton<String>(
      value: currentValue,
      dropdownColor: AppColors.navCapsule,
      style: TextStyle(color: AppColors.numberText, fontSize: 16),
      underline: Container(height: 1, color: AppColors.numberText.withOpacity(0.24)),
      items: widget.units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
      onChanged: (val) {
        if (val != null) {
          setState(() {
            if (isFrom) _fromUnit = val;
            else _toUnit = val;
            _calculate();
          });
        }
      },
    );
  }
}
