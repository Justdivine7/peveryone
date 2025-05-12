import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { success, error, info }

class ToastWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  ToastWidget(this.navigatorKey);
  void show(String message, {ToastType type = ToastType.info}) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    Color bgColor;
    Color textColor;

    switch (type) {
      case ToastType.success:
        bgColor = scheme.secondary;
        textColor = scheme.onSecondary;
        break;
      case ToastType.error:
        bgColor = scheme.error;
        textColor = scheme.onError;
        break;
      case ToastType.info:
        bgColor = scheme.surface;
        textColor = scheme.onSurface;
        break;
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: bgColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }
}
