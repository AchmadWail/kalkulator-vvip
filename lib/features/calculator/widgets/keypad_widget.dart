import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import 'dart:math' as math;
import '../../../core/theme/app_colors.dart';

class KeypadWidget extends StatelessWidget {
  KeypadWidget({Key? key}) : super(key: key);

  Widget _buildButton(BuildContext context, Widget content, Color bgColor, Color textColor, double buttonSize, {String? actionString, List<Color>? gradient}) {
    return _AnimatedCalcButton(
      size: buttonSize,
      bgColor: bgColor,
      gradient: gradient,
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
      child: content,
    );
  }

  Widget _buildText(String text, Color color, BuildContext context, {double? fontSize}) {
    final size = MediaQuery.of(context).size;
    final double responsiveFontSize = fontSize ?? (size.width > 400 ? 30 : 26);
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
        final double availableWidth = math.max(0.0, maxWidth - 48);
        final double availableHeight = math.max(0.0, maxHeight - 80);
        final double maxButtonWidth = availableWidth / 4;
        final double maxButtonHeight = availableHeight / 5;
        final double buttonSize = math.min(maxButtonWidth, maxButtonHeight);

        return Center(
          child: SizedBox(
            width: maxWidth,
            child: Padding(
              padding: EdgeInsets.only(bottom: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildButton(context, _buildText('AC', AppColors.accentPink, context, fontSize: buttonSize * 0.3), AppColors.operatorButton, AppColors.operatorText, buttonSize),
                      _buildButton(context, _buildText('%', AppColors.operatorText, context, fontSize: buttonSize * 0.35), AppColors.operatorButton, AppColors.operatorText, buttonSize),
                      _buildButton(context, Icon(Icons.backspace_outlined, size: buttonSize * 0.3, color: AppColors.operatorText), AppColors.operatorButton, AppColors.operatorText, buttonSize),
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
                      _buildButton(
                        context,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [AppColors.accentCyan, AppColors.accentPurple],
                              ).createShader(bounds),
                              child: Text('SCI', style: TextStyle(fontSize: buttonSize * 0.18, color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 1)),
                            ),
                            Text('MODE', style: TextStyle(fontSize: buttonSize * 0.13, color: AppColors.previewText, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        AppColors.numberButton, AppColors.numberText, buttonSize, actionString: 'SCI',
                      ),
                      _buildButton(context, _buildText('0', AppColors.numberText, context, fontSize: buttonSize * 0.4), AppColors.numberButton, AppColors.numberText, buttonSize),
                      _buildButton(context, _buildText('.', AppColors.numberText, context, fontSize: buttonSize * 0.4), AppColors.numberButton, AppColors.numberText, buttonSize),
                      _buildButton(
                        context,
                        _buildText('=', Colors.white, context, fontSize: buttonSize * 0.4),
                        AppColors.equalsButton, AppColors.equalsText, buttonSize,
                        gradient: AppColors.dangerGradient,
                      ),
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

/// Animated button with scale-down press effect
class _AnimatedCalcButton extends StatefulWidget {
  final double size;
  final Color bgColor;
  final List<Color>? gradient;
  final VoidCallback onPressed;
  final Widget child;

  const _AnimatedCalcButton({
    required this.size,
    required this.bgColor,
    required this.onPressed,
    required this.child,
    this.gradient,
  });

  @override
  State<_AnimatedCalcButton> createState() => _AnimatedCalcButtonState();
}

class _AnimatedCalcButtonState extends State<_AnimatedCalcButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
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
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: widget.size,
        height: widget.size,
        margin: EdgeInsets.all(6),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTapDown: (_) => _controller.forward(),
            onTapUp: (_) {
              _controller.reverse();
              widget.onPressed();
            },
            onTapCancel: () => _controller.reverse(),
            borderRadius: BorderRadius.circular(widget.size / 2),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.gradient == null ? widget.bgColor : null,
                gradient: widget.gradient != null
                    ? LinearGradient(
                        colors: widget.gradient!,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: (widget.gradient != null ? widget.gradient!.first : widget.bgColor).withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 3),
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
