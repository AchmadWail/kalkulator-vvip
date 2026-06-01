import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../../../core/theme/app_colors.dart';
import 'dart:ui';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Riwayat", style: TextStyle(color: AppColors.numberText, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.numberText),
        actions: [
          Consumer<HistoryProvider>(
            builder: (context, provider, _) {
              if (provider.history.isEmpty) return SizedBox.shrink();
              return IconButton(
                icon: Icon(Icons.delete_sweep_rounded, color: AppColors.accentPink),
                tooltip: 'Hapus Semua',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: AppColors.surface,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      title: Text('Hapus Riwayat?', style: TextStyle(color: AppColors.numberText)),
                      content: Text(
                        'Semua riwayat kalkulasi akan dihapus permanen.',
                        style: TextStyle(color: AppColors.numberText.withOpacity(0.7)),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text('Batal', style: TextStyle(color: AppColors.previewText)),
                        ),
                        TextButton(
                          onPressed: () {
                            provider.clearHistory();
                            Navigator.pop(ctx);
                          },
                          child: Text('Hapus', style: TextStyle(color: AppColors.accentPink)),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background decoration
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.accentPurple.withOpacity(0.08), Colors.transparent],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Consumer<HistoryProvider>(
              builder: (context, provider, child) {
                if (provider.history.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calculate_outlined, size: 80, color: AppColors.previewText.withOpacity(0.3)),
                        SizedBox(height: 16),
                        Text(
                          "Belum ada riwayat",
                          style: TextStyle(color: AppColors.previewText, fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Mulai menghitung untuk melihat riwayat di sini",
                          style: TextStyle(color: AppColors.previewText.withOpacity(0.6), fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: provider.history.length,
                  itemBuilder: (context, index) {
                    final item = provider.history[index];
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 300 + (index * 50).clamp(0, 300)),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Dismissible(
                        key: ValueKey(item.timestamp.toIso8601String()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 24),
                          margin: EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: AppColors.accentPink.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(Icons.delete_rounded, color: AppColors.accentPink),
                        ),
                        onDismissed: (_) => provider.removeAt(index),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.numberText.withOpacity(0.05)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                item.expression,
                                style: TextStyle(
                                  color: AppColors.previewText,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(height: 6),
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [AppColors.accentCyan, AppColors.accentPurple],
                                ).createShader(bounds),
                                child: Text(
                                  "= ${item.result}",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                _formatTime(item.timestamp),
                                style: TextStyle(color: AppColors.previewText.withOpacity(0.5), fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inHours < 1) return '${diff.inMinutes} menit lalu';
    if (diff.inDays < 1) return '${diff.inHours} jam lalu';
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
