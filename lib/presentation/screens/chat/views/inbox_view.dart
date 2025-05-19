import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:peveryone/core/helpers/ui_helpers.dart';
import 'package:peveryone/presentation/providers/auth_provider.dart';
import 'package:peveryone/presentation/providers/general_providers/inbox_search_provider.dart';
import 'package:peveryone/presentation/providers/inbox_provider.dart';
import 'package:peveryone/presentation/widgets/app_alert_dialog.dart';
import 'package:peveryone/presentation/widgets/app_text_field.dart';
import 'package:peveryone/presentation/widgets/error_screen.dart';
import 'package:peveryone/presentation/widgets/inbox_tile.dart';

class InboxView extends ConsumerStatefulWidget {
  static const routeName = '/inbox-screen';

  const InboxView({super.key});

  @override
  ConsumerState<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends ConsumerState<InboxView> {
  final auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final inboxAsync = ref.watch(inboxProvider(auth.currentUser!.uid));
    final searchQuery = ref.watch(inboxSearchProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('Inbox'),
        // actions: [
        //   IconButton(onPressed: () {}, icon: const Icon(Iconsax.add_square)),
        //   IconButton(onPressed: () {}, icon: const Icon(Iconsax.more_circle)),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
            SizedBox(height: height(context, 0.03)),

            Expanded(
              child: inboxAsync.when(
                data: (inboxList) {
                  final filteredList =
                      inboxList
                          .where(
                            (inbox) => inbox.chatWithName
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()),
                          )
                          .toList();

                  if (filteredList.isEmpty) {
                    return const Center(child: Text('No chats yet'));
                  }
                  final allList = inboxList.toList();
                  // final topFive = inboxList.take(5).toList();
                  // final remainingList =
                  //     inboxList.length > 5 ? inboxList.skip(5).toList() : [];
                  return ListView(
                    children: [
                      // const Text(
                      //   'Top Chats',
                      //   style: TextStyle(fontWeight: FontWeight.bold),
                      // ),
                      // // SizedBox(height: height(context, 0.01)),
                      // SizedBox(
                      //   height: height(context, 0.12),
                      //   child: SingleChildScrollView(
                      //     scrollDirection: Axis.horizontal,

                      //     child: Row(
                      //       children:
                      //           topFive
                      //               .map(
                      //                 (inbox) => Padding(
                      //                   padding: const EdgeInsets.only(
                      //                     right: 8.0,
                      //                   ), // spacing between items
                      //                   child: TopChatBadge(
                      //                     onTap: () {
                      //                       Navigator.pushNamed(
                      //                         context,
                      //                         '/chat-room',
                      //                         arguments: ChatRoom(
                      //                           senderId: auth.currentUser!.uid,
                      //                           receiverId: inbox.chatWith,
                      //                           firstName: inbox.chatWithName,
                      //                         ),
                      //                       );
                      //                     },
                      //                     userName:
                      //                         inbox.chatWithName.capitalize(),
                      //                     image:
                      //                         inbox.chatWithPhotoUrl != null &&
                      //                                 inbox
                      //                                     .chatWithPhotoUrl!
                      //                                     .isNotEmpty
                      //                             ? NetworkImage(
                      //                               inbox.chatWithPhotoUrl!,
                      //                             )
                      //                             : AssetImage(
                      //                                   'assets/images/dummy.png',
                      //                                 )
                      //                                 as ImageProvider,
                      //                   ),
                      //                 ),
                      //               )
                      //               .toList(),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: height(context, 0.01)),
                      const Text(
                        'All Chats',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...allList.map(
                        (inbox) => InboxTile(inbox: inbox, auth: auth),
                      ),
                    ],
                  );
                },
                error: (e, _) {
                  print('Inbox view error: $e');
                  return ErrorScreen(error: e.toString());
                },
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
