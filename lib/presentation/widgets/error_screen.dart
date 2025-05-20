import 'package:flutter/material.dart';
import 'package:peveryone/core/helpers/ui_helpers.dart';

class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_sharp,
              size: height(context, 0.1),
              color: Theme.of(context).hoverColor,
            ),
            SizedBox(height: height(context, 0.03)),
            Text('This page does not exist'),
          ],
        ),
      ),
    );
  }
}
