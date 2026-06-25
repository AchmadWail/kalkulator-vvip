import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

class CipherScreen extends StatefulWidget {
  @override
  _CipherScreenState createState() => _CipherScreenState();
}

class _CipherScreenState extends State<CipherScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  String _result = '';

  void _encrypt() {
    String text = _inputController.text;
    String key = _keyController.text;
    if (text.isEmpty) return;
    
    try {
      if (key.isEmpty) {
        setState(() {
          _result = base64Encode(utf8.encode(text));
        });
        return;
      }
      
      List<int> textBytes = utf8.encode(text);
      List<int> keyBytes = utf8.encode(key);
      List<int> encryptedBytes = [];
      
      for (int i = 0; i < textBytes.length; i++) {
        // XOR Encryption
        encryptedBytes.add(textBytes[i] ^ keyBytes[i % keyBytes.length]);
      }
      
      setState(() {
        _result = base64Encode(encryptedBytes);
      });
    } catch (e) {
      setState(() {
        _result = "Error: Gagal mengenkripsi.";
      });
    }
  }

  void _decrypt() {
    String text = _inputController.text;
    String key = _keyController.text;
    if (text.isEmpty) return;

    try {
      // Membersihkan teks dari spasi atau karakter newline yang mungkin terbawa saat paste
      String normalizedText = text.replaceAll(RegExp(r'\s+'), '');
      // Menambahkan padding '=' jika diperlukan agar valid Base64
      while (normalizedText.length % 4 != 0) {
        normalizedText += '=';
      }
      
      List<int> encryptedBytes = base64Decode(normalizedText);
      
      if (key.isEmpty) {
        setState(() {
          _result = utf8.decode(encryptedBytes, allowMalformed: true);
        });
        return;
      }

      List<int> keyBytes = utf8.encode(key);
      List<int> decryptedBytes = [];
      
      for (int i = 0; i < encryptedBytes.length; i++) {
        // XOR Decryption
        decryptedBytes.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
      }
      
      setState(() {
        // allowMalformed: true agar jika kata kunci salah, tetap menampilkan teks acak (bukan error system)
        _result = utf8.decode(decryptedBytes, allowMalformed: true);
      });
    } catch (e) {
      setState(() {
        _result = "Error: Teks rahasia (Cipher) tidak valid. Pastikan Anda menyalin seluruh kode dengan benar.";
      });
    }
  }

  void _copyResult() {
    if (_result.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _result));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Berhasil disalin ke clipboard!'),
          backgroundColor: AppColors.accentGreen,
        ),
      );
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Pesan Rahasia', style: TextStyle(color: AppColors.numberText)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.numberText),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lock_person_rounded, color: AppColors.accentPurple, size: 28),
                SizedBox(width: 12),
                Text(
                  'Kriptografi VVIP',
                  style: TextStyle(color: AppColors.numberText, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Ubah teks biasa menjadi kode rahasia menggunakan Kata Kunci Anda. Hanya penerima yang memiliki kata kunci yang sama yang bisa membaca pesan ini.',
              style: TextStyle(color: AppColors.previewText, fontSize: 14, height: 1.5),
            ),
            SizedBox(height: 32),
            _buildTextField(
              controller: _inputController,
              label: 'Masukkan Teks Biasa atau Kode Rahasia',
              icon: Icons.message_rounded,
              maxLines: 4,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _keyController,
              label: 'Kata Kunci (Password)',
              icon: Icons.vpn_key_rounded,
              isPassword: true,
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _encrypt,
                    icon: Icon(Icons.enhanced_encryption_rounded, size: 20),
                    label: Text('ENKRIPSI', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentPurple.withOpacity(0.2),
                      foregroundColor: AppColors.accentPurple,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _decrypt,
                    icon: Icon(Icons.no_encryption_rounded, size: 20),
                    label: Text('DEKRIPSI', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentCyan.withOpacity(0.2),
                      foregroundColor: AppColors.accentCyan,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            if (_result.isNotEmpty) ...[
              Text(
                'Hasil Proses:',
                style: TextStyle(color: AppColors.previewText, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accentGreen.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(color: AppColors.accentGreen.withOpacity(0.05), blurRadius: 20, spreadRadius: 2),
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      _result,
                      style: TextStyle(
                        color: _result.startsWith("Error") ? AppColors.accentPink : AppColors.numberText, 
                        fontSize: 16, 
                        fontFamily: 'monospace'
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: _copyResult,
                        icon: Icon(Icons.copy_rounded, color: AppColors.accentGreen, size: 20),
                        label: Text('Salin Hasil', style: TextStyle(color: AppColors.accentGreen)),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.accentGreen.withOpacity(0.1),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.numberText.withOpacity(0.08)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        maxLines: isPassword ? 1 : maxLines,
        style: TextStyle(color: AppColors.numberText, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColors.previewText),
          prefixIcon: Padding(
            padding: EdgeInsets.only(bottom: isPassword ? 0 : (maxLines > 1 ? 60 : 0)),
            child: Icon(icon, color: AppColors.previewText),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }
}
