import 'package:flutter/material.dart';
import 'package:peveryone/presentation/screens/auth/views/login_view.dart';
 
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState()   {
    super.initState();
     Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/images/peveryone_logo.png'),
        ),
      ),
    );
  }
}
