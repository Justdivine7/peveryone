import 'package:flutter/material.dart';
import 'package:peveryone/presentation/screens/auth/views/account_type_view.dart';
import 'package:peveryone/presentation/screens/auth/views/email_verification_view.dart';
import 'package:peveryone/presentation/screens/auth/views/forgot_password_view.dart';
import 'package:peveryone/presentation/screens/auth/views/login_view.dart';
import 'package:peveryone/presentation/screens/auth/views/registration_view.dart';
import 'package:peveryone/presentation/screens/base/base_view.dart';
import 'package:peveryone/presentation/screens/chat/views/chat_room.dart';
import 'package:peveryone/presentation/screens/chat/views/image_preview_view.dart';
import 'package:peveryone/presentation/screens/chat/views/inbox_view.dart';
import 'package:peveryone/presentation/screens/home/view/home_view.dart';
import 'package:peveryone/presentation/screens/user_profile/views/edit_profile_view.dart';
import 'package:peveryone/presentation/screens/user_profile/views/user_profile_view.dart';
import 'package:peveryone/presentation/widgets/error_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginView.routeName:
      return MaterialPageRoute(builder: (context) => const LoginView());
    case RegistrationView.routeName:
      return MaterialPageRoute(builder: (context) => const RegistrationView());
    case ForgotPasswordView.routeName:
      return MaterialPageRoute(builder: (context) => ForgotPasswordView());
    case AccountTypeView.routeName:
      return MaterialPageRoute(builder: (context) => AccountTypeView());
    case InboxView.routeName:
      return MaterialPageRoute(builder: (context) => InboxView());
    case EmailVerificationView.routeName:
      return MaterialPageRoute(builder: (context) => EmailVerificationView());
    case ChatRoom.routeName:
      final args = settings.arguments as ChatRoom;
      return MaterialPageRoute(
        builder:
            (context) => ChatRoom(
              senderId: args.senderId,
              receiverId: args.receiverId,
              firstName: args.firstName,
            ),
      );
    case ImagePreviewView.routeName:
      final args = settings.arguments as ImagePreviewView;
      return MaterialPageRoute(
        builder: (context) => ImagePreviewView(imageUrl: args.imageUrl),
      );
    case UserProfileView.routeName:
      return MaterialPageRoute(builder: (context) => UserProfileView());
    case EditProfileView.routeName:
      return MaterialPageRoute(builder: (context) => EditProfileView());
    case HomeView.routeName:
      return MaterialPageRoute(builder: (context) => HomeView());
    case BaseView.routeName:
      return MaterialPageRoute(builder: (context) => BaseView());
    default:
      return MaterialPageRoute(
        builder:
            (context) => const ErrorScreen(error: "This page doesn't exist"),
      );
  }
}
