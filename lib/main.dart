import 'package:flutter/material.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/login_screen.dart';
import 'homepage.dart';

void main() {
  runApp(TindahanapApp());
}

class TindahanapApp extends StatelessWidget {
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
      home: LoginPage(), // Start with the login page
    );
  }
}
