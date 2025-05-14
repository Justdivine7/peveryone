import 'package:flutter/material.dart';
import 'package:peveryone/presentation/screens/auth/screens/login_screen.dart';
 
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState()   {
    super.initState();
     Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
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
