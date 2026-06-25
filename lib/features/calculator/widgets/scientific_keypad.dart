import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import 'dart:math' as math;
import '../../../core/theme/app_colors.dart';

class ScientificKeypad extends StatelessWidget {
  ScientificKeypad({Key? key}) : super(key: key);

  Widget _buildSciButton(BuildContext context, String label, double width, double height, {String? action, Color? textColor, Color? bgColor, List<Color>? gradient}) {
    final btnAction = action ?? label;
    final color = textColor ?? AppColors.scientificText;
    final bg = bgColor ?? AppColors.scientificButton;
    final minDim = math.min(width, height);

    return _AnimatedSciButton(
      width: width,
      height: height,
      bgColor: bg,
      gradient: gradient,
      onPressed: () {
        context.read<CalculatorProvider>().onButtonPress(btnAction, context);
      },
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: EdgeInsets.all(4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: minDim * 0.28,
              fontWeight: FontWeight.w500,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double maxHeight = constraints.maxHeight;
        final int cols = 5;
        final int rows = 7;
        final double availableWidth = math.max(0.0, maxWidth - (cols * 10));
        final double availableHeight = math.max(0.0, maxHeight - (rows * 10) - 16);
        final double btnWidth = availableWidth / cols;
        final double btnHeight = availableHeight / rows;

        return Center(
          child: SizedBox(
            width: maxWidth,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Row 1: Trig functions
                  _buildRow(context, [
                    _buildSciButton(context, 'sin', btnWidth, btnHeight, action: 'sin'),
                    _buildSciButton(context, 'cos', btnWidth, btnHeight, action: 'cos'),
                    _buildSciButton(context, 'tan', btnWidth, btnHeight, action: 'tan'),
                    _buildSciButton(context, '(', btnWidth, btnHeight, textColor: AppColors.accentOrange),
                    _buildSciButton(context, ')', btnWidth, btnHeight, textColor: AppColors.accentOrange),
                  ]),
                  // Row 2: Log, sqrt, power
                  _buildRow(context, [
                    _buildSciButton(context, 'log', btnWidth, btnHeight, action: 'log'),
                    _buildSciButton(context, 'ln', btnWidth, btnHeight, action: 'ln'),
                    _buildSciButton(context, '√', btnWidth, btnHeight, action: '√'),
                    _buildSciButton(context, 'x²', btnWidth, btnHeight, action: 'x²', textColor: AppColors.accentPink),
                    _buildSciButton(context, 'xʸ', btnWidth, btnHeight, action: 'xʸ', textColor: AppColors.accentPink),
                  ]),
                  // Row 3: Constants & extras
                  _buildRow(context, [
                    _buildSciButton(context, 'π', btnWidth, btnHeight, action: 'π', textColor: AppColors.accentGreen),
                    _buildSciButton(context, 'e', btnWidth, btnHeight, action: 'e', textColor: AppColors.accentGreen),
                    _buildSciButton(context, 'x!', btnWidth, btnHeight, action: 'x!', textColor: AppColors.accentPink),
                    _buildSciButton(context, '|x|', btnWidth, btnHeight, action: '|x|'),
                    _buildSciButton(context, '⌫', btnWidth, btnHeight, action: '⌫', textColor: AppColors.accentPink),
                  ]),
                  // Row 4: AC, %, numbers
                  _buildRow(context, [
                    _buildSciButton(context, 'AC', btnWidth, btnHeight, action: 'AC', textColor: AppColors.accentPink, bgColor: AppColors.operatorButton),
                    _buildSciButton(context, '%', btnWidth, btnHeight, textColor: AppColors.operatorText, bgColor: AppColors.operatorButton),
                    _buildSciButton(context, '7', btnWidth, btnHeight, textColor: AppColors.numberText, bgColor: AppColors.numberButton),
                    _buildSciButton(context, '8', btnWidth, btnHeight, textColor: AppColors.numberText, bgColor: AppColors.numberButton),
                    _buildSciButton(context, '9', btnWidth, btnHeight, textColor: AppColors.numberText, bgColor: AppColors.numberButton),
                  ]),
                  // Row 5
                  _buildRow(context, [
                    _buildSciButton(context, '×', btnWidth, btnHeight, action: '×', textColor: AppColors.operatorText, bgColor: AppColors.operatorButton),
                    _buildSciButton(context, '÷', btnWidth, btnHeight, action: '÷', textColor: AppColors.operatorText, bgColor: AppColors.operatorButton),
                    _buildSciButton(context, '4', btnWidth, btnHeight, textColor: AppColors.numberText, bgColor: AppColors.numberButton),
                    _buildSciButton(context, '5', btnWidth, btnHeight, textColor: AppColors.numberText, bgColor: AppColors.numberButton),
                    _buildSciButton(context, '6', btnWidth, btnHeight, textColor: AppColors.numberText, bgColor: AppColors.numberButton),
                  ]),
                  // Row 6
                  _buildRow(context, [
                    _buildSciButton(context, '+', btnWidth, btnHeight, textColor: AppColors.operatorText, bgColor: AppColors.operatorButton),
                    _buildSciButton(context, '−', btnWidth, btnHeight, action: '-', textColor: AppColors.operatorText, bgColor: AppColors.operatorButton),
                    _buildSciButton(context, '1', btnWidth, btnHeight, textColor: AppColors.numberText, bgColor: AppColors.numberButton),
                    _buildSciButton(context, '2', btnWidth, btnHeight, textColor: AppColors.numberText, bgColor: AppColors.numberButton),
                    _buildSciButton(context, '3', btnWidth, btnHeight, textColor: AppColors.numberText, bgColor: AppColors.numberButton),
                  ]),
                  // Row 7
                  _buildRow(context, [
                    _buildSciButton(context, 'STD', btnWidth, btnHeight, action: 'SCI', textColor: AppColors.accentCyan, bgColor: AppColors.scientificButton),
                    _buildSciButton(context, ',', btnWidth, btnHeight, textColor: AppColors.numberText, bgColor: AppColors.numberButton),
                    _buildSciButton(context, '0', btnWidth, btnHeight, textColor: AppColors.numberText, bgColor: AppColors.numberButton),
                    _buildSciButton(context, '00', btnWidth, btnHeight, textColor: AppColors.numberText, bgColor: AppColors.numberButton),
                    _buildSciButton(context, '=', btnWidth, btnHeight, textColor: Colors.white, gradient: AppColors.dangerGradient),
                  ]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(BuildContext context, List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

/// Animated scientific button with scale press effect
class _AnimatedSciButton extends StatefulWidget {
  final double width;
  final double height;
  final Color bgColor;
  final List<Color>? gradient;
  final VoidCallback onPressed;
  final Widget child;

  const _AnimatedSciButton({
    required this.width,
    required this.height,
    required this.bgColor,
    required this.onPressed,
    required this.child,
    this.gradient,
  });

  @override
  State<_AnimatedSciButton> createState() => _AnimatedSciButtonState();
}

class _AnimatedSciButtonState extends State<_AnimatedSciButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double minDim = math.min(widget.width, widget.height);
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: widget.width,
        height: widget.height,
        margin: EdgeInsets.all(4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTapDown: (_) => _controller.forward(),
            onTapUp: (_) {
              _controller.reverse();
              widget.onPressed();
            },
            onTapCancel: () => _controller.reverse(),
            borderRadius: BorderRadius.circular(minDim * 0.25),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(minDim * 0.25),
                color: widget.gradient == null ? widget.bgColor : null,
                gradient: widget.gradient != null
                    ? LinearGradient(colors: widget.gradient!, begin: Alignment.topLeft, end: Alignment.bottomRight)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: (widget.gradient != null ? widget.gradient!.first : widget.bgColor).withOpacity(0.15),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}
