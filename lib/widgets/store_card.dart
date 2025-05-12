import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../models/filters.dart';
import '../models/store.dart';
import '../screens/product_catalog_screen.dart';
import 'inherited_shared_data.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  final Position userLocation;

  const StoreCard({
    super.key,
    required this.store,
    required this.userLocation,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final distanceFromUser = getDistanceFromUser(
      userLocation.latitude,
      userLocation.longitude,
      store.latitude,
      store.longitude,
    );

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
              MaterialPageRoute(builder: (context) {
                return SharedData(
                  filters: Filters(),
                  location: userLocation,
                  child: ProductCatalogScreen(store: store),
                );
              }),
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
                      store.name,
                      style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),

                    Text(
                      store.address,
                      style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                      overflow: TextOverflow.ellipsis,
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
                          '${distanceToString(distanceFromUser)} away',
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