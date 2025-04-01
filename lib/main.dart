import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase initialization with the config for Flutter
  await Firebase.initializeApp(
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tindahanap',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(), // Start with the login page
    );
  }
}
