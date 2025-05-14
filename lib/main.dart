import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peveryone/core/theme/app_theme.dart';
import 'package:peveryone/data/routes/route.dart';
import 'package:peveryone/firebase_options.dart';
import 'package:peveryone/presentation/providers/general_providers/toast_provider.dart';
import 'package:peveryone/presentation/screens/auth/views/auth_gate.dart';
import 'package:peveryone/presentation/widgets/toast_widget.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ProviderScope(
      overrides: [toastProvider.overrideWithValue(ToastWidget(navigatorKey))],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peveryone',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightThemeData(),
      // darkTheme: AppTheme.darkThemeData(),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: AuthGate(),
    );
  }
}
