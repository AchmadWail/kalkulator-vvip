import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../../../core/theme/app_colors.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Riwayat"),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Provider.of<HistoryProvider>(context, listen: false).clearHistory();
            },
          )
        ],
      ),
      body: Consumer<HistoryProvider>(
        builder: (context, provider, child) {
          if (provider.history.isEmpty) {
            return Center(child: Text("Belum ada riwayat."));
          }
          return ListView.builder(
            itemCount: provider.history.length,
            itemBuilder: (context, index) {
              final item = provider.history[index];
              return ListTile(
                title: Text(item.expression, style: TextStyle(fontSize: 18)),
                subtitle: Text("= ${item.result}", style: TextStyle(fontSize: 24, color: AppColors.numberText)),
              );
            },
          );
        },
      ),
    );
  }
}
