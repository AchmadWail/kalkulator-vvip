import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import 'vault_screen.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  Future<void> _processPayment(BuildContext context) async {
    final Uri danaUri = Uri.parse('dana://pay?amount=15000&note=KalkulatorVIP');
    
    // Try to launch DANA deep link
    try {
      if (await canLaunchUrl(danaUri)) {
        await launchUrl(danaUri);
      }
    } catch (e) {
      debugPrint('DANA app not found or could not be launched');
    }

    // SIMULATION: Automatically unlock VIP after "payment" clicked
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_vip_unlocked', true);
    
    if (context.mounted) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pembayaran Berhasil! Brankas VIP Terbuka.')));
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VaultScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Akses Ditolak', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.navCapsule,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.navCapsule,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.equalsButton.withOpacity(0.5), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, color: AppColors.equalsButton, size: 80),
              const SizedBox(height: 24),
              const Text(
                'Brankas Terkunci',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Anda harus berlangganan VIP untuk mengakses brankas tersembunyi ini. Biaya berlangganan hanya Rp 15.000 (Satu kali bayar).',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.equalsButton,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () => _processPayment(context),
                  child: const Text('Bayar via DANA (Rp 15.000)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
