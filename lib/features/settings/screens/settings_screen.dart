import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../history/providers/history_provider.dart';
import '../../../app.dart' as import_app;
import '../../converters/screens/base_converter_screen.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isVip = false;
  bool _soundEnabled = true;
  bool _hapticEnabled = true;
  bool _isDarkMode = true;
  String _defaultCurrency = 'IDR';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isVip = prefs.getBool('is_vip_unlocked') ?? false;
      _soundEnabled = prefs.getBool('setting_sound') ?? true;
      _hapticEnabled = prefs.getBool('setting_haptic') ?? true;
      _isDarkMode = prefs.getBool('setting_dark_mode') ?? true;
      _defaultCurrency = prefs.getString('setting_currency') ?? 'IDR';
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
        backgroundColor: AppColors.numberButton,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Hapus Riwayat', style: TextStyle(color: AppColors.numberText)),
        content: Text(
          'Anda yakin ingin menghapus seluruh riwayat kalkulasi?',
          style: TextStyle(color: AppColors.numberText.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: TextStyle(color: AppColors.numberText.withOpacity(0.54))),
          ),
          TextButton(
            onPressed: () {
              Provider.of<HistoryProvider>(context, listen: false).clearHistory();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Riwayat berhasil dihapus'), backgroundColor: Colors.green),
              );
            },
            child: Text('Hapus', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
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
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Decor (Glow effects)
          Positioned(
            top: -50,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purpleAccent.withOpacity(0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          
          SafeArea(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                _buildSectionHeader('Akun & Status'),
                _buildVipStatusCard(),
                
                SizedBox(height: 24),
                _buildSectionHeader('Preferensi Aplikasi'),
                _buildSettingsCard(
                  children: [
                    _buildSwitchTile(
                      icon: Icons.dark_mode_rounded,
                      iconColor: Colors.purpleAccent,
                      title: 'Mode Gelap',
                      value: _isDarkMode,
                      onChanged: (val) {
                        setState(() => _isDarkMode = val);
                        _toggleSetting('setting_dark_mode', val);
                        import_app.themeNotifier.value = val;
                      },
                    ),
                    Divider(color: AppColors.numberText.withOpacity(0.10), height: 1),
                    _buildSwitchTile(
                      icon: Icons.volume_up_rounded,
                      iconColor: Colors.cyanAccent,
                      title: 'Suara Tombol',
                      value: _soundEnabled,
                      onChanged: (val) {
                        setState(() => _soundEnabled = val);
                        _toggleSetting('setting_sound', val);
                      },
                    ),
                    Divider(color: AppColors.numberText.withOpacity(0.10), height: 1),
                    _buildSwitchTile(
                      icon: Icons.vibration_rounded,
                      iconColor: Colors.orangeAccent,
                      title: 'Getaran (Haptic)',
                      value: _hapticEnabled,
                      onChanged: (val) {
                        setState(() => _hapticEnabled = val);
                        _toggleSetting('setting_haptic', val);
                      },
                    ),
                    Divider(color: AppColors.numberText.withOpacity(0.10), height: 1),
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.attach_money_rounded, color: Colors.greenAccent, size: 20),
                      ),
                      title: Text('Mata Uang Default', style: TextStyle(color: AppColors.numberText)),
                      trailing: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: AppColors.operatorButton,
                          value: _defaultCurrency,
                          style: TextStyle(color: AppColors.numberText.withOpacity(0.70), fontSize: 14),
                          items: ['IDR', 'USD', 'EUR', 'MYR'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newVal) async {
                            if (newVal != null) {
                              setState(() => _defaultCurrency = newVal);
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString('setting_currency', newVal);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 24),
                _buildSectionHeader('Data & Penyimpanan'),
                _buildSettingsCard(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.history_rounded, color: Colors.redAccent, size: 20),
                      ),
                      title: Text('Hapus Riwayat Kalkulator', style: TextStyle(color: AppColors.numberText)),
                      trailing: Icon(Icons.chevron_right_rounded, color: AppColors.numberText.withOpacity(0.38)),
                      onTap: _clearHistory,
                    ),
                  ],
                ),
                
                SizedBox(height: 24),
                _buildSectionHeader('Fitur Tambahan'),
                _buildSettingsCard(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.code_rounded, color: Colors.greenAccent, size: 20),
                      ),
                      title: Row(
                        children: [
                          Text('Konversi Basis Logika', style: TextStyle(color: AppColors.numberText)),
                          if (!_isVip) ...[
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text('VVIP', style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                      trailing: Icon(
                        _isVip ? Icons.chevron_right_rounded : Icons.lock_outline_rounded,
                        color: _isVip ? AppColors.numberText.withOpacity(0.38) : Colors.amber.withOpacity(0.5),
                        size: _isVip ? 24 : 20,
                      ),
                      onTap: () {
                        if (!_isVip) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Fitur eksklusif ini hanya untuk VVIP Member. Silakan upgrade!'),
                              backgroundColor: Colors.amber.shade800,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (_) => BaseConverterScreen()));
                      },
                    ),
                  ],
                ),
                
                SizedBox(height: 24),
                _buildSectionHeader('Tentang'),
                _buildSettingsCard(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.info_outline_rounded, color: Colors.blueAccent, size: 20),
                      ),
                      title: Text('Versi Aplikasi', style: TextStyle(color: AppColors.numberText)),
                      trailing: Text('v2.0 (VVIP Edition)', style: TextStyle(color: AppColors.numberText.withOpacity(0.54), fontSize: 14)),
                    ),
                  ],
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: AppColors.numberText.withOpacity(0.5),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.numberButton,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.numberText.withOpacity(0.05)),
      ),
      child: Column(
        children: children,
      ),
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
      secondary: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: TextStyle(color: AppColors.numberText)),
      value: value,
      activeColor: AppColors.equalsButton,
      inactiveTrackColor: AppColors.numberText.withOpacity(0.10),
      onChanged: onChanged,
    );
  }

  Widget _buildVipStatusCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isVip 
              ? [Colors.amber.shade800.withOpacity(0.3), Colors.amber.shade900.withOpacity(0.1)]
              : [AppColors.numberText.withOpacity(0.1), AppColors.numberText.withOpacity(0.02)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isVip ? Colors.amber.withOpacity(0.5) : AppColors.numberText.withOpacity(0.10),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _isVip ? Colors.amber.withOpacity(0.2) : AppColors.numberText.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isVip ? Icons.star_rounded : Icons.lock_outline_rounded,
              color: _isVip ? Colors.amber : AppColors.numberText.withOpacity(0.54),
              size: 32,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isVip ? 'VVIP Member' : 'Standar (Free)',
                  style: TextStyle(
                    color: _isVip ? Colors.amber : AppColors.numberText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _isVip 
                      ? 'Akses penuh ke semua fitur rahasia dan vault.'
                      : 'Ketik 99+99= di kalkulator untuk upgrade ke VVIP.',
                  style: TextStyle(
                    color: AppColors.numberText.withOpacity(0.6),
                    fontSize: 12,
                    height: 1.4,
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
