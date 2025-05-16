import 'package:flutter/material.dart';
import 'package:peveryone/core/helpers/ui_helpers.dart';

class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.wifi_off_sharp,
            size: height(context, 0.2),
            color: Theme.of(context).cardColor,
          ),
          SizedBox(height: height(context, 0.03)),
          Text(error),
        ],
      ),
    );
  }
}
