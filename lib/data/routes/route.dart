import 'package:flutter/material.dart';
import 'package:peveryone/presentation/screens/auth/screens/account_type_screen.dart';
import 'package:peveryone/presentation/screens/auth/screens/email_verification_screen.dart';
import 'package:peveryone/presentation/screens/auth/screens/forgot_password_screen.dart';
import 'package:peveryone/presentation/screens/auth/screens/login_screen.dart';
import 'package:peveryone/presentation/screens/auth/screens/registration_screen.dart';
import 'package:peveryone/presentation/screens/chat/screens/chat_room.dart';
import 'package:peveryone/presentation/screens/chat/screens/inbox_screen.dart';
import 'package:peveryone/presentation/widgets/error_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case RegistrationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const RegistrationScreen(),
      );
    case ForgotPasswordScreen.routeName:
      return MaterialPageRoute(builder: (context) => ForgotPasswordScreen());
    case AccountTypeScreen.routeName:
      return MaterialPageRoute(builder: (context) => AccountTypeScreen());
    case InboxScreen.routeName:
      return MaterialPageRoute(builder: (context) => InboxScreen());
    case EmailVerificationScreen.routeName:
      return MaterialPageRoute(builder: (context) => EmailVerificationScreen());
    case ChatRoom.routeName:
      final userName = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => ChatRoom(userName: userName),
      );
    default:
      return MaterialPageRoute(
        builder:
            (context) => const ErrorScreen(error: "This page doesn't exist"),
      );
  }
}
