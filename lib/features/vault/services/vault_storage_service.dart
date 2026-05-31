import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Model for a stored vault file
class VaultFileData {
  final String name;
  final String folderType; // 'image', 'video', 'document', 'audio'
  final String base64Data; // base64 encoded file bytes
  final String mimeType;
  final DateTime addedAt;

  VaultFileData({
    required this.name,
    required this.folderType,
    required this.base64Data,
    required this.mimeType,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'folderType': folderType,
    'base64Data': base64Data,
    'mimeType': mimeType,
    'addedAt': addedAt.toIso8601String(),
  };

  factory VaultFileData.fromJson(Map<String, dynamic> json) => VaultFileData(
    name: json['name'] ?? '',
    folderType: json['folderType'] ?? '',
    base64Data: json['base64Data'] ?? '',
    mimeType: json['mimeType'] ?? '',
    addedAt: DateTime.tryParse(json['addedAt'] ?? '') ?? DateTime.now(),
  );
}

class VaultStorageService {
  static const String _storageKey = 'vault_files_data';

  /// Get all files for a specific folder type
  static Future<List<VaultFileData>> getFiles(String folderType) async {
    final prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(raw);
      return decoded
          .map((e) => VaultFileData.fromJson(e as Map<String, dynamic>))
          .where((f) => f.folderType == folderType)
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get all files
  static Future<List<VaultFileData>> getAllFiles() async {
    final prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final List<dynamic> decoded = jsonDecode(raw);
      return decoded
          .map((e) => VaultFileData.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Add a file
  static Future<void> addFile(VaultFileData file) async {
    final allFiles = await getAllFiles();
    allFiles.add(file);
    await _saveAll(allFiles);
  }

  /// Remove a file by index within a folder type
  static Future<void> removeFile(String folderType, int index) async {
    final allFiles = await getAllFiles();
    final folderFiles = allFiles.where((f) => f.folderType == folderType).toList();
    if (index >= 0 && index < folderFiles.length) {
      final target = folderFiles[index];
      allFiles.removeWhere((f) =>
          f.name == target.name &&
          f.folderType == target.folderType &&
          f.addedAt == target.addedAt);
      await _saveAll(allFiles);
    }
  }

  /// Save all files
  static Future<void> _saveAll(List<VaultFileData> files) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(files.map((f) => f.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  /// Get count of files in a folder type
  static Future<int> getFileCount(String folderType) async {
    final files = await getFiles(folderType);
    return files.length;
  }
}
