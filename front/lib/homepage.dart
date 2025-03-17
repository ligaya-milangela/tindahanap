import 'package:flutter/material.dart';
import 'store_map.dart'; // Import the Map View page

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Track selected tab index

  void _onTabTapped(int index) {
    if (index == 0) {
      // If already on "Stores", do nothing
      if (_currentIndex == 0) return;

      // Navigate back to HomePage if it's not the current screen
      Navigator.popUntil(context, (route) => route.isFirst);
      setState(() {
        _currentIndex = 0;
      });
    } else if (index == 1) {
      // Navigate to StoreMap
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StoreMap()),
      ).then((_) {
        // When returning from StoreMap, update index
        setState(() {
          _currentIndex = 0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Location Selector & Search Bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 121, 85, 255), // Purple header
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Location Selector
                GestureDetector(
                  onTap: () {
                    // Add location selection functionality here
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 196, 178, 252),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.location_on, color: Colors.white),
                        SizedBox(width: 8),
                        Text("Ateneo Ave, Naga City",
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Search Bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search stores or products",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Icon(Icons.filter_list, color: Colors.grey),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Store List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: 5, // Example store count
              itemBuilder: (context, index) {
                return _buildStoreCard(context);
              },
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar with Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, 
        selectedItemColor: Color.fromARGB(255, 78, 14, 190),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: "Stores"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // Store Card Widget
  Widget _buildStoreCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Example navigation when tapping a store
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            // Store Image Placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.image, color: Colors.grey[600]),
            ),
            SizedBox(width: 12),

            // Store Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sari-Sari Store Name",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text("Address", style: TextStyle(color: Colors.grey[600])),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.purple),
                      SizedBox(width: 4),
                      Text("200m away",
                          style: TextStyle(color: Colors.purple, fontSize: 12)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 10, color: Colors.green),
                      SizedBox(width: 4),
                      Text("Open until 9:00 PM",
                          style: TextStyle(color: Colors.green, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
