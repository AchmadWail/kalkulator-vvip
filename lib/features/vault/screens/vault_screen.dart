import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({Key? key}) : super(key: key);

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
          ? const Center(
              child: Text(
                'Brankas masih kosong.\nKetuk tombol + untuk menambahkan media.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _mediaNames.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.operatorButton,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.image, color: Colors.white70, size: 40),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          _mediaNames[index],
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickMedia,
        backgroundColor: AppColors.equalsButton,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
