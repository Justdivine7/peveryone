import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:peveryone/core/constants/extensions.dart';
import 'package:peveryone/core/helpers/ui_helpers.dart';
import 'package:peveryone/presentation/providers/auth_provider.dart';
import 'package:peveryone/presentation/providers/general_providers/inbox_search_provider.dart';
import 'package:peveryone/presentation/providers/inbox_provider.dart';
import 'package:peveryone/presentation/screens/chat/views/chat_room.dart';
import 'package:peveryone/presentation/widgets/app_alert_dialog.dart';
import 'package:peveryone/presentation/widgets/app_text_field.dart';
import 'package:peveryone/presentation/widgets/error_screen.dart';

class InboxView extends ConsumerStatefulWidget {
  static const routeName = '/inbox-screen';

  const InboxView({super.key});

  @override
  ConsumerState<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends ConsumerState<InboxView> {
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref.read(inboxSearchProvider.notifier).state =
          _searchController.text.trim();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void logout() async {
    final auth = ref.read(authRepositoryProvider);
    await auth.signOut();
  }

  String _formatTime(DateTime dateTime) {
    // Return formatted string like "10:30 AM" or "Yesterday"
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final inboxAsync = ref.watch(inboxProvider(auth.currentUser!.uid));
    final searchQuery = ref.watch(inboxSearchProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text('Inbox'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Iconsax.add_square)),
          IconButton(onPressed: () {}, icon: Icon(Iconsax.more_circle)),
          IconButton(
            onPressed: () {
              appAlertDialog(
                context: context,
                title: 'Sign out',
                content: 'Are you sure you want to sign out',
                confirmText: 'Yes',
                cancelText: 'Cancel',
                onConfirm: () async {
                  final auth = ref.read(authRepositoryProvider);
                  await auth.signOut();
                },
              );
            },
            icon: Icon(Iconsax.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                hintText: 'Search',
                textController: _searchController,
                obscure: false,
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).dividerColor,
                ),
              ),
              SizedBox(height: height(context, 0.02)),

              Text('Messages'),
              inboxAsync.when(
                data: (inboxList) {
                  final filteredList =
                      inboxList.where((inbox) {
                        final searchLower = searchQuery.toLowerCase();
                        return inbox.chatWithName.toLowerCase().contains(
                          searchLower,
                        );
                        // ||
                        // inbox.lastMessage.toLowerCase().contains(
                        //   searchLower,
                        // );
                      }).toList();
                  if (filteredList.isEmpty) {
                    return Center(child: Text('No chats yet'));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final inbox = filteredList[index];
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
                          backgroundColor: Theme.of(context).focusColor,
                          backgroundImage:
                              inbox.chatWithPhotoUrl != null &&
                                      inbox.chatWithPhotoUrl!.isNotEmpty
                                  ? NetworkImage(inbox.chatWithPhotoUrl!)
                                  : AssetImage(
                                    'assets/images/dummy-user-picture.png',
                                  ),
                        ),

                        title: Text(inbox.chatWithName.capitalize()),
                        subtitle: Text(inbox.lastMessage),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_formatTime(inbox.lastTimestamp)),
                            if (inbox.unreadCount > 0)
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Text('${inbox.unreadCount}'),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
                error: (e, StackTrace) {
                  print('Inbox view: ${e.toString()}');
                  return ErrorScreen(error: e.toString());
                },
                loading: () => Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
