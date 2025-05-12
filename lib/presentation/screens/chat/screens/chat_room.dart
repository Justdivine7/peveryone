import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:peveryone/core/constants/ui_helpers.dart';
import 'package:peveryone/presentation/widgets/app_text_field.dart';

class ChatRoom extends StatefulWidget {
  final String userName;
  static const routeName = '/chat-room';

  const ChatRoom({super.key, required this.userName});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _chatController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> messages = [
      {'text': 'Hey there!', 'isMe': false, 'time': '09:00 AM', 'day': 'Today'},
      {
        'text': 'Hi! How are you?',
        'isMe': true,
        'time': '09:01 AM',
        'day': 'Today',
      },
      {
        'text': 'Doing great! What about you?',
        'isMe': false,
        'time': '09:02 AM',
        'day': 'Today',
      },
      {
        'text': 'Yesterday was awesome.',
        'isMe': true,
        'time': '08:00 PM',
        'day': 'Yesterday',
      },
      {
        'text': 'Yes, it was!',
        'isMe': false,
        'time': '08:10 PM',
        'day': 'Yesterday',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        forceMaterialTransparency: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Iconsax.add_square)),
          IconButton(onPressed: () {}, icon: Icon(Iconsax.video)),
          IconButton(onPressed: () {}, icon: Icon(Iconsax.more_circle)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];

                bool showDateLabel = true;
                if (index > 0 && messages[index - 1]['day'] == message['day']) {
                  showDateLabel = false;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showDateLabel)
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).indicatorColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(message['day'], style: TextStyle()),
                        ),
                      ),
                    Align(
                      alignment:
                          message['isMe']
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        margin: EdgeInsets.symmetric(vertical: 4),
                        constraints: BoxConstraints(maxWidth: 250),
                        decoration: BoxDecoration(
                          color:
                              message['isMe']
                                  ? Theme.of(context).hoverColor
                                  : Theme.of(context).indicatorColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              message['isMe']
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['text'],
                              style: TextStyle(
                                color:
                                    message['isMe']
                                        ? Colors.white
                                        : Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              message['time'],
                              style: TextStyle(
                                fontSize: 10,
                                color:
                                    message['isMe']
                                        ? Colors.white70
                                        : Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                
                Expanded(
                  child: AppTextField(
                    hintText: 'Type message...',
                    textController: _chatController,
                    obscure: false,
                    suffixIcon: Icon(Icons.photo_camera_outlined, color: Theme.of(context).dividerColor,),
                  ),
                ),
                SizedBox(width: width (context, 0.013)),
                Container(
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
                  child: IconButton(
                    icon: Icon(Icons.send_rounded),
                    color: Colors.white,
                    onPressed: () {
                      // handle send action
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height(context, 0.02)),
        ],
      ),
    );
  }
}
