// lib/services/phone_detector_service.dart
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class PhoneDetectorService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static Future<String> getPhoneModel() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        String brand = androidInfo.brand.toLowerCase();
        String model = androidInfo.model.toLowerCase();
        String product = androidInfo.product.toLowerCase();

        return _normalizePhoneModel(brand, model, product);
      }
      return 'unknown';
    } catch (e) {
      print('Error detecting phone model: $e');
      return 'unknown';
    }
  }

  static String _normalizePhoneModel(
      String brand, String model, String product) {
    String fullModel = '$brand $model'.toLowerCase();

    // Samsung Galaxy Series
    if (fullModel.contains('samsung') && fullModel.contains('galaxy')) {
      if (fullModel.contains('s24 ultra')) return 'Samsung Galaxy S24 Ultra';
      if (fullModel.contains('s24')) return 'Samsung Galaxy S24';
      if (fullModel.contains('s25 ultra')) return 'Samsung Galaxy S25 Ultra';
      if (fullModel.contains('z fold 6') || fullModel.contains('zfold6'))
        return 'Samsung Galaxy Z Fold 6';
      if (fullModel.contains('z flip 6') || fullModel.contains('zflip6'))
        return 'Samsung Galaxy Z Flip 6';
      if (fullModel.contains('a54')) return 'Samsung Galaxy A54 5G';
      if (fullModel.contains('a15')) return 'Samsung Galaxy A15';
    }

    // Google Pixel Series
    if (fullModel.contains('pixel')) {
      if (fullModel.contains('9 pro')) return 'Google Pixel 9 Pro';
      if (fullModel.contains('8 pro')) return 'Google Pixel 8 Pro';
      if ((fullModel.contains('pixel 9') || fullModel.contains('Pixel9')) &&
          !fullModel.contains('pro')) return 'Google Pixel 9';
      if (fullModel.contains('8a')) return 'Google Pixel 8a';
    }

    // Motorola Series
    if (fullModel.contains('motorola')) {
      if (fullModel.contains('razr') && fullModel.contains('50 ultra'))
        return 'Motorola Razr 50 Ultra';
      if (fullModel.contains('edge 50 pro')) return 'Motorola Edge 50 Pro';
      if (fullModel.contains('edge 50')) return 'Motorola Edge 50';
    }

    // Xiaomi Series
    if (fullModel.contains('xiaomi')) {
      if (fullModel.contains('13 pro')) return 'Xiaomi 13 Pro';
      if (fullModel.contains('14 ultra')) return 'Xiaomi 14 Ultra';
    }

    // OnePlus Series
    if (fullModel.contains('oneplus')) {
      if (fullModel.contains('12')) return 'OnePlus 12';
      if (fullModel.contains('open')) return 'OnePlus Open';
    }

    // Sony Xperia
    if (fullModel.contains('sony') && fullModel.contains('xperia 5v')) {
      return 'Sony Xperia 5V';
    }

    // Huawei
    if (fullModel.contains('huawei') && fullModel.contains('mate 60 pro')) {
      return 'Huawei Mate 60 Pro';
    }

    return 'Unknown Device';
  }
}
