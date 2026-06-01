import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../widgets/display_widget.dart';
import '../widgets/keypad_widget.dart';
import '../widgets/scientific_keypad.dart';
import '../widgets/navbar_top.dart';
import '../../../core/theme/app_colors.dart';

class CalculatorScreen extends StatefulWidget {
  CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> with TickerProviderStateMixin {
  late AnimationController _bgAnimController;
  late Animation<double> _bgAnimation;

  @override
  void initState() {
    super.initState();
    _bgAnimController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    )..repeat(reverse: true);
    _bgAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bgAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bgAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalculatorProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // Animated background glow
            AnimatedBuilder(
              animation: _bgAnimation,
              builder: (context, child) {
                final v = _bgAnimation.value;
                return Stack(
                  children: [
                    Positioned(
                      top: -80 + (v * 30),
                      right: -60 + (v * 20),
                      child: _GlowOrb(
                        size: 200,
                        color: AppColors.accentPurple,
                        opacity: 0.12,
                      ),
                    ),
                    Positioned(
                      bottom: -40 - (v * 20),
                      left: -30 + (v * 15),
                      child: _GlowOrb(
                        size: 160,
                        color: AppColors.accentCyan,
                        opacity: 0.08,
                      ),
                    ),
                  ],
                );
              },
            ),
            // Main content
            SafeArea(
              child: Consumer<CalculatorProvider>(
                builder: (context, provider, _) {
                  return Column(
                    children: [
                      NavbarTop(),
                      Expanded(
                        flex: 3,
                        child: DisplayWidget(),
                      ),
                      Expanded(
                        flex: provider.isScientificMode ? 8 : 6,
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) {
                            final curve = CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            );
                            return FadeTransition(
                              opacity: curve,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(0, 0.05),
                                  end: Offset.zero,
                                ).animate(curve),
                                child: child,
                              ),
                            );
                          },
                          child: provider.isScientificMode
                              ? ScientificKeypad(key: ValueKey('sci'))
                              : KeypadWidget(key: ValueKey('std')),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A simple radial glow orb for background decoration
class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;
  const _GlowOrb({required this.size, required this.color, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(opacity),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
