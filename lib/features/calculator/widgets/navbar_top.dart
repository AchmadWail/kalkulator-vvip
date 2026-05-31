import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../converters/screens/unit_converter_screen.dart';
import '../../converters/screens/currency_converter_screen.dart';

class NavbarTop extends StatelessWidget {
  const NavbarTop({Key? key}) : super(key: key);

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _buildNavIcon(BuildContext context, String assetPath, String msg, double size, {Widget? navigateTo}) {
    return InkWell(
      onTap: () {
        if (navigateTo != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => navigateTo));
        } else {
          _showSnack(context, msg);
        }
      },
      borderRadius: BorderRadius.circular(size),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0), 
        child: Image.asset(
          assetPath, 
          width: size, 
          height: size, 
          color: Colors.white60,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double calculatedSize = screenWidth * 0.05; 
    final iconSize = calculatedSize.clamp(14.0, 22.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Question mark in a capsule
          Container(
            decoration: BoxDecoration(
              color: AppColors.navCapsule,
              borderRadius: BorderRadius.circular(30),
            ),
            child: _buildNavIcon(context, 'assets/icons/icon_question.png', 'Info: Fitur tersembunyi tersedia.', iconSize),
          ),
          
          // Right side: Clock, $, Ruler in a single capsule
          Container(
            decoration: BoxDecoration(
              color: AppColors.navCapsule,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNavIcon(context, 'assets/icons/icon_clock.png', 'Riwayat Kalkulator', iconSize),
                _buildNavIcon(context, 'assets/icons/icon_dollar.png', 'Konverter Mata Uang', iconSize, navigateTo: const CurrencyConverterScreen()),
                _buildNavIcon(context, 'assets/icons/icon_ruler.png', 'Konverter Satuan', iconSize, navigateTo: const UnitConverterScreen()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
