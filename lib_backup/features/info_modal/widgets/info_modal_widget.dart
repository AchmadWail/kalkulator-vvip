import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class InfoModalWidget extends StatelessWidget {
  InfoModalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                Color(0xFF2C2C2E).withOpacity(0.85),
                Color(0xFF1C1C1E).withOpacity(0.95),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: AppColors.equalsButton.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
              BoxShadow(
                color: AppColors.equalsButton.withOpacity(0.15),
                blurRadius: 30,
                spreadRadius: -5,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.equalsButton.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.vpn_key_rounded,
                  color: AppColors.equalsButton,
                  size: 36,
                ),
              ),
              SizedBox(height: 20),
              
              // Title
              Text(
                'Akses Rahasia',
                style: TextStyle(
                  color: AppColors.numberText,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 12),
              
              // Description
              Text(
                'Kalkulator ini memiliki fitur brankas (Vault) tersembunyi. Gunakan kode berikut pada kalkulator:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.numberText.withOpacity(0.7),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24),
              
              // Secret Code Items
              _buildCodeItem(
                code: '1+1=',
                description: 'Akses Vault (Lihat Saja)',
                icon: Icons.visibility_outlined,
                color: Colors.cyanAccent,
              ),
              SizedBox(height: 12),
              _buildCodeItem(
                code: '99+99=',
                description: 'Akses Vault (VIP Penuh)',
                icon: Icons.star_rounded,
                color: Colors.amber,
              ),
              
              SizedBox(height: 32),
              
              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.equalsButton,
                    foregroundColor: AppColors.background,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Mengerti',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.numberText.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  code,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.numberText.withOpacity(0.6),
                    fontSize: 12,
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
