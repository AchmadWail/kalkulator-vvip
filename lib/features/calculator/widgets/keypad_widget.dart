import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../../../core/theme/app_colors.dart';

class KeypadWidget extends StatelessWidget {
  const KeypadWidget({Key? key}) : super(key: key);

  Widget _buildButton(BuildContext context, Widget content, Color bgColor, Color textColor, double buttonSize) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      margin: const EdgeInsets.all(6), // Jarak antar tombol dibuat tetap
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          // Extract text if content is Text, or pass specific identifiers
          String action = '';
          if (content is Text) {
            action = content.data ?? '';
          } else if (content is Icon) {
            if (content.icon == Icons.backspace_outlined) action = '⌫';
          }
          context.read<CalculatorProvider>().onButtonPress(action, context);
        },
        child: Align(
          alignment: Alignment.center,
          child: content,
        ),
      ),
    );
  }

  Widget _buildText(String text, Color color) {
    return Text(
      text,
      style: TextStyle(fontSize: 40, fontWeight: FontWeight.w400, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Maksimal lebar area tombol adalah 400px agar tidak renggang di layar lebar
    final double maxWidth = size.width > 400 ? 400 : size.width;
    
    // Hitung ukuran berdasarkan lebar (4 kolom + margin)
    final sizeFromWidth = (maxWidth - 5 * 12) / 4;
    // Hitung ukuran berdasarkan tinggi (asumsi keypad butuh ~55% layar max)
    final sizeFromHeight = (size.height * 0.55 - 6 * 12) / 5;
    
    // Ambil yang paling kecil agar tidak menabrak batas layar bawah (overflow)
    final buttonSize = sizeFromWidth < sizeFromHeight ? sizeFromWidth : sizeFromHeight;

    return Center(
      child: SizedBox(
        width: maxWidth,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(context, _buildText('AC', AppColors.operatorText), AppColors.operatorButton, AppColors.operatorText, buttonSize),
                _buildButton(context, _buildText('%', AppColors.operatorText), AppColors.operatorButton, AppColors.operatorText, buttonSize),
                _buildButton(context, const Icon(Icons.backspace_outlined, size: 32, color: AppColors.operatorText), AppColors.operatorButton, AppColors.operatorText, buttonSize),
                _buildButton(context, _buildText('÷', AppColors.operatorText), AppColors.operatorButton, AppColors.operatorText, buttonSize),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(context, _buildText('7', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('8', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('9', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('×', AppColors.operatorText), AppColors.operatorButton, AppColors.operatorText, buttonSize),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(context, _buildText('4', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('5', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('6', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('-', AppColors.operatorText), AppColors.operatorButton, AppColors.operatorText, buttonSize),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(context, _buildText('1', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('2', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('3', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('+', AppColors.operatorText), AppColors.operatorButton, AppColors.operatorText, buttonSize),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(context, _buildText('+/-', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('0', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText(',', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('=', AppColors.equalsText), AppColors.equalsButton, AppColors.equalsText, buttonSize),
              ],
            ),
            const SizedBox(height: 20), // Bottom padding
          ],
        ),
      ),
    );
  }
}
