import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'stores_list_screen.dart'; // Import the HomePage

class StoresMapScreen extends StatelessWidget {
  final double userLat;
  final double userLon;
  final List stores;

  StoresMapScreen({
    required this.userLat,
    required this.userLon,
    required this.stores,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Flutter Map
          FlutterMap(
            mapController: MapController(),
            options: MapOptions(
              initialCenter: LatLng(userLat, userLon),
              initialZoom: 13.0,
              interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: stores.map((store) {
                  double storeLat = store['lat'];
                  double storeLon = store['lon'];
                  return _buildMarker(LatLng(storeLat, storeLon));
                }).toList(),
              ),
            ],
          ),
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildCustomNavBar(context),
          ),
        ],
      ),
    );
  }

  Marker _buildMarker(LatLng point) {
    return Marker(
      point: point,
      width: 30,
      height: 30,
      child: Icon(Icons.location_on, size: 30, color: Colors.purple),
    );
  }

  Widget _buildLocationSelector() {
    return Container(
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
          Text("User Location", style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

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
          _buildNavItem(context, Icons.store, "Stores", 0), // Store icon to navigate back to HomePage
          _buildNavItem(context, Icons.map, "Map", 1, isSelected: true),
          _buildNavItem(context, Icons.favorite_border, "Favorites", 2),
          _buildNavItem(context, Icons.person, "Profile", 3),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          // Navigate to HomePage when the store icon is clicked
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StoresListScreen()), // Navigate to HomePage
          );
        } else {
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
