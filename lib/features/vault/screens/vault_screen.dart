import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../services/vault_storage_service.dart';
import 'folder_detail_screen.dart';

class VaultScreen extends StatefulWidget {
  final bool isVip;
  VaultScreen({Key? key, this.isVip = false}) : super(key: key);

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  Map<String, int> _fileCounts = {};

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final counts = <String, int>{};
    for (final type in ['image', 'video', 'document', 'audio']) {
      counts[type] = await VaultStorageService.getFileCount(type);
    }
    if (mounted) {
      setState(() => _fileCounts = counts);
    }
  }

  Widget _buildFolderItem(
      BuildContext context, String title, IconData icon, String folderType, Color accentColor) {
    final count = _fileCounts[folderType] ?? 0;
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FolderDetailScreen(
              title: title,
              folderType: folderType,
              isVip: widget.isVip,
            ),
          ),
        );
        // Reload counts when returning
        _loadCounts();
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.numberText.withOpacity(0.12), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 32, color: accentColor),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: AppColors.numberText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (count > 0) ...[
              SizedBox(height: 4),
              Text(
                '$count file',
                style: TextStyle(
                  color: AppColors.numberText.withOpacity(0.4),
                  fontSize: 12,
                ),
              ),
            ],
            // Show lock icon for non-VIP
            if (!widget.isVip) ...[
              SizedBox(height: 8),
              Icon(Icons.lock_outline, size: 14, color: Colors.amber.withOpacity(0.5)),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isVip ? "Vault VIP" : "Vault (Lihat Saja)"),
        backgroundColor: AppColors.background,
        actions: [
          if (!widget.isVip)
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                margin: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock, color: Colors.amber, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Gratis',
                      style: TextStyle(color: Colors.amber, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          if (widget.isVip)
            Padding(
              padding: EdgeInsets.only(right: 8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                margin: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'VIP',
                      style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildFolderItem(context, 'Gambar', Icons.image, 'image', Colors.amber),
            _buildFolderItem(context, 'Video', Icons.video_library, 'video', Colors.purpleAccent),
            _buildFolderItem(context, 'Dokumen', Icons.insert_drive_file, 'document', Colors.cyanAccent),
            _buildFolderItem(context, 'Audio', Icons.audiotrack, 'audio', Colors.greenAccent),
          ],
        ),
      ),
    );
  }
}
