import 'package:flutter/material.dart';
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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(), // Start with the login page
    );
  }
}
