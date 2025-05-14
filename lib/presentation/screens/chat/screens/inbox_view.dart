import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:peveryone/core/constants/ui_helpers.dart';
import 'package:peveryone/presentation/providers/auth_provider.dart';
import 'package:peveryone/presentation/screens/chat/screens/chat_room.dart';
import 'package:peveryone/presentation/widgets/app_alert_dialog.dart';
import 'package:peveryone/presentation/widgets/app_text_field.dart';

class InboxView extends ConsumerStatefulWidget {
  static const routeName = '/inbox-screen';

  const InboxView({super.key});

  @override
  ConsumerState<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends ConsumerState<InboxView> {
  List<Map<String, dynamic>> recently = [
    {'name': 'Julia', 'image': 'assets/images/image7.png'},
    {'name': 'Jenny', 'image': 'assets/images/image8.png'},
    {'name': 'Andrew', 'image': 'assets/images/image9.png'},
    {'name': 'Sarah', 'image': 'assets/images/image7.png'},
    {'name': 'James', 'image': 'assets/images/image9.png'},
  ];
  List<Map<String, dynamic>> messages = [
    {
      'name': 'Jenny',
      'image': 'assets/images/image1.png',
      'message': 'Hello ',
      'number': '2',
      'time': '02:00',
    },
    {
      'name': 'Warren',
      'image': 'assets/images/image2.png',
      'message': 'Whats good ',
      'number': '1',
      'time': '04:00',
    },
    {
      'name': 'Theresa',
      'image': 'assets/images/image3.png',
      'message': 'That is hillarious',
      'number': '2',
      'time': 'Monday',
    },
    {
      'name': 'Brooklyn',
      'image': 'assets/images/image2.png',
      'message': 'Good Morning',
      'number': '4',
      'time': '09:00',
    },
    {
      'name': 'Annnete',
      'image': 'assets/images/image5.png',
      'message': 'I want to see you ',
      'number': '1',
      'time': 'Yesterday',
    },
    {
      'name': 'Jenny',
      'image': 'assets/images/image6.png',
      'message': 'Hello ',
      'number': '2',
      'time': '02:00',
    },
    {
      'name': 'Julia',
      'image': 'assets/images/image1.png',
      'message': 'Yo whats up',
      'number': '5',
      'time': '03:00',
    },
    {
      'name': 'Jenny',
      'image': 'assets/images/image1.png',
      'message': 'Hello ',
      'number': '2',
      'time': '02:00',
    },
  ];

  void logout() async {
    final auth = ref.read(authRepositoryProvider);
    await auth.signOut();
  }

  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
              Text('Recently'),
              SizedBox(
                height: height(context, 0.15),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: recently.length,
                  itemBuilder: (context, index) {
                    final user = recently[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => ChatRoom(userName: user['name']),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(user['image']),
                              radius: 35,
                            ),
                            Text(user['name']),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Text('Messages'),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final user = messages[index];
                  return ListTile(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Theme.of(context).indicatorColor,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => ChatRoom(userName: user['name']),
                        ),
                      );
                    },
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(user['image']),
                      radius: 30,
                    ),
                    title: Text(user['name']),
                    subtitle: Text(user['message']),
                    trailing: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
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
                            user['number'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Text(user['time']),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
