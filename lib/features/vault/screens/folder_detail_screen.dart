import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:open_file/open_file.dart';
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
  bool _isSelectionMode = false;
  Set<int> _selectedIndices = {};
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

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    List<VaultFileData> newFiles = [];
    final int maxFileSizeInBytes = 15 * 1024 * 1024; // Limit 15 MB per file
    int skippedFiles = 0;

    try {
      if (widget.folderType == 'image') {
        final ImagePicker picker = ImagePicker();
        final List<XFile> images = await picker.pickMultiImage(imageQuality: 80);
        for (var image in images) {
          final fileBytes = await image.readAsBytes();
          if (fileBytes.lengthInBytes > maxFileSizeInBytes) {
            skippedFiles++;
            continue;
          }
          final mimeType = 'image/${image.name.split('.').last}';
          newFiles.add(VaultFileData(
            name: image.name,
            folderType: widget.folderType,
            base64Data: base64Encode(fileBytes),
            mimeType: mimeType,
            addedAt: DateTime.now(),
          ));
        }
      } else if (widget.folderType == 'video') {
        final ImagePicker picker = ImagePicker();
        final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
        if (video != null) {
          final fileBytes = await video.readAsBytes();
          if (fileBytes.lengthInBytes > maxFileSizeInBytes) {
            skippedFiles++;
          } else {
            newFiles.add(VaultFileData(
              name: video.name,
              folderType: widget.folderType,
              base64Data: base64Encode(fileBytes),
              mimeType: 'video/${video.name.split('.').last}',
              addedAt: DateTime.now(),
            ));
          }
        }
      } else if (widget.folderType == 'document') {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
          allowMultiple: true,
          withData: true,
        );
        if (result != null) {
          for (var file in result.files) {
            if (file.bytes != null) {
              if (file.bytes!.lengthInBytes > maxFileSizeInBytes) {
                skippedFiles++;
                continue;
              }
              newFiles.add(VaultFileData(
                name: file.name,
                folderType: widget.folderType,
                base64Data: base64Encode(file.bytes!),
                mimeType: 'application/${file.extension}',
                addedAt: DateTime.now(),
              ));
            }
          }
        }
      } else if (widget.folderType == 'audio') {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.audio,
          allowMultiple: true,
          withData: true,
        );
        if (result != null) {
          for (var file in result.files) {
            if (file.bytes != null) {
              if (file.bytes!.lengthInBytes > maxFileSizeInBytes) {
                skippedFiles++;
                continue;
              }
              newFiles.add(VaultFileData(
                name: file.name,
                folderType: widget.folderType,
                base64Data: base64Encode(file.bytes!),
                mimeType: 'audio/${file.extension}',
                addedAt: DateTime.now(),
              ));
            }
          }
        }
      }

      if (newFiles.isNotEmpty) {
        for (var vaultFile in newFiles) {
          await VaultStorageService.addFile(vaultFile);
        }
        await _loadFiles();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.numberText, size: 20),
                  SizedBox(width: 8),
                  Expanded(child: Text('${newFiles.length} file berhasil ditambahkan')),
                ],
              ),
              backgroundColor: Colors.green.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );

          if (skippedFiles > 0) {
            _showSizeLimitWarning(skippedFiles);
          }
        }
      } else {
        if (mounted) {
          setState(() => _isLoading = false);
          if (skippedFiles > 0) {
            _showSizeLimitWarning(skippedFiles);
          }
        }
      }
    } catch (e) {
      debugPrint("Error picking files: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSizeLimitWarning(int count) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.numberText.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.numberText.withOpacity(0.1), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: -5,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 48),
                ),
                SizedBox(height: 24),
                Text(
                  'Batas Ukuran File',
                  style: TextStyle(
                    color: AppColors.numberText,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '$count file gagal ditambahkan karena ukurannya melebihi batas maksimal 15MB per file.\n\nSistem membatasi ukuran file untuk mencegah aplikasi memakan terlalu banyak memori.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.numberText.withOpacity(0.7),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Mengerti',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteFile(int index) async {
    final file = _files[index];
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
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

  void _viewVideo(VaultFileData file) {
    final bytes = base64Decode(file.base64Data);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullScreenVideoViewer(
          videoBytes: bytes,
          fileName: file.name,
        ),
      ),
    );
  }

  void _playAudio(VaultFileData file) {
    final bytes = base64Decode(file.base64Data);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _FullScreenAudioViewer(
          audioBytes: bytes,
          fileName: file.name,
        ),
      ),
    );
  }

  Future<void> _openDocument(VaultFileData file) async {
    try {
      final bytes = base64Decode(file.base64Data);
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/${file.name}');
      await tempFile.writeAsBytes(bytes);
      await OpenFile.open(tempFile.path);
    } catch (e) {
      debugPrint("Error opening document: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuka dokumen')),
        );
      }
    }
  }

  Future<void> _deleteSelectedFiles() async {
    if (_selectedIndices.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Hapus Terpilih', style: TextStyle(color: AppColors.numberText)),
        content: Text(
          'Yakin ingin menghapus ${_selectedIndices.length} file ini secara permanen?',
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
      final indicesList = _selectedIndices.toList()..sort((a, b) => b.compareTo(a));
      for (final index in indicesList) {
        await VaultStorageService.removeFile(widget.folderType, index);
      }
      setState(() {
        _isSelectionMode = false;
        _selectedIndices.clear();
      });
      await _loadFiles();
    }
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
              padding: EdgeInsets.only(right: 8),
              child: IconButton(
                icon: Icon(
                  _isSelectionMode ? Icons.close : Icons.checklist,
                  color: AppColors.numberText,
                ),
                onPressed: () {
                  setState(() {
                    _isSelectionMode = !_isSelectionMode;
                    _selectedIndices.clear();
                  });
                },
              ),
            ),
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
      floatingActionButton: (_isSelectionMode && _selectedIndices.isNotEmpty)
          ? FloatingActionButton(
              onPressed: _deleteSelectedFiles,
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.delete, color: Colors.white, size: 28),
            )
          : (widget.isVip && !_isSelectionMode)
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
            onTap: () {
              if (_isSelectionMode) {
                setState(() {
                  if (_selectedIndices.contains(index)) {
                    _selectedIndices.remove(index);
                  } else {
                    _selectedIndices.add(index);
                  }
                });
              } else {
                _viewImage(file);
              }
            },
            onLongPress: widget.isVip ? () {
              if (!_isSelectionMode) {
                setState(() {
                  _isSelectionMode = true;
                  _selectedIndices.add(index);
                });
              }
            } : null,
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
                          color: AppColors.surfaceVariant,
                          child: Icon(Icons.broken_image, color: AppColors.numberText.withOpacity(0.38)),
                        ),
                      ),
                    ),
                  ),
                ),
                if (_isSelectionMode)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _selectedIndices.contains(index) ? Colors.redAccent : Colors.black45,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: _selectedIndices.contains(index)
                          ? Icon(Icons.check, color: Colors.white, size: 16)
                          : null,
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
                backgroundColor: AppColors.surface,
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
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isSelectionMode && _selectedIndices.contains(index)
                    ? Colors.redAccent.withOpacity(0.5)
                    : AppColors.numberText.withOpacity(0.10),
                width: _isSelectionMode && _selectedIndices.contains(index) ? 1.5 : 1.0,
              ),
            ),
            child: ListTile(
              onTap: () {
                if (_isSelectionMode) {
                  setState(() {
                    if (_selectedIndices.contains(index)) {
                      _selectedIndices.remove(index);
                    } else {
                      _selectedIndices.add(index);
                    }
                  });
                } else {
                  if (widget.folderType == 'video') {
                    _viewVideo(file);
                  } else if (widget.folderType == 'audio') {
                    _playAudio(file);
                  } else if (widget.folderType == 'document') {
                    _openDocument(file);
                  }
                }
              },
              onLongPress: widget.isVip ? () {
                if (!_isSelectionMode) {
                  setState(() {
                    _isSelectionMode = true;
                    _selectedIndices.add(index);
                  });
                }
              } : null,
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
              trailing: _isSelectionMode
                  ? Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _selectedIndices.contains(index) ? Colors.redAccent : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedIndices.contains(index) ? Colors.redAccent : AppColors.numberText.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: _selectedIndices.contains(index)
                          ? Icon(Icons.check, color: Colors.white, size: 16)
                          : null,
                    )
                  : (widget.isVip
                      ? IconButton(
                          icon: Icon(Icons.delete_outline, color: AppColors.numberText.withOpacity(0.38), size: 20),
                          onPressed: () => _deleteFile(index),
                        )
                      : null),
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

