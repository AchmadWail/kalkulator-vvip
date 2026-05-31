import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import 'dart:math' as math;
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
          shape: const CircleBorder(),
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

  Widget _buildText(String text, Color color, BuildContext context, {double? fontSize}) {
    // Dynamic font size based on screen width
    final size = MediaQuery.of(context).size;
    final double responsiveFontSize = fontSize ?? (size.width > 400 ? 32 : 28);
    return Text(
      text,
      style: TextStyle(fontSize: responsiveFontSize, fontWeight: FontWeight.w400, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth > 420 ? 420 : constraints.maxWidth;
        final double maxHeight = constraints.maxHeight;

        // Calculate available width and height after removing margins.
        // We have 4 columns, meaning 4 buttons horizontally, each with margin: EdgeInsets.all(8), so 16px horizontal margin per button. Total = 64.
        // We have 5 rows, meaning 5 buttons vertically, each with 16px vertical margin. Total = 80.
        // Plus bottom padding of 16. Total vertical space used = 96.
        final double availableWidth = math.max(0.0, maxWidth - 64);
        final double availableHeight = math.max(0.0, maxHeight - 96);

        final double maxButtonWidth = availableWidth / 4;
        final double maxButtonHeight = availableHeight / 5;

        // Make button perfectly square/circular by taking the minimum of width and height
        final double buttonSize = maxButtonWidth < maxButtonHeight ? maxButtonWidth : maxButtonHeight;

        return Center(
          child: SizedBox(
            width: maxWidth,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(context, _buildText('AC', AppColors.operatorText, context, fontSize: buttonSize * 0.3), AppColors.operatorButton, AppColors.operatorText, buttonSize),
                      _buildButton(context, _buildText('%', AppColors.operatorText, context, fontSize: buttonSize * 0.35), AppColors.operatorButton, AppColors.operatorText, buttonSize),
                      _buildButton(context, Icon(Icons.backspace_outlined, size: buttonSize * 0.35, color: AppColors.operatorText), AppColors.operatorButton, AppColors.operatorText, buttonSize),
                      _buildButton(context, _buildText('÷', AppColors.operatorText, context, fontSize: buttonSize * 0.4), AppColors.operatorButton, AppColors.operatorText, buttonSize),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(context, _buildText('7', AppColors.numberText, context, fontSize: buttonSize * 0.4), AppColors.numberButton, AppColors.numberText, buttonSize),
                      _buildButton(context, _buildText('8', AppColors.numberText, context, fontSize: buttonSize * 0.4), AppColors.numberButton, AppColors.numberText, buttonSize),
                      _buildButton(context, _buildText('9', AppColors.numberText, context, fontSize: buttonSize * 0.4), AppColors.numberButton, AppColors.numberText, buttonSize),
                      _buildButton(context, _buildText('×', AppColors.operatorText, context, fontSize: buttonSize * 0.4), AppColors.operatorButton, AppColors.operatorText, buttonSize),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(context, _buildText('4', AppColors.numberText, context, fontSize: buttonSize * 0.4), AppColors.numberButton, AppColors.numberText, buttonSize),
                      _buildButton(context, _buildText('5', AppColors.numberText, context, fontSize: buttonSize * 0.4), AppColors.numberButton, AppColors.numberText, buttonSize),
                      _buildButton(context, _buildText('6', AppColors.numberText, context, fontSize: buttonSize * 0.4), AppColors.numberButton, AppColors.numberText, buttonSize),
                      _buildButton(context, _buildText('−', AppColors.operatorText, context, fontSize: buttonSize * 0.4), AppColors.operatorButton, AppColors.operatorText, buttonSize, actionString: '-'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(context, _buildText('1', AppColors.numberText, context, fontSize: buttonSize * 0.4), AppColors.numberButton, AppColors.numberText, buttonSize),
                      _buildButton(context, _buildText('2', AppColors.numberText, context, fontSize: buttonSize * 0.4), AppColors.numberButton, AppColors.numberText, buttonSize),
                      _buildButton(context, _buildText('3', AppColors.numberText, context, fontSize: buttonSize * 0.4), AppColors.numberButton, AppColors.numberText, buttonSize),
                      _buildButton(context, _buildText('+', AppColors.operatorText, context, fontSize: buttonSize * 0.4), AppColors.operatorButton, AppColors.operatorText, buttonSize),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(context, Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('SCI', style: TextStyle(fontSize: buttonSize * 0.18, color: AppColors.previewText, fontWeight: FontWeight.w500)),
                          Text('MODE', style: TextStyle(fontSize: buttonSize * 0.18, color: AppColors.previewText, fontWeight: FontWeight.w500)),
                        ],
                      ), AppColors.numberButton, AppColors.numberText, buttonSize, actionString: 'SCI'),
                      _buildButton(context, _buildText('0', AppColors.numberText, context, fontSize: buttonSize * 0.4), AppColors.numberButton, AppColors.numberText, buttonSize),
                      _buildButton(context, _buildText('.', AppColors.numberText, context, fontSize: buttonSize * 0.4), AppColors.numberButton, AppColors.numberText, buttonSize),
                      _buildButton(context, _buildText('=', AppColors.equalsText, context, fontSize: buttonSize * 0.45), AppColors.equalsButton, AppColors.equalsText, buttonSize),
                    ],
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
