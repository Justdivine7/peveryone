import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:peveryone/core/helpers/ui_helpers.dart';
import 'package:peveryone/presentation/providers/general_providers/global_providers.dart';
import 'package:peveryone/presentation/providers/inbox_provider.dart';
import 'package:peveryone/presentation/widgets/app_text_field.dart';
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

                  return ListView(
                    children: [
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
                  debugPrint('Inbox view error: $e');
                  return Center(child: Text('An error occurred'));
                },
                loading:
                    () => Center(
                      child: Container(
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Lottie.asset(
                          'assets/animations/loading.json',
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
