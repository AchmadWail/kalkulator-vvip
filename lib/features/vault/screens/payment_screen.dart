import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import 'vault_screen.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  final String danaNumber = "081359070793";

  Future<void> _processPayment(BuildContext context) async {
    // Gunakan skema web URL DANA app-link yang akan otomatis me-redirect ke aplikasi DANA
    // Format link.dana.id sering digunakan untuk direct transfer
    final Uri danaUri = Uri.parse('https://link.dana.id/mme?phone=$danaNumber&amount=15000');
    
    try {
      if (await canLaunchUrl(danaUri)) {
        await launchUrl(danaUri, mode: LaunchMode.externalApplication); // Force external
      } else {
        // Fallback ke skema dana:// murni jika app-link browser diblokir
        await launchUrl(Uri.parse('dana://pay?amount=15000&note=VVIP_081359070793'), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('DANA app tidak ditemukan: $e');
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Membuka DANA... Silakan transfer Rp 15.000 ke $danaNumber'),
          backgroundColor: Colors.blueAccent,
        )
      );
    }
  }

  Future<void> _unlockVip(BuildContext context) async {
    // Fitur rahasia admin: Bypass tekan lama
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_vip_unlocked', true);
    
    if (context.mounted) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bypass VIP Berhasil!')));
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VaultScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('VVIP Access', style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)), // Emas
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFFFD700)),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF2A2A2A),
                  AppColors.navCapsule,
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.3), width: 2), // Border Emas
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD700).withOpacity(0.1),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onLongPress: () => _unlockVip(context), // Rahasia admin
                  child: const Icon(Icons.workspace_premium, color: Color(0xFFFFD700), size: 100),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Akses Eksklusif',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 28, 
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Brankas ini dilindungi enkripsi VVIP. Tingkatkan akun Anda untuk membuka penyimpanan file tanpa batas dan tanpa iklan selamanya.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
                ),
                const SizedBox(height: 32),
                
                // Info Harga
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    children: [
                      const Text('Biaya Akses VVIP', style: TextStyle(color: Colors.white54, fontSize: 14)),
                      const SizedBox(height: 8),
                      const Text('Rp 15.000', style: TextStyle(color: Color(0xFFFFD700), fontSize: 36, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white12),
                      const SizedBox(height: 16),
                      const Text('Transfer ke DANA:', style: TextStyle(color: Colors.white54, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(danaNumber, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF108EE9), // Warna Biru DANA
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 8,
                    ),
                    onPressed: () => _processPayment(context),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payment, color: Colors.white),
                        SizedBox(width: 12),
                        Text('Bayar Otomatis via DANA', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
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
}
