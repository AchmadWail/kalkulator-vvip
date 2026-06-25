import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../services/vault_storage_service.dart';

class FolderDetailScreen extends StatefulWidget {
  final String title;
  final String folderType; // 'image', 'video', 'document', 'audio'
  final bool isVip;

  FolderDetailScreen({
    Key? key,
    required this.title,
    required this.folderType,
    this.isVip = false,
  }) : super(key: key);

  @override
  State<FolderDetailScreen> createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen>
    with SingleTickerProviderStateMixin {
  List<VaultFileData> _files = [];
  bool _isLoading = true;
  late AnimationController _fabAnimController;

  @override
  void initState() {
    super.initState();
    _fabAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _loadFiles();
  }

  @override
  void dispose() {
    _fabAnimController.dispose();
    super.dispose();
  }

  Future<void> _loadFiles() async {
    final files = await VaultStorageService.getFiles(widget.folderType);
    if (mounted) {
      setState(() {
        _files = files;
        _isLoading = false;
      });
    }
  }

  void _addMedia() async {
    if (!widget.isVip) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Akses VIP diperlukan untuk menambah file."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    Uint8List? fileBytes;
    String? fileName;
    String mimeType = '';

    if (widget.folderType == 'image') {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        fileBytes = await image.readAsBytes();
        fileName = image.name;
        mimeType = 'image/${image.name.split('.').last}';
      }
    } else if (widget.folderType == 'video') {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        fileBytes = await video.readAsBytes();
        fileName = video.name;
        mimeType = 'video/${video.name.split('.').last}';
      }
    } else if (widget.folderType == 'document') {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
        withData: true,
      );
      if (result != null && result.files.single.bytes != null) {
        fileBytes = result.files.single.bytes!;
        fileName = result.files.single.name;
        mimeType = 'application/${result.files.single.extension}';
      }
    } else if (widget.folderType == 'audio') {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.audio,
        withData: true,
      );
      if (result != null && result.files.single.bytes != null) {
        fileBytes = result.files.single.bytes!;
        fileName = result.files.single.name;
        mimeType = 'audio/${result.files.single.extension}';
      }
    }

    if (fileBytes != null && fileName != null) {
      final base64 = base64Encode(fileBytes);
      final vaultFile = VaultFileData(
        name: fileName,
        folderType: widget.folderType,
        base64Data: base64,
        mimeType: mimeType,
        addedAt: DateTime.now(),
      );
      await VaultStorageService.addFile(vaultFile);
      await _loadFiles();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.numberText, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text('$fileName berhasil ditambahkan')),
              ],
            ),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  Future<void> _deleteFile(int index) async {
    final file = _files[index];
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Hapus File', style: TextStyle(color: AppColors.numberText)),
        content: Text(
          'Yakin ingin menghapus "${file.name}"?',
          style: TextStyle(color: AppColors.numberText.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Batal', style: TextStyle(color: AppColors.numberText.withOpacity(0.54))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Hapus', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await VaultStorageService.removeFile(widget.folderType, index);
      await _loadFiles();
    }
  }

  void _viewImage(VaultFileData file) {
    final bytes = base64Decode(file.base64Data);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullScreenImageViewer(
          imageBytes: bytes,
          fileName: file.name,
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (widget.folderType) {
      case 'image':
        return Icons.image;
      case 'video':
        return Icons.video_collection;
      case 'document':
        return Icons.insert_drive_file;
      case 'audio':
        return Icons.audiotrack;
      default:
        return Icons.folder;
    }
  }

  Color _getAccentColor() {
    switch (widget.folderType) {
      case 'image':
        return Colors.amber;
      case 'video':
        return Colors.purpleAccent;
      case 'document':
        return Colors.cyanAccent;
      case 'audio':
        return Colors.greenAccent;
      default:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accent = _getAccentColor();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.background,
        actions: [
          if (widget.isVip && _files.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_files.length} file',
                    style: TextStyle(color: accent, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: accent),
            )
          : _files.isEmpty
              ? _buildEmptyState(accent)
              : _buildFileGrid(),
      // Only show FAB for VIP users
      floatingActionButton: widget.isVip
          ? FloatingActionButton(
              onPressed: _addMedia,
              backgroundColor: accent,
              child: Icon(Icons.add, color: AppColors.background, size: 28),
            )
          : null,
    );
  }

  Widget _buildEmptyState(Color accent) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getIcon(),
            size: 80,
            color: accent.withOpacity(0.3),
          ),
          SizedBox(height: 20),
          Text(
            widget.isVip
                ? 'Folder ${widget.title} kosong'
                : 'Folder ${widget.title} kosong',
            style: TextStyle(color: AppColors.numberText.withOpacity(0.54), fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            widget.isVip
                ? 'Tekan + untuk menambahkan file'
                : 'Upgrade ke VIP untuk menambahkan file',
            style: TextStyle(
              color: AppColors.numberText.withOpacity(0.3),
              fontSize: 14,
            ),
          ),
          if (!widget.isVip) ...[
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock, color: Colors.amber, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Fitur VIP',
                    style: TextStyle(color: Colors.amber, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFileGrid() {
    if (widget.folderType == 'image') {
      return _buildImageGrid();
    }
    return _buildFileList();
  }

  Widget _buildImageGrid() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: _files.length,
        itemBuilder: (context, index) {
          final file = _files[index];
          final bytes = base64Decode(file.base64Data);
          return GestureDetector(
            onTap: () => _viewImage(file),
            onLongPress: widget.isVip ? () => _deleteFile(index) : null,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: 'image_$index',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.numberText.withOpacity(0.10), width: 0.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        bytes,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[900],
                          child: Icon(Icons.broken_image, color: AppColors.numberText.withOpacity(0.38)),
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.isVip)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent, size: 20),
                        padding: EdgeInsets.all(4),
                        constraints: BoxConstraints(),
                        onPressed: () => _deleteFile(index),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFileList() {
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: _files.length,
      itemBuilder: (context, index) {
        final file = _files[index];
        final accent = _getAccentColor();
        return Dismissible(
          key: ValueKey('${file.name}_${file.addedAt.toIso8601String()}'),
          direction: widget.isVip ? DismissDirection.endToStart : DismissDirection.none,
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.delete, color: Colors.redAccent),
          ),
          confirmDismiss: (_) async {
            if (!widget.isVip) return false;
            return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: Color(0xFF1C1C1E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: Text('Hapus File', style: TextStyle(color: AppColors.numberText)),
                content: Text(
                  'Yakin ingin menghapus "${file.name}"?',
                  style: TextStyle(color: AppColors.numberText.withOpacity(0.7)),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text('Batal', style: TextStyle(color: AppColors.numberText.withOpacity(0.54))),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text('Hapus', style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            );
          },
          onDismissed: (_) async {
            await VaultStorageService.removeFile(widget.folderType, index);
            await _loadFiles();
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.numberText.withOpacity(0.10)),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_getIcon(), color: accent, size: 24),
              ),
              title: Text(
                file.name,
                style: TextStyle(color: AppColors.numberText, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                _formatDate(file.addedAt),
                style: TextStyle(color: AppColors.numberText.withOpacity(0.4), fontSize: 12),
              ),
              trailing: widget.isVip
                  ? IconButton(
                      icon: Icon(Icons.delete_outline, color: AppColors.numberText.withOpacity(0.38), size: 20),
                      onPressed: () => _deleteFile(index),
                    )
                  : null,
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

/// Full screen image viewer
class _FullScreenImageViewer extends StatelessWidget {
  final Uint8List imageBytes;
  final String fileName;

  const _FullScreenImageViewer({
    required this.imageBytes,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          fileName,
          style: TextStyle(fontSize: 14, color: AppColors.numberText.withOpacity(0.70)),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.memory(
            imageBytes,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(
              Icons.broken_image,
              color: AppColors.numberText.withOpacity(0.38),
              size: 80,
            ),
          ),
        ),
      ),
    );
  }
}
