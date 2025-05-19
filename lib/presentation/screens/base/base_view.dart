import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peveryone/presentation/providers/general_providers/auth_loader.dart';
import 'package:peveryone/presentation/screens/chat/views/inbox_view.dart';
import 'package:peveryone/presentation/screens/home/view/home_view.dart';
import 'package:peveryone/presentation/screens/user_profile/user_profile_view.dart';

class BaseView extends ConsumerStatefulWidget {
  static const routeName = '/base-view';
  const BaseView({super.key});

  @override
  ConsumerState<BaseView> createState() => _BaseView();
}

class _BaseView extends ConsumerState<BaseView> {
  List<Widget> screens = const [HomeView(), InboxView(), UserProfileView()];
  @override
  Widget build(BuildContext context) {
    final pageIndex = ref.watch(AuthLoader.selectedIndexProvider);

    return Scaffold(
      body: screens[pageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Theme.of(context).disabledColor,
        animationDuration: Duration(milliseconds: 300),
        items: [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.mail_rounded, color: Colors.white),
          Icon(Icons.person_2_rounded, color: Colors.white),
        ],
        onTap: (index) {
          ref.read(AuthLoader.selectedIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}
