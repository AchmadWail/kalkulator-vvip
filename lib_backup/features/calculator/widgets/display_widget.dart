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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Agar column tidak maksa tinggi maksimum jika tidak perlu
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (previewValue.isNotEmpty) ...[
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomRight,
                child: Text(
                  displayValue,
                  style: TextStyle(
                    color: AppColors.previewText,
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            SizedBox(height: 8),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomRight,
                child: Text(
                  previewValue,
                  style: TextStyle(
                    color: AppColors.numberText,
                    fontSize: 80,
                    fontWeight: FontWeight.w300,
                    height: 1.1,
                  ),
                  maxLines: 1,
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
                    fontSize: 80,
                    fontWeight: FontWeight.w300,
                    height: 1.1,
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
