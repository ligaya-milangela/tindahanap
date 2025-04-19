import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../static_data/day_data.dart';

class StoreExtraDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> store;

  const StoreExtraDetailsScreen({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    double lat = store['lat'] ?? 0.0;
    double lon = store['lon'] ?? 0.0;
    final businessHours = List.generate(7, (index) => DayData[index]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Details'),
        backgroundColor: colorScheme.secondaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location Map', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            SizedBox(
              height: 280,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(lat, lon),
                  initialZoom: 17.0,
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
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 32, thickness: 2),

            Text('Business Hours', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            ...businessHours.map((day) => ListTile(
              title: Text(day['day']),
              trailing: Text(day['time']),
            )),
          ],
        ),
      ),
    );
  }
}
