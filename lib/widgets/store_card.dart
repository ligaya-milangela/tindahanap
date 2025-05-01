import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../screens/product_catalog_screen.dart';

class StoreCard extends StatelessWidget {
  final dynamic store;

  const StoreCard({
    super.key,
    required this.store
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final name = store['tags']?['name'] ?? 'Unnamed Store';
    final address = store['tags']?['addr:street'] ?? 'No street address';
    final city = store['tags']?['addr:city'] ?? 'No city';
    final postcode = store['tags']?['addr:postcode'] ?? 'No postcode';
    final distance = LocationService.getDistance(store['lat'], store['lon']);

    return SizedBox(
      width: double.infinity,
      height: 240.0,
      child: Card(
        color: colorScheme.surfaceContainerLow,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductCatalogScreen(store: store)),
            );
          },
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 136.0,

                // Replace with Ink.image for store image
                child: Ink(color: colorScheme.tertiary),
              ),

              Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      '$address, $city, $postcode',
                      style: textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 4.0,
                      children: [
                        Icon(
                          Icons.place,
                          size: 14.0,
                          color: colorScheme.secondary,
                        ),

                        Text(
                          '${LocationService.distanceToString(distance)} away',
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}