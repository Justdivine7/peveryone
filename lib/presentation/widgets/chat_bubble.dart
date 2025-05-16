import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:peveryone/core/constants/message_enum.dart';
import 'package:peveryone/data/model/message_model/message_model.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  const ChatBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isMe
                  ? Theme.of(context).hoverColor
                  : Theme.of(context).indicatorColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (message.type == MessageType.text) Text(message.content),
            if (message.type == MessageType.image)
              Image.network(message.content),
            if (message.type == MessageType.video) Icon(Icons.videocam),
            Text(
              DateFormat.Hm().format(message.sentAt),
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
