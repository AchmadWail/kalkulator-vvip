import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../../../core/theme/app_colors.dart';

class KeypadWidget extends StatelessWidget {
  const KeypadWidget({Key? key}) : super(key: key);

  Widget _buildButton(BuildContext context, Widget content, Color bgColor, Color textColor, double buttonSize, {String? actionString}) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      margin: const EdgeInsets.all(8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        onPressed: () {
          String action = actionString ?? '';
          if (action.isEmpty) {
            if (content is Text) {
              action = content.data ?? '';
            } else if (content is Icon) {
              if (content.icon == Icons.backspace_outlined) action = '⌫';
            }
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

  Widget _buildText(String text, Color color, {double fontSize = 28}) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w400, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double maxWidth = size.width > 420 ? 420 : size.width;
    
    // 4 columns + margins
    final sizeFromWidth = (maxWidth - 5 * 16) / 4;
    final sizeFromHeight = (size.height * 0.6 - 6 * 16) / 5;
    
    final buttonSize = sizeFromWidth < sizeFromHeight ? sizeFromWidth : sizeFromHeight;

    return Center(
      child: SizedBox(
        width: maxWidth,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(context, _buildText('AC', AppColors.operatorText, fontSize: 22), AppColors.operatorButton, AppColors.operatorText, buttonSize),
                _buildButton(context, _buildText('%', AppColors.operatorText, fontSize: 24), AppColors.operatorButton, AppColors.operatorText, buttonSize),
                _buildButton(context, const Icon(Icons.backspace_outlined, size: 24, color: AppColors.operatorText), AppColors.operatorButton, AppColors.operatorText, buttonSize),
                _buildButton(context, _buildText('÷', AppColors.operatorText, fontSize: 28), AppColors.operatorButton, AppColors.operatorText, buttonSize),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(context, _buildText('7', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('8', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('9', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('×', AppColors.operatorText, fontSize: 28), AppColors.operatorButton, AppColors.operatorText, buttonSize),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(context, _buildText('4', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('5', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('6', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('−', AppColors.operatorText, fontSize: 28), AppColors.operatorButton, AppColors.operatorText, buttonSize, actionString: '-'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(context, _buildText('1', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('2', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('3', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('+', AppColors.operatorText, fontSize: 28), AppColors.operatorButton, AppColors.operatorText, buttonSize),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildButton(context, Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('SCI', style: TextStyle(fontSize: 12, color: AppColors.previewText, fontWeight: FontWeight.w500)),
                    Text('MODE', style: TextStyle(fontSize: 12, color: AppColors.previewText, fontWeight: FontWeight.w500)),
                  ],
                ), AppColors.numberButton, AppColors.numberText, buttonSize, actionString: 'SCI'),
                _buildButton(context, _buildText('0', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('.', AppColors.numberText), AppColors.numberButton, AppColors.numberText, buttonSize),
                _buildButton(context, _buildText('=', AppColors.equalsText, fontSize: 32), AppColors.equalsButton, AppColors.equalsText, buttonSize),
              ],
            ),
            const SizedBox(height: 32), // Bottom padding
          ],
        ),
      ),
    );
  }
}
