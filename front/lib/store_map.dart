import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class StoreMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Store Map")),
      body: FlutterMap(
        mapController: MapController(),  // Optional: Add controller if needed
        options: MapOptions(
          initialCenter: LatLng(13.6218, 123.1945), // Default center
          initialZoom: 12.0, // Zoom level
          interactionOptions: const InteractionOptions(flags: InteractiveFlag.all), // Allow interaction
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
        ],
      ),
    );
  }
}
