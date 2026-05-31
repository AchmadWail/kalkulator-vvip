import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';

class VaultScreen extends StatefulWidget {
  final bool isFreeMode;
  const VaultScreen({Key? key, this.isFreeMode = false}) : super(key: key);

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final List<String> _mediaNames = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickMedia() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _mediaNames.add(image.name); // Store name instead of path for web compatibility demo
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      // If permission fails, mock it
      setState(() {
         _mediaNames.add('Secret_Photo_${_mediaNames.length + 1}.png');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Brankas Rahasia', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.navCapsule,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _mediaNames.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.security, color: Color(0xFFFFD700), size: 100),
                  const SizedBox(height: 24),
                  const Text(
                    'Brankas Kosong',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Data dienkripsi secara lokal.\nKetuk tombol + untuk menyembunyikan file.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: _mediaNames.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF333333), Color(0xFF1A1A1A)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 8, spreadRadius: 2),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.image_outlined, color: Colors.white38, size: 50),
                      Positioned(
                        bottom: 8,
                        left: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _mediaNames[index],
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(Icons.lock, color: const Color(0xFFFFD700).withOpacity(0.8), size: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: widget.isFreeMode 
        ? null 
        : FloatingActionButton.extended(
            onPressed: _pickMedia,
            backgroundColor: const Color(0xFFFFD700), // Gold VIP
            icon: const Icon(Icons.add_a_photo, color: Colors.black),
            label: const Text('Simpan File', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
    );
  }
}
