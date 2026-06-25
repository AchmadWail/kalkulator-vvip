import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../../../core/theme/app_colors.dart';

class DisplayWidget extends StatelessWidget {
  DisplayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayValue = context.watch<CalculatorProvider>().displayValue;
    final previewValue = context.watch<CalculatorProvider>().previewValue;
    final isSci = context.watch<CalculatorProvider>().isScientificMode;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 28, vertical: 10),
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // SCI mode indicator
          if (isSci)
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.accentCyan.withOpacity(0.2), AppColors.accentPurple.withOpacity(0.2)],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.accentCyan.withOpacity(0.3)),
              ),
              child: Text(
                'SCI MODE',
                style: TextStyle(
                  color: AppColors.accentCyan,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
          if (previewValue.isNotEmpty) ...[
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomRight,
                child: AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 200),
                  style: TextStyle(
                    color: AppColors.previewText,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                  ),
                  child: Text(
                    displayValue,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            SizedBox(height: 6),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomRight,
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [AppColors.numberText, AppColors.accentPurple.withOpacity(0.8)],
                  ).createShader(bounds),
                  child: Text(
                    previewValue,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontWeight: FontWeight.w200,
                      height: 1.1,
                      letterSpacing: -1,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ] else ...[
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomRight,
                child: Text(
                  displayValue,
                  style: TextStyle(
                    color: AppColors.numberText,
                    fontSize: 64,
                    fontWeight: FontWeight.w200,
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
