import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../converters/screens/unit_converter_screen.dart';
import '../../converters/screens/currency_converter_screen.dart';
import '../../history/screens/history_screen.dart';
import '../../info_modal/widgets/info_modal_widget.dart';
import '../../settings/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';class NavbarTop extends StatelessWidget {
  NavbarTop({Key? key}) : super(key: key);

  void _showInfo(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Info',
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => InfoModalWidget(),
      transitionBuilder: (context, a1, a2, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(a1.value),
          child: Opacity(opacity: a1.value, child: child),
        );
      },
    );
  }

  void _navigateWithSlide(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 350),
      ),
    );
  }

  Widget _buildNavIcon(BuildContext context, IconData icon, String msg, double size, {Widget? navigateTo, bool isSelected = false, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {
          if (navigateTo != null) {
            _navigateWithSlide(context, navigateTo);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
          }
        },
        borderRadius: BorderRadius.circular(30),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Icon(
            icon,
            size: size,
            color: isSelected ? AppColors.equalsButton : AppColors.navbarIcon.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton(BuildContext context, Widget child, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.navCapsule,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.navbarIcon.withOpacity(0.1)),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double calculatedSize = screenWidth * 0.05;
    final iconSize = calculatedSize.clamp(18.0, 22.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side
          Row(
            children: [
              _buildCircleButton(
                context,
                Text(
                  '?',
                  style: TextStyle(
                    color: AppColors.navbarIcon,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                () => _showInfo(context),
              ),
              SizedBox(width: 8),
              _buildCircleButton(
                context,
                Icon(Icons.settings_outlined, color: AppColors.navbarIcon, size: 18),
                () => _navigateWithSlide(context, SettingsScreen()),
              ),
            ],
          ),
          // Right capsule
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.navCapsule,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.navbarIcon.withOpacity(0.08)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildNavIcon(context, Icons.access_time_rounded, 'Riwayat', iconSize, navigateTo: HistoryScreen()),
                    _buildNavIcon(context, Icons.currency_exchange_rounded, 'Valuta', iconSize, navigateTo: CurrencyConverterScreen()),
                    _buildNavIcon(context, Icons.straighten_rounded, 'Satuan', iconSize, navigateTo: UnitConverterScreen()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
