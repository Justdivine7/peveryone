import 'package:flutter/material.dart';
import 'package:peveryone/core/theme/app_theme.dart';
import 'package:peveryone/data/routes/route.dart';
 import 'package:peveryone/presentation/screens/auth/screens/login_screen.dart';
 
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peveryone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightThemeData(),
      darkTheme: AppTheme.darkThemeData(),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: LoginScreen(),
    );
  }
}
