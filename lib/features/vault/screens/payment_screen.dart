import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import 'vault_screen.dart';
import 'dart:ui';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({Key? key}) : super(key: key);

  // Link DANA langsung
  static String _danaPaymentLink =
      "https://link.dana.id/minta?full_url=https://qr.dana.id/v1/281012092026051530332753";

  final int amount = 15000;

  void _payAndUnlock(BuildContext context) async {
    final Uri danaUrl = Uri.parse(_danaPaymentLink);

    bool launched = false;
    try {
      // Langsung buka link DANA - akan otomatis membuka aplikasi DANA
      launched = await launchUrl(
        danaUrl,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('Launch URL error: $e');
    }

    if (!launched) {
      // Coba dengan mode platform default
      try {
        launched = await launchUrl(
          danaUrl,
          mode: LaunchMode.platformDefault,
        );
      } catch (e) {
        debugPrint('Fallback launch error: $e');
      }
    }

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tidak dapat membuka DANA secara otomatis. Pastikan DANA terinstal.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }

    // Beri akses VIP setelah tombol ditekan
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_vip_unlocked', true);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pembayaran berhasil! Akses VVIP telah terbuka.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Premium Access"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Decor (Glow effects)
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber.withOpacity(0.15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          // Content
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPremiumCard(context),
                  SizedBox(height: 40),
                  _buildDanaButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Color(0xFF2C2C2E).withOpacity(0.9),
            Color(0xFF1C1C1E).withOpacity(0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.amber.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: -5,
            offset: Offset(0, -5),
          ),
        ],
        border: Border.all(
          color: Colors.amber.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.shield, color: Colors.amber, size: 36),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber.withOpacity(0.5)),
                ),
                child: Text(
                  "VVIP STATUS",
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Text(
            "Akses Vault VIP",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Buka fitur tersembunyi tanpa batas. Amankan foto, video, dokumen, dan audio pribadi Anda.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Rp",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              SizedBox(width: 4),
              Text(
                "15.000",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              SizedBox(width: 8),
              Text(
                "/ selamanya",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDanaButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _payAndUnlock(context),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [Color(0xFF118EEA), Color(0xFF0F75C1)], // Warna khas DANA
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF118EEA).withOpacity(0.4),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment, color: AppColors.numberText, size: 24),
            SizedBox(width: 12),
            Text(
              "Bayar Sekarang dengan DANA",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.numberText,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
