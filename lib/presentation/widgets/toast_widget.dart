import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

// enum ToastType { success, error, info }

class ToastWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  ToastWidget(this.navigatorKey);
  void show({required String message, required ToastificationType type}) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    toastification.show(
      context: context,
      style: ToastificationStyle.flatColored,
      type: type,
      title: Text(message),
      autoCloseDuration: Duration(seconds: 3),
      alignment: Alignment.topCenter,
      animationDuration: const Duration(milliseconds: 300),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: true,
    );
  }
}
