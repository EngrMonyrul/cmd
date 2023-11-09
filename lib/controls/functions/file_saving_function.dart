import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> saveFileToDirectory({required String subDirectory}) async {
  Directory? directory;
  String newDir = '';
  String name = DateTime.now().millisecondsSinceEpoch.toString();

  try {
    if (Platform.isAndroid) {
      if (await checkStoragePermission()) {
        directory = await getExternalStorageDirectory();
        if (directory != null) {
          List<String> folders = directory.path.split('/');
          for (int i = 0; i < folders.length; i++) {
            String folder = folders[i];
            if (folder != 'Android') {
              newDir += '$folder/';
            } else {
              break;
            }
          }

          newDir += subDirectory;
          directory = Directory(newDir);

          if (await directory.exists()) {
            return directory.path;
          } else {
            directory.createSync(recursive: true);
          }
        } else {}
      } else {}
    } else {
      if (await checkStoragePermission()) {
        directory = await getTemporaryDirectory();
      }
    }
  } catch (e) {
    debugPrint("file saving failed: $e");
    return "";
  }

  return '';
}

Future<bool> checkStoragePermission() async {
  if (Platform.isAndroid) {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
    if ((info.version.sdkInt) <= 29) {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        return true;
      }
      if (status.isDenied) {
        await Permission.storage.request();
      }
      if (status.isPermanentlyDenied) {
        openAppSettings();
      }
    } else {
      var status = await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        return true;
      }
      if (status.isDenied) {
        await Permission.manageExternalStorage.request();
      }
      if (status.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  } else {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    }
    if (status.isDenied) {
      await Permission.storage.request();
    }
    if (status.isPermanentlyDenied) {}
  }
  return false;
}
