import 'package:flutter/material.dart';

Future<void> appAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = "OK",
  VoidCallback? onConfirm,
  String? cancelText,
  VoidCallback? onCancel,
  bool isDismissible = true,
}) {
  return showDialog(
    context: context,
    barrierDismissible: isDismissible,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            if (cancelText != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onCancel != null) onCancel();
                },
                child: Text(cancelText),
              ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onConfirm != null) onConfirm();
              },
              child: Text(confirmText),
            ),
          ],
        ),
  );
}
