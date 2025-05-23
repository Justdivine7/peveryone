import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:peveryone/core/constants/extensions.dart';
import 'package:peveryone/core/helpers/ui_helpers.dart';
import 'package:peveryone/presentation/providers/home_view_provider.dart';
import 'package:peveryone/presentation/screens/chat/views/chat_room.dart';

class HomeView extends ConsumerWidget {
  static const routeName = '/home-view';
  const HomeView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = FirebaseAuth.instance.currentUser;

    final usersProvider = ref.watch(allUsersProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text('People'), automaticallyImplyLeading: false),
      body: SafeArea(
        child: usersProvider.when(
          data: (users) {
            final filteredUsers =
                users.where((u) => u.uid != auth?.uid).toList();

            return GridView.builder(
              padding: EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,

                crossAxisSpacing: 8,
                mainAxisSpacing: 4,
              ),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];

                return Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Theme.of(context).hoverColor),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image:
                          (user.photoUrl != null && user.photoUrl!.isNotEmpty)
                              ? CachedNetworkImageProvider(user.photoUrl!)
                              : const AssetImage('assets/images/dummy.png'),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        user.firstName.capitalize(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(6),
                                backgroundColor: Colors.black,
                              ),
                              onPressed: () {},
                              child: Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                                // size: ,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(6),
                                backgroundColor:
                                    Theme.of(context).disabledColor,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/chat-room',

                                  arguments: ChatRoom(
                                    senderId: auth?.uid ?? '',
                                    receiverId: user.uid,
                                    firstName: user.firstName,
                                  ),
                                );
                              },
                              child: Icon(
                                Iconsax.message_text_1,
                                color: Colors.white,
                                // size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
          error: (e, stackTrace) {
            debugPrint(e.toString());
            return Center(
              child: Column(
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    size: height(context, 0.2),
                    color: Theme.of(context).hoverColor,
                  ),
                  SizedBox(height: height(context, 0.02)),
                  Text('Error: Something went wrong'),
                ],
              ),
            );
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
    );
  }
}
