import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';
import '../static_data/product_data.dart';
import '../static_data/day_data.dart';

class StoreDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> store;

  const StoreDetailsScreen({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Extract store details safely
    String name = store['tags']?['name'] ?? 'Unnamed Store';
    String type = store['tags']?['shop'] ?? 'Unknown Type';
    String address = store['tags']?['addr:street'] ?? 'No street address';
    String city = store['tags']?['addr:city'] ?? 'No city';
    String postcode = store['tags']?['addr:postcode'] ?? 'No postcode';

    // Get coordinates
    double lat = store['lat'] ?? 0.0;
    double lon = store['lon'] ?? 0.0;

    // Generate random subset of products
    final random = Random();
    final randomProducts = List.generate(3, (_) => sampleProducts[random.nextInt(sampleProducts.length)]);

    //generate working hours for 7 days
    final BusinessHours = List.generate(7, (index) => DayData[index]);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          name,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.secondaryContainer,
      ),
      body: Stack(
        children: [
          // Store image placeholder
          Container(
            color: colorScheme.tertiary,
            width: double.infinity,
            height: 256.0,
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 224.0),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 24.0,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(32.0),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8.0),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16.0,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '$address, $city, $postcode',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8.0),

                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16.0,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        type,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24.0),

                  // Map display
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    height: 280.0,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(lat, lon),
                        initialZoom: 17.0,
                        cameraConstraint: CameraConstraint.contain(
                          bounds: LatLngBounds(
                            LatLng(lat - 0.005, lon - 0.005),
                            LatLng(lat + 0.005, lon + 0.005),
                          ),
                        ),
                        minZoom: 15.0,
                        maxZoom: 18.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(lat, lon),
                              child: Icon(
                                Icons.location_on,
                                size: 40.0,
                                color: colorScheme.primaryContainer,
                                shadows: [
                                  const Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 4.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                   const Divider(height: 20, thickness: 2, indent: 20, endIndent: 0, color: Colors.black),

                  const SizedBox(height: 16.0),
                  Text(
                    'Available Products',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8.0),
                  ...List.generate(randomProducts.length, (index) {
                    final product = randomProducts[index];
                    return ListTile(
                      leading: const Icon(Icons.shopping_bag),
                      title: Text(product['name'] ?? 'Unnamed'),
                      trailing: Text('₱${product['price'].toString()}'),
                    );
                  }),

                  const Divider(height: 20, thickness: 2, indent: 20, endIndent: 0, color: Colors.black),
                  
                  Text(
                    'Business Hours',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  ...List.generate(7, (index) {
                    final days = BusinessHours[index];

                    return ListTile(
                      title: Text(days['day']),
                      trailing: Text(days['time']),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
