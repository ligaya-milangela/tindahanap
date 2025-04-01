import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class StoreDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> store;

  StoreDetailsScreen({required this.store});

  @override
  Widget build(BuildContext context) {
    // Extract store details safely
    String name = store['tags']?['name'] ?? 'Unnamed Store';
    String type = store['tags']?['shop'] ?? 'Unknown Type';
    String address = store['tags']?['addr:street'] ?? 'No street address';
    String city = store['tags']?['addr:city'] ?? 'No city';
    String postcode = store['tags']?['addr:postcode'] ?? 'No postcode';
    
    // Get coordinates
    double lat = store['lat'] ?? 0.0;
    double lon = store['lon'] ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Color.fromARGB(255, 121, 85, 255),
      ),
      body: SingleChildScrollView(  // Wrapping the body with SingleChildScrollView to avoid overflow
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.store, size: 80, color: Colors.grey[700]),
              SizedBox(height: 20),
              Text("Store Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(name, style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text("Type", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(type, style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text("Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("$address, $city, $postcode", style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),

              // Add OpenStreetMap below the details using flutter_map
              Container(
                height: 300, // You can adjust this as needed
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(lat, lon), // Using initialCenter here
                    initialZoom: 15.0, // Adjust zoom level
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(lat, lon),
                          width: 30,
                          height: 30,
                          child: Icon(Icons.location_on, size: 30, color: Colors.purple),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 121, 85, 255)),
                child: Text("Back"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
