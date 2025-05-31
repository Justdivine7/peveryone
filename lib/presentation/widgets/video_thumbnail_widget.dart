
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
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    try {
      final uint8list = await VideoThumbnail.thumbnailData(
        video: widget.videoUrl,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 300, // Thumbnail width
        quality: 75,
      );

      if (mounted) {
        setState(() {
          _thumbnail = uint8list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
    debugPrint(_error);
         return Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.videocam_off,
                size: 40,
                color: Theme.of(context).hoverColor,
              ),
              SizedBox(height: 8),
              Text(
                'Video preview unavailable',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }
    if(_isLoading){
       return Container(
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ); 
    }
    
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            _thumbnail!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(12),
          child: const Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 30,
          ),
        ),
      ],
    );
  }
}