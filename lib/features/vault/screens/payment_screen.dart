import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import 'vault_screen.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  final String danaNumber = "081359070793";

  void _payAndUnlock(BuildContext context) async {
    // Salin nomor
    await Clipboard.setData(ClipboardData(text: danaNumber));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nomor DANA disalin!')));

    // Buka DANA
    final url = Uri.parse("dana://pay?amount=15000&note=KalkulatorVIP");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }

    // Beri akses VIP
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_vip_unlocked', true);

    if (context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const VaultScreen(isVip: true)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Premium Access"), backgroundColor: Colors.black),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, size: 80, color: Colors.amber),
              const SizedBox(height: 20),
              const Text("Akses Vault VIP", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.amber)),
              const SizedBox(height: 20),
              const Text("Harga: Rp 15.000", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Text("Kirim DANA ke: $danaNumber", style: const TextStyle(fontSize: 18, color: Colors.white70)),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                ),
                onPressed: () => _payAndUnlock(context),
                child: const Text("Bayar dengan DANA", style: TextStyle(fontSize: 18, color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
