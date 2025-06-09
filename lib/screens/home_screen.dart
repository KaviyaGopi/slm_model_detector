// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../services/phone_detector_service.dart';
import '../services/slm_model_service.dart';
import '../services/model_download_service.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _phoneModel = 'Detecting...';
  ModelInfo? _recommendedModel;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  bool _isModelDownloaded = false;
  List<String> _downloadedModels = [];

  @override
  void initState() {
    super.initState();
    _detectPhoneAndModel();
    _checkDownloadedModels();
  }

  Future<void> _detectPhoneAndModel() async {
    try {
      final phoneModel = await PhoneDetectorService.getPhoneModel();
      final modelInfo = SLMModelService.getModelForPhone(phoneModel) ??
          SLMModelService.getDefaultModel();

      final isDownloaded =
          await ModelDownloadService.isModelDownloaded(modelInfo.filename);

      setState(() {
        _phoneModel = phoneModel;
        _recommendedModel = modelInfo;
        _isModelDownloaded = isDownloaded;
      });
    } catch (e) {
      setState(() {
        _phoneModel = 'Detection failed';
      });
    }
  }

  Future<void> _checkDownloadedModels() async {
    final models = await ModelDownloadService.getDownloadedModels();
    setState(() {
      _downloadedModels = models;
    });
  }

  Future<void> _downloadModel() async {
    if (_recommendedModel == null) return;

    final hasPermission = await ModelDownloadService.requestPermissions();
    if (!hasPermission) {
      _showMessage(
          'Storage permission is required to download models. Please grant permission in Settings.');
      // Open app settings if permission is permanently denied
      if (await Permission.storage.isPermanentlyDenied ||
          await Permission.manageExternalStorage.isPermanentlyDenied) {
        await openAppSettings();
      }
      return;
    }

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    try {
      await ModelDownloadService.downloadModel(
        _recommendedModel!,
        (progress) {
          setState(() {
            _downloadProgress = progress;
          });
        },
      );

      setState(() {
        _isDownloading = false;
        _isModelDownloaded = true;
      });

      _showMessage('Model downloaded successfully!');
      _checkDownloadedModels();
    } catch (e) {
      setState(() {
        _isDownloading = false;
      });
      _showMessage('Download failed: $e');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SLM Model Detector'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Device Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Phone Model: $_phoneModel'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_recommendedModel != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recommended Model',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Model: ${_recommendedModel!.modelName}'),
                      const SizedBox(height: 8),
                      Text('Repository: ${_recommendedModel!.repository}'),
                      const SizedBox(height: 8),
                      Text('Description: ${_recommendedModel!.description}'),
                      const SizedBox(height: 16),
                      if (_isDownloading) ...[
                        LinearProgressIndicator(value: _downloadProgress),
                        const SizedBox(height: 8),
                        Text(
                            'Downloading... ${(_downloadProgress * 100).toStringAsFixed(1)}%'),
                      ] else if (_isModelDownloaded) ...[
                        const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 8),
                            Text('Model downloaded and ready!'),
                          ],
                        ),
                      ] else ...[
                        ElevatedButton(
                          onPressed: _downloadModel,
                          child: const Text('Download Model'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (_downloadedModels.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Downloaded Models',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._downloadedModels.map((model) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                const Icon(Icons.file_download_done,
                                    color: Colors.green),
                                const SizedBox(width: 8),
                                Expanded(child: Text(model)),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _detectPhoneAndModel();
          _checkDownloadedModels();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
