import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class UnitConverterScreen extends StatefulWidget {
  UnitConverterScreen({Key? key}) : super(key: key);

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController(text: "1");
  String _result = "";
  late AnimationController _animController;
  late Animation<double> _resultAnimation;

  final List<Map<String, dynamic>> _categories = [
    {"name": "Panjang", "icon": Icons.straighten_rounded, "color": Color(0xFF22D3EE)},
    {"name": "Berat", "icon": Icons.fitness_center_rounded, "color": Color(0xFFA78BFA)},
    {"name": "Suhu", "icon": Icons.thermostat_rounded, "color": Color(0xFFFF6B6B)},
    {"name": "Area", "icon": Icons.crop_square_rounded, "color": Color(0xFF34D399)},
    {"name": "Volume", "icon": Icons.water_drop_rounded, "color": Color(0xFF60A5FA)},
    {"name": "Waktu", "icon": Icons.timer_rounded, "color": Color(0xFFFBBF24)},
    {"name": "Kecepatan", "icon": Icons.speed_rounded, "color": Color(0xFFF472B6)},
    {"name": "Data", "icon": Icons.storage_rounded, "color": Color(0xFF818CF8)},
  ];
  String _selectedCategory = "Panjang";

  final Map<String, List<String>> _unitsByCategory = {
    "Panjang": ["Meter", "Centimeter", "Kilometer", "Milimeter", "Inci", "Kaki", "Yard", "Mil", "Mikrometer"],
    "Berat": ["Kilogram", "Gram", "Miligram", "Ton", "Pound", "Ounce"],
    "Suhu": ["Celsius", "Fahrenheit", "Kelvin", "Reamur"],
    "Area": ["Meter Persegi", "Hektar", "Kilometer Persegi", "Acre", "Are"],
    "Volume": ["Liter", "Mililiter", "Meter Kubik", "Galon US", "Galon UK", "Pint"],
    "Waktu": ["Detik", "Menit", "Jam", "Hari", "Minggu", "Bulan", "Tahun"],
    "Kecepatan": ["m/s", "km/h", "mph", "knot"],
    "Data": ["Byte", "Kilobyte", "Megabyte", "Gigabyte", "Terabyte"],
  };

  String _fromUnit = "Meter";
  String _toUnit = "Centimeter";

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _resultAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _inputController.addListener(_calculate);
    _calculate();
  }

  @override
  void dispose() {
    _animController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  void _onCategoryChanged(String cat) {
    setState(() {
      _selectedCategory = cat;
      _fromUnit = _unitsByCategory[cat]!.first;
      _toUnit = _unitsByCategory[cat]![1];
    });
    _calculate();
  }

  void _swapUnits() {
    setState(() {
      final temp = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = temp;
    });
    _calculate();
  }

  void _calculate() {
    String cleanText = _inputController.text.replaceAll('.', '').replaceAll(',', '.');
    double value = double.tryParse(cleanText) ?? 0.0;
    double outValue = 0.0;

    switch (_selectedCategory) {
      case "Panjang": outValue = _convertLength(value, _fromUnit, _toUnit); break;
      case "Berat": outValue = _convertWeight(value, _fromUnit, _toUnit); break;
      case "Suhu": outValue = _convertTemp(value, _fromUnit, _toUnit); break;
      case "Area": outValue = _convertArea(value, _fromUnit, _toUnit); break;
      case "Volume": outValue = _convertVolume(value, _fromUnit, _toUnit); break;
      case "Waktu": outValue = _convertTime(value, _fromUnit, _toUnit); break;
      case "Kecepatan": outValue = _convertSpeed(value, _fromUnit, _toUnit); break;
      case "Data": outValue = _convertData(value, _fromUnit, _toUnit); break;
    }

    setState(() {
      _result = _formatResult(outValue);
    });
    _animController.reset();
    _animController.forward();
  }

  String _formatResult(double v) {
    if (v == 0) return "0";
    String str = v.toStringAsFixed(6);
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

  double _convertLength(double v, String from, String to) {
    Map<String, double> toMeter = {"Meter": 1, "Centimeter": 0.01, "Kilometer": 1000, "Milimeter": 0.001, "Inci": 0.0254, "Kaki": 0.3048, "Yard": 0.9144, "Mil": 1609.34, "Mikrometer": 0.000001};
    return v * toMeter[from]! / toMeter[to]!;
  }

  double _convertWeight(double v, String from, String to) {
    Map<String, double> toKg = {"Kilogram": 1, "Gram": 0.001, "Miligram": 0.000001, "Ton": 1000, "Pound": 0.453592, "Ounce": 0.0283495};
    return v * toKg[from]! / toKg[to]!;
  }

  double _convertTemp(double v, String from, String to) {
    if (from == to) return v;
    double c = v;
    if (from == "Fahrenheit") c = (v - 32) * 5 / 9;
    else if (from == "Kelvin") c = v - 273.15;
    else if (from == "Reamur") c = v * 5 / 4;

    if (to == "Celsius") return c;
    else if (to == "Fahrenheit") return (c * 9 / 5) + 32;
    else if (to == "Kelvin") return c + 273.15;
    else return c * 4 / 5; // Reamur
  }

  double _convertArea(double v, String from, String to) {
    Map<String, double> toSqM = {"Meter Persegi": 1, "Hektar": 10000, "Kilometer Persegi": 1000000, "Acre": 4046.86, "Are": 100};
    return v * toSqM[from]! / toSqM[to]!;
  }

  double _convertVolume(double v, String from, String to) {
    Map<String, double> toLiter = {"Liter": 1, "Mililiter": 0.001, "Meter Kubik": 1000, "Galon US": 3.78541, "Galon UK": 4.54609, "Pint": 0.473176};
    return v * toLiter[from]! / toLiter[to]!;
  }

  double _convertTime(double v, String from, String to) {
    Map<String, double> toSec = {"Detik": 1, "Menit": 60, "Jam": 3600, "Hari": 86400, "Minggu": 604800, "Bulan": 2592000, "Tahun": 31536000};
    return v * toSec[from]! / toSec[to]!;
  }

  double _convertSpeed(double v, String from, String to) {
    Map<String, double> toMs = {"m/s": 1, "km/h": 0.277778, "mph": 0.44704, "knot": 0.514444};
    return v * toMs[from]! / toMs[to]!;
  }

  double _convertData(double v, String from, String to) {
    Map<String, double> toByte = {"Byte": 1, "Kilobyte": 1024, "Megabyte": 1048576, "Gigabyte": 1073741824, "Terabyte": 1099511627776};
    return v * toByte[from]! / toByte[to]!;
  }

  @override
  Widget build(BuildContext context) {
    final currentUnits = _unitsByCategory[_selectedCategory]!;
    final catInfo = _categories.firstWhere((c) => c['name'] == _selectedCategory);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Konverter Satuan"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.numberText),
      ),
      body: Stack(
        children: [
          // Background glow
          Positioned(
            top: -60, right: -80,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  (catInfo['color'] as Color).withOpacity(0.1),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Category chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: _categories.map((cat) {
                      final isSelected = cat['name'] == _selectedCategory;
                      return Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () => _onCategoryChanged(cat['name']),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 250),
                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? (cat['color'] as Color).withOpacity(0.15) : AppColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected ? (cat['color'] as Color).withOpacity(0.5) : AppColors.numberText.withOpacity(0.05),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(cat['icon'], size: 16, color: isSelected ? cat['color'] : AppColors.previewText),
                                SizedBox(width: 6),
                                Text(
                                  cat['name'],
                                  style: TextStyle(
                                    color: isSelected ? cat['color'] : AppColors.previewText,
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        // Input field
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: (catInfo['color'] as Color).withOpacity(0.2)),
                          ),
                          child: TextField(
                            controller: _inputController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            style: TextStyle(color: AppColors.numberText, fontSize: 28, fontWeight: FontWeight.w500, height: 1.2),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                              hintText: "Masukkan nilai",
                              hintStyle: TextStyle(color: AppColors.previewText.withOpacity(0.5), fontSize: 20, height: 1.2),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        // From/To selectors with swap button
                        Row(
                          children: [
                            Expanded(child: _buildUnitSelector(currentUnits, _fromUnit, (v) {
                              setState(() => _fromUnit = v!);
                              _calculate();
                            })),
                            GestureDetector(
                              onTap: _swapUnits,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 12),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: (catInfo['color'] as Color).withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.swap_horiz_rounded, color: catInfo['color'], size: 24),
                              ),
                            ),
                            Expanded(child: _buildUnitSelector(currentUnits, _toUnit, (v) {
                              setState(() => _toUnit = v!);
                              _calculate();
                            })),
                          ],
                        ),
                        SizedBox(height: 40),
                        // Result
                        FadeTransition(
                          opacity: _resultAnimation,
                          child: ScaleTransition(
                            scale: _resultAnimation,
                          child: Column(
                            children: [
                              Text("Hasil", style: TextStyle(color: AppColors.previewText, fontSize: 14, letterSpacing: 1)),
                              SizedBox(height: 8),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [catInfo['color'] as Color, AppColors.accentPurple],
                                    ).createShader(bounds),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        "$_result",
                                        style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: 1.5),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _toUnit,
                                style: TextStyle(color: AppColors.previewText, fontSize: 16, fontWeight: FontWeight.w500),
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
          ),
        ],
      ),
    );
  }

  Widget _buildUnitSelector(List<String> units, String value, ValueChanged<String?> onChanged) {
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
          style: TextStyle(color: AppColors.numberText, fontSize: 14),
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.previewText),
          items: units.map((u) => DropdownMenuItem(value: u, child: Text(u, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
