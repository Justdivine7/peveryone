import 'package:flutter/material.dart';
import 'package:peveryone/core/theme/app_theme.dart';
import 'package:peveryone/data/routes/route.dart';
import 'package:peveryone/firebase_options.dart';
import 'package:peveryone/presentation/screens/auth/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await Future.delayed(Duration(seconds: 3));
  // FlutterNativeSplash.remove();
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
      // darkTheme: AppTheme.darkThemeData(),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: LoginScreen(),
    );
  }
}
