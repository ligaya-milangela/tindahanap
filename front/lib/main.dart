import 'package:flutter/material.dart';
import 'login_page.dart';  // Import your LoginPage

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tindahanap',
      home: LoginPage(),  // Ensure LoginPage is the first screen
    );
  }
}
