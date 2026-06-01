import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class InfoModalWidget extends StatelessWidget {
  InfoModalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          padding: EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                AppColors.surface.withOpacity(0.95),
                AppColors.background.withOpacity(0.98),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: AppColors.accentPurple.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 30,
                offset: Offset(0, 15),
              ),
              BoxShadow(
                color: AppColors.accentPurple.withOpacity(0.1),
                blurRadius: 40,
                spreadRadius: -10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              // Animated gradient icon
              Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.accentPurple.withOpacity(0.15), AppColors.accentCyan.withOpacity(0.15)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [AppColors.accentPurple, AppColors.accentCyan],
                  ).createShader(bounds),
                  child: Icon(Icons.vpn_key_rounded, color: Colors.white, size: 36),
                ),
              ),
              SizedBox(height: 22),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [AppColors.numberText, AppColors.accentPurple],
                ).createShader(bounds),
                child: Text(
                  'Akses Rahasia',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Kalkulator ini memiliki fitur brankas tersembunyi. Gunakan kode di bawah:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.numberText.withOpacity(0.6),
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
              SizedBox(height: 24),
              _buildCodeItem(
                code: '1+1=',
                description: 'Buka Vault (Mode Gratis)',
                icon: Icons.visibility_outlined,
                color: AppColors.accentCyan,
              ),
              SizedBox(height: 10),
              _buildCodeItem(
                code: '99+99=',
                description: 'Buka Vault (VIP Penuh)',
                icon: Icons.diamond_rounded,
                color: AppColors.accentOrange,
              ),
              SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    backgroundColor: Colors.transparent,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: AppColors.primaryGradient),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        'Mengerti',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildCodeItem({
    required String code,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  code,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.numberText.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
