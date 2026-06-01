import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../history/providers/history_provider.dart';
import '../../../app.dart' as import_app;
import '../../converters/screens/base_converter_screen.dart';
import '../../graphing/screens/cyber_visualizer_screen.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SingleTickerProviderStateMixin {
  bool _isVip = false;
  bool _soundEnabled = true;
  bool _hapticEnabled = true;
  bool _isDarkMode = true;
  String _defaultCurrency = 'IDR';
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
                _buildAnimatedItem(2, _buildSectionHeader('Preferensi Aplikasi')),
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
                    _buildSwitchTile(
                      icon: Icons.volume_up_rounded,
                      iconColor: AppColors.accentCyan,
                      title: 'Suara Tombol',
                      value: _soundEnabled,
                      onChanged: (val) {
                        setState(() => _soundEnabled = val);
                        _toggleSetting('setting_sound', val);
                      },
                    ),
                    _divider(),
                    _buildSwitchTile(
                      icon: Icons.vibration_rounded,
                      iconColor: AppColors.accentOrange,
                      title: 'Getaran (Haptic)',
                      value: _hapticEnabled,
                      onChanged: (val) {
                        setState(() => _hapticEnabled = val);
                        _toggleSetting('setting_haptic', val);
                      },
                    ),
                    _divider(),
                    ListTile(
                      leading: _buildIconBox(Icons.attach_money_rounded, AppColors.accentGreen),
                      title: Text('Mata Uang Default', style: TextStyle(color: AppColors.numberText)),
                      trailing: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: AppColors.surface,
                          value: _defaultCurrency,
                          style: TextStyle(color: AppColors.numberText.withOpacity(0.70), fontSize: 14),
                          items: ['IDR', 'USD', 'EUR', 'MYR', 'SGD', 'JPY', 'GBP'].map((String value) {
                            return DropdownMenuItem<String>(value: value, child: Text(value));
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
                )),
                SizedBox(height: 24),
                _buildAnimatedItem(4, _buildSectionHeader('Data & Penyimpanan')),
                _buildAnimatedItem(5, _buildSettingsCard(
                  children: [
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
                      onTap: () {
                        if (!_isVip) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Fitur eksklusif ini hanya untuk VVIP Member. Ketik 99+99= untuk upgrade!'),
                              backgroundColor: Colors.amber.shade800,
                            ),
                          );
                          return;
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (_) => BaseConverterScreen()));
                      },
                    ),
                    _divider(),
                    ListTile(
                      leading: _buildIconBox(Icons.hub_rounded, AppColors.accentCyan),
                      title: Row(
                        children: [
                          Flexible(child: Text('VVIP Cyber Visualizer', style: TextStyle(color: AppColors.numberText))),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Fitur eksklusif ini hanya untuk VVIP Member. Ketik 99+99= untuk upgrade!'),
                              backgroundColor: Colors.amber.shade800,
                            ),
                          );
                          return;
                        }
                        Navigator.push(context, MaterialPageRoute(builder: (_) => CyberVisualizerScreen()));
                      },
                    ),
                  ],
                )),
                SizedBox(height: 24),
                _buildAnimatedItem(8, _buildSectionHeader('Tentang')),
                _buildAnimatedItem(9, _buildSettingsCard(
                  children: [
                    ListTile(
                      leading: _buildIconBox(Icons.info_outline_rounded, AppColors.accentCyan),
                      title: Text('Versi Aplikasi', style: TextStyle(color: AppColors.numberText)),
                      trailing: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: AppColors.primaryGradient,
                        ).createShader(bounds),
                        child: Text('v3.0 VVIP', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
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
    return Container(
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
                      : 'Ketik 99+99= di kalkulator untuk upgrade.',
                  style: TextStyle(
                    color: AppColors.numberText.withOpacity(0.5),
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
