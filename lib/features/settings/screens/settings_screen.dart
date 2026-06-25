import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../../core/theme/app_colors.dart';
import '../../history/providers/history_provider.dart';
import '../../../app.dart' as import_app;
import '../../converters/screens/base_converter_screen.dart';
import '../../cryptography/screens/cipher_screen.dart';
import '../../health_calculator/screens/health_calculator_screen.dart';
import '../../split_bill/screens/split_bill_screen.dart';
import '../../time_matrix/screens/time_matrix_screen.dart';
import '../../vault/screens/payment_screen.dart';
class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  bool _isVip = false;
  bool _isDarkMode = true;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..forward();
    _loadSettings();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isVip = prefs.getBool('is_vip_unlocked') ?? false;
      _isDarkMode = prefs.getBool('setting_dark_mode') ?? true;
    });
  }

  Future<void> _toggleSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void _clearHistory() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Hapus Riwayat', style: TextStyle(color: AppColors.numberText)),
        content: Text(
          'Anda yakin ingin menghapus seluruh riwayat kalkulasi?',
          style: TextStyle(color: AppColors.numberText.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: TextStyle(color: AppColors.previewText)),
          ),
          TextButton(
            onPressed: () {
              Provider.of<HistoryProvider>(context, listen: false).clearHistory();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Riwayat berhasil dihapus'), backgroundColor: AppColors.accentGreen),
              );
            },
            child: Text('Hapus', style: TextStyle(color: AppColors.accentPink)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.info_rounded, color: AppColors.accentCyan),
            SizedBox(width: 8),
            Text('Tentang Aplikasi', style: TextStyle(color: AppColors.numberText)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kalkulator VVIP v3.0',
              style: TextStyle(color: AppColors.numberText, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Aplikasi ini adalah kalkulator multifungsi yang dilengkapi dengan brankas rahasia (Vault) untuk menyembunyikan file pribadi Anda.\n\nFitur VVIP mencakup enkripsi pesan tingkat lanjut, manajemen keuangan, serta perlindungan privasi eksklusif.',
              style: TextStyle(color: AppColors.numberText.withOpacity(0.7), height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Tutup', style: TextStyle(color: AppColors.accentCyan)),
          ),
        ],
      ),
    );
  }

  void _showReportDialog() {
    final TextEditingController _reportController = TextEditingController();
    bool _isSending = false;
    String _selectedType = 'Laporan bug aplikasi';
    final List<String> _reportTypes = [
      'Laporan bug aplikasi',
      'Saran fitur baru',
      'Masalah VVIP / Pembayaran',
      'Lainnya'
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Icon(Icons.bug_report_rounded, color: Colors.redAccent),
                SizedBox(width: 8),
                Text('Laporan Masalah', style: TextStyle(color: AppColors.numberText)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pesan akan dikirim langsung ke tim developer secara rahasia.',
                    style: TextStyle(color: AppColors.numberText.withOpacity(0.7), fontSize: 13),
                  ),
                  SizedBox(height: 16),
                  Text('Kategori:', style: TextStyle(color: AppColors.numberText, fontSize: 14)),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedType,
                        isExpanded: true,
                        dropdownColor: AppColors.surface,
                        style: TextStyle(color: AppColors.numberText),
                        items: _reportTypes.map((type) {
                          return DropdownMenuItem(value: type, child: Text(type));
                        }).toList(),
                        onChanged: (val) {
                          setState(() => _selectedType = val!);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _reportController,
                    maxLines: 4,
                    style: TextStyle(color: AppColors.numberText),
                    decoration: InputDecoration(
                      hintText: 'Jelaskan detail masalahnya...',
                      hintStyle: TextStyle(color: AppColors.numberText.withOpacity(0.3)),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: _isSending ? null : () => Navigator.pop(ctx),
                child: Text('Batal', style: TextStyle(color: AppColors.previewText)),
              ),
              ElevatedButton(
                onPressed: _isSending
                    ? null
                    : () async {
                        if (_reportController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Laporan tidak boleh kosong')),
                          );
                          return;
                        }
                        
                        setState(() => _isSending = true);
                        
                        try {
                          await Future.delayed(Duration(milliseconds: 500)); // Sedikit animasi loading
                          
                          final Uri emailUri = Uri(
                            scheme: 'mailto',
                            path: 'rydenzz01@gmail.com',
                            query: _encodeQueryParameters(<String, String>{
                              'subject': 'Laporan Kalkulator VVIP: $_selectedType',
                              'body': 'Kategori: $_selectedType\n\nDetail Laporan:\n${_reportController.text.trim()}',
                            }),
                          );
                          
                          await launchUrl(emailUri, mode: LaunchMode.externalApplication);
                          Navigator.pop(ctx);
                        } catch (e) {
                          setState(() => _isSending = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Tidak dapat membuka aplikasi email.'), backgroundColor: Colors.redAccent),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSending 
                    ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('Kirim', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        }
      ),
    );
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Widget _buildAnimatedItem(int index, Widget child) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 80)),
      curve: Curves.easeOutCubic,
      builder: (context, value, c) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - value)),
            child: c,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Pengaturan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.numberText),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background glows
          Positioned(
            top: -50, right: -100,
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.accentPurple.withOpacity(0.08),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: -50, left: -50,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.accentCyan.withOpacity(0.06),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                _buildAnimatedItem(0, _buildSectionHeader('Akun & Status')),
                _buildAnimatedItem(1, _buildVipStatusCard()),
                SizedBox(height: 24),
                _buildAnimatedItem(2, _buildSectionHeader('Preferensi & Data')),
                _buildAnimatedItem(3, _buildSettingsCard(
                  children: [
                    _buildSwitchTile(
                      icon: Icons.dark_mode_rounded,
                      iconColor: AppColors.accentPurple,
                      title: 'Mode Gelap',
                      value: _isDarkMode,
                      onChanged: (val) {
                        setState(() => _isDarkMode = val);
                        _toggleSetting('setting_dark_mode', val);
                        import_app.themeNotifier.value = val;
                      },
                    ),
                    _divider(),
                    ListTile(
                      leading: _buildIconBox(Icons.history_rounded, AppColors.accentPink),
                      title: Text('Hapus Riwayat Kalkulator', style: TextStyle(color: AppColors.numberText)),
                      trailing: Icon(Icons.chevron_right_rounded, color: AppColors.numberText.withOpacity(0.3)),
                      onTap: _clearHistory,
                    ),
                  ],
                )),
                SizedBox(height: 24),
                _buildAnimatedItem(6, _buildSectionHeader('Fitur Tambahan')),
                _buildAnimatedItem(7, _buildSettingsCard(
                  children: [
                    ListTile(
                      leading: _buildIconBox(Icons.code_rounded, AppColors.accentGreen),
                      title: Row(
                        children: [
                          Flexible(child: Text('Konversi Basis Logika', style: TextStyle(color: AppColors.numberText))),
                          if (!_isVip) ...[
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [Colors.amber.shade700, Colors.orange.shade600]),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('VVIP', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                      trailing: Icon(
                        _isVip ? Icons.chevron_right_rounded : Icons.lock_outline_rounded,
                        color: _isVip ? AppColors.numberText.withOpacity(0.3) : Colors.amber.withOpacity(0.5),
                        size: _isVip ? 24 : 20,
                      ),
                      onTap: () async {
                        if (!_isVip) {
                          await Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen()));
                          _loadSettings();
                          return;
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (_) => BaseConverterScreen()));
                      },
                    ),
                    _divider(),
                    ListTile(
                      leading: _buildIconBox(Icons.lock_person_rounded, AppColors.accentPurple),
                      title: Row(
                        children: [
                          Flexible(child: Text('Enkripsi Pesan Rahasia', style: TextStyle(color: AppColors.numberText))),
                          if (!_isVip) ...[
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [Colors.amber.shade700, Colors.orange.shade600]),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('VVIP', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                      trailing: Icon(
                        _isVip ? Icons.chevron_right_rounded : Icons.lock_outline_rounded,
                        color: _isVip ? AppColors.numberText.withOpacity(0.3) : Colors.amber.withOpacity(0.5),
                        size: _isVip ? 24 : 20,
                      ),
                      onTap: () async {
                        if (!_isVip) {
                          await Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen()));
                          _loadSettings();
                          return;
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (_) => CipherScreen()));
                      },
                    ),
                    _divider(),
                    ListTile(
                      leading: _buildIconBox(Icons.hourglass_bottom, AppColors.accentOrange),
                      title: Row(
                        children: [
                          Flexible(child: Text('Time Matrix', style: TextStyle(color: AppColors.numberText))),
                          if (!_isVip) ...[
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [Colors.amber.shade700, Colors.orange.shade600]),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('VVIP', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                      trailing: Icon(
                        _isVip ? Icons.chevron_right_rounded : Icons.lock_outline_rounded,
                        color: _isVip ? AppColors.numberText.withOpacity(0.3) : Colors.amber.withOpacity(0.5),
                        size: _isVip ? 24 : 20,
                      ),
                      onTap: () {
                        if (!_isVip) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen()));
                          return;
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (_) => TimeMatrixScreen()));
                      },
                    ),
                    _divider(),
                    ListTile(
                      leading: _buildIconBox(Icons.monitor_heart, AppColors.accentPink),
                      title: Row(
                        children: [
                          Flexible(child: Text('Kesehatan', style: TextStyle(color: AppColors.numberText))),
                          if (!_isVip) ...[
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [Colors.amber.shade700, Colors.orange.shade600]),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('VVIP', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                      trailing: Icon(
                        _isVip ? Icons.chevron_right_rounded : Icons.lock_outline_rounded,
                        color: _isVip ? AppColors.numberText.withOpacity(0.3) : Colors.amber.withOpacity(0.5),
                        size: _isVip ? 24 : 20,
                      ),
                      onTap: () {
                        if (!_isVip) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen()));
                          return;
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (_) => HealthCalculatorScreen()));
                      },
                    ),
                    _divider(),
                    ListTile(
                      leading: _buildIconBox(Icons.receipt_long, AppColors.accentCyan),
                      title: Row(
                        children: [
                          Flexible(child: Text('Split Bill', style: TextStyle(color: AppColors.numberText))),
                          if (!_isVip) ...[
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [Colors.amber.shade700, Colors.orange.shade600]),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('VVIP', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                      trailing: Icon(
                        _isVip ? Icons.chevron_right_rounded : Icons.lock_outline_rounded,
                        color: _isVip ? AppColors.numberText.withOpacity(0.3) : Colors.amber.withOpacity(0.5),
                        size: _isVip ? 24 : 20,
                      ),
                      onTap: () {
                        if (!_isVip) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen()));
                          return;
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (_) => SplitBillScreen()));
                      },
                    ),
                  ],
                )),
                SizedBox(height: 24),
                _buildAnimatedItem(8, _buildSectionHeader('Bantuan & Tentang')),
                _buildAnimatedItem(9, _buildSettingsCard(
                  children: [

                    ListTile(
                      leading: _buildIconBox(Icons.bug_report_rounded, Colors.redAccent),
                      title: Text('Laporan Masalah', style: TextStyle(color: AppColors.numberText)),
                      trailing: Icon(Icons.chevron_right_rounded, color: AppColors.numberText.withOpacity(0.3)),
                      onTap: _showReportDialog,
                    ),
                    _divider(),
                    ListTile(
                      leading: _buildIconBox(Icons.info_outline_rounded, AppColors.accentCyan),
                      title: Text('Tentang Aplikasi', style: TextStyle(color: AppColors.numberText)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: AppColors.primaryGradient,
                            ).createShader(bounds),
                            child: Text('v3.0 VVIP', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.chevron_right_rounded, color: AppColors.numberText.withOpacity(0.3)),
                        ],
                      ),
                      onTap: _showAboutDialog,
                    ),
                  ],
                )),
                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(color: AppColors.numberText.withOpacity(0.06), height: 1, indent: 60);

  Widget _buildIconBox(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppColors.previewText,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.numberText.withOpacity(0.04)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: _buildIconBox(icon, iconColor),
      title: Text(title, style: TextStyle(color: AppColors.numberText)),
      value: value,
      activeColor: AppColors.accentPurple,
      inactiveTrackColor: AppColors.numberText.withOpacity(0.08),
      onChanged: onChanged,
    );
  }

  Widget _buildVipStatusCard() {
    return GestureDetector(
      onTap: () async {
        if (!_isVip) {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen()));
          _loadSettings();
        }
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isVip
                ? [Colors.amber.shade800.withOpacity(0.2), Colors.amber.shade900.withOpacity(0.08)]
                : [AppColors.surface, AppColors.surface],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _isVip ? Colors.amber.withOpacity(0.4) : AppColors.numberText.withOpacity(0.06),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: _isVip
                    ? LinearGradient(colors: [Colors.amber.withOpacity(0.2), Colors.orange.withOpacity(0.15)])
                    : null,
                color: _isVip ? null : AppColors.numberText.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isVip ? Icons.diamond_rounded : Icons.lock_outline_rounded,
                color: _isVip ? Colors.amber : AppColors.previewText,
                size: 28,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isVip ? 'VVIP Member ✨' : 'Standar (Free)',
                    style: TextStyle(
                      color: _isVip ? Colors.amber : AppColors.numberText,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _isVip
                        ? 'Akses penuh ke semua fitur & vault.'
                        : 'Ketuk di sini untuk upgrade.',
                    style: TextStyle(
                      color: AppColors.numberText.withOpacity(0.5),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (!_isVip)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.amber.shade600, Colors.orange.shade700]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.amber.withOpacity(0.2), blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('UPGRADE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 10),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
