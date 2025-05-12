import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peveryone/presentation/screens/auth/screens/login_screen.dart';
import 'package:peveryone/presentation/screens/chat/screens/inbox_screen.dart';
import 'package:peveryone/presentation/widgets/error_screen.dart';

final authStateChangesProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    return authState.when(
      data: (user) {
        if (user != null) {
          return const InboxScreen();
        } else {
          return const LoginScreen();
        }
      },
      error: (e, _) => ErrorScreen(error: 'Something went wrong'),
      loading:
          () => Scaffold(
            body: Center(
              child: Image(image: AssetImage('assets/animations/loading.json')),
            ),
          ),
    );
  }
}
