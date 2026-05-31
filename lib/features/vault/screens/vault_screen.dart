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
