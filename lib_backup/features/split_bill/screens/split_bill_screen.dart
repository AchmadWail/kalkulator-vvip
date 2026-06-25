import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/theme/app_colors.dart';

class SplitBillScreen extends StatefulWidget {
  @override
  _SplitBillScreenState createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  final TextEditingController _billController = TextEditingController();

  double _tipPercentage = 10.0;
  double _taxPercentage = 11.0;
  int _peopleCount = 2;

  double get _totalBill => double.tryParse(_billController.text) ?? 0;
  double get _tipAmount => _totalBill * (_tipPercentage / 100);
  double get _taxAmount => _totalBill * (_taxPercentage / 100);
  double get _grandTotal => _totalBill + _tipAmount + _taxAmount;
  double get _perPerson => _peopleCount > 0 ? _grandTotal / _peopleCount : 0;

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},');
  }

  @override
  void dispose() {
    _billController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Split Bill VVIP",
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
            top: 0,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber.withOpacity(0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purpleAccent.withOpacity(0.1),
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
                          Icon(Icons.star, color: Colors.amber, size: 16),
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
                  // Bill Input
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: TextField(
                      controller: _billController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                      onChanged: (val) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: "0",
                        hintStyle: TextStyle(color: Colors.white24),
                        prefixText: "Rp ",
                        prefixStyle: TextStyle(fontSize: 24, color: Colors.amber),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Sliders
                  _buildSlider(
                    "Tip",
                    "$_tipPercentage%",
                    _tipPercentage,
                    30,
                    (val) => setState(() => _tipPercentage = val.roundToDouble()),
                  ),
                  SizedBox(height: 20),
                  _buildSlider(
                    "Pajak / Tax",
                    "$_taxPercentage%",
                    _taxPercentage,
                    25,
                    (val) => setState(() => _taxPercentage = val.roundToDouble()),
                  ),
                  SizedBox(height: 20),

                  // People Counter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Jumlah Orang",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      Row(
                        children: [
                          _buildCounterBtn(Icons.remove, () {
                            if (_peopleCount > 1) setState(() => _peopleCount--);
                          }),
                          SizedBox(width: 16),
                          Text(
                            "$_peopleCount",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(width: 16),
                          _buildCounterBtn(Icons.add, () {
                            setState(() => _peopleCount++);
                          }),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 40),

                  // Result Card
                  _buildResultCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, String valueStr, double value, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: Colors.white70, fontSize: 16)),
            Text(valueStr, style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.amber,
            inactiveTrackColor: Colors.white10,
            thumbColor: Colors.amber,
            overlayColor: Colors.amber.withOpacity(0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: 0,
            max: max,
            divisions: max.toInt(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildCounterBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
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
            color: Colors.amber.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: -5,
            offset: Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Colors.amber.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          _buildResultRow("Total Tip", _tipAmount),
          SizedBox(height: 12),
          _buildResultRow("Total Pajak", _taxAmount),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Colors.white24),
          ),
          _buildResultRow("Grand Total", _grandTotal, isBold: true),
          SizedBox(height: 24),
          Text(
            "Per Orang",
            style: TextStyle(color: Colors.amber.withOpacity(0.8), fontSize: 14, letterSpacing: 1),
          ),
          SizedBox(height: 8),
          Text(
            "Rp ${_formatCurrency(_perPerson)}",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              shadows: [Shadow(color: Colors.amber.withOpacity(0.5), blurRadius: 20)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, double amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? Colors.white : Colors.white60,
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          "Rp ${_formatCurrency(amount)}",
          style: TextStyle(
            color: isBold ? Colors.amber : Colors.white,
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