/// Full screen video player
class _FullScreenVideoViewer extends StatefulWidget {
  final Uint8List videoBytes;
  final String fileName;

  const _FullScreenVideoViewer({
    required this.videoBytes,
    required this.fileName,
  });

  @override
  State<_FullScreenVideoViewer> createState() => _FullScreenVideoViewerState();
}

class _FullScreenVideoViewerState extends State<_FullScreenVideoViewer> {
  VideoPlayerController? _videoPlayerController;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/${widget.fileName}');
      await tempFile.writeAsBytes(widget.videoBytes);

      _videoPlayerController = VideoPlayerController.file(tempFile)
        ..setLooping(false)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
            _videoPlayerController?.play();
          }
        });

      _videoPlayerController?.addListener(() {
        if (mounted) setState(() {});
      });
    } catch (e) {
      debugPrint("Video init error: $e");
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  void _replayVideo() {
    _videoPlayerController?.seekTo(Duration.zero);
    _videoPlayerController?.play();
  }

  @override
  Widget build(BuildContext context) {
    final isFinished = _videoPlayerController?.value.isInitialized == true &&
        _videoPlayerController?.value.position == _videoPlayerController?.value.duration;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.fileName, style: TextStyle(fontSize: 14)),
      ),
      body: Center(
        child: _hasError
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                  SizedBox(height: 16),
                  Text("Gagal memuat video", style: TextStyle(color: Colors.white)),
                ],
              )
            : _isInitialized && _videoPlayerController != null
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _videoPlayerController!.value.aspectRatio,
                        child: VideoPlayer(_videoPlayerController!),
                      ),
                      if (isFinished)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            iconSize: 64,
                            icon: Icon(Icons.replay, color: Colors.white),
                            onPressed: _replayVideo,
                          ),
                        )
                      else if (!_videoPlayerController!.value.isPlaying)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            iconSize: 64,
                            icon: Icon(Icons.play_arrow, color: Colors.white),
                            onPressed: () {
                              _videoPlayerController?.play();
                            },
                          ),
                        ),
                      // Pause button when playing (optional, can just tap to pause)
                      if (_videoPlayerController!.value.isPlaying)
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () {
                              _videoPlayerController?.pause();
                            },
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                    ],
                  )
                : CircularProgressIndicator(color: Colors.purpleAccent),
      ),
    );
  }
}

