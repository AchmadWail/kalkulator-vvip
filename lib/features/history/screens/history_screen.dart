import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../calculator/providers/calculator_provider.dart';
import '../../../core/theme/app_colors.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Read history from provider
    final history = context.watch<CalculatorProvider>().history;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Perhitungan', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.navCapsule,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: history.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, color: Colors.white24, size: 80),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada riwayat',
                    style: TextStyle(color: Colors.white54, fontSize: 18),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                // To show the latest history first, we reverse the index
                final reversedIndex = history.length - 1 - index;
                final item = history[reversedIndex];
                
                // item looks like: "2+6 = 8"
                final parts = item.split('=');
                final expression = parts[0].trim();
                final result = parts.length > 1 ? parts[1].trim() : '';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.navCapsule,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        expression,
                        style: const TextStyle(color: Colors.white54, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '= $result',
                        style: const TextStyle(color: AppColors.equalsButton, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
