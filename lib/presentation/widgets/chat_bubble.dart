import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peveryone/core/constants/message_enum.dart';
import 'package:peveryone/core/helpers/ui_helpers.dart';
import 'package:peveryone/data/model/message_model/message_model.dart';
import 'package:peveryone/presentation/screens/chat/views/image_preview_view.dart';
import 'package:peveryone/presentation/widgets/video_player_widget.dart';
import 'package:peveryone/presentation/widgets/video_thumbnail_widget.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  const ChatBubble({super.key, required this.message, required this.isMe});

  IconData getStatusIcon(MessageStatus status) {
    switch (message.status) {
      case MessageStatus.sending:
        return Icons.access_time;
      case MessageStatus.sent:
        return Icons.check;
      case MessageStatus.delivered:
        return Icons.done_all;
    }
  }

  Color getStatusColor(BuildContext context) {
    return isMe ? Colors.white70 : Colors.black54;
  }

  @override
  Widget build(BuildContext context) {
    final isImage = message.type == MessageType.image;
    final isVideo = message.type == MessageType.video;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding:
            (!isImage && !isVideo) ? EdgeInsets.all(10) : EdgeInsets.all(6),
        decoration: BoxDecoration(
          color:
              isMe
                  ? Theme.of(context).hoverColor
                  : Theme.of(context).shadowColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (message.type == MessageType.text)
              Container(
                constraints: BoxConstraints(maxWidth: width(context, 0.5)),
                child: Text(
                  message.content,
                  style: TextStyle(color: isMe ? Colors.white : Colors.black),
                ),
              ),
            if (isImage)
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/image-preview',
                    arguments: ImagePreviewView(imageUrl: message.content),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: width(context, 0.6),
                        maxHeight: height(context, 0.4),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: message.content,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => CircularProgressIndicator(
                              strokeWidth: 1,
                              color: Colors.white,
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              color: Theme.of(context).indicatorColor,
                              child: Icon(
                                Icons.image,
                                size: 35,
                                color: Theme.of(context).hoverColor,
                              ),
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            if (isVideo)
            buildVideoMessage(context, message),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat.Hm().format(message.sentAt),
                    style: TextStyle(
                      fontSize: 10,
                      color: getStatusColor(context),
                    ),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    Icon(
                      getStatusIcon(message.status),
                      size: 14,
                      color: getStatusColor(context),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildVideoMessage(BuildContext context, MessageModel message) {
    bool _isLocalFile(String path) {
      // Check if it's a network URL
      if (path.startsWith('http://') || path.startsWith('https://')) {
        return false;
      }
      try {
        // Check if it's a local file path
        return File(path).existsSync();
      } catch (e) {
        return false;
      }
    }

    String videoUrl;
    bool isLocal;
    if (message.localFilePath != null &&
        message.localFilePath!.isNotEmpty &&
        _isLocalFile(message.localFilePath!)) {
      videoUrl = message.localFilePath!;
      isLocal = true;
    } else {
      videoUrl = message.content;
      isLocal = _isLocalFile(message.content);
    }
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (_) => Dialog(
                backgroundColor: Colors.black12,
                insetPadding: EdgeInsets.all(16),
                child: Stack(
                  children: [
                    VideoPlayerWidget(videoUrl: videoUrl, isLocal: isLocal),
                    Positioned(
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
        );
      },
      child: SizedBox(
        width: width(context, 0.6),
        height: height(context, 0.3),
        child: VideoThumbnailWidget(videoUrl: videoUrl, isLocal: isLocal),
      ),
    );
  }
}
