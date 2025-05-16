import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:video_compress/video_compress.dart';

Future<File> compressImage(File file) async {
  final targetPath =
      '${file.parent.path}/compressed_${file.uri.pathSegments.last}';

  final result =
      await FlutterImageCompress.compressAndGetFile(
            file.absolute.path,
            targetPath,
            quality: 70,
          )
          as File?;

  // If compression failed, return the original file
  return result ?? file;
}

Future<File> compressVideo(File file) async {
  final info = await VideoCompress.compressVideo(
    file.path,
    quality: VideoQuality.MediumQuality,
    deleteOrigin: false,
  );
  return info?.file ?? file;
}
