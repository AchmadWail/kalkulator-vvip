import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class InfoModalWidget extends StatelessWidget {
  const InfoModalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.operatorButton,
      title: const Text('Informasi Rahasia', style: TextStyle(color: Colors.white)),
      content: const Text(
        'Kalkulator ini memiliki fitur tersembunyi.\n\n'
        'Gunakan kode berikut:\n'
        '• 1+1= (Akses Vault Gratis)\n'
        '• 99+99= (Akses Vault VIP)',
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup', style: TextStyle(color: AppColors.equalsButton)),
        ),
      ],
    );
  }
}