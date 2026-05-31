import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../converters/screens/unit_converter_screen.dart';
import '../../converters/screens/currency_converter_screen.dart';
import '../../history/screens/history_screen.dart';
import '../../info_modal/widgets/info_modal_widget.dart';
import '../../settings/screens/settings_screen.dart';

class NavbarTop extends StatelessWidget {
  NavbarTop({Key? key}) : super(key: key);

  void _showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => InfoModalWidget(),
    );
  }

  Widget _buildNavIcon(BuildContext context, IconData icon, String msg, double size, {Widget? navigateTo, bool isSelected = false}) {
    Widget iconWidget = Icon(
      icon,
      size: size,
      color: isSelected ? AppColors.equalsButton : AppColors.navbarIcon.withOpacity(0.5),
    );

    if (isSelected) {
      iconWidget = Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.equalsButton.withOpacity(0.3), width: 1),
        ),
        child: iconWidget,
      );
    }

    return InkWell(
      onTap: () {
        if (navigateTo != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => navigateTo));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        }
      },
      borderRadius: BorderRadius.circular(30),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: iconWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double calculatedSize = screenWidth * 0.05;
    final iconSize = calculatedSize.clamp(18.0, 24.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Question mark and Settings
          Row(
            children: [
              InkWell(
                onTap: () => _showInfo(context),
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.navCapsule,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '?',
                    style: TextStyle(
                      color: AppColors.navbarIcon,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SettingsScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.navCapsule,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.settings_outlined,
                    color: AppColors.navbarIcon,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          
          // Right side: Icons in a capsule
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.navCapsule,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNavIcon(context, Icons.access_time, 'Riwayat', iconSize, navigateTo: HistoryScreen()),
                _buildNavIcon(context, Icons.monetization_on_outlined, 'Mata Uang', iconSize, navigateTo: CurrencyConverterScreen(), isSelected: true),
                _buildNavIcon(context, Icons.straighten, 'Satuan', iconSize, navigateTo: UnitConverterScreen()),
              ],
            ),
          )
        ],
      ),
    );
  }
}

