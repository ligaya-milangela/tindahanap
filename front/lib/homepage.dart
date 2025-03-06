import 'package:flutter/material.dart';
import 'store_map.dart'; // Import StoreMap page

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tindahanap")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Welcome to Tindahanap!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20), // Space between text and button
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => StoreMap()));
            },
            child: Text("View Map"),
          ),
        ],
      ),
    );
  }
}
