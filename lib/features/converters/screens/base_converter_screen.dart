import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

class BaseConverterScreen extends StatefulWidget {
  BaseConverterScreen({Key? key}) : super(key: key);

  @override
  _BaseConverterScreenState createState() => _BaseConverterScreenState();
}

class _BaseConverterScreenState extends State<BaseConverterScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _inputBase = "Desimal";
  
  String _binaryResult = "0";
  String _octalResult = "0";
  String _decimalResult = "0";
  String _hexResult = "0";

  final Map<String, int> _baseMap = {
    "Biner": 2,
    "Oktal": 8,
    "Desimal": 10,
    "Heksadesimal": 16,
  };

  String _formatSpaced(String text, int groupSize, {String separator = ' '}) {
    if (text == 'Error' || text == '0' || text.isEmpty) return text;
    bool isNegative = text.startsWith('-');
    if (isNegative) text = text.substring(1);
    
    final rev = text.split('').reversed.join();
    final chunks = <String>[];
    for (int i = 0; i < rev.length; i += groupSize) {
      chunks.add(rev.substring(i, (i + groupSize > rev.length) ? rev.length : i + groupSize));
    }
    String result = chunks.join(separator).split('').reversed.join();
    return isNegative ? '-$result' : result;
  }

  void _calculate(String value) {
    value = value.replaceAll(' ', '').replaceAll('.', '').trim();
    if (value.isEmpty) {
      setState(() {
        _binaryResult = "0";
        _octalResult = "0";
        _decimalResult = "0";
        _hexResult = "0";
      });
      return;
    }

    try {
      int base = _baseMap[_inputBase]!;
      BigInt decimalValue = BigInt.parse(value, radix: base);
      setState(() {
        _binaryResult = _formatSpaced(decimalValue.toRadixString(2), 4);
        _octalResult = _formatSpaced(decimalValue.toRadixString(8), 3);
        _decimalResult = _formatSpaced(decimalValue.toString(), 3, separator: '.');
        _hexResult = _formatSpaced(decimalValue.toRadixString(16).toUpperCase(), 4);
      });
    } catch (e) {
      setState(() {
        _binaryResult = "Error";
        _octalResult = "Error";
        _decimalResult = "Error";
        _hexResult = "Error";
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Widget _buildResultCard(String title, String subtitle, String value, Color accentColor, IconData icon, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 350 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, anim, child) {
        return Opacity(
          opacity: anim,
          child: Transform.translate(
            offset: Offset(20 * (1 - anim), 0),
            child: child,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 14),
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: accentColor.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accentColor, size: 22),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: TextStyle(color: AppColors.numberText.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.w600)),
                      SizedBox(width: 6),
                      Text(subtitle, style: TextStyle(color: accentColor.withOpacity(0.5), fontSize: 10)),
                    ],
                  ),
                  SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      value,
                      style: TextStyle(
                        color: AppColors.numberText,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        fontFamily: 'monospace',
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.copy_rounded, color: AppColors.numberText.withOpacity(0.3), size: 20),
              onPressed: () {
                if (value != "Error" && value != "0") {
                  Clipboard.setData(ClipboardData(text: value));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$title disalin!'),
                      backgroundColor: accentColor,
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Konversi Basis"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.numberText),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -60, left: -80,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [AppColors.accentCyan.withOpacity(0.08), Colors.transparent]),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input base selector
                  Row(
                    children: [
                      Text("Basis Input:", style: TextStyle(color: AppColors.previewText, fontSize: 13, fontWeight: FontWeight.w600)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.numberText.withOpacity(0.05)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _inputBase,
                              dropdownColor: AppColors.surface,
                              style: TextStyle(color: AppColors.numberText, fontSize: 14),
                              items: _baseMap.keys.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                              onChanged: (v) {
                                setState(() {
                                  _inputBase = v!;
                                  _inputController.clear();
                                  _binaryResult = "0";
                                  _octalResult = "0";
                                  _decimalResult = "0";
                                  _hexResult = "0";
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.accentCyan.withOpacity(0.2)),
                    ),
                    child: TextField(
                      controller: _inputController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: AppColors.numberText, fontSize: 28, fontWeight: FontWeight.w600, fontFamily: 'monospace', height: 1.2),
                      onChanged: _calculate,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        hintText: "Masukkan angka...",
                        hintStyle: TextStyle(color: AppColors.numberText.withOpacity(0.2), fontSize: 20, height: 1.2),
                      ),
                    ),
                  ),
                  SizedBox(height: 28),
                  Text(
                    "HASIL KONVERSI",
                    style: TextStyle(color: AppColors.previewText, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5),
                  ),
                  SizedBox(height: 14),
                  Expanded(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        _buildResultCard("Biner", "(Basis 2)", _binaryResult, AppColors.accentCyan, Icons.memory_rounded, 0),
                        _buildResultCard("Oktal", "(Basis 8)", _octalResult, AppColors.accentOrange, Icons.filter_8_rounded, 1),
                        _buildResultCard("Desimal", "(Basis 10)", _decimalResult, AppColors.accentGreen, Icons.pin_rounded, 2),
                        _buildResultCard("Heksadesimal", "(Basis 16)", _hexResult, AppColors.accentPurple, Icons.hexagon_rounded, 3),
                      ],
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
