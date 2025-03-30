import 'package:flutter/material.dart';
import 'ui/theme/app_theme.dart';
import 'login_page.dart';
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
      theme: themeData,
      home: LoginPage(), // Start with the login page
    );
  }
}
