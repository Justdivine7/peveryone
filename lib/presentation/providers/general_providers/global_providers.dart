import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peveryone/main.dart';
import 'package:peveryone/presentation/screens/user_profile/repository/user_profile_repository.dart';
import 'package:peveryone/presentation/widgets/toast_widget.dart';

final profileImageProvider = StateProvider<File?>((ref) => null);
final userProfileProvider = Provider((ref) => UserProfileRepository());
final inboxSearchProvider = StateProvider<String>((ref) => '');
final toastProvider = Provider<ToastWidget>((ref) => ToastWidget(navigatorKey));
