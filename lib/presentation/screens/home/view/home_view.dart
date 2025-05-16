import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:peveryone/core/constants/extensions.dart';
import 'package:peveryone/core/constants/ui_helpers.dart';
import 'package:peveryone/presentation/providers/home_view_provider.dart';

class HomeView extends ConsumerWidget {
  static const routeName = '/home-view';
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersProvider = ref.watch(allUsersProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: Text('People'), automaticallyImplyLeading: false),
      body: usersProvider.when(
        data:
            (users) => GridView.builder(
              padding: EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // mainAxisExtent: 2,
                crossAxisSpacing: 6,
                mainAxisSpacing: 4,
              ),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(color:Theme.of(context).hoverColor),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        user.photoUrl ??
                            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=1000&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8cG9ydHJhaXR8ZW58MHx8MHx8fDA%3D',
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          SizedBox(width: width(context, 0.01)),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(6),
                                backgroundColor: Theme.of(context).hoverColor,
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/chat-room',
                                  arguments: user.firstName,
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
            ),
        error:
            (e, _) => Center(
              child: Column(
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    size: height(context, 0.2),
                    color: Theme.of(context).hoverColor,
                  ),
                  SizedBox(height: height(context, 0.02)),
                  Text('Error: $e'),
                ],
              ),
            ),
        loading:
            () => Center(child: Image.asset('assets/animations/loading.json')),
      ),
    );
  }
}
