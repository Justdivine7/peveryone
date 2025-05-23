import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peveryone/core/constants/extensions.dart';
import 'package:peveryone/core/constants/message_enum.dart';
import 'package:peveryone/data/model/inbox_model/inbox_model.dart';
import 'package:peveryone/presentation/screens/chat/views/chat_room.dart';

class InboxTile extends StatelessWidget {
  final InboxModel inbox;
  final FirebaseAuth auth;
  const InboxTile({super.key, required this.inbox, required this.auth});

  @override
  Widget build(BuildContext context) {
    debugPrint(
      'InboxTile - Chat: ${inbox.chatWithName}, UnreadCount: ${inbox.unreadCount}',
    );

    return ListTile(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/chat-room',
          arguments: ChatRoom(
            senderId: auth.currentUser!.uid,
            receiverId: inbox.chatWith,
            firstName: inbox.chatWithName,
          ),
        );
      },
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Theme.of(context).focusColor,
        backgroundImage:
            (inbox.chatWithPhotoUrl != null &&
                    inbox.chatWithPhotoUrl!.isNotEmpty)
                ? CachedNetworkImageProvider(inbox.chatWithPhotoUrl!)
                    as ImageProvider
                : const AssetImage('assets/images/dummy.png'),
      ),
      title: Text(inbox.chatWithName.capitalize()),
      subtitle: buildLastMessage(inbox.lastMessage, inbox.lastMessageType),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_formatTime(inbox.lastTimestamp)),
          if (inbox.unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).highlightColor,
                    Theme.of(context).hoverColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                '${inbox.unreadCount}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  Widget buildLastMessage(String message, MessageType type) {
    return type == MessageType.image
        ? const Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text('🖼️'), SizedBox(width: 4), Text('Image')],
        )
        : type == MessageType.video
        ? const Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text('📹'), SizedBox(width: 4), Text('Video')],
        )
        : Text(message, maxLines: 1, overflow: TextOverflow.ellipsis);
  }
}
