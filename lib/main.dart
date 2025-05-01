import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:front/home.dart';
import 'theme/color_scheme.dart';
import 'theme/custom_colors.dart';
import 'theme/text_theme.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAY-2R0EX1vY1T5UTSJSrVLV-whQSmjU1w',
        appId: '1:342791532648:web:85714f4e0b1c238cb6cbdd',
        messagingSenderId: '342791532648',
        projectId: 'tindahanap',
        authDomain: 'tindahanap.firebaseapp.com',
        storageBucket: 'tindahanap.appspot.com',
        measurementId: 'G-DST5DB9KXB',
      ),
    );
  } else {
    // Android: Use google-services.json
    await Firebase.initializeApp();
  }

  runApp(const TindahanapApp());
}

class TindahanapApp extends StatelessWidget {
  const TindahanapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tindahanap',
      theme: ThemeData(
        extensions: [CustomColors()],
        brightness: Brightness.light,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      ),
      initialRoute: '/home',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const Home(),
      },
    );
  }
}
