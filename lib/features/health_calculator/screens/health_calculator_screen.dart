import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/theme/app_colors.dart';

class HealthCalculatorScreen extends StatefulWidget {
  @override
  _HealthCalculatorScreenState createState() => _HealthCalculatorScreenState();
}

class _HealthCalculatorScreenState extends State<HealthCalculatorScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  double _bmi = 0;
  String _bmiCategory = "";
  Color _bmiColor = Colors.white;

  void _calculateBMI() {
    double weight = double.tryParse(_weightController.text) ?? 0;
    double heightCm = double.tryParse(_heightController.text) ?? 0;

    if (weight > 0 && heightCm > 0) {
      double heightM = heightCm / 100;
      setState(() {
        _bmi = weight / (heightM * heightM);
        if (_bmi < 18.5) {
          _bmiCategory = "Kekurangan Berat Badan";
          _bmiColor = Colors.blue;
        } else if (_bmi >= 18.5 && _bmi < 24.9) {
          _bmiCategory = "Normal (Ideal)";
          _bmiColor = Colors.green;
        } else if (_bmi >= 25 && _bmi < 29.9) {
          _bmiCategory = "Kelebihan Berat Badan";
          _bmiColor = Colors.orange;
        } else {
          _bmiCategory = "Obesitas";
          _bmiColor = Colors.red;
        }
      });
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Health VVIP",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber.withOpacity(0.15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent.withOpacity(0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.amber.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.diamond, color: Colors.amber, size: 16),
                          SizedBox(width: 8),
                          Text(
                            "Eksklusif VVIP Member",
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Kalkulator BMI",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Hitung Indeks Massa Tubuh Anda secara akurat.",
                    style: TextStyle(color: Colors.white60, fontSize: 14),
                  ),
                  SizedBox(height: 30),
                  _buildInputField(
                    "Berat Badan (kg)",
                    Icons.monitor_weight_outlined,
                    _weightController,
                  ),
                  SizedBox(height: 16),
                  _buildInputField(
                    "Tinggi Badan (cm)",
                    Icons.height_outlined,
                    _heightController,
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _calculateBMI,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.equalsButton,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                        shadowColor: AppColors.equalsButton.withOpacity(0.4),
                      ),
                      child: Text(
                        "HITUNG SEKARANG",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.numberText,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  if (_bmi > 0) _buildResultCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, IconData icon, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white54),
          prefixIcon: Icon(icon, color: Colors.white54),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2C2C2E).withOpacity(0.9),
                    Color(0xFF1C1C1E).withOpacity(0.95),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _bmiColor.withOpacity(0.2),
                    blurRadius: 30 * value,
                    spreadRadius: -5,
                    offset: Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: _bmiColor.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Skor BMI Anda",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _bmi.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: _bmiColor,
                      shadows: [
                        Shadow(color: _bmiColor.withOpacity(0.5), blurRadius: 20),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _bmiColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _bmiCategory.toUpperCase(),
                      style: TextStyle(
                        color: _bmiColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
