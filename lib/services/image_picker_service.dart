import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Pick an image from the specified [source] (Camera or Gallery).
  /// Returns an [XFile] if successful, or null if cancelled/failed.
  Future<XFile?> pickImage(ImageSource source) async {
    // 1. Check Permissions (Mobile Only)
    if (!kIsWeb) {
      final hasPermission = await _checkAndRequestPermission(source);
      if (!hasPermission) {
        debugPrint("❌ Permission denied for $source");
        return null;
      }
    }

    // 2. Pick Image
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Optimize image size
      );
      return image;
    } catch (e) {
      debugPrint("❌ Error picking image: $e");
      return null;
    }
  }

  /// Handles permission logic for Android and iOS
  Future<bool> _checkAndRequestPermission(ImageSource source) async {
    Permission permission;

    if (source == ImageSource.camera) {
      permission = Permission.camera;
    } else {
      // Gallery Logic
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 33) {
          permission = Permission.photos; // Android 13+
        } else {
          permission = Permission.storage; // Older Android
        }
      } else {
        permission = Permission.photos; // iOS
      }
    }

    final status = await permission.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    } else if (status.isPermanentlyDenied) {
      // Open settings if permanently denied
      await openAppSettings();
      return false;
    }

    return true;
  }
}