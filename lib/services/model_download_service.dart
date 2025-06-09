// lib/services/model_download_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:slm_model_detector/services/slm_model_service.dart';

class ModelDownloadService {
  static final Dio _dio = Dio();

  static Future<bool> requestPermissions() async {
    // For Android 11+ (API 30+), we need to handle scoped storage differently
    if (Platform.isAndroid) {
      // Check Android version and request appropriate permissions
      final deviceInfo = await DeviceInfoPlugin().androidInfo;

      if (deviceInfo.version.sdkInt >= 30) {
        // Android 11+ - Use manage external storage for full access
        if (await Permission.manageExternalStorage.isGranted) {
          return true;
        }

        final status = await Permission.manageExternalStorage.request();
        return status.isGranted;
      } else {
        // Android 10 and below - Use regular storage permissions
        if (await Permission.storage.isGranted) {
          return true;
        }

        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }

    return true; // For iOS or other platforms
  }

  static Future<String> getModelPath(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final modelDir = Directory('${directory.path}/models');
    if (!await modelDir.exists()) {
      await modelDir.create(recursive: true);
    }
    return '${modelDir.path}/$filename';
  }

  static Future<bool> isModelDownloaded(String filename) async {
    final path = await getModelPath(filename);
    return File(path).exists();
  }

  static Future<void> downloadModel(
    ModelInfo modelInfo,
    Function(double) onProgress,
  ) async {
    try {
      final path = await getModelPath(modelInfo.filename);

      if (await File(path).exists()) {
        onProgress(1.0);
        return;
      }

      await _dio.download(
        modelInfo.downloadUrl,
        path,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress(received / total);
          }
        },
      );
    } catch (e) {
      throw Exception('Failed to download model: $e');
    }
  }

  static Future<void> deleteModel(String filename) async {
    final path = await getModelPath(filename);
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<List<String>> getDownloadedModels() async {
    final directory = await getApplicationDocumentsDirectory();
    final modelDir = Directory('${directory.path}/models');

    if (!await modelDir.exists()) {
      return [];
    }

    final files = await modelDir.list().toList();
    return files
        .where((file) => file is File && file.path.endsWith('.gguf'))
        .map((file) => file.path.split('/').last)
        .toList();
  }
}
