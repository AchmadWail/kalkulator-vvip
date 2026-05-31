import os

base_path = r"c:\Users\MY ASUS\kalkulator_vvip\lib"

files_to_create = {
    r"features\history\providers\history_provider.dart": """
import 'package:flutter/material.dart';
import '../models/history_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryProvider with ChangeNotifier {
  List<HistoryModel> _history = [];
  List<HistoryModel> get history => _history;

  HistoryProvider() {
    _loadHistory();
  }

  void addHistory(String expression, String result) {
    _history.insert(0, HistoryModel(expression: expression, result: result, timestamp: DateTime.now()));
    _saveHistory();
    notifyListeners();
  }

  void clearHistory() {
    _history.clear();
    _saveHistory();
    notifyListeners();
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _history.map((h) => jsonEncode(h.toJson())).toList();
    prefs.setStringList('calc_history', jsonList);
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('calc_history') ?? [];
    _history = jsonList.map((j) => HistoryModel.fromJson(jsonDecode(j))).toList();
    notifyListeners();
  }
}
""",
    r"features\history\screens\history_screen.dart": """
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../../../core/theme/app_colors.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat"),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<HistoryProvider>(context, listen: false).clearHistory();
            },
          )
        ],
      ),
      body: Consumer<HistoryProvider>(
        builder: (context, provider, child) {
          if (provider.history.isEmpty) {
            return const Center(child: Text("Belum ada riwayat."));
          }
          return ListView.builder(
            itemCount: provider.history.length,
            itemBuilder: (context, index) {
              final item = provider.history[index];
              return ListTile(
                title: Text(item.expression, style: const TextStyle(fontSize: 18)),
                subtitle: Text("= ${item.result}", style: const TextStyle(fontSize: 24, color: AppColors.numberText)),
              );
            },
          );
        },
      ),
    );
  }
}
""",
    r"features\vault\screens\payment_screen.dart": """
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
    await prefs.setString("vip_unlocked", "true");

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
""",
    r"features\vault\screens\vault_screen.dart": """
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';

class VaultScreen extends StatefulWidget {
  final bool isVip;
  const VaultScreen({Key? key, this.isVip = false}) : super(key: key);

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final List<String> _mediaFiles = [];

  void _addMedia() async {
    if (!widget.isVip) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Akses VIP diperlukan untuk menambah file.")));
      return;
    }
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _mediaFiles.add(image.name);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isVip ? "Vault VIP" : "Vault (Lihat Saja)"), backgroundColor: Colors.black),
      backgroundColor: AppColors.background,
      body: _mediaFiles.isEmpty 
          ? const Center(child: Text("Vault kosong", style: TextStyle(color: Colors.white54, fontSize: 18)))
          : ListView.builder(
              itemCount: _mediaFiles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.image, color: Colors.white),
                  title: Text(_mediaFiles[index], style: const TextStyle(color: Colors.white)),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMedia,
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
""",
    r"main.dart": """
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'features/calculator/providers/calculator_provider.dart';
import 'features/history/providers/history_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalculatorProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const KalkulatorVipApp(),
    ),
  );
}
"""
}

# Delete all empty files
for dp, dn, filenames in os.walk(base_path):
    for f in filenames:
        full_path = os.path.join(dp, f)
        if full_path.endswith(".dart"):
            if os.path.getsize(full_path) == 0:
                os.remove(full_path)

# Create missing core files
for relative_path, content in files_to_create.items():
    full_path = os.path.join(base_path, relative_path)
    os.makedirs(os.path.dirname(full_path), exist_ok=True)
    with open(full_path, "w", encoding="utf-8") as f:
        f.write(content.strip())

print("Cleanup and fill successful.")
