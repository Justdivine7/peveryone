import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peveryone/presentation/providers/auth_provider.dart';
import 'package:peveryone/presentation/screens/auth/views/login_view.dart';
import 'package:peveryone/presentation/screens/chat/screens/inbox_view.dart';
import 'package:peveryone/presentation/widgets/error_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    return authState.when(
      data: (user) {
        if (user != null && user.emailVerified) {
          return const InboxView();
        } else {
          return const LoginView();
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
