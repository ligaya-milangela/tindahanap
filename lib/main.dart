import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase initialization with the config for Flutter
  await Firebase.initializeApp(
    name: 'tindahanap-app',
    options: FirebaseOptions(
      apiKey: "AIzaSyAY-2R0EX1vY1T5UTSJSrVLV-whQSmjU1w",
      appId: "1:342791532648:web:85714f4e0b1c238cb6cbdd",
      messagingSenderId: "342791532648",
      projectId: "tindahanap",
      authDomain: "tindahanap.firebaseapp.com",
      storageBucket: "tindahanap.firebasestorage.app",
      measurementId: "G-DST5DB9KXB",
    ),
  );

  runApp(TindahanapApp());
}

class TindahanapApp extends StatelessWidget {
  const TindahanapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tindahanap',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      ),
      home: LoginScreen(), // Start with the login screen
    );
  }
}
