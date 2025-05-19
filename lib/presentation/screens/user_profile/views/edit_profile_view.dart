import 'package:flutter/material.dart';

class EditProfileView extends StatelessWidget {
  static const routeName = '/edit-profile';
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: SingleChildScrollView(child: Padding(padding: EdgeInsets.all(16))),
    );
  }
}
