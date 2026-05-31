import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../../../core/theme/app_colors.dart';

class DisplayWidget extends StatelessWidget {
  const DisplayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayValue = context.watch<CalculatorProvider>().displayValue;
    final previewValue = context.watch<CalculatorProvider>().previewValue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      alignment: Alignment.bottomRight,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Agar column tidak maksa tinggi maksimum jika tidak perlu
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.bottomRight,
              child: Text(
                displayValue,
                style: const TextStyle(
                  color: AppColors.numberText,
                  fontSize: 80,
                  fontWeight: FontWeight.w300,
                  height: 1.1, // Agar spasi vertikal rapat
                ),
                maxLines: 1,
              ),
            ),
          ),
          if (previewValue.isNotEmpty) ...[
            const SizedBox(height: 4),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomRight,
                child: Text(
                  previewValue,
                  style: const TextStyle(
                    color: AppColors.previewText,
                    fontSize: 40,
                    fontWeight: FontWeight.w400,
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
