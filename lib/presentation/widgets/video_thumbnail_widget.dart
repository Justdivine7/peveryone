import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;
  final bool isLocal;

  const VideoThumbnailWidget({
    super.key,
    required this.videoUrl,
    this.isLocal = false,
  });

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  Uint8List? _thumbnail;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: widget.videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 300, // Thumbnail width
      quality: 75,
    );

    if (mounted) {
      setState(() => _thumbnail = uint8list);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_thumbnail != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(_thumbnail!, fit: BoxFit.cover),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        color: Colors.black12,
        child: const CircularProgressIndicator(),
      );
    }
  }
}
