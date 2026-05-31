import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../vault/screens/vault_screen.dart';
import '../../vault/screens/payment_screen.dart';

class SecretDetector {
  String _inputBuffer = '';

  bool detect(String input, BuildContext context) {
    if (input == 'AC') {
      _inputBuffer = '';
      return false;
    }
    
    _inputBuffer += input;

    if (_inputBuffer.length > 20) {
      _inputBuffer = _inputBuffer.substring(_inputBuffer.length - 20);
    }

    if (_inputBuffer.endsWith('1+1=')) {
      _inputBuffer = '';
      _openVault(context, freeMode: true);
      return true;
    } else if (_inputBuffer.endsWith('99+99=')) {
      _inputBuffer = '';
      _openVault(context, freeMode: false);
      return true;
    }

    return false;
  }

  Future<void> _openVault(BuildContext context, {required bool freeMode}) async {
    final prefs = await SharedPreferences.getInstance();
    final isVip = prefs.getBool('is_vip_unlocked') ?? false;

    if (!context.mounted) return;

    if (freeMode || isVip) {
       Navigator.push(context, MaterialPageRoute(builder: (_) => const VaultScreen()));
    } else {
       Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentScreen()));
    }
  }
}
