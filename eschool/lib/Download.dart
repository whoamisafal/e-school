import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadFile {
  final String fileName;
  final String url;

  DownloadFile(this.fileName, this.url);
  downloadStart() async {
    FlutterDownloader.initialize();
    final status = await Permission.storage.request();

    if (status.isGranted) {
      final externalDir = await createFolder();

      await FlutterDownloader.enqueue(
        url: url,
        savedDir: externalDir.path,
        fileName: fileName + ".pdf",
        showNotification: true,
        openFileFromNotification: true,
      );
    } else {
      print("Permission denied");
    }
  }
}

createFolder() async {
  PermissionStatus permissionStatus = await Permission.storage.request();
  if (permissionStatus == PermissionStatus.granted) {
    var root = await getExternalStorageDirectory();
    Directory dir = Directory('${root.path}/smartSchool');
    if (await dir.exists()) {
      print("Already created a directory " + dir.path);
      return dir;
    } else {
      dir.create(recursive: true);
      print("Created a directory " + dir.path);
      return dir;
    }
  }
}
