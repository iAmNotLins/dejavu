import 'package:dejavu/pages/auth_page.dart';
import 'package:dejavu/pages/screen_splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dejavu/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp()); // Remova o const aqui
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Remova o const aqui também
      routes: {
        '/auth': (context) => AuthPage(), // Navegação para AuthPage
      },
    );
  }
}