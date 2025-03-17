import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'homepage.dart'; // Import HomePage to navigate back

class StoreMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Flutter Map
          FlutterMap(
            mapController: MapController(),
            options: MapOptions(
              initialCenter: LatLng(13.6218, 123.1945), // Default center
              initialZoom: 13.0, // Zoom level
              interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
            ),
            children: [
              // Map Tiles
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),

              // User's Location Circle
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: LatLng(13.6218, 123.1945),
                    color: Colors.blue.withOpacity(0.3),
                    radius: 300,
                    useRadiusInMeter: true,
                  ),
                ],
              ),

              // Store Markers
              MarkerLayer(
                markers: [
                  _buildMarker(LatLng(13.625, 123.198)), // Example markers
                  _buildMarker(LatLng(13.619, 123.192)),
                  _buildMarker(LatLng(13.630, 123.200)),
                ],
              ),
            ],
          ),

          // Search Bar & Location Selector
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Column(
              children: [
                _buildLocationSelector(),
                SizedBox(height: 10),
                _buildSearchBar(),
              ],
            ),
          ),

          // Custom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildCustomNavBar(context), // Custom navigation logic
          ),
        ],
      ),
    );
  }

  // Helper function to create store markers
  Marker _buildMarker(LatLng point) {
    return Marker(
      point: point,
      width: 30,
      height: 30,
      child: Icon(Icons.location_on, size: 30, color: Colors.purple),
    );
  }

  // Location Selector Widget
  Widget _buildLocationSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 196, 178, 252), // Light purple
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, color: Colors.white),
          SizedBox(width: 8),
          Text("Ateneo Ave, Naga City", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  // Search Bar Widget
  Widget _buildSearchBar() {
    return Container(
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
    );
  }

  // ✅ **Custom Bottom Navigation Bar**
  Widget _buildCustomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.store, "Stores", 0),
          _buildNavItem(context, Icons.map, "Map", 1, isSelected: true),
          _buildNavItem(context, Icons.favorite_border, "Favorites", 2),
          _buildNavItem(context, Icons.person, "Profile", 3),
        ],
      ),
    );
  }

  // ✅ **Navigation Bar Item**
  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          // If "Stores" is tapped, return to HomePage
          Navigator.popUntil(context, (route) => route.isFirst);
        } else if (index == 1) {
          // Do nothing, already on "Map"
        } else {
          // Handle other pages (Favorites, Profile)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("$label page is not implemented")),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Color.fromARGB(255, 78, 14, 190) : Colors.grey),
          Text(label, style: TextStyle(color: isSelected ? Color.fromARGB(255, 78, 14, 190) : Colors.grey)),
        ],
      ),
    );
  }
}
