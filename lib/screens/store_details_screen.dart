import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/custom_colors.dart';

class StoreDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> store;

  const StoreDetailsScreen({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final customColors = Theme.of(context).extension<CustomColors>()!;
    final textTheme = Theme.of(context).textTheme;

    String name = store['tags']?['name'] ?? 'Unnamed Store';
    String address = store['tags']?['addr:street'] ?? 'No street address';
    String city = store['tags']?['addr:city'] ?? 'No city';
    String postcode = store['tags']?['addr:postcode'] ?? 'No postcode';
    double lat = store['lat'] ?? 0.0;
    double lon = store['lon'] ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Store Profile',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onTertiaryContainer,
            fontWeight: FontWeight.bold
          ),
        ),
        shadowColor: colorScheme.shadow,
        backgroundColor: colorScheme.tertiaryContainer,
        iconTheme: IconThemeData(color: colorScheme.onTertiaryContainer),
      ),
      body: Stack(
        children: [
          Container(
            color: colorScheme.primary,
            width: double.infinity,
            height: double.infinity,
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 160.0),
            child: Container(
              padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 64.0),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: customColors.successContainer,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    constraints: const BoxConstraints(maxWidth: 172.0),
                    child: Row(
                      spacing: 6.0,
                      children: [
                        Container(
                          width: 8.0,
                          height: 8.0,
                          decoration: ShapeDecoration(
                            color: customColors.success,
                            shape: const CircleBorder(),
                          ),
                        ),

                        Text(
                          'Open until 12:00 PM',
                          style: textTheme.labelLarge?.copyWith(color: customColors.onSuccessContainer),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed mollis bibendum facilisis. Suspendisse potenti. Nunc aliquet a lorem ac rhoncus. Sed a eros et mauris.',
                    style: textTheme.bodyLarge,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16.0),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonalIcon(
                      onPressed: () {},
                      icon: const Icon(Icons.call),
                      label: Text('Call', style: textTheme.labelLarge),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  const Divider(),
                  const SizedBox(height: 16.0),

                  Text(
                    'Contact Information',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),

                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 12.0,
                      children: [
                        Icon(
                          Icons.map,
                          size: 20.0,
                          color: colorScheme.onSurfaceVariant,
                        ),

                        Expanded(child: Text('$address, $city, $postcode')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4.0),

                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 12.0,
                      children: [
                        Icon(
                          Icons.phone_android,
                          size: 20.0,
                          color: colorScheme.onSurfaceVariant,
                        ),

                        const Expanded(child: Text('0983 262 5802')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  
                  SizedBox(
                    height: 200.0,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(lat, lon),
                        initialZoom: 16.0,
                        interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                      ),
                      children: [
                        TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(lat, lon),
                              child: Icon(
                                Icons.location_on,
                                size: 28.0,
                                color: colorScheme.primaryContainer,
                                shadows: [
                                  const Shadow(offset: Offset(2.0, 2.0), blurRadius: 4.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  const Divider(),
                  const SizedBox(height: 16.0),

                  Text(
                    'Business Hours',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  Column(
                    spacing: 8.0,
                    children: [
                      _buildHoursRow(context, 'Monday', '06:00AM - 09:00PM'),
                      _buildHoursRow(context, 'Tuesday', '06:00AM - 09:00PM'),
                      _buildHoursRow(context, 'Wednesday', '06:00AM - 09:00PM'),
                      _buildHoursRow(context, 'Thursday', '06:00AM - 09:00PM'),
                      _buildHoursRow(context, 'Friday', '06:00AM - 09:00PM'),
                      _buildHoursRow(context, 'Saturday', '06:00AM - 09:00PM'),
                      _buildHoursRow(context, 'Sunday', '06:00AM - 09:00PM'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoursRow(BuildContext context, String day, String time) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    bool isToday = (day == 'Tuesday'); // Actual implementation needed

    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80.0,
            child: Text(
              day,
              style: textTheme.bodyMedium?.copyWith(
                color: isToday ? colorScheme.primary : colorScheme.onSurface,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),

          Expanded(child: Container()),
          
          SizedBox(
            width: 140.0,
            child: Text(
              time,
              style: textTheme.bodyMedium?.copyWith(
                color: isToday ? colorScheme.primary : colorScheme.onSurface,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
