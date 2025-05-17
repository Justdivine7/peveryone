import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';

Future<File> compressImage(File file) async {
  final targetPath =
      '${file.parent.path}/compressed_${file.uri.pathSegments.last}';

  final result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 70,
  );

  if (result != null) {
    final fileResult = File(result.path); // <-- convert XFile to File
    debugPrint('Compressed image size: ${await fileResult.length()} bytes');
    return fileResult;
  } else {
    debugPrint('Image compression failed, using original.');
    return file;
  }
}

Future<File> compressVideo(File file) async {
  final info = await VideoCompress.compressVideo(
    file.path,
    quality: VideoQuality.MediumQuality,
    deleteOrigin: false,
  );

  if (info?.file != null) {
    debugPrint('Compressed video size: ${await info!.file!.length()} bytes');
    return info.file!;
  } else {
    debugPrint('Video compression failed, using original.');
    return file;
  }
}
