import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({Key? key}) : super(key: key);

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final TextEditingController _inputController = TextEditingController(text: "1");
  String _result = "";
  
  final List<String> _categories = ["Panjang", "Berat", "Suhu", "Area", "Volume", "Waktu"];
  String _selectedCategory = "Panjang";

  final Map<String, List<String>> _unitsByCategory = {
    "Panjang": ["Meter", "Centimeter", "Kilometer", "Milimeter", "Inci", "Kaki", "Mil"],
    "Berat": ["Kilogram", "Gram", "Miligram", "Pound", "Ounce"],
    "Suhu": ["Celsius", "Fahrenheit", "Kelvin"],
    "Area": ["Meter Persegi", "Hektar", "Kilometer Persegi", "Acre"],
    "Volume": ["Liter", "Mililiter", "Meter Kubik", "Galon"],
    "Waktu": ["Detik", "Menit", "Jam", "Hari", "Minggu"],
  };
  
  String _fromUnit = "Meter";
  String _toUnit = "Centimeter";

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_calculate);
    _calculate();
  }
  
  void _onCategoryChanged(String cat) {
    setState(() {
      _selectedCategory = cat;
      _fromUnit = _unitsByCategory[cat]!.first;
      _toUnit = _unitsByCategory[cat]![1];
      _calculate();
    });
  }

  void _calculate() {
    double value = double.tryParse(_inputController.text) ?? 0.0;
    double outValue = 0.0;
    
    if (_selectedCategory == "Panjang") {
      outValue = _convertLength(value, _fromUnit, _toUnit);
    } else if (_selectedCategory == "Berat") {
      outValue = _convertWeight(value, _fromUnit, _toUnit);
    } else if (_selectedCategory == "Suhu") {
      outValue = _convertTemp(value, _fromUnit, _toUnit);
    } else if (_selectedCategory == "Area") {
      outValue = _convertArea(value, _fromUnit, _toUnit);
    } else if (_selectedCategory == "Volume") {
      outValue = _convertVolume(value, _fromUnit, _toUnit);
    } else if (_selectedCategory == "Waktu") {
      outValue = _convertTime(value, _fromUnit, _toUnit);
    }

    setState(() {
      _result = outValue.toStringAsFixed(4).replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
      if (_result.endsWith('.')) _result = _result.substring(0, _result.length - 1);
      if (_result.isEmpty) _result = "0";
    });
  }

  double _convertLength(double v, String from, String to) {
    Map<String, double> toMeter = {"Meter": 1, "Centimeter": 0.01, "Kilometer": 1000, "Milimeter": 0.001, "Inci": 0.0254, "Kaki": 0.3048, "Mil": 1609.34};
    double meters = v * toMeter[from]!;
    return meters / toMeter[to]!;
  }
  
  double _convertWeight(double v, String from, String to) {
    Map<String, double> toKg = {"Kilogram": 1, "Gram": 0.001, "Miligram": 0.000001, "Pound": 0.453592, "Ounce": 0.0283495};
    double kg = v * toKg[from]!;
    return kg / toKg[to]!;
  }

  double _convertTemp(double v, String from, String to) {
    if (from == to) return v;
    double c = v;
    if (from == "Fahrenheit") c = (v - 32) * 5 / 9;
    else if (from == "Kelvin") c = v - 273.15;
    
    if (to == "Celsius") return c;
    else if (to == "Fahrenheit") return (c * 9 / 5) + 32;
    else return c + 273.15;
  }

  double _convertArea(double v, String from, String to) {
    Map<String, double> toSqM = {"Meter Persegi": 1, "Hektar": 10000, "Kilometer Persegi": 1000000, "Acre": 4046.86};
    double sqM = v * toSqM[from]!;
    return sqM / toSqM[to]!;
  }

  double _convertVolume(double v, String from, String to) {
    Map<String, double> toLiter = {"Liter": 1, "Mililiter": 0.001, "Meter Kubik": 1000, "Galon": 3.78541};
    double l = v * toLiter[from]!;
    return l / toLiter[to]!;
  }

  double _convertTime(double v, String from, String to) {
    Map<String, double> toSec = {"Detik": 1, "Menit": 60, "Jam": 3600, "Hari": 86400, "Minggu": 604800};
    double sec = v * toSec[from]!;
    return sec / toSec[to]!;
  }

  @override
  Widget build(BuildContext context) {
    final currentUnits = _unitsByCategory[_selectedCategory]!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Konverter Satuan", style: TextStyle(color: Colors.white)), backgroundColor: Colors.black, iconTheme: const IconThemeData(color: Colors.white)),
      body: Column(
        children: [
          // Custom TabBar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(cat, style: TextStyle(color: isSelected ? Colors.black : Colors.white)),
                    selected: isSelected,
                    selectedColor: AppColors.equalsButton,
                    backgroundColor: AppColors.operatorButton,
                    onSelected: (_) => _onCategoryChanged(cat),
                  ),
                );
              }).toList(),
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  TextField(
                    controller: _inputController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 32),
                    decoration: const InputDecoration(
                      labelText: "Jumlah", 
                      labelStyle: TextStyle(color: AppColors.previewText),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.operatorButton)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.equalsButton)),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.numberButton,
                            borderRadius: BorderRadius.circular(16)
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _fromUnit,
                              dropdownColor: AppColors.numberButton,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              items: currentUnits.map((u) => DropdownMenuItem(value: u, child: Text(u, overflow: TextOverflow.ellipsis))).toList(),
                              onChanged: (v) {
                                setState(() => _fromUnit = v!);
                                _calculate();
                              },
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(Icons.swap_horiz, color: AppColors.navbarIcon, size: 32),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.numberButton,
                            borderRadius: BorderRadius.circular(16)
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _toUnit,
                              dropdownColor: AppColors.numberButton,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              items: currentUnits.map((u) => DropdownMenuItem(value: u, child: Text(u, overflow: TextOverflow.ellipsis))).toList(),
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
                  const SizedBox(height: 60),
                  const Text("Hasil Konversi:", style: TextStyle(color: AppColors.previewText, fontSize: 16)),
                  const SizedBox(height: 8),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "$_result $_toUnit", 
                      style: const TextStyle(color: AppColors.equalsButton, fontSize: 48, fontWeight: FontWeight.bold)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
