import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:peveryone/core/constants/extensions.dart';
import 'package:peveryone/core/helpers/chat_helpers.dart';
import 'package:peveryone/core/helpers/ui_helpers.dart';
import 'package:peveryone/data/model/message_model/message_model.dart';
import 'package:peveryone/presentation/providers/home_view_provider.dart';
import 'package:peveryone/presentation/widgets/app_text_field.dart';
import 'package:peveryone/presentation/widgets/chat_bubble.dart';
import 'package:peveryone/presentation/widgets/error_screen.dart';

class ChatRoom extends ConsumerStatefulWidget {
  final String senderId;
  final String receiverId;
  final String firstName;
  static const routeName = '/chat-room';

  const ChatRoom({
    super.key,
    required this.firstName,
    required this.senderId,
    required this.receiverId,
  });

  @override
  ConsumerState<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends ConsumerState<ChatRoom> {
  final scrollController = ScrollController();
  final TextEditingController _chatController = TextEditingController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  void _handleSend() {
    final text = _chatController.text.trim();
    if (text.isNotEmpty) {
      sendText(text, widget.senderId, widget.receiverId, ref);
      _chatController.clear();
    }
  }

  void _handleMediaPick() async {
    await ref
        .read(homeViewProvider)
        .pickMediaAndSend(context, ref, widget.senderId, widget.receiverId);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatId = [widget.senderId, widget.receiverId]..sort();
    final chatKey = '${chatId[0]}_${chatId[1]}';
    final messagesList = ref.watch(messagesStreamProvider(chatKey));
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {},
          child: Text(widget.firstName.capitalize()),
        ),
        forceMaterialTransparency: true,
        actions: [
          // IconButton(onPressed: () {}, icon: Icon(Iconsax.add_square)),
          IconButton(onPressed: () {}, icon: Icon(Iconsax.video)),
          IconButton(onPressed: () {}, icon: Icon(Iconsax.call)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: messagesList.when(
                data: (messages) {
                  final sentMessages = messages.where(
                    (msg) =>
                        msg.receiverId ==
                            widget.receiverId && // current user is the receiver
                        msg.status == MessageStatus.sent,
                  );

                  if (sentMessages.isNotEmpty) {
                    ref
                        .read(homeViewProvider)
                        .markMessagesAsDelivered(
                          widget.senderId, // current user
                          widget.receiverId, // the one who sent the message
                        );
                  }
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _scrollToBottom(),
                  );
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg.senderId == widget.senderId;
                      return ChatBubble(message: msg, isMe: isMe);
                    },
                  );
                },
                error: (e, _) => ErrorScreen(error: e.toString()),
                loading: () => Center(child: Text('loading conversations')),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    hintText: 'Type message...',
                    textController: _chatController,
                    obscure: false,
                    suffixIcon: GestureDetector(
                      onTap: _handleMediaPick,
                      child: Icon(
                        Icons.photo_outlined,
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width(context, 0.013)),
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
                    onPressed: _handleSend,
                    // handle send action
                  ),
                ),
              ],
            ),
            SizedBox(height: height(context, 0.02)),
          ],
        ),
      ),
    );
  }
}
