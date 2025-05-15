import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';

class LocationButton extends StatefulWidget {
  const LocationButton({super.key});

  @override
  State<LocationButton> createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  String locationName = 'Fetching location...';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () {},
        style: FilledButton.styleFrom(
          foregroundColor: colorScheme.onSurface,
          backgroundColor: colorScheme.surfaceContainerLow,
          iconColor: colorScheme.primary,
          elevation: 2.0,
          alignment: const Alignment(-1.0, 0.0),
        ),
        icon: const Icon(Icons.near_me),
        label: Text(locationName, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Future<void> _fetchUserLocation() async {
    try {
      final Position position = await getUserLocation();
      final String placemarkName = await getPlacemarkName(position.latitude, position.longitude);

      if (!mounted) return;
      setState(() {
        locationName = placemarkName;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching location: $e');
      
      if (!mounted) return;
      setState(() {
        locationName = 'Undefined';
        isLoading = false;
      });
    }
  }
}