/// Full screen audio player
class _FullScreenAudioViewer extends StatefulWidget {
  final Uint8List audioBytes;
  final String fileName;

  const _FullScreenAudioViewer({
    required this.audioBytes,
    required this.fileName,
  });

  @override
  State<_FullScreenAudioViewer> createState() => _FullScreenAudioViewerState();
}

class _FullScreenAudioViewerState extends State<_FullScreenAudioViewer> {
  VideoPlayerController? _audioController;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/${widget.fileName}');
      await tempFile.writeAsBytes(widget.audioBytes);

      _audioController = VideoPlayerController.file(tempFile)
        ..setLooping(false)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
            _audioController?.play();
          }
        });

      _audioController?.addListener(() {
        if (mounted) setState(() {});
      });
    } catch (e) {
      debugPrint("Audio init error: $e");
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _audioController?.dispose();
    super.dispose();
  }

  void _replayAudio() {
    _audioController?.seekTo(Duration.zero);
    _audioController?.play();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final isFinished = _audioController?.value.isInitialized == true &&
        _audioController?.value.position == _audioController?.value.duration;
        
    final position = _audioController?.value.position ?? Duration.zero;
    final duration = _audioController?.value.duration ?? Duration.zero;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.fileName, style: TextStyle(fontSize: 14)),
      ),
      body: Center(
        child: _hasError
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                  SizedBox(height: 16),
                  Text("Gagal memuat audio", style: TextStyle(color: AppColors.numberText)),
                ],
              )
            : _isInitialized && _audioController != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.music_note, size: 80, color: Colors.greenAccent),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(position), style: TextStyle(color: AppColors.numberText)),
                            Text(_formatDuration(duration), style: TextStyle(color: AppColors.numberText.withOpacity(0.7))),
                          ],
                        ),
                      ),
                      Slider(
                        activeColor: Colors.greenAccent,
                        inactiveColor: Colors.greenAccent.withOpacity(0.3),
                        value: position.inSeconds.toDouble(),
                        max: duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          _audioController?.seekTo(Duration(seconds: value.toInt()));
                        },
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          iconSize: 64,
                          icon: Icon(
                            isFinished 
                                ? Icons.replay 
                                : (_audioController!.value.isPlaying ? Icons.pause : Icons.play_arrow), 
                            color: Colors.greenAccent
                          ),
                          onPressed: () {
                            if (isFinished) {
                              _replayAudio();
                            } else if (_audioController!.value.isPlaying) {
                              _audioController?.pause();
                            } else {
                              _audioController?.play();
                            }
                          },
                        ),
                      ),
                    ],
                  )
                : CircularProgressIndicator(color: Colors.greenAccent),
      ),
    );
  }
}
