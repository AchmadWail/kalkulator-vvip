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
  
  String _binaryResult = "0";
  String _octalResult = "0";
  String _hexResult = "0";

  void _calculate(String value) {
    if (value.isEmpty) {
      setState(() {
        _binaryResult = "0";
        _octalResult = "0";
        _hexResult = "0";
      });
      return;
    }

    try {
      int decimalValue = int.parse(value);
      setState(() {
        _binaryResult = decimalValue.toRadixString(2);
        _octalResult = decimalValue.toRadixString(8);
        _hexResult = decimalValue.toRadixString(16).toUpperCase();
      });
    } catch (e) {
      setState(() {
        _binaryResult = "Error";
        _octalResult = "Error";
        _hexResult = "Error";
      });
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Widget _buildResultCard(String title, String value, Color accentColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.numberButton,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.numberText.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.numbers_rounded, color: accentColor, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.numberText.withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: AppColors.numberText,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy_rounded, color: AppColors.numberText.withOpacity(0.5)),
            onPressed: () {
              if (value != "Error" && value != "0") {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$title disalin ke clipboard'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Konversi Basis Logika", style: TextStyle(color: AppColors.numberText)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.numberText),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Masukkan Angka Desimal",
                style: TextStyle(
                  color: AppColors.numberText.withOpacity(0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.numberButton,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.equalsButton.withOpacity(0.3)),
                ),
                child: TextField(
                  controller: _inputController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(color: AppColors.numberText, fontSize: 32, fontWeight: FontWeight.bold),
                  onChanged: _calculate,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "0",
                    hintStyle: TextStyle(color: AppColors.numberText.withOpacity(0.3)),
                  ),
                ),
              ),
              SizedBox(height: 32),
              Text(
                "HASIL KONVERSI",
                style: TextStyle(
                  color: AppColors.numberText.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    _buildResultCard("Biner (Basis 2)", _binaryResult, Colors.cyanAccent),
                    _buildResultCard("Oktal (Basis 8)", _octalResult, Colors.orangeAccent),
                    _buildResultCard("Heksadesimal (Basis 16)", _hexResult, Colors.purpleAccent),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